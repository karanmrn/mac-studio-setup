#!/usr/bin/env python3
"""Public installer tests with isolated homes and mocked network/package boundaries."""
import hashlib
import io
import os
from pathlib import Path
import shutil
import subprocess
import tarfile
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SHA = 'ab8d03ad1360baf4edeed3a1c57867d2e8237092'
MOCK = r'''#!/usr/bin/python3
import json, os, pathlib, shutil, sys
name=pathlib.Path(sys.argv[0]).name
args=sys.argv[1:]
root=pathlib.Path(os.environ['MOCK_ROOT'])
with (root/'calls').open('a') as f: f.write(json.dumps([name]+args)+'\n')
if name=='uname': print('Darwin' if args==['-s'] else 'arm64')
elif name=='brew':
 if args and args[0]=='list': sys.exit(1)
 if args and args[0]=='--prefix': print(root)
elif name=='gh': sys.exit(int(os.environ.get('AUTH_FAIL','0')))
elif name=='curl':
 out=pathlib.Path(args[args.index('-o')+1]);url=args[args.index('-o')-1]
 asset='herdr' if 'herdr-macos' in url else ('treehouse' if 'treehouse-' in url else 'no-mistakes')
 shutil.copyfile(root/('asset-'+asset),out)
 if os.environ.get('CORRUPT'): out.write_bytes(b'corrupted download')
elif name=='npm':
 prefix=pathlib.Path(args[args.index('--prefix')+1]);package=args[-1]
 if args[0]=='list':
  p=prefix/'lib/node_modules'/package/'.test-version'
  if not p.exists(): sys.exit(1)
  print(package+'@'+p.read_text())
 else:
  package,version=package.rsplit('@',1)
  p=prefix/'lib/node_modules'/package;p.mkdir(parents=True,exist_ok=True)
  (p/'.test-version').write_text(version)
  cli='codex' if package=='@openai/codex' else package
  dest=prefix/'bin'/cli;dest.parent.mkdir(parents=True,exist_ok=True)
  dest.write_text('#!/bin/sh\necho '+cli+' '+version+'\n');dest.chmod(0o755)
elif name=='git':
 if args[0]=='clone':
  p=pathlib.Path(args[-1])
  if 'mac-studio-setup.git' in args[-2]: shutil.copytree(os.environ['MOCK_SOURCE'],p,dirs_exist_ok=True)
  (p/'.git').mkdir(parents=True)
  (p/'.git/origin').write_text(args[-2]);(p/'.git/head').write_text('0'*40)
 else:
  p=pathlib.Path(args[1]);cmd=args[2:]
  if cmd[0]=='checkout': (p/'.git/head').write_text(cmd[-1])
  elif cmd[:2]==['rev-parse','HEAD']: print((p/'.git/head').read_text())
  elif cmd[:2]==['remote','get-url']: print((p/'.git/origin').read_text())
  elif cmd[0]=='status': print(' M tracked' if os.environ.get('DIRTY') else '',end='')
'''


