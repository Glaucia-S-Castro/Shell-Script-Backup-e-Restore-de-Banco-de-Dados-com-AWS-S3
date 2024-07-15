#!/bin/bash

CAMINHO_HOME=/home/galcastro
cd $CAMINHO_HOME

if [ ! -d backup_amazonS3 ];
then
    mkdir backup_amazonS3
fi

CAMINHO_BACKUP=/home/galcastro/backup_amazonS3
cd $CAMINHO_BACKUP

data=$(date +%F)
if [ ! -d $data ]
then
    mkdir $data
fi

tabelas=$(mysql -u root pdv -e "show tables;" | grep -v Tables)
for tabela in $tabelas
do
    mysqldump -u root pdv $tabela > $CAMINHO_BACKUP/$data/$tabela.sql
done

aws s3 sync $CAMINHO_BACKUP s3://glauciacastro-labs1-pdv