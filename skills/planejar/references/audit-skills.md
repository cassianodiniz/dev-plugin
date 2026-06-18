# Skills de Auditoria por Dominio

Referencia de quais skills usar na Fase 6 (Auditoria) baseado na stack do projeto.

**Esta tabela e um EXEMPLO de mapeamento, nao a fonte da verdade.** A fonte da verdade e a lista de skills disponiveis no contexto da sessao (sempre presente no system prompt). Skills instaladas depois desta tabela tambem devem ser consideradas — filtre a lista da sessao pelos dominios da stack do projeto. Os nomes abaixo sao skills reais instaladas (plugins de boas praticas); se um nome nao aparecer mais na sessao, ignore e use o que estiver disponivel.

## Mapeamento (skills reais instaladas)

| Dominio | Skills |
|---------|--------|
| React / Next.js | `vercel:react-best-practices`, `vercel:nextjs`, `vercel:next-cache-components`, `vercel:routing-middleware` |
| Frontend / UI | `frontend-design:frontend-design`, `design:design-critique`, `design:design-system` |
| Supabase / Postgres | `supabase:supabase`, `supabase:supabase-postgres-best-practices` |
| Cloudflare (Workers, D1, R2, KV) | `cloudflare:workers-best-practices`, `cloudflare:durable-objects`, `cloudflare:wrangler` |
| Deploy / CI-CD (Vercel) | `vercel:deployments-cicd`, `vercel:verification`, `vercel:vercel-functions` |
| Performance web | `cloudflare:web-perf` |
| Seguranca | `security-review`, `code-review` |
| Acessibilidade | `design:accessibility-review` |
| IA / LLM | `claude-api`, `gemini-api-dev`, `vercel:ai-sdk`, `vercel:ai-gateway` |
| Testes / verificacao | `superpowers:test-driven-development`, `superpowers:verification-before-completion`, `verify` |
| Plugin / skill Claude Code | `plugin-Titan:skill-development`, `plugin-Titan:plugin-structure` |
| Caca-bug generica (qualquer repo) | skill de caca-bug generica instalada, se houver (ex.: `*:findbugs`) |

## Dominios transversais

Independente da stack, considere sempre nesses casos:

- **Seguranca** (`security-review` / `code-review`) — qualquer produto com auth, dados de usuario ou API publica
- **Acessibilidade** (`design:accessibility-review`) — qualquer produto com UI
- **Testes** (`superpowers:test-driven-development`) — qualquer plano que inclua testes (todos deveriam)

## Dominio sem skill local

Se a stack tem um dominio sem skill de boas praticas instalada (ex: SwiftUI, Vue, Django, Flutter):

1. Invocar `find-skills` pra procurar uma skill daquela tecnologia — encontrou algo bom, propor instalacao ao usuario (nunca instalar sem aprovacao).
2. Nao encontrou (ou usuario recusou) → o subagent daquele dominio audita usando docs oficiais via `context7` + boas praticas gerais, e o relatorio marca o dominio como "auditado sem skill especializada".

## Como atualizar

Quando instalar novas skills tecnicas, adicione-as na tabela acima no dominio correspondente — mas lembre: mesmo sem atualizar a tabela, o modelo deve filtrar a lista da sessao na hora da auditoria.
