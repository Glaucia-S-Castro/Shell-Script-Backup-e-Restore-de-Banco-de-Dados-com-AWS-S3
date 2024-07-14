#!/bin/bash

CAMINHO_RESTORE=/home/galcastro/restore_amazon
aws s3 sync s3://glauciacastro-labs1-pdv/$(date +%F) $CAMINHO_RESTORE

cd $CAMINHO_RESTORE
if [ -f $1.sql ]
then
    mysql -u root pdv < $1.sql
    if [ $? -eq 0 ]
    then
        echo "O restore foi realizado com sucesso"
    fi
else
    echo "O arquivo procurado não existe no diretorio"
fi