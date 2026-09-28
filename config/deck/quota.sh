#!/usr/bin/env bash
# Command deck pane: harness quota per window (compact). Sanitized for mac-studio-setup:
# OpenRouter balance uses OPENROUTER_API_KEY from the environment (load via FM_HOME keys.env).
set -u
INTERVAL=${1:-60}
ONCE=${2:-}
LINE_FILE="$(cd "$(dirname "$0")" && pwd)/quota.line"
while :; do
  frame=$(timeout 60 quota-axi --json --allow-keychain-prompt 2>/dev/null | python3 -c '
import sys,json,datetime,os
d=json.load(sys.stdin)
now=datetime.datetime.now(datetime.timezone.utc)
def left(iso):
    try:
        t=datetime.datetime.fromisoformat(iso.replace("Z","+00:00")); s=int((t-now).total_seconds())
        if s<0: return "now"
        h,m=divmod(s//60,60); dd,h=divmod(h,24)
        return f"{dd}d{h}h" if dd else (f"{h}h{m:02d}" if h else f"{m}m")
    except Exception: return "?"
rows=[]
for p in d.get("providers",[]):
    name=p.get("provider","?"); plan=(p.get("plan") or "")[:5]
    wins=p.get("windows") or []
    st=(p.get("state") or {}).get("status","")
    if not wins:
        att=(p.get("attention") or p.get("auth") or {})
        reason=p.get("reason") or (att.get("detail") if isinstance(att,dict) else "") or st or "no data"
        if "unavailable" in str(reason): continue
        rows.append(f"{name:<9} {plan:<5} -    {str(reason)[:30]}"); continue
    first=True
    for w in wins:
        pct=w.get("percentRemaining"); lab=(w.get("label") or w.get("id") or "")[:9]
        v = pct if pct is not None else "?"
        r = left(w.get("resetsAt",""))
        head = f"{name:<9} {plan:<5}" if first else " "*15
        rows.append(f"{head} {v:>3}% {lab:<9} {r}")
        first=False
print("\n".join(rows))
short=[]
pick={"claude":["session","week","Fable"],"codex":["week"],"cursor":["included"],"grok":["week","credits"],"opencode-go":["rolling"]}
for p in d.get("providers",[]):
    name=p.get("provider","?")
    if name not in pick: continue
    wins=p.get("windows") or []
    if not wins:
        st=(p.get("state") or {}).get("status","")
        short.append(f"{name} " + ("login" if st=="auth_required" else "-")); continue
    bits=[]
    for want in pick[name]:
        for w in wins:
            lab=(w.get("label") or w.get("id") or "")
            if lab.lower().startswith(want.lower()):
                v=w.get("percentRemaining"); v="?" if v is None else v
                suffix=want[0].lower() if name=="claude" else ""
                bits.append(f"{v}%{suffix}")
                break
        if bits and name!="claude": break
    nm="ocgo" if name=="opencode-go" else name
    short.append(nm+" "+" ".join(bits))
try:
    import urllib.request
    _k=os.environ.get("OPENROUTER_API_KEY")
    if _k:
        _r=urllib.request.Request("https://openrouter.ai/api/v1/credits",headers={"Authorization":"Bearer "+_k})
        _d=json.load(urllib.request.urlopen(_r,timeout=4)).get("data",{})
        short.append("or $%.2f" % (float(_d.get("total_credits",0))-float(_d.get("total_usage",0))))
    else:
        short.append("or ?")
except Exception:
    short.append("or ?")
open(sys.argv[1],"w").write(" | ".join(short)+"\n")' "$LINE_FILE")
  clear
  printf '%s  quota · remaining per window (reset in)\n' "$(date +%H:%M:%S)"
  printf '%s\n' "$frame" | cut -c1-53
  [ "$ONCE" = once ] && exit 0
  sleep "$INTERVAL"
done
