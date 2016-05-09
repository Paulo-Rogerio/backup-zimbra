H1
# Objetivo - Backup do Servidor Zimbra.

<h1>Armazenamento dos Backups</h1> 

Você necessitará de Servidor de Arquivos ( Windows ou Linux ), nesse servidor de arquivos deve existir um compartilhamento chamado zimbra e um usuário zimbra com previlégios de escrita no compartilhamento.

<h1>Configurar o Script</h1> 

<h3> Ajustar o Arquivo de Definições</h3>

Algumas variáveis de Ambiente desse script deverá ser ajustada de acordo com a sua estrutura.

<code>
USER_SMB="zimbra"</code>
PASS_SMB="xxxxxx"
SERVER_HOST="mail.empresa.com.br"
SMB_SERVER="172.16.XX.XX"
COMPARTILHAMENTO="zimbra"
PARA="pessoa_que_recebera_notificacao_do_backup@empresa.com.br"
SUBJECT="Empresa [ Backup Servidor Zimbra - Empresa XXXX ]"
</code>

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


