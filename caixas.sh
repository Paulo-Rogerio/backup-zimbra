#!/bin/bash
#
# Script de Backup para Caixas dos Usuarios - Zimbra
# 2015.08.17
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
if [ ! -e ${REPOSITORIO_CAIXAS}/${TIMESTAMP} ];
then
    mkdir -p ${REPOSITORIO_CAIXAS}/${TIMESTAMP}
    sleep 2
fi

# 
echo ----------------------------------------------------------------------------------------- 

# Armazena em um array todas as contas de email
# Extraindo delas os dados da conta.

for CAIXAS in $(${ZMPROV} -l gaa | grep -v admin | grep -v galsync | grep -v ham | grep -v spam | grep -v virus-quarantine | sort); do
	let contador=0
	${ZMMAILBOX} -z -m ${CAIXAS} getRestURL  -u https://${SERVER_HOST} "//?fmt=tgz" > ${REPOSITORIO_CAIXAS}/${TIMESTAMP}/${CAIXAS}.tgz
        MOSTRA "Extraindo mensagens da caixa : ${CAIXAS}"  
        MOSTRA "Extraindo mensagens da caixa : ${CAIXAS}" >> ${LOGFILE} 
	let contador=${contador}+1
done

# Checa se o dump foi realizado com sucesso.
# Escrevendo no arquivo de LOGs
if [ $? -eq 0 ] ; then
    MOSTRA Status Sucesso >> ${LOGFILE}
    MOSTRA Server: `hostname` >> ${LOGFILE}
    MOSTRA Arquivo: ${REPOSITORIO_CAIXAS}/${TIMESTAMP} >> ${LOGFILE}
else
    MOSTRA Nao pode extrair dados da conta dos usuarios. >> ${LOGFILE}
    MOSTRA Terminado com Erros.
    exit 0;
fi

# Remove arquivos antigos.
MOSTRA Removendo backups com mais de ${DIAS} dias. >> ${LOGFILE}
MOSTRA Removendo backups com mais de ${DIAS} dias.
find ${REPOSITORIO_CAIXAS} -follow -type f -ctime +${DIAS} -exec rm {} \;
find ${REPOSITORIO_CAIXAS} -follow -type d -ctime +${DIAS} -exec rmdir {} \; > /dev/null
MOSTRA Log gerado em: ${LOGFILE}  
MOSTRA Terminado com Sucesso.  >> ${LOGFILE}
echo ----------------------------------------------------------------------------------------- >> ${LOGFILE}        

