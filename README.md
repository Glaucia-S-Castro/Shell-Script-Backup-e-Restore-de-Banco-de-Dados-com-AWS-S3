# Shell Script - Backup e Restore de Banco de Dados com AWS S3

Este repositório contém dois scripts shell para realizar backup agendado de um banco de dados em ambiente Linux e enviá-lo para um bucket S3 da AWS, e outro para restaurar esse backup em caso de problemas.

## Pré-Requisitos

   - AWS CLI instalada e configurada com suas credenciais
   - MySQL instalado e configurado
   - Permissões adequadas para acesso ao banco de dados MySQL
   - Acesso ao bucket S3 especificado.
   - Permissões de gravação/leitura no bucket S3 configuradas no usuario IAM a ser utilizado.

 ----  
## Scripts

1. **backup_amazonS3.sh**
2. **restore_amazon.sh**

-----
## Backup_amazonS3.sh

Este script realiza o backup das tabelas de um banco de dados MySQL e envia o backup para um bucket S3.

**Uso :**

1- Configure as Credenciais AWS: Certifique-se de que suas credenciais AWS estão configuradas corretamente em ~/.aws/credentials ou utilizando o comando:

    aws configure

2- Usando um editor de texto (nano ou vim) edite o arquivo do sccript realizando os ajustes abaixo.

Ajuste o path:


    # na linha 3 altere o path inserindo o caminho onde seu script esta salvo

    CAMINHO_BACKUP=/home/seu-usuario/seu-caminho/backup_amazonS3


Ajuste o nome do db:

    # nas linhas 12 e 15 substitua o nome *pdv* pelo nome do database que você vai fazer o backup


    tabelas=$(mysql -u root nome_do_db -e "show tables;" | grep -v Tables)

    mysqldump -u root nome_do_db $tabela > $CAMINHO_BACKUP/$data/$tabela.sql

Ajuste o nome do bucket no S3

    # na linha 18, ultima linha, ajuste altere o caminho com o nome do bucket, substituindo pelo caminho do bucket que você fará o uso

    aws s3 sync $CAMINHO_BACKUP s3://seu-bucket-S3-na-aws

3- Agendamento pra execução automática: Utilize o cron para agendar a execução deste script diariamente.

    sudo crontab -e

Adicione a linha abaixo para executar o script todos os dias às 2 da manhã:

    0 2 * * * /caminho/para/backup_amazonS3.sh

Caso prefira rodar manualmente sem aguardar o agendamento, basta roda-lo com o comando abaixo. Lembre-se de estar no diretório onde o script esta salvo para rodar.

    bash backup_amazonS3.sh

-----
## Restore_amazon.sh

Este script restaura um backup do banco de dados a partir de um bucket S3 da AWS.

**Uso :**

Ajuste o path:

    ## na linha 3 altere o path inserindo o caminho onde seu script esta salvo

    CAMINHO_RESTORE=/home/seu-usuario/seu-caminho/restore_amazon

Ajuste o nome do bucket no S3

    ## na linha 4 altere o caminho com o nome do bucket, substituindo pelo caminho do seu bucket de onde vão vir os dados do restore

    aws s3 sync s3://seu-bucket-S3-na-aws/$(date +%F) $CAMINHO_RESTORE

Ajuste o nome do db:

    ## na linha 9 ubstitua o nome *pdv* pelo nome do database onde que você vai fazer o restore

     mysql -u root nome_do_db < $1.sql

-----

## Considerações

Certifique-se de que o usuário MySQL root tem permissão para realizar backup e restore das tabelas.

Verifique se o bucket S3 especificado existe e se você tem as permissões necessárias para acessar e enviar arquivos para ele.

-----
## Licença

Este projeto é um projeto pessoal e não possui uma licença específica.

----
## Contribuições

- Faça um fork do repositório
- Crie uma branch para sua modificação (git checkout -b feature/nova-feature)
- Faça commit das suas alterações (git commit -m 'Adiciona nova feature')
- Faça push para a branch (git push origin feature/nova-feature)
- Abra um Pull Request

-----
## Autor
Glaucia Castro - glauciacastro.dev@gmail.com