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

# Chama a funcao para backup das contas de usuario.
. ./contas_email.sh
. ./gg_distribuicao.sh
. ./caixas.sh
. ./aliases.sh
. ./agendas.sh

# Desmontar unidade remota apos conclusao dos backups
DESMONTAR

# Checa se desmontou com suceso
 if [ $? -eq 0 ];
then
   echo "Unidade Desmontada com sucesso!!!"
else
   echo "Erro ao desmontar a unidade remota!!!"
   exit 0
fi
