# FUNCIONALIDADES BÁSICAS

O aplicativo de controle de peso, IMC e medidas corporais oferece as seguintes funcionalidades principais:

<!-- Codigo para por imagens dentro da documentação -->
![Diagrama de Caso de Uso](docs/casodeuso.png)

1. **Registro de Usuário**
Os usuários podem se cadastrar no aplicativo fornecendo informações como nome, CPF, data de nascimento, sexo, e-mail e senha. Além disso, podem adicionar uma foto de perfil que pode ser tirada diretamente com a câmera ou selecionada da galeria.

2. **Login e Autenticação**
Os usuários podem se autenticar no sistema utilizando seu e-mail e senha. O sistema possui tratamento de erros para senhas incorretas ou e-mails não cadastrados, garantindo uma experiência de usuário segura e eficiente.

3. **Controle de Peso e IMC**
Os usuários podem registrar seu peso periodicamente. A partir dos dados inseridos, o aplicativo calcula automaticamente o Índice de Massa Corporal (IMC). Os dados são exibidos em um gráfico de evolução de peso e IMC ao longo do tempo, permitindo o acompanhamento fácil do progresso.


4. **Controle de Medidas Corporais**
O usuário pode registrar as medidas da cintura e quadril, associando cada registro a uma data específica e, opcionalmente, a uma foto. As medidas são armazenadas e exibidas em forma de cards na interface, e ao clicar em um card, a foto associada é exibida de forma ampliada para revisão.

5.  **Gráficos de Evolução**
O aplicativo exibe gráficos que mostram a evolução do peso e do IMC ao longo do tempo, utilizando as informações registradas pelo usuário. Esses gráficos são gerados dinamicamente e atualizados a cada novo registro, proporcionando uma visão clara da progressão da saúde física.

6. **Armazenamento de Dados Local**
Todos os dados do aplicativo são armazenados localmente em um banco de dados SQLite, incluindo informações de usuário, registros de peso, medidas corporais, e consumo de água. Isso permite que o aplicativo funcione offline, garantindo que os usuários possam utilizar suas funcionalidades mesmo sem conexão à internet.

7. **Gerenciamento de Imagens**
O aplicativo permite que o usuário associe imagens a registros de medidas corporais, e essas imagens são armazenadas diretamente no banco de dados em formato Uint8List. Na tela inicial, a foto de perfil do usuário também é exibida centralizada, reforçando a personalização da experiência.

8. **Notificações e Lembretes (Funcionalidade futura)**
O aplicativo planeja incluir lembretes para que o usuário registre o peso semanalmente e consuma água em intervalos regulares, enviando notificações push diretamente para o dispositivo.