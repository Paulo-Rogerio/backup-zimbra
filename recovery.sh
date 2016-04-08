#!/bin/bash
#
# Script de Backup - Zimbra
# 2015.08.17
#
# - Faz a chamada para todos os outros scripts
#
# @author              Paulo Rogerio (psilva.gomes.rogerio@gmail.com)
# @copyright           2015, PRGS
# @version             1.0.0
# @license             http://opensource.org/licenses/gpl-license.php GNU Public License
#
# Dados da conta a ser restaurada. 
#
# TimeStamp 
# Esse valor deve ser alterado de acordo com a data do backup a ser restaurado 
# acesse o caminho: \\172.16.0.50\zimbra\caixa

DATA_RESTORE="2015-08-21-163342"
CONTA_ORIGEM="paulo@empresa.com.br.tgz"
CONTA_RECOVERY="paulo.recovery@empresa.com.br"

# Carrega as definicoes
cd `dirname $0`
. ./definicoes.sh

# Monta a unidade remota
MONTAR

# Checa se montou com sucesso.
if [ $? -eq 0 ];
then
   echo "Unidade Montada com sucesso!!!"
else
   echo "Erro ao montar a unidade remota, backup nao realizado!!!"
   exit 0
fi

# 
echo ----------------------------------------------------------------------------------------- 

MOSTRA "Restaurando os email da conta ${CONTA_ORIGEM} para a conta ${CONTA_RECOVERY}" >> ${LOGFILE}
MOSTRA "Restaurando os email da conta ${CONTA_ORIGEM} para a conta ${CONTA_RECOVERY}"

${ZMMAILBOX} -z -m ${CONTA_RECOVERY} postRestURL  -u https://${SERVER_HOST} "//?fmt=tgz&resolve=reset" ${REPOSITORIO_CAIXAS}/${DATA_RESTORE}/${CONTA_ORIGEM} 

MOSTRA "Restauracao realizada com sucesso !!!!" 

DESMONTAR

# Checa se desmontou com suceso
 if [ $? -eq 0 ];
then
   echo "Unidade Desmontada com sucesso!!!"
else
   echo "Erro ao desmontar a unidade remota!!!"
   exit 0
fi
