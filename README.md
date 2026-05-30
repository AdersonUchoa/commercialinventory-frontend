# 🎨 Gestão de Inventário - Web (Front-end)

Esta é a interface de usuário construída com **Nuxt 3** e **Vue.js**, estilizada com TailwindCSS. A aplicação consome a API RESTful de Inventário para gerenciamento de Produtos e Categorias de forma assíncrona e reativa.

## 🛠️ Pré-requisitos

Para rodar este projeto, você precisará:
* [API do Back-end](https://github.com/AdersonUchoa/commercialinventory-backend) rodando (Verifique as respectivas introduções deste para executá-lo, disponíveis no README do repositório da aplicação).
* [Docker e Docker Compose](https://www.docker.com/products/docker-desktop/) (Recomendado)
* [Node.js](https://nodejs.org/) versão 20 ou superior (Caso queira rodar localmente sem Docker).

---

## ⚙️ Configuração de Ambiente

Na raiz do projeto Front-end, crie o seu arquivo de variáveis de ambiente:
1. Faça uma cópia do arquivo `.env.example` e renomeie para `.env`.
2. Certifique-se de que a variável `NUXT_PUBLIC_API_BASE` está apontando para o endereço correto onde sua API está rodando.

```env
# Exemplo do .env
NUXT_PUBLIC_API_BASE="http://localhost:8080/api/v1"
```

---

## 🐳 Executando com Docker (Recomendado)

Certifique-se de que o Back-end (API) já está em execução. Em seguida, abra o terminal na raiz do projeto Front-end e execute:

```bash
# Constrói a imagem otimizada para produção e inicia o container em segundo plano
docker compose up -d --build
```

Após o término da construção, a interface estará acessível em: 👉 `http://localhost:3000`

> **⚠️ Atenção com as portas:** A porta **3000** precisa estar livre na sua máquina. Caso esteja em uso por outro serviço, você pode interrompê-lo ou alterá-la manualmente no `docker-compose.yml` (apenas o número à esquerda do `:`).

Para parar a execução:

```bash
docker compose stop
```

---

## 💻 Executando Localmente (Sem Docker - Modo de Desenvolvimento)

Se desejar alterar o código, debugar ou executar sem o Docker, utilize o servidor de desenvolvimento nativo do Nuxt.

### 1. Instalar os pacotes NPM

```bash
npm install
```

### 2. Iniciar o servidor de desenvolvimento

```bash
npm run dev
```

A aplicação estará disponível em `http://localhost:3000` com Hot-Reload ativado (atualiza automaticamente ao salvar arquivos).