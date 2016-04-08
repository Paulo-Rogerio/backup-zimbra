Configurar Script Bash para fazer Backup do Servidor Zimbra.

* Armazenamento dos Backups 

Servidor de Arquivos ( Windows ou Linux ) No servidor de arquivos deve existir um compartilhamento chamado zimbra. Um usuário zimbra no servidor de arquivos com previlégios de escrita no compartilhamento.

* Configurar o Script ( definicoes.sh )

Algumas variáveis de Ambiente que deverá ser ajustada de acordo com a sua estrutura.O scritp que deverá ser ajustado é o definicoes.sh

Usuário zimbra que autentica no compartilhamento de arquivos, para montar a unidade remota.

USER_SMB="zimbra"

Senha do usuário zimbra no compartilhamento de arquivos.

PASS_SMB="xxxxxx"

Nome completo FQDN do seu servidor Zimbra.

SERVER_HOST="mail.empresa.com.br"

Ip do servidor de arquivos.

SMB_SERVER="172.16.XX.XX"

Nome do compartilhamento que as máquinas enchergam.

COMPARTILHAMENTO="zimbra"

Nome do usuario ou Grupo de Distribuição que recebem os E-mail
 
PARA="pessoa_que_recebera_notificacao_do_backup@empresa.com.br"

Defini o subject para o E-mail enviado pelo backup.

SUBJECT="Empresa [ Backup Servidor Zimbra - Empresa XXXX ]"

* Modo de Usar

Você com certeza irá agendar os seus backups no crontab. Mas qual script será agendado? Sera agenda o ( backup.sh ). Para fins de testes, caso queira roda-lo manualmente basta executar. O script deve ser executado e agendado com usuário ( root )
#./backup.sh

Ex: Crontab

30 00 *	* * /opt/scripts/backup.sh

Neste script backup.sh , você tem a mobilidade de escolher o que pegar do backup. Caso queira apenas fazer backup das caixas e contas de E-mail, comente as outras entradas e deixe apenas as que são referencia ao seu backup alvo.

Ex:

. ./contas_email.sh

. ./caixas.sh

* Modo de Restauração

Para restaurar um Backup ( Uma caixa ), será necessário realizar os seguintes passos.

1-) Criar uma nova conta no zimbra que receberá o backup.

Ex: 
Suponha que temos uma conta chamado ( paulo@empresa.com.br ) e quero voltar o backup desta conta. Crie uma conta chamado ( paulo.recovery@empresa.com.br )

Obs.: Nada impede de voltar um backup em cima de uma conta já existente. Mas fique ciente que esse processo irá sobrepor os E-mail já existente. Faça-o por sua conta e risco. Depois de criado o seu novo E-Mail que receberá o seu backup. Proceda com as instruções:

2-) Editar o arquivo ( recovery.sh )

Três variáveis serão necessárias serem alteradas.

Esta é o nome da pasta que contém o backup que deseja restaurar. Ela é criada no momento do Backup e fica armazenda no servidor de arquivos.

DATA_RESTORE="2015-08-21-163342"

Conta que foi realizado o backup. Observer a estensão ".tgz" . Esse é o backup propriamente dito.

CONTA_ORIGEM="paulo@empresa.com.br.tgz"

Conta à qual será realizado o processo de restauração do backup. O Backup será importado para esta conta.

CONTA_RECOVERY="paulo.recovery@empresa.com.br"


