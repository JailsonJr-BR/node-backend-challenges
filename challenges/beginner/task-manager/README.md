# Desafio: Gerenciador de Tarefas (Task Manager API)

## 📝 Descrição

Neste desafio, você irá criar uma API REST para gerenciar tarefas de usuários, contemplando operações de CRUD
(Create, Read, Update, Delete), além de um sistema básico de autenticação e registro de usuários.

O objetivo é praticar os fundamentos do desenvolvimento backend em Node.js, incluindo organização de projeto,
boas práticas de arquitetura, uso de banco de dados e recursos de segurança mínimos (autenticação JWT).

## 🎯 Objetivos

- Familiarizar-se com a criação de APIs REST utilizando Node.js e Express (ou outro framework HTTP).
- Aplicar conceitos de CRUD e autenticação básica.
- Aprender a estruturar um projeto, separando regras de negócio, rotas, modelos e controllers.
- Entender como lidar com respostas HTTP, códigos de status e boas práticas de versionamento de API.
- Praticar integração com banco de dados (SQL ou NoSQL).

## 📋 Requisitos

### Funcionais

#### Cadastro de usuário

- O usuário deve poder se cadastrar informando: nome, e-mail e senha.
- Não deve ser possível cadastrar dois usuários com o mesmo e-mail.

#### Autenticação de usuário

- O usuário deve poder fazer login com e-mail e senha.
- Ao autenticar com sucesso, retornar um token JWT que dará acesso às rotas protegidas.

#### Gerenciamento de tarefas

- Criar tarefa: o usuário autenticado deve poder criar uma tarefa, informando título, descrição e status.
- Listar tarefas: o usuário autenticado deve poder listar todas as suas tarefas.
- Obter tarefa específica: buscar detalhes de uma tarefa pelo seu ID.
- Atualizar tarefa: o usuário pode atualizar o título, descrição ou status de uma tarefa.
- Excluir tarefa: o usuário pode excluir a tarefa.

#### Associação usuário/tarefas

- Cada tarefa deve pertencer a apenas um usuário.
- O usuário só pode visualizar/alterar/excluir suas próprias tarefas.

### Não Funcionais

- Segurança básica: proteger rotas de criação, atualização e exclusão de tarefas exigindo token JWT válido.
- Boas práticas de código: manter padrão de nomenclatura consistente.
- Mensagens de erro claras: em caso de erros ou validações, a API deve retornar mensagens claras.

### Técnicos

- Node.js na versão LTS ou superior.
- Framework HTTP (Express, Fastify, Hapi, etc.).
- Banco de dados relacional (MySQL, PostgreSQL) ou NoSQL (MongoDB).
- Ferramenta de migração (caso seja SQL) ou scripts de seed (caso NoSQL).
- Gerenciamento de dependências (npm ou yarn).
- Uso de .env para gerenciar variáveis de ambiente.
- Autenticação usando JWT (jsonwebtokens).

## 📐 Arquitetura (Sugestão)

```
project/
│   package.json
│   .env
│   README.md
└───src/
    └── config/
    │     database.js       // Configurações de conexão com o banco
    └── controllers/
    │     auth.controller.js
    │     task.controller.js
    │     user.controller.js
    └── models/
    │     user.model.js
    │     task.model.js
    └── routes/
    │     auth.routes.js
    │     task.routes.js
    │     user.routes.js
    └── middleware/
    │     auth.middleware.js
    └── services/
          auth.service.js
          task.service.js
          user.service.js
└─── tests/ (opcional)
```

### Responsabilidades

- Controllers: Recebem requisições, chamam services e retornam respostas.
- Services: Contêm regras de negócio e interação com os models.
- Models: Definem os schemas e interagem com o banco de dados.
- Routes: Definem os endpoints da aplicação.
- Middleware: Lógica de validação e autenticação.

## 📊 Modelos de Dados

### User

```javascript
{
  id: String,        // pode ser UUID ou ObjectId (caso MongoDB)
  name: String,
  email: String,
  password: String,  // armazenada com hash
  createdAt: Date,
  updatedAt: Date
}
```

### Task

```javascript
{
  id: String,        // pode ser UUID ou ObjectId
  title: String,
  description: String,
  status: String,    // "pending", "completed"
  userId: String,    // referência para o usuário dono da tarefa
  createdAt: Date,
  updatedAt: Date
}
```

## 🔗 API Endpoints

### Auth

#### POST /api/v1/auth/register

Body:

```json
{
  "name": "Exemplo",
  "email": "exemplo@mail.com",
  "password": "123456"
}
```

Resposta (sucesso - 201):

