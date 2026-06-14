# Changelog — dev

## 1.0.3 — 2026-06-14

### Mudado
- **dev:** plugin **neutralizado (white-label)** — qualquer pessoa instala e adota como próprio. Removidas as menções ao Praxios e ao claudex (manifesto, README, `auto-prompt`, referências da `planejar`); o nome do marketplace `cassiano-local` virou instrução genérica no README e no `INSTALL.md`; referência a `smart-claudex:findbugs` virou exemplo genérico. **Autoria preservada:** Cassiano Diniz (autor) + Thales Laray (co-autor, novo campo `contributors` no manifesto e crédito no README). Nenhum caminho de máquina, credencial ou dado pessoal embutido — confirmado por varredura.

## 1.0.2 — 2026-06-14

### Adicionado
- **planejar:** nova etapa na Fase 1 — **"Como já resolveram isso" (prior art)**. Antes de desenhar, usa a skill `/pesquisa` pra descobrir como o problema já foi resolvido lá fora e trazer ângulos que o usuário não estava vendo. Recomendada, mas pulável. Método em `references/descoberta-prior-art.md`, com 3 travas contra "visão diferente porém pior": o jeito simples sempre na mesa (baseline) · filtro da realidade do usuário (dá pra uma pessoa só, não-programador, construir e manter?) · confronto adversarial do Codex GPT. A pesquisa informa, o usuário decide. Salva a comparação em `docs/<nome>-prior-art.md`. Fecha o gap: a `/pesquisa` estava instalada mas não era usada por nenhuma skill.
- **dev:** novo **`INSTALL.md`** — arquivo de auto-instalação que reúne todas as dependências externas do plugin (superpowers, taste-skill, find-skills, cloudflare, `/pesquisa`+Perplexity, gemini-api-dev, Stitch MCP, context7, firecrawl, Codex CLI) com os comandos exatos, agrupadas por crítica/com-fallback. Confirmado por investigação: tudo que o professor listou está instalado e em uso pela `planejar` — a `/pesquisa` era a única peça parada.
- **dev:** novo **`install.sh`** — instalador guiado pra quem não curte terminal. Roda sozinho a parte automatizável (skills via `npx` + MCP do Stitch se a chave for passada) e, no fim, lista o pouco que só o usuário pode fazer (colar as linhas de `/plugin` e dar as chaves). O `INSTALL.md` ganhou uma seção "Jeito rápido" no topo separando "o script instala" × "só você faz".

## 1.0.1 — 2026-06-14

### Corrigido
- **auto-prompt:** removidas todas as menções ao "ultracode". A descrição do plugin (vitrine do `/plugin`) dizia que a skill "liga o ultracode sozinha e calibra o esforço pelo tamanho da tarefa" — o oposto da regra interna, que deixa o esforço inteiramente na mão do usuário. Texto realinhado no manifesto, README, frontmatter, corpo da skill e `protocolo.md`. Keyword `ultracode`/`multi-agente` saiu do manifesto.
- **planejar:** as fases agora salvam os dois pareceres do Codex que a tabela final prometia mas o passo a passo não gerava — `docs/<nome>-revisao-problema.md` (Fase 1) e `docs/<nome>-revisao-sanidade.md` (Fase 6).
- **planejar:** removido o manual de instalação antigo (`README-install.md`, jeito `.tar.gz`). A instalação oficial é via `/plugin` → marketplace do plugin, já documentada no README.

### Mudado
- **handoff:** em vez de despejar o documento inteiro no chat, agora **salva o `.md`**, **abre na tela** (`open` no Mac / `start` no Windows Git Bash) e **avisa o caminho** em uma linha. Só cai pro despejo no chat se não houver nenhum local gravável.

## 1.0.0

- Versão inicial: três skills — `planejar` (metodologia de 8 fases), `auto-prompt` (executor Claude + crítico Codex com protocolo de segurança) e `handoff` (passagem de bastão entre sessões).
