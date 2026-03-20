# Prompt para Claude Code

---

Quero que você construa um projeto completo, do zero, que ao final entregue uma URL pública de um site estático hospedado no S3 da AWS, usando Terraform para toda a infraestrutura.

## O que o projeto deve fazer

O usuário acessa a URL e vê uma sequência automática de três fases, sem nenhum clique:

**Fase 1 — Boot Slackware (15 segundos)**
Simulação fiel de boot do Slackware Linux 15.0 ocupando a tela inteira. Fundo preto, fonte monoespaçada verde fósforo, efeito CRT com scanlines e vinheta. As linhas de boot aparecem progressivamente com timing realista, incluindo: mensagens do kernel (azuladas), serviços sendo iniciados com status `[ OK ]` em verde e `[ SKIP ]` em âmbar, hostname `slackware15`, Apache e SSH subindo. Nos últimos 2 segundos exibe o ASCII art do logo Slackware e a linha "Slackware Linux 15.0 (kernel 5.15.19)".

**Fase 2 — Mensagem (15 segundos)**
Tela preta. Centro da tela: emoji 😄 grande pulsando com glow verde. Abaixo, em fonte VT323 grande, o texto aparece com fade-in:
```
Não daria pra fazer em 30 minutos...
mas daria sim. 😄
Espere mais 15 segundos.
```
Texto branco com sombra verde. Embaixo, menor, em verde escuro: `iniciando mario world...`

**Fase 3 — Mario World**
Barra de loading estilo terminal verde com percentual e steps fake ("loading sprites...", "initializing physics...", "loading world 1-1..."). Ao chegar em 100%, redireciona automaticamente para `./mario/` onde está o jogo.

## Stack do projeto

- **Infraestrutura**: Terraform (AWS provider), perfil pessoal (`~/.aws/credentials` profile `pessoal` — ajuste se necessário)
- **Região**: `sa-east-1`
- **Hosting**: S3 bucket com static website hosting habilitado, policy pública de leitura
- **Jogo Mario**: clonar `https://github.com/meth-meth-method/super-mario` na pasta `mario/` do projeto. Se esse repo precisar de build com npm, executar o build e copiar o output. Se não funcionar, usar como fallback `https://github.com/robertkleinschuster/mario`
- **Deploy**: `aws s3 sync` via `local-exec` no Terraform OU script `deploy.sh` separado que roda após o `terraform apply`
- **Output**: ao fim do apply, exibir a URL pública do site no terminal

## Estrutura de arquivos esperada do projeto

```
mario-slackware/
├── main.tf              # S3 bucket + static hosting + bucket policy
├── outputs.tf           # output: website_url
├── variables.tf         # aws_profile, region, bucket_name
├── terraform.tfvars     # valores padrão (profile=pessoal, região sa-east-1)
├── deploy.sh            # script: terraform apply + aws s3 sync
├── site/
│   ├── index.html       # splash page completa (fases 1+2+3)
│   └── mario/           # clone/build do jogo aqui
└── README.md            # instruções de uso em 5 linhas
```

## Requisitos da splash page (index.html)

- Arquivo único, zero dependências externas exceto Google Fonts (VT323 + Share Tech Mono)
- Todo o JavaScript inline, sem frameworks
- Funciona offline após carregado (exceto fontes)
- Responsivo — funciona em desktop e mobile
- A fase 3 redireciona para `./mario/index.html` (ou o entry point correto do clone escolhido)

## O que Claude Code deve entregar ao final

1. Todos os arquivos do projeto criados localmente
2. Saída do `terraform init` e `terraform apply` bem-sucedidos
3. Clone/build do Mario em `site/mario/`
4. `aws s3 sync` executado
5. **URL pública impressa no terminal**, pronta para copiar e colar no browser
6. Commit e push de todo o projeto para `git@github.com:AntonioMPereira/slack-mario-presente-beto.git`

Para o passo 6, executar em sequência:
```bash
git init
git remote add origin git@github.com:AntonioMPereira/slack-mario-presente-beto.git
git add .
git commit -m "feat: mario slackware splash + terraform s3 deploy"
git branch -M main
git push -u origin main
```

Adicionar `.gitignore` com:
```
.terraform/
*.tfstate
*.tfstate.backup
.terraform.lock.hcl
site/mario/node_modules/
```

O `.tfstate` não vai para o repo — contém ARNs e dados da conta AWS.

## Observações

- Não criar CloudFront, Route53, ACM ou qualquer outro recurso além do S3. HTTP simples é suficiente.
- O bucket name deve ser único — usar sufixo aleatório ou timestamp: ex. `mario-slackware-{random_id}`
- Se o Mario precisar de ajuste no entry point (pasta `public/`, `dist/`, etc.), detectar automaticamente e ajustar o redirect na fase 3
- Não pedir confirmações intermediárias — executar tudo em sequência até a URL estar no ar