class PortableInstall(unittest.TestCase):
    def setUp(self):
        (ROOT/'.validation').mkdir(exist_ok=True)
        self.temp = tempfile.TemporaryDirectory(prefix='public-installer-', dir=ROOT/'.validation')
        self.lab = Path(self.temp.name)
        self.home = self.lab/'home with spaces'
        self.home.mkdir()
        (self.lab/'tmp').mkdir()
        self.repo = self.lab/'source'
        self.repo.mkdir()
        for f in ('install.sh', 'bootstrap.sh', 'verify.sh'):
            shutil.copyfile(ROOT/f, self.repo/f)
        shutil.copytree(ROOT/'config', self.repo/'config')
        (self.repo/'scripts').mkdir()
        shutil.copyfile(ROOT/'scripts/install-portable.sh', self.repo/'scripts/install-portable.sh')
        self.bin = self.lab/'bin'
        self.bin.mkdir()
        for cmd in ('brew', 'npm', 'git', 'gh', 'curl', 'uname'):
            f = self.bin/cmd
            f.write_text(MOCK)
            f.chmod(0o755)
        versions = self.repo/'config/portable-versions.sh'
        text = versions.read_text()
        for name, version in [('herdr', '0.9.3'), ('treehouse', '3.1.1'), ('no-mistakes', '1.84.0')]:
            payload = ('#!/bin/sh\necho '+name+' '+version+'\n').encode()
            asset = self.lab/('asset-'+name)
            if name == 'herdr':
                asset.write_bytes(payload)
            else:
                with tarfile.open(asset, 'w:gz') as tar:
                    info = tarfile.TarInfo(name)
                    info.size = len(payload)
                    info.mode = 0o755
                    tar.addfile(info, io.BytesIO(payload))
            import re
            digest = hashlib.sha256(asset.read_bytes()).hexdigest()
            key = name.upper().replace('-', '_')+'_SHA256'
            text = re.sub(key+r'=[0-9a-f]+', key+'='+digest, text)
        versions.write_text(text)
        self.env = dict(os.environ, HOME=str(self.home), FM_HOME=str(self.home/'karan-agent-workspace'),
                        PATH=str(self.bin)+':/usr/bin:/bin', MOCK_ROOT=str(self.lab), MOCK_SOURCE=str(self.repo), TMPDIR=str(self.lab/'tmp'), INSTALL_DRY_RUN='0')
        self.env.pop('CODEX_HOME', None)
        # macOS's /usr/bin/python3 launcher can create its own runtime cache.
        # Warm that exact boundary before measuring installer-created changes.
        subprocess.run([str(self.bin/'uname'), '-s'], env=self.env, check=True,
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        (self.lab/'calls').unlink()
        self.runtime_baseline = self.snapshot()

    def tearDown(self):
        self.temp.cleanup()

    def run_script(self, file='install.sh', args=(), expected=0, **env):
        result = subprocess.run(['/bin/bash', str(self.repo/file), *args], env=dict(self.env, **env),
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        self.assertEqual(result.returncode, expected, result.stdout)
        return result.stdout

    def snapshot(self):
        return {str(p.relative_to(self.home)): ('link', os.readlink(p)) if p.is_symlink()
                else ('file', p.read_bytes()) if p.is_file() else ('directory',)
                for p in self.home.rglob('*')}

    def assert_home_unchanged(self):
        self.assertEqual(self.snapshot(), self.runtime_baseline)

    def calls(self):
        return (self.lab/'calls').read_text() if (self.lab/'calls').exists() else ''

    def test_dry_run_never_writes_home_or_calls_package_network_tools(self):
        output = self.run_script(args=['--dry-run'])
        self.assert_home_unchanged()
        self.assertIn('gpt-6.1-sol', output)
        self.assertNotIn('no-mistakes 1.84.0 from', output)
        self.assertNotIn('npm', self.calls())
        self.assertNotIn('curl', self.calls())

    def test_dry_run_assertion_rejects_installer_created_write(self):
        entrypoint = self.repo/'install.sh'
        entrypoint.write_text(entrypoint.read_text().replace(
            'set -euo pipefail',
            'set -euo pipefail\nmkdir -p "$HOME/installer-side-effect"', 1))
        self.run_script(args=['--dry-run'])
        with self.assertRaises(AssertionError):
            self.assert_home_unchanged()

    def test_first_install_and_rerun_preserve_files_and_skip_npm_downloads(self):
        self.run_script()
        self.run_script(file='verify.sh', args=['--config-only'])
        before = self.snapshot()
        calls = self.calls().count('"npm", "install"')
        self.run_script()
        self.assertEqual(self.snapshot(), before)
        self.assertEqual(self.calls().count('"npm", "install"'), calls)
        self.assertNotIn('no-mistakes', self.calls())
        self.assertFalse((self.home/'.codex/hooks.json').exists())

    def test_conflict_is_preserved_until_explicit_backed_up_replacement(self):
        config = self.home/'.codex/config.toml'
        config.parent.mkdir()
        config.write_text('model = "existing-model"\n')
        skills = self.home/'.codex/skills/custom/SKILL.md'
        skills.parent.mkdir(parents=True)
        skills.write_text('custom skill source\n')
        self.run_script(args=['--config-only'])
        self.assertIn('existing-model', config.read_text())
        self.run_script(args=['--config-only', '--replace-config'])
        backups = self.home/'.local/state/mac-studio-setup/backups'
        saved = list(backups.rglob('config.toml'))
        self.assertTrue(any('existing-model' in p.read_text() for p in saved))
        self.assertIn('gpt-6.1-sol', config.read_text())
        self.assertEqual(skills.read_text(), 'custom skill source\n')

    def test_symlink_replacement_backs_up_node_and_leaves_owner_untouched(self):
        owner = self.lab/'owner.toml'
        owner.write_text('owner stays intact\n')
        dest = self.home/'.codex/config.toml'
        dest.parent.mkdir()
        dest.symlink_to(owner)
        self.run_script(args=['--config-only', '--replace-config'])
        self.assertFalse(dest.is_symlink())
        self.assertEqual(owner.read_text(), 'owner stays intact\n')
        saved = list((self.home/'.local/state/mac-studio-setup/backups').rglob('config.toml'))
        self.assertTrue(any(p.is_symlink() and p.resolve() == owner for p in saved))

    def test_linked_parent_is_refused_without_modifying_owner(self):
        owner = self.lab/'external'
        owner.mkdir()
        (self.home/'.codex').symlink_to(owner)
        self.run_script(args=['--config-only'], expected=1)
        self.assertEqual(list(owner.iterdir()), [])

    def test_download_corruption_fails_before_binary_install(self):
        self.run_script(expected=1, CORRUPT='1')
        self.assertFalse((self.home/'.local/bin/herdr').exists())
        self.assertFalse((self.home/'.local/bin/treehouse').exists())

    def test_authentication_failure_precedes_package_changes(self):
        self.run_script(expected=1, AUTH_FAIL='1')
        self.assertNotIn('"brew", "install"', self.calls())
        self.assert_home_unchanged()

    def test_existing_firstmate_revision_is_preserved(self):
        self.run_script()
        head = self.home/'karan-agent-workspace/.git/head'
        head.write_text('9'*40)
        self.run_script(expected=1)
        self.assertEqual(head.read_text(), '9'*40)

    def test_pipeline_is_explicit_opt_in(self):
        self.run_script(args=['--with-pipeline'])
        self.assertTrue((self.home/'.local/bin/no-mistakes').exists())
        self.assertNotIn('daemon', self.calls())

    def test_upgrade_backs_up_conflicting_binary(self):
        dest = self.home/'.local/bin/herdr'
        dest.parent.mkdir(parents=True)
        dest.write_text('#!/bin/sh\necho herdr 0.1.0\n')
        dest.chmod(0o755)
        self.run_script()
        self.assertIn('0.1.0', dest.read_text())
        self.run_script(args=['--upgrade'])
        self.assertIn('0.9.3', dest.read_text())
        saved = list((self.home/'.local/state/mac-studio-setup/backups').rglob('herdr'))
        self.assertTrue(any('0.1.0' in p.read_text() for p in saved))

    def test_authenticated_bootstrap_first_install_rerun_and_dirty_refusal(self):
        self.run_script(file='bootstrap.sh', args=['--ref', SHA])
        cache = self.home/'.local/share/mac-studio-setup'/SHA
        self.assertTrue((cache/'install.sh').exists())
        self.assertEqual((cache/'.git/head').read_text(), SHA)
        before = self.snapshot()
        self.run_script(file='bootstrap.sh', args=['--ref', SHA])
        self.assertEqual(self.snapshot(), before)
        self.run_script(file='bootstrap.sh', args=['--ref', SHA], expected=1, DIRTY='1')
        self.assertEqual(self.snapshot(), before)

    def test_bootstrap_refuses_non_commit_and_dry_run_is_empty(self):
        self.run_script(file='bootstrap.sh', args=['--ref', 'main'], expected=1)
        self.run_script(file='bootstrap.sh', args=['--ref', SHA, '--dry-run'])
        self.assert_home_unchanged()
        self.assertEqual(self.calls(), '')


if __name__ == '__main__':
    unittest.main(verbosity=2)
