#!/bin/bash
#
# Script de Backup das Agendas dos Usuarios - Zimbra
# 2015.08.26
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
if [ ! -e ${REPOSITORIO_AGENDAS}/${TIMESTAMP} ];
then
    mkdir -p ${REPOSITORIO_AGENDAS}/${TIMESTAMP}
    sleep 2
fi

# 
echo ----------------------------------------------------------------------------------------- 

# Armazena em um array todas as contas de email
# Extraindo delas os dados da conta.

for CONTA in $(${ZMPROV} -l gaa | grep -v admin | grep -v galsync | grep -v ham | grep -v spam | grep -v virus-quarantine | sort);       do
      ${ZMMAILBOX} -z -m ${CONTA} getRestURL -u https://${SERVER_HOST} "//calendar?fmt=ics" >> ${REPOSITORIO_AGENDAS}/${TIMESTAMP}/${CONTA}.ics
      MOSTRA "Extraindo agenda da conta do usuario: ${CONTA}"  
      MOSTRA "Extraindo agenda da conta dos usuario: ${CONTA}" >> ${LOGFILE} 
done

# Checa se o dump foi realizado com sucesso.
# Escrevendo no arquivo de LOGs
if [ $? -eq 0 ] ; then
    MOSTRA Status Sucesso >> ${LOGFILE}
    MOSTRA Server: `hostname` >> ${LOGFILE}
    MOSTRA Arquivo: ${REPOSITORIO_AGENDAS}/${TIMESTAMP} >> ${LOGFILE}
else
    MOSTRA Nao pode extrair dados da conta dos usuarios. >> ${LOGFILE}
    MOSTRA Terminado com Erros.
    exit 0;
fi

# Remove arquivos antigos.
MOSTRA Removendo backups com mais de ${DIAS} dias. >> ${LOGFILE}
MOSTRA Removendo backups com mais de ${DIAS} dias.
find ${REPOSITORIO_AGENDAS} -follow -type f -ctime +${DIAS} -exec rm {} \;
find ${REPOSITORIO_AGENDAS} -follow -type d -ctime +${DIAS} -exec rmdir {} \; > /dev/null
MOSTRA Log gerado em: ${LOGFILE}  
MOSTRA Terminado com Sucesso.  >> ${LOGFILE}
echo ----------------------------------------------------------------------------------------- >> ${LOGFILE}        
