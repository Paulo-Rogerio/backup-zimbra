#!/bin/bash
#
# Script de Backup para Contas Usuarios - Zimbra
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
if [ ! -e ${REPOSITORIO_CONTAS}/${TIMESTAMP} ];
then
    mkdir -p ${REPOSITORIO_CONTAS}/${TIMESTAMP}
    sleep 2
fi

# 
echo ----------------------------------------------------------------------------------------- 

# Armazena em um array todas as contas de email
# Extraindo delas os dados da conta.

for CONTA in $(${ZMPROV} -l gaa | grep -v admin | grep -v galsync | grep -v ham | grep -v spam | grep -v virus-quarantine | sort);       do
               DNOME=$(${ZMPROV} -l ga ${CONTA} displayName | grep displayName | awk -F " " '{print $2" "$3" "$4" "$5}')
               PNOME=$(${ZMPROV} -l ga ${CONTA} givenName | grep givenName | awk -F " " '{print $2}')
               SNOME=$(${ZMPROV} -l ga ${CONTA} sn | grep sn | awk -F " " '{print $2}')
               SENHA=$(${ZMPROV} -l ga ${CONTA} userPassword | grep userPassword | awk -F " " '{print $2}')
 
               echo "Conta: ${CONTA}" > ${REPOSITORIO_CONTAS}/${TIMESTAMP}/Dados-da-Conta-${CONTA}
               echo "Display: ${DNOME}" >> ${REPOSITORIO_CONTAS}/${TIMESTAMP}/Dados-da-Conta-${CONTA}
               echo "Nome: ${PNOME}" >> ${REPOSITORIO_CONTAS}/${TIMESTAMP}/Dados-da-Conta-${CONTA}
               echo "Sobrenome: ${SNOME}" >> ${REPOSITORIO_CONTAS}/${TIMESTAMP}/Dados-da-Conta-${CONTA}
               echo "Senha: ${SENHA}" >> ${REPOSITORIO_CONTAS}/${TIMESTAMP}/Dados-da-Conta-${CONTA}
        
        echo "zmprov ca ${CONTA} 123456 cn \"${PNOME} ${SNOME}\" displayName \"${DNOME}\" givenName \"${PNOME}\" zimbraPrefFromDisplay \"${PNOME} ${SNOME}\"" >> ${REPOSITORIO_CONTAS}/${TIMESTAMP}/Dados-Todas-Contas.txt
        echo "zmprov ma ${CONTA} userPassword '${SENHA}'" >> ${REPOSITORIO_CONTAS}/${TIMESTAMP}/Dados-Todas-Contas.txt
        MOSTRA "Extraindo dados da contas dos usuarios: ${CONTA}"  
        MOSTRA "Extraindo dados da contas dos usuarios: ${CONTA}" > ${LOGFILE} 
done

# Checa se o dump foi realizado com sucesso.
# Escrevendo no arquivo de LOGs
if [ $? -eq 0 ] ; then
    MOSTRA Status Sucesso >> ${LOGFILE}
    MOSTRA Server: `hostname` >> ${LOGFILE}
    MOSTRA Arquivo: ${REPOSITORIO_CONTAS}/${TIMESTAMP} >> ${LOGFILE}
else
    MOSTRA Nao pode extrair dados da conta dos usuarios. >> ${LOGFILE}
    MOSTRA Terminado com Erros.
    exit 0;
fi

# Remove arquivos antigos.
MOSTRA Removendo backups com mais de ${DIAS} dias. >> ${LOGFILE}
MOSTRA Removendo backups com mais de ${DIAS} dias.
find ${REPOSITORIO_CONTAS} -follow -type f -ctime +${DIAS} -exec rm {} \;
find ${REPOSITORIO_CONTAS} -follow -type d -ctime +${DIAS} -exec rmdir {} \; > /dev/null
MOSTRA Log gerado em: ${LOGFILE}  
MOSTRA Terminado com Sucesso.  >> ${LOGFILE}
echo ----------------------------------------------------------------------------------------- >> ${LOGFILE}        
