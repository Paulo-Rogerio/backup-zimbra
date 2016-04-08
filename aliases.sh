#!/bin/bash
#
# Script de Backup para os Aliases - Zimbra
# 2015.08.20
#
# - Efetua copia do arquivos de configuracao do servidor
# - Compactacao:  .tar .zip
# - Salva Backup em um diretorios de backup com data e hora no filename.
#
# @author              Paulo Rogerio (psilva.gomes.rogerio@gmail.com)
# @copyright           2015, PRGS
# @version             1.0.0
# @license             http://opensource.org/licenses/gpl-license.php GNU Public License
#
# Carrega as definicoes

cd `dirname $0`
. ./definicoes.sh

# Cria o diretorio onde o backup sera processado 
if [ ! -e ${REPOSITORIO_ALIASES}/${TIMESTAMP} ];
then
    mkdir -p ${REPOSITORIO_ALIASES}/${TIMESTAMP}
    sleep 2
fi

# 
echo ----------------------------------------------------------------------------------------- 

# Armazena em um array todas as contas de email
# Extraindo delas os dados da conta.

for MAIL in $(${ZMPROV} -l gaa | sort); do

		ALIASES=$($ZMPROV -l ga $MAIL zimbraMailAlias | grep zimbraMailAlias | awk -F " " '{print $2}')
 
   		echo "Aliases apontados para: ${MAIL}" > ${REPOSITORIO_ALIASES}/${TIMESTAMP}/Aliases-${MAIL}
		echo "zmprov aaa ${MAIL} ${ALIASES}" >> ${REPOSITORIO_ALIASES}/${TIMESTAMP}/Todos-Aliases.txt
        	MOSTRA "Extraindo os aliases apontados para o email : ${MAIL}"  
        	MOSTRA "Extraindo os aliases apontados para o email : ${MAIL}" >> ${LOGFILE} 
done

# Checa se o dump foi realizado com sucesso.
# Escrevendo no arquivo de LOGs
if [ $? -eq 0 ] ; then
    MOSTRA Status Sucesso >> ${LOGFILE}
    MOSTRA Server: `hostname` >> ${LOGFILE}
    MOSTRA Arquivo: ${REPOSITORIO_ALIASES}/${TIMESTAMP} >> ${LOGFILE}
else
    MOSTRA Nao pode extrair dados da conta dos usuarios. >> ${LOGFILE}
    MOSTRA Terminado com Erros.
    exit 0;
fi

# Remove arquivos antigos.
MOSTRA Removendo backups com mais de $DIAS dias. >> ${LOGFILE}
MOSTRA Removendo backups com mais de $DIAS dias.
find ${REPOSITORIO_ALIASES} -follow -type f -ctime +${DIAS} -exec rm {} \;
find ${REPOSITORIO_ALIASES} -follow -type d -ctime +${DIAS} -exec rmdir {} \; > /dev/null
MOSTRA Log gerado em: ${LOGFILE}  
MOSTRA Terminado com Sucesso.  >> ${LOGFILE}
echo ----------------------------------------------------------------------------------------- >> ${LOGFILE}        

# Envio de email para notificacao
(echo "Subject: ${SUBJECT}";cat "${LOGFILE}") | ${SENDMAIL} ${PARA}
