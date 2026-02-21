#!/bin/bash
# Diagnostic script for Telegram 401 errors on Railway
# Run with: railway run bash scripts/diagnose-telegram.sh

echo "=== Telegram Diagnostic Report ==="
echo ""

echo "1. Checking gateway processes:"
ps aux | grep -E 'gateway|openclaw' | grep -v grep || echo "No gateway processes found"
echo ""

echo "2. Checking port 18789:"
lsof -i:18789 2>/dev/null || echo "lsof not available or port not in use"
echo ""

echo "3. Checking config file:"
if [ -f /data/.openclaw/openclaw.json ]; then
  echo "Config exists at /data/.openclaw/openclaw.json"
  echo "Telegram config:"
  cat /data/.openclaw/openclaw.json | grep -A 10 '"telegram"' | grep -v 'botToken' || echo "No telegram config found"
  echo ""
  echo "Gateway auth config:"
  cat /data/.openclaw/openclaw.json | grep -A 5 '"auth"' || echo "No auth config found"
else
  echo "Config file NOT FOUND at /data/.openclaw/openclaw.json"
fi
echo ""

echo "4. Checking gateway token file:"
if [ -f /data/.openclaw/gateway.token ]; then
  echo "Gateway token file exists"
  echo "Token length: $(wc -c < /data/.openclaw/gateway.token) chars"
else
  echo "Gateway token file NOT FOUND"
fi
echo ""

echo "5. Checking lock files:"
ls -la /data/.openclaw/*.lock 2>/dev/null || echo "No lock files found"
ls -la /data/.openclaw/*.pid 2>/dev/null || echo "No PID files found"
echo ""

echo "6. Testing gateway connectivity:"
curl -s http://localhost:18789/healthz 2>&1 | head -5 || echo "Gateway not reachable on localhost:18789"
echo ""

echo "7. Checking wrapper logs (last 20 lines):"
tail -20 /tmp/*.log 2>/dev/null || echo "No log files in /tmp"
echo ""

echo "8. Checking OpenClaw logs:"
if [ -d /tmp/openclaw ]; then
  echo "OpenClaw log directory exists"
  ls -lt /tmp/openclaw/*.log 2>/dev/null | head -5
  echo "Latest log tail:"
  tail -10 /tmp/openclaw/*.log 2>/dev/null | grep -E "telegram|401|auth" | head -10 || echo "No relevant log entries"
else
  echo "OpenClaw log directory NOT FOUND"
fi
echo ""

echo "=== End Diagnostic Report ==="
