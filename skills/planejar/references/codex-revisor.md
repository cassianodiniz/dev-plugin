# Revisor Codex (segundo par de olhos)

A `/planejar` usa o Codex GPT-5.5 como revisor independente em dois momentos: a sanidade do **problema** (Fase 1) e a sanidade do **plano** (Fase 6). É um modelo DIFERENTE do que conduz o planejamento — a graça é a divergência de opinião, não a confirmação.

Não é auditoria técnica linha a linha (isso são os subagents de domínio da Fase 6). Aqui a lente é única: **isso faz sentido / resolve o problema?**

## Regra de ouro — o Claude filtra antes, com PROVA

O parecer do Codex NUNCA é aplicado cego. Para cada ponto que ele levantar, o Claude verifica: **isso procede?** Confronta com o escopo e o plano reais.
- Não procede → descarta, **mas a refutação tem que ser provada**: aponte o `arquivo:linha` ou a seção do plano/escopo que contradiz o ponto do Codex. Proibido refutar com opinião ("não acho que se aplica") — sem evidência concreta, o ponto NÃO pode ser descartado; na dúvida, trata como procede.
- Procede e é **grave** (problema mal formulado, plano não resolve, caminho muito mais simples) → é decisão de produto: **PARA e pergunta ao usuário** em linguagem de diretor (A/B), nunca decide sozinho.
- Procede e é **menor** → entra na lista de achados normal e é corrigido no fluxo (Fase 1: ajusta o escopo; Fase 6: vira achado da auditoria, corrigido na Fase 7).

### Registro obrigatório — tudo documentado, sim ou não

Todo ponto do Codex vira uma linha de registro, **aceito ou refutado**, com a prova ao lado. Sem isso vira história de "ele falou, eu ignorei" sem rastro. Anexe esta tabela ao final do arquivo de parecer (`docs/<nome>-revisao-problema.md` na Fase 1, `docs/<nome>-revisao-sanidade.md` na Fase 6):

```markdown
## Veredito do Claude (cada ponto do Codex, com prova)

| # | Ponto do Codex (resumo) | Veredito | Prova (arquivo:linha / seção) | Destino |
|---|--------------------------|----------|-------------------------------|---------|
| 1 | <o que o Codex disse>    | PROCEDE  | `docs/x-plano.md` §Backend     | Ajuste aplicado |
| 2 | <...>                    | REFUTADO | `src/api/auth.ts:42` já trata  | Descartado |
| 3 | <...>                    | PROCEDE/GRAVE | §Arquitetura — não resolve o caso Y | Subiu pro usuário (A/B) |
```

Regras da tabela:
- **Uma linha por ponto do Codex** — nenhum fica de fora.
- Coluna **Prova** nunca vazia: PROCEDE cita onde o plano falha; REFUTADO cita o `arquivo:linha` ou seção que já cobre aquilo. "Subjetivo / a meu ver" não é prova.
- **Destino** fecha o ciclo: `Descartado`, `Ajuste aplicado`, ou `Subiu pro usuário (A/B)`.

## Pré-requisito

`codex` CLI instalado e logado na máquina. Se a chamada falhar (binário ausente, erro), NÃO trava o fluxo: o Claude faz o papel do revisor por conta própria, com a mesma lente crítica (advogado do diabo), e informa que rodou sem o Codex.

## Gotcha obrigatório

Toda chamada termina com `< /dev/null`. Sem isso o `codex exec` trava esperando stdin quando rodado via Bash tool (reproduzido empiricamente). O parecer sai no arquivo apontado por `-o`.

---

## Chamada 1 — Sanidade do PROBLEMA (Fase 1, uma vez só)

Roda DEPOIS de fechar problema + escopo do MVP + nome, ANTES do gate de aprovação da Fase 1. Esforço `high` (checagem rápida de enquadramento, não revisão pesada).

Salve o escopo da Fase 1 em `docs/<nome>-escopo.md` (problema, público, fluxos principais, MVP vs futuro, nome) e aponte o Codex pra ele:

```bash
OUT="docs/<nome>-revisao-problema.md"
codex exec \
  --model gpt-5.5 \
  -c model_reasoning_effort="high" \
  --skip-git-repo-check \
  --ignore-user-config \
  --full-auto \
  -o "$OUT" \
  "Voce e um revisor critico de PRODUTO. Alguem vai construir algo e definiu o PROBLEMA e o escopo do MVP. NAO revise codigo, NAO sugira stack. Uma passada so, responda tres perguntas:
1. O problema declarado e real e claro, ou esta vago / mal formulado?
2. O escopo do MVP ataca ESSE problema, ou esta resolvendo a coisa errada?
3. Voce sugeriria repensar algo ANTES de investir em pesquisa e plano? (escopo grande demais, premissa fragil, alternativa obvia ignorada, problema que talvez nem precise de software)

Leia: docs/<nome>-escopo.md

Devolva NESTE formato:
## Veredito
SEGUIR  |  REPENSAR
## Pontos
- (no maximo 5, cada um curto e acionavel; se REPENSAR, diga exatamente o que repensar)
Sem elogio, sem resumo do que voce leu." \
  < /dev/null
```

Depois: o Claude lê `$OUT`, filtra pela regra de ouro e apresenta ao usuário. Se `REPENSAR` com ponto que procede → A/B (seguir assim mesmo / ajustar o escopo). Se `SEGUIR` → menciona em uma linha e avança o gate normal da Fase 1.

---

## Chamada 2 — Sanidade do PLANO (Fase 6, junto da auditoria técnica)

Roda na Fase 6, em paralelo aos subagents de domínio. Lente: o plano resolve o problema? Esforço `xhigh` (revisão profunda).

```bash
OUT="docs/<nome>-revisao-sanidade.md"
codex exec \
  --model gpt-5.5 \
  -c model_reasoning_effort="xhigh" \
  --skip-git-repo-check \
  --ignore-user-config \
  --full-auto \
  -o "$OUT" \
  "Voce e o critico de SANIDADE de um plano de implementacao. NAO faca auditoria tecnica linha a linha (outro revisor cuida disso) e NAO marque coisas 'faltando no codigo' (o codigo ainda nao foi escrito). Responda so tres perguntas, com evidencia:
1. O plano RESOLVE o problema declarado? (o problema esta em docs/<nome>-escopo.md; o plano em <path-do-plano>)
2. Existe um caminho substancialmente MAIS SIMPLES pro mesmo resultado?
3. Tem parte do plano que NAO serve ao objetivo (peso morto que da pra cortar)?

Devolva NESTE formato:
## Veredito
RESOLVE  |  RESOLVE PARCIAL  |  NAO RESOLVE
## Pontos
- (cada um citando a SECAO do plano afetada; se houver caminho muito mais simples ou peso morto, seja especifico)
Se o veredito for NAO RESOLVE ou houver um caminho muito mais simples, deixe explicito — isso e decisao de produto, nao um ajuste tecnico. Sem elogio, sem resumo." \
  < /dev/null
```

Depois: o Claude lê `$OUT` e aplica a regra de ouro.
- `NAO RESOLVE` (que procede) ou "caminho muito mais simples" → **PARA**, sobe pro usuário em A/B antes da Fase 7.
- `RESOLVE PARCIAL` / pontos menores que procedem → entram no relatório da Fase 6 como achados (prioridade conforme o caso) e são corrigidos na Fase 7.
- Pontos que não procedem → descarta, registra o motivo no relatório.
