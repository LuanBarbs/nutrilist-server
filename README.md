# NutriList Server

Backend da aplicação NutriList desenvolvido com NestJS, TypeORM e PostgreSQL para gerenciamento de listas de compras nutricionais.

## Sobre o Projeto

O NutriList Server é uma API RESTful que fornece serviços para a aplicação móvel NutriList, permitindo o gerenciamento de usuários, produtos, listas de compras e itens. A aplicação utiliza arquitetura modular com NestJS e banco de dados PostgreSQL.

## Tecnologias Utilizadas

- **NestJS** - Framework Node.js para construção de aplicações escaláveis
- **TypeScript** - Linguagem de programação tipada
- **TypeORM** - ORM para TypeScript e JavaScript
- **PostgreSQL** - Banco de dados relacional
- **bcrypt** - Biblioteca para hash de senhas
- **Jest** - Framework de testes
- **ESLint** - Linter para qualidade de código

## Estrutura do Projeto

```
src/
├── app/
│   ├── app.controller.ts     # Controlador principal
│   ├── app.module.ts         # Módulo principal da aplicação
│   └── app.service.ts        # Serviço principal
├── database/
│   └── database.providers.ts # Configurações do banco de dados
├── user/
│   ├── user.controller.ts     # Controlador de usuários
│   ├── user.entity.ts         # Entidade de usuário
│   ├── user.module.ts         # Módulo de usuários
│   └── user.service.ts        # Serviço de usuários
├── produto/
│   ├── produto.controller.ts   # Controlador de produtos
│   ├── produto.entity.ts       # Entidade de produto
│   ├── produto.module.ts       # Módulo de produtos
│   └── produto.service.ts      # Serviço de produtos
├── lista/
│   ├── lista.controller.ts     # Controlador de listas
│   ├── lista.module.ts         # Módulo de listas
│   └── lista.service.ts        # Serviço de listas
├── item/
│   ├── item.controller.ts      # Controlador de itens
│   ├── item.entity.ts          # Entidade de item
│   ├── item.module.ts          # Módulo de itens
│   └── item.service.ts         # Serviço de itens
└── main.ts                     # Ponto de entrada da aplicação
```

## Modelos de Dados

### Usuário (User)
- Gerenciamento de contas de usuário
- Autenticação e autorização
- Dados pessoais e preferências

### Produto (Produto)
- Catálogo de produtos nutricionais
- Categorização e informações nutricionais
- Preços e disponibilidade

### Lista (Lista)
- Listas de compras personalizadas
- Associação com usuários
- Datas de criação e modificação

### Item (Item)
- Itens individuais nas listas
- Quantidades e observações
- Relacionamento com produtos

## Pré-requisitos

- Node.js (versão 18 ou superior)
- npm ou yarn
- PostgreSQL (versão 12 ou superior)
- NestJS CLI (opcional, para desenvolvimento)

## Instalação e Execução

1. **Clone o repositório**
   ```bash
   git clone <url-do-repositorio>
   cd nutrilist-server
   ```

2. **Instale as dependências**
   ```bash
   npm install
   ```

3. **Configure o banco de dados**
   - Crie um banco PostgreSQL
   - Configure as variáveis de ambiente (DATABASE_URL)
   - Execute as migrações (se aplicável)

4. **Inicie a aplicação**
   ```bash
   # Desenvolvimento
   npm run start:dev
   
   # Produção
   npm run build
   npm run start:prod
   ```

## Scripts Disponíveis

- `npm run build` - Compila o projeto
- `npm run start` - Inicia a aplicação
- `npm run start:dev` - Inicia em modo desenvolvimento com hot-reload
- `npm run start:debug` - Inicia em modo debug
- `npm run start:prod` - Inicia em modo produção
- `npm run lint` - Executa o linter
- `npm run test` - Executa os testes
- `npm run test:watch` - Executa os testes em modo watch
- `npm run test:cov` - Executa os testes com cobertura
- `npm run test:e2e` - Executa os testes end-to-end

## Configuração da API

A API está configurada para rodar na porta 3000 por padrão e inclui:

- **CORS habilitado** para todas as origens (configurável para produção)
- **Validação de dados** com pipes do NestJS
- **Interceptors** para transformação de respostas
- **Guards** para autenticação e autorização

## Endpoints da API

### Usuários
- `POST /users` - Criação de usuário
- `GET /users/:id` - Busca usuário por ID
- `PUT /users/:id` - Atualização de usuário
- `DELETE /users/:id` - Remoção de usuário

### Produtos
- `GET /produtos` - Lista todos os produtos
- `POST /produtos` - Criação de produto
- `GET /produtos/:id` - Busca produto por ID
- `PUT /produtos/:id` - Atualização de produto

### Listas
- `GET /listas` - Lista todas as listas
- `POST /listas` - Criação de lista
- `GET /listas/:id` - Busca lista por ID
- `PUT /listas/:id` - Atualização de lista

### Itens
- `GET /items` - Lista todos os itens
- `POST /items` - Criação de item
- `PUT /items/:id` - Atualização de item
- `DELETE /items/:id` - Remoção de item