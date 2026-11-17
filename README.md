# Tokio Marine

Desafio técnico: um painel de seguros inspirado na Tokio Marine, com login, home, menu lateral e um fluxo de Automóvel abrindo WebView. O mesmo código roda em **Android**, **iOS** e **web**.

## Escopo

### Login
- Campos de CPF e senha
- Abas/ações de Entrar e Cadastrar
- Checkbox "Lembrar sempre" (persistido com `shared_preferences`)
- Link "Esqueceu a senha?"  UI, sem integração
- Cadastro  UI, sem integração
- Ícones de redes sociais ilustrativos
- Login funcional com **Firebase Authentication**

### Home (após o login)
- Nome do usuário logado
- Área **Cotar e Contratar** com:
  - Automóvel
  - Residência
  - Vida
  - Acidentes Pessoais
- **Minha Família**: ação para adicionar membros
- **Contratados**: estado vazio com mensagem de que não há seguros contratados

### Menu lateral (Drawer)
- Nome e avatar do usuário
- Home / Seguros
- Minhas Contratações
- Meus Sinistros
- Minha Família
- Meus Bens
- Pagamentos
- Coberturas
- Validar Boleto
- Telefones Importantes
- Configurações
- Sair

### Extra do enunciado
- Toque em **Automóvel**:
  - **Android / iOS** → WebView in-app (`webview_flutter`)
  - **Web** → abre a URL no navegador (`url_launcher`)
  - URL de exemplo: `https://jsonplaceholder.typicode.com/`

### Responsividade
- Layout pensado para mobile e web no mesmo codebase
- Em telas maiores, drawer/home adaptam espaçamento e cards, sem forks de projeto

## Stack

| Peça | Escolha |
|------|---------|
| Flutter | 3.47.2 (stable) |
| Dart | 3.13.2 |
| Plataformas | Android, iOS, Web |
| State management | Bloc |
| Auth | Firebase Authentication |
| Lembrar sempre | shared_preferences |
| WebView | webview_flutter no mobile; na web abre a URL no navegador (`url_launcher`) |
| Testes | unitários + widget nos fluxos principais |
| Deploy web | Firebase Hosting |
| Arquitetura | Clean Architecture |
| Injeção de dependências | get_it |

## Organização do código

Clean Architecture por feature, com dependências apontando sempre para dentro (UI → domain ← data). O `get_it` registra repositórios, use cases e Blocs.

```
lib/
  app/                 # MaterialApp, tema, rotas
  core/                # erros, utils, widgets e DI (get_it)
  features/
    auth/
      domain/          # entidades, repositórios (contratos), use cases
      data/            # impls Firebase, datasources, models
      presentation/    # pages, widgets, blocs
    home/
      domain/
      data/
      presentation/
    drawer/
      presentation/   
    auto/
      domain/
      data/
      presentation/   
```


## Como rodar

1. Configurar o Firebase do projeto (Android / iOS / Web) e colocar os arquivos de config no lugar.
2. Instalar deps e subir:

```bash
flutter pub get
flutter run
```

Web:

```bash
flutter run -d chrome
```

Testes:

```bash
flutter test
```