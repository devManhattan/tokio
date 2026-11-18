# Tokio Marine

Desafio técnico: um painel de seguros inspirado na Tokio Marine, com login, home, menu lateral e um fluxo de Automóvel abrindo WebView. O mesmo código roda em **Android** e **web**.

Versão web: https://tokio-df656.web.app

Para acessar, crie uma conta pela aba **Cadastrar**.


## Como rodar

Pré-requisitos: Flutter 3.47.2 e, para usar outro projeto Firebase, o Firebase CLI e o FlutterFire CLI.

```bash
flutter pub get
flutter run
```

Web:

```bash
flutter run -d chrome
```

Para apontar para outro projeto Firebase:

1. `flutterfire configure`
2. No console, ativar o login por **e-mail/senha** e criar o banco do **Cloud Firestore**
3. Publicar as regras: `firebase deploy --only firestore:rules`

## Funcionalidades

### Login

- Campos de CPF e senha
- Abas de Entrar e Cadastrar
- Checkbox "Lembrar sempre" (CPF e senha persistidos com `flutter_secure_storage`)
- Link "Esqueceu a senha?" envia o e-mail de recuperação pelo Firebase Authentication
- Cadastro com Firebase Authentication e dados do usuário no Cloud Firestore
- Ícones de redes sociais ilustrativos

### Home

- Nome do usuário logado
- Área **Cotar e Contratar** com Automóvel, Residência, Vida e Acidentes Pessoais
- **Minha Família**: ação para adicionar membros
- **Contratados**: estado vazio com mensagem de que não há seguros contratados

### Menu lateral

- Nome e avatar do usuário
- Home / Seguros, Minhas Contratações, Meus Sinistros, Minha Família, Meus Bens, Pagamentos, Coberturas, Validar Boleto, Telefones Importantes e Configurações
- Sair

### Automóvel (WebView)

- **Android** → WebView in-app (`webview_flutter`)
- **Web** → abre a URL em uma nova aba (`url_launcher`)
- URL de exemplo: `https://jsonplaceholder.typicode.com/`

### Responsividade

- Um único codebase para mobile e web
- Login e cadastro se ajustam à altura disponível, inclusive em telas pequenas (a partir de 360x640)
- Na web, o card de login tem largura fixa e o cabeçalho muda de alinhamento

## Stack

| Peça                    | Escolha                                                                    |
| ----------------------- | -------------------------------------------------------------------------- |
| Flutter                 | 3.47.2 (stable)                                                            |
| Dart                    | 3.13.2                                                                     |
| Plataformas             | Android e Web (iOS configurado, não testado)                               |
| State management        | Bloc/Cubit                                                                 |
| Auth                    | Firebase Authentication                                                    |
| Banco de dados          | Cloud Firestore                                                            |
| Rotas                   | go_router                                                                  |
| Lembrar sempre          | flutter_secure_storage                                                     |
| WebView                 | webview_flutter no mobile; na web abre a URL no navegador (`url_launcher`) |
| Testes                  | unitários + widget (bloc_test, mocktail)                                   |
| Deploy web              | Firebase Hosting                                                           |
| Arquitetura             | Clean Architecture                                                         |
| Injeção de dependências | get_it                                                                     |

## Organização do código

Clean Architecture por feature, com dependências apontando sempre para dentro (UI → domain ← data). O `get_it` registra repositórios, use cases e cubits.

```
lib/
  app/                 # MaterialApp
  core/                # constantes, DI (get_it), rotas, tema, utils e widgets
  features/
    auth/
      domain/          # entidades, falhas, repositórios (contratos), use cases
      data/            # datasources e repositórios com Firebase
      presentation/    # pages, widgets, cubits
    home/
      domain/
      presentation/
    drawer/
      presentation/
    auto/
      presentation/
    placeholder/
      presentation/
```

## Decisões técnicas

### Login por CPF

O Firebase Authentication autentica por e-mail e senha. No cadastro, além do usuário no Auth, são gravados:

- `cpfs/{cpf}` → `{ email, uid }`, usado para encontrar o e-mail a partir do CPF no login e na recuperação de senha
- `users/{uid}` → `{ name, cpf, email }`

Se a gravação no Firestore falhar, o usuário recém-criado no Auth é removido, evitando contas sem CPF associado.

### Lembrar sempre

Com a opção marcada, CPF e senha ficam no `flutter_secure_storage` e preenchem o formulário na próxima abertura. Sem a opção, nada é salvo e a sessão anterior é encerrada ao abrir o app.

### Sessão e rotas

O `SessionCubit` acompanha o usuário do Firebase. O `go_router` redireciona com base nesse estado: sem sessão, apenas login, cadastro e recuperação de senha ficam acessíveis. Com sessão, essas rotas levam para a home.

## Segurança

As regras ficam em `firestore.rules`:

- `cpfs/{cpf}`: leitura por documento liberada (necessária antes do login), listagem bloqueada. A criação exige usuário autenticado, CPF com 11 dígitos e `uid`/`email` iguais aos do usuário logado.
- `users/{uid}`: leitura e escrita apenas pelo próprio usuário.

Como a leitura de `cpfs/{cpf}` é pública, quem souber um CPF cadastrado consegue descobrir o e-mail associado. Em produção, essa consulta iria para uma Cloud Function que retornasse apenas o necessário para o login.

## Testes

```bash
flutter test
```

Cobrem:

- validadores de formulário
- repositório de autenticação (mapeamento de erros e índice de CPF)
- use cases de login, cadastro e restauração de sessão
- cubits de sessão e login
- redirecionamentos do router
- telas de login, cadastro, recuperação de senha, home e menu lateral, incluindo layout em telas pequenas
