# IAC · Resolvedoria — como publicar

Arquivos:

- `index.html`: formulário que o líder comercial preenche (empresa, e-mail, momento e os 20 critérios).
- `admin.html`: seu painel. Entra com e-mail e senha, escolhe a empresa, vê os envios, valida as notas e compara inicial com final.
- `iac.js`: critérios, opções de resposta e cálculo do índice. Para mudar um texto de critério, é aqui.
- `estilo.css`: identidade visual.
- `config.js`: endereço e chave do Supabase (você preenche no passo 5).
- `supabase.sql`: cria as tabelas e as regras de acesso.

## Parte 1 — Supabase (banco de dados), cerca de 10 minutos

1. Entre em supabase.com (pode entrar com a conta do GitHub) e crie um projeto: nome `iac-resolvedoria`, região **South America (São Paulo)**. Guarde a senha do banco que ele pedir.
2. No menu da esquerda, abra **SQL Editor**, clique em **New query**, cole todo o conteúdo de `supabase.sql` e clique em **Run**. Deve aparecer "Success".
3. Abra **Authentication > Users > Add user > Create new user**. Use `joao@resolvedoria.com.br`, crie uma senha e marque **Auto Confirm User**. Esse é o seu login do painel.
4. Em **Authentication > Sign In / Providers**, desligue **Allow new users to sign up**. Assim ninguém mais cria conta.
5. Em **Project Settings > API**, copie a **Project URL** e a chave **anon public**. Abra `config.js` e cole cada uma no lugar de `COLE_AQUI_...`.

Se quiser usar outro e-mail de administrador, troque `joao@resolvedoria.com.br` em `supabase.sql` antes do passo 2.

## Parte 2 — GitHub Pages (site), cerca de 5 minutos

6. Em github.com, crie um repositório **público** chamado `iac`. Na tela seguinte, clique em **uploading an existing file**, arraste os seis arquivos (`index.html`, `admin.html`, `iac.js`, `estilo.css`, `config.js`, `supabase.sql`) e clique em **Commit changes**.
7. No repositório, abra **Settings > Pages**. Em **Source**, escolha **Deploy from a branch**, branch **main**, pasta **/ (root)**, e salve.
8. Em um ou dois minutos o site fica no ar:
   - Formulário para o cliente: `https://SEU-USUARIO.github.io/iac/`
   - Seu painel: `https://SEU-USUARIO.github.io/iac/admin.html`

## Bom saber

- **A chave anon fica visível no site, e isso é normal.** Quem protege os dados são as regras do `supabase.sql`: qualquer pessoa com o link consegue enviar respostas, mas só o seu login consegue ler, validar ou apagar.
- **O plano gratuito do Supabase pausa o projeto depois de 7 dias sem uso.** Se o formulário parar de enviar, entre no Supabase e clique em **Restore project**. Com clientes respondendo toda semana, isso não deve acontecer.
- **Envio errado ou de teste:** apague em **Table Editor > iac_respostas** no Supabase.
- **Empresa escrita de jeitos diferentes** ("Acme", " acme "): o painel junta maiúsculas, acentos e espaços. Nomes diferentes de fato ("Acme" e "Acme Ltda") aparecem separados.
- **Rascunho:** o formulário guarda as respostas no navegador de quem está preenchendo. Se a pessoa fechar a página, encontra tudo lá ao voltar.
