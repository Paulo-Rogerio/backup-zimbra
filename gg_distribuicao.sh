#!/bin/bash
#
# Script de Backup para os Grupos de Distribuicao - Zimbra
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
if [ ! -e ${REPOSITORIO_GG_DISTRIBUICAO}/${TIMESTAMP} ];
then
    mkdir -p ${REPOSITORIO_GG_DISTRIBUICAO}/${TIMESTAMP}
    sleep 2
fi

# 
echo ----------------------------------------------------------------------------------------- 

# Armazena em um array todas as contas de email
# Extraindo delas os dados da conta.

for GG_MAIL in $(${ZMPROV} gadl | sort); do

		MEMBER_GG_DISTRIBUICAO=$(${ZMPROV} gdl ${GG_MAIL} | grep zimbraMailForwardingAddress | awk -F " " '{print $2}')
 
   		echo "Grupo Distribuicao: ${GG_MAIL}" > ${REPOSITORIO_GG_DISTRIBUICAO}/${TIMESTAMP}/Membros-Grupo-${GG_MAIL}
		echo "Membros: ${MEMBER_GG_DISTRIBUICAO}" >> ${REPOSITORIO_GG_DISTRIBUICAO}/${TIMESTAMP}/Membros-Grupo-${GG_MAIL}
		echo "zmprov cdl ${GG_MAIL}" >> ${REPOSITORIO_GG_DISTRIBUICAO}/${TIMESTAMP}/Todos-Grupos.txt
		echo "zmprov adlm ${GG_MAIL} ${MEMBER_GG_DISTRIBUICAO}" >> ${REPOSITORIO_GG_DISTRIBUICAO}/${TIMESTAMP}/Todos-Grupos.txt	  
        	MOSTRA "Extraindo os membros do grupo de distribuicao : ${GG_MAIL}"  
        	MOSTRA "Extraindo dados da contas dos usuarios: ${GG_MAIL}" >> ${LOGFILE} 
done

# Checa se o dump foi realizado com sucesso.
# Escrevendo no arquivo de LOGs
if [ $? -eq 0 ] ; then
    MOSTRA Status Sucesso >> ${LOGFILE}
    MOSTRA Server: `hostname` >> ${LOGFILE}
    MOSTRA Arquivo: ${REPOSITORIO_GG_DISTRIBUICAO}/${TIMESTAMP} >> ${LOGFILE}
else
    MOSTRA Nao pode extrair dados da conta dos usuarios. >> ${LOGFILE}
    MOSTRA Terminado com Erros.
    exit 0;
fi

# Remove arquivos antigos.
MOSTRA Removendo backups com mais de $DIAS dias. >> ${LOGFILE}
MOSTRA Removendo backups com mais de $DIAS dias.
find ${REPOSITORIO_GG_DISTRIBUICAO} -follow -type f -ctime +${DIAS} -exec rm {} \;
find ${REPOSITORIO_GG_DISTRIBUICAO} -follow -type d -ctime +${DIAS} -exec rmdir {} \; > /dev/null
MOSTRA Log gerado em: ${LOGFILE}  
MOSTRA Terminado com Sucesso.  >> ${LOGFILE}
echo ----------------------------------------------------------------------------------------- >> ${LOGFILE}       

