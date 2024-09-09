# Arquitetura do Projeto (MVC)

Para a criação do Saude++ foi utilizado a arquitetura MVC:

- **Model** : Pasta na qual fica os arquivos de armazenamento de dados do (Usuário, IMC e Medidas Corporais).
- **View** : Pasta na qual fica a interface da aplicação. Telas de Cadastro de usuário, Tela de Login, Tela de Regitro de IMC, Tela de Registro de Medidas Corporais, Tela Home.
- **Control**: Pasta que realiza o processo de intermediação entre **Model** e **View**, sendo responsável pelo gerenciamento dos dados entre telas e banco de dados.

# Fluxo dos Dados

- O usuário interage com as telas **(View)** , como por exemplo 'clicar em um botão de salvar cadastro'.
- Durante a interação a classe Usercontroller **(Control)** é acionada, e inicia o processo de armazenamento de todos os dados do usuário dentro das variaveis do user **(Model)** .
- O user **(Model)** ela envia e/ou recebe os dados do banco de dados SqLite.
- O UserController **(Controller)** retorna os dados para a tela **(View)**.

![Diagrama de Caso de Uso](docs/casodeuso.png)