```json
{
  "message": "Usuário criado com sucesso!",
  "user": {
    "id": "12345",
    "name": "Exemplo",
    "email": "exemplo@mail.com"
  }
}
```

Resposta (erro - 400 ou 409):

```json
{
  "message": "E-mail já cadastrado."
}
```

#### POST /api/v1/auth/login

Body:

```json
{
  "email": "exemplo@mail.com",
  "password": "123456"
}
```

Resposta (sucesso - 200):

```json
{
  "message": "Autenticado com sucesso!",
  "token": "<JWT_TOKEN>"
}
```

Resposta (erro - 401 ou 400):

```json
{
  "message": "Credenciais inválidas."
}
```

### Tasks (todas exigem autenticação)

#### POST /api/v1/tasks

Body:

```json
{
  "title": "Aprender Node.js",
  "description": "Estudar documentação oficial e fazer projetos práticos"
}
```

Resposta (sucesso - 201):

```json
{
  "message": "Tarefa criada com sucesso!",
  "task": {
    "id": "123",
    "title": "Aprender Node.js",
    "description": "Estudar documentação oficial e fazer projetos práticos",
    "status": "pending",
    "createdAt": "2025-01-01T10:00:00.000Z",
    "updatedAt": "2025-01-01T10:00:00.000Z"
  }
}
```

#### GET /api/v1/tasks

Resposta (sucesso - 200):

```json
{
  "tasks": [
    {
      "id": "123",
      "title": "Aprender Node.js",
      "description": "Estudar documentação oficial e fazer projetos práticos",
      "status": "pending"
    },
    {
      "id": "456",
      "title": "Praticar testes",
      "description": "Escrever testes unitários e de integração",
      "status": "pending"
    }
  ]
}
```

#### GET /api/v1/tasks/:taskId

Resposta (sucesso - 200):

```json
{
  "task": {
    "id": "123",
    "title": "Aprender Node.js",
    "description": "Estudar documentação oficial e fazer projetos práticos",
    "status": "pending"
  }
}
```

Resposta (erro - 404):

```json
{
  "message": "Tarefa não encontrada."
}
```

#### PUT /api/v1/tasks/:taskId

Body:

```json
{
  "title": "Aprender Node.js (atualizado)",
  "status": "completed"
}
```

Resposta (sucesso - 200):

```json
{
  "message": "Tarefa atualizada com sucesso!",
  "task": {
    "id": "123",
    "title": "Aprender Node.js (atualizado)",
    "description": "Estudar documentação oficial e fazer projetos práticos",
    "status": "completed"
  }
}
```

Resposta (erro - 403):

```json
{
  "message": "Você não tem permissão para atualizar esta tarefa."
}
```

#### DELETE /api/v1/tasks/:taskId

Resposta (sucesso - 200):

```json
{
  "message": "Tarefa excluída com sucesso!"
}
```

Resposta (erro - 403):

```json
{
  "message": "Você não tem permissão para excluir esta tarefa."
}
```

## 📈 Critérios de Avaliação

- Corretude: A API funciona conforme o esperado? Todas as rotas atendem seus requisitos?
- Organização do Código: Uso de uma arquitetura separando controllers, services e models.
- Boas Práticas:
  - Uso de status codes corretos (200, 201, 400, 401, 403, 404, 409, 500).
  - Mensagens de erro amigáveis.
  - Tratamento de exceções.
- Segurança: Implementação mínima de autenticação JWT e proteção de rotas sensíveis.
- Documentação: O projeto possui um README claro com instruções de instalação, configuração e uso?
- Escalabilidade (básico): Cuidado com a estrutura, evitando hardcodes ou códigos monolíticos confusos.
- Validações: Garantir que campos obrigatórios sejam validados antes de salvar no banco.

## 🎁 Bônus (Opcionais)

- Filtros de busca de tarefas: por status (pending, completed), por data de criação, etc.
- Paginação na listagem de tarefas (ex.: `?page=1&limit=10`).
- Recuperação de Senha: enviar e-mail de recuperação, token de reset.
- Testes Automatizados: testes unitários e/ou de integração (Jest, Mocha, Chai).
- Deploy em um serviço gratuito (Heroku, Render, Railway etc.) e documentação no README.

## 📚 Recursos

- [Documentação do Node.js](https://nodejs.org)
- [Documentação do Express](https://expressjs.com)
- [JSON Web Tokens (JWT) em Node.js](https://jwt.io/)
- [bcrypt para hashing de senhas](https://www.freecodecamp.org/news/how-to-hash-passwords-with-bcrypt-in-nodejs/)
- [Sequelize (SQL) ou Mongoose (MongoDB)](https://sequelize.org/ | https://mongoosejs.com/)
