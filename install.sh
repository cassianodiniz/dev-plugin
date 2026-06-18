#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════════
# install.sh — instalador guiado das dependências do plugin `Titan`.
#
# Roda sozinho tudo que dá pra automatizar (skills via npx + MCP do Stitch)
# e, no fim, lista o pouco que SÓ VOCÊ pode fazer (colar os /plugin e dar as
# chaves) — porque comando /plugin é digitado por você no Claude Code, não
# pelo script.
#
# Uso:
#   bash install.sh                         # instala as skills automáticas
#   STITCH_API_KEY=xxxx bash install.sh     # + configura o MCP do Stitch
#
# Mac/Linux nativo; no Windows, via Git Bash.
# ════════════════════════════════════════════════════════════════════════
set -uo pipefail

say()  { printf '%s\n' "$*"; }
ok()   { printf '  ✅ %s\n' "$*"; }
warn() { printf '  ⚠️  %s\n' "$*"; }

say "=== Instalador do plugin Titan — dependências externas ==="
say ""

# ── Pré-requisitos ──────────────────────────────────────────────────────
command -v npx >/dev/null 2>&1 \
  || warn "npx (Node.js) não encontrado — instale o Node (https://nodejs.org). As skills via npx não vão rodar."
command -v claude >/dev/null 2>&1 \
  || warn "CLI 'claude' não encontrada no PATH — o MCP do Stitch precisa dela."
say ""

run() {
  local desc="$1"; shift
  say "→ $desc"
  if "$@"; then ok "$desc — ok"; else warn "$desc — falhou; veja o passo manual no INSTALL.md"; fi
  say ""
}

# ── 1. Skills que o script instala sozinho ──────────────────────────────
run "Taste Skill (design-taste-frontend)" \
  npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"
run "Find Skill" \
  npx skills add https://github.com/vercel-labs/skills --skill find-skills
run "Gemini (gemini-api-dev)" \
  npx skills add google-gemini/gemini-skills --skill gemini-api-dev --global

# ── 2. MCP do Stitch (só se você passar a chave) ────────────────────────
KEY="${STITCH_API_KEY:-${GOOGLE_STITCH_API_KEY:-}}"
if [ -n "$KEY" ]; then
  run "MCP Google Stitch" \
    claude mcp add stitch --transport http https://stitch.googleapis.com/mcp \
      --header "X-Goog-Api-Key: $KEY" -s user
else
  warn "MCP Stitch pulado — rode 'STITCH_API_KEY=suachave bash install.sh' pra configurar, ou use o comando manual do INSTALL.md."
  say ""
fi

# ── 3. O que só você pode fazer ─────────────────────────────────────────
say "════════════════════════════════════════════════════════════════"
say "FALTA VOCÊ FAZER (eu não consigo digitar /plugin por você):"
say ""
say "  Cole no Claude Code, uma linha por vez:"
say "    /plugin marketplace add obra/superpowers-marketplace"
say "    /plugin install superpowers@superpowers-marketplace"
say "    /plugin marketplace add cloudflare/skills"
say "    /plugin install cloudflare@cloudflare"
say ""
say "  Chaves e serviços (detalhe no INSTALL.md):"
say "    • GEMINI_API_KEY → https://aistudio.google.com/apikey  (mockups)"
say "    • /pesquisa      → curso do professor (operacaoautonomia...)"
say "    • MCPs context7 / firecrawl / perplexity → conforme seu provedor"
say "    • Codex CLI (o crítico) → instalar e logar"
say "════════════════════════════════════════════════════════════════"
say ""
say "Pronto. O preflight da Fase 0 do /planejar confere o que ficou faltando."
