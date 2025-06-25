# 💸 MobiCash

> Aplicativo Flutter para controle de gastos pessoais, com persistência local e interface simples e eficiente.

---

## 📱 Funcionalidades

- Cadastrar despesas com descrição, valor, categoria, forma de pagamento e data
- Visualizar lista de gastos
- Excluir gastos individuais
- Gerar relatório visual por categoria (gráfico de pizza)
- Resetar dados salvos (configurações)
- Persistência de dados local com Hive
- Navegação estruturada por rotas nomeadas
- Interface responsiva e fácil de usar

---

## 🧠 Arquitetura

lib/
├── core/ → Tema, estilos e utilitários
├── database/ → Configuração do Hive
├── model/ → Modelos de dados (Hive)
├── service/ → Serviços de acesso ao banco local
├── viewmodel/ → ViewModels com ChangeNotifier
├── view/ → Telas da aplicação
├── widget/ → Componentes reutilizáveis
├── routes/ → Gerenciador de rotas
└── main.dart → Inicialização e configuração global

Este projeto segue o padrão **MVVM com Provider**, promovendo separação de responsabilidades e escalabilidade.



---

## 🚀 Funcionalidades

- ✅ Cadastro de despesas com categoria, cartão, data, valor e descrição
- ✅ Lista de gastos atualizada em tempo real
- ✅ Exclusão individual de gastos
- ✅ Relatórios em gráfico de pizza por categoria
- ✅ Tela de configurações com opção para apagar todos os dados
- ✅ Armazenamento local com Hive (offline)
- ✅ Navegação por rotas nomeadas

---

## 📦 Tecnologias

- [Flutter](https://flutter.dev/)
- [Provider](https://pub.dev/packages/provider)
- [Hive](https://pub.dev/packages/hive)
- [Hive Flutter](https://pub.dev/packages/hive_flutter)
- [fl_chart](https://pub.dev/packages/fl_chart)
- [intl](https://pub.dev/packages/intl)

---

## ⚙️ Como rodar o projeto

```bash
# Clone o repositório
git clone https://github.com/lpcamphora/mobicash.git
cd mobicash

# Instale as dependências
flutter pub get

# Gere os arquivos do Hive
dart run build_runner build

# Execute o app
flutter run

