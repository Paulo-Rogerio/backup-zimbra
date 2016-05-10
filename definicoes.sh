#!/bin/bash
#
# Definicoes para backup - Zimbra
# 2015.08.17
#
# @author              Paulo Rogerio (psilva.gomes.rogerio@gmail.com)
# @copyright           2015, PRGS
# @version             1.0.0
# @license             http://opensource.org/licenses/gpl-license.php GNU Public License
#
# Dados da conexao com Samba - Unidade Remota
USER_SMB="zimbra"
PASS_SMB="xxxxxx"
#
# Nome do Servidor ( FQDN )
SERVER_HOST="mail.empresa.com.br"
#
# Dados da conexao do Repositorios
SMB_SERVER="172.16.XX.XX"
COMPARTILHAMENTO="zimbra"
UNIDADE_LOCAL="/mnt/backup_zimbra"
#
# Binarios do Zimbra
ZMPROV="/opt/zimbra/bin/zmprov"
ZMMAILBOX="/opt/zimbra/bin/zmmailbox"
#
# Definir quantidade de dias em que o backup permanecera na maquina de backup.
DIAS="1" 
LOGFILE="/var/log/backup-zimbra.log" 
TIMESTAMP=`date +%Y-%m-%d-%H%M%S`
#
# Repositorios no servidor de arquivos
REPOSITORIO_AGENDAS="${UNIDADE_LOCAL}/agendas"
REPOSITORIO_CONTAS="${UNIDADE_LOCAL}/contas"
REPOSITORIO_CAIXAS="${UNIDADE_LOCAL}/caixas"
REPOSITORIO_ALIASES="${UNIDADE_LOCAL}/aliases"
REPOSITORIO_GG_DISTRIBUICAO="${UNIDADE_LOCAL}/gg_distribuicao"
#
# Notificacao - Email
SENDMAIL="/opt/zimbra/postfix/sbin/sendmail"
PARA="pessoa_que_recebera_notificacao_do_backup@empresa.com.br"
SUBJECT="Empresa [ Backup Servidor Zimbra - Empresa XXXX ]"
#
# Mostra a data e Hora para iniciar o Backup.
MOSTRA () {
        echo $(date +%Y-%m-%d-%H:%M:%S) - $@
}
#
# Funcao para montar unidade remota.
MONTAR() {
  mount -t cifs //${SMB_SERVER}/${COMPARTILHAMENTO} ${UNIDADE_LOCAL} -o username=${USER_SMB},password=${PASS_SMB},rw
}
#
# Funcao para desmontar unidade remota.
DESMONTAR() {
  umount ${UNIDADE_LOCAL}
}

# Checa se a unidade local existe.
if [ ! -e ${UNIDADE_LOCAL} ];
then
   mkdir -p ${UNIDADE_LOCAL}
fi

# Checa o usuario que start o Backup
if [ "`whoami`" != root ]
then
        echo Execute os comandos de backup com o usuario root 
        exit 1
fi
