# Shell Script - Backup e Restore de Banco de Dados com AWS S3

Este repositório contém dois scripts shell para realizar backup agendado de um banco de dados em ambiente Linux e enviá-lo para um bucket S3 da AWS, e outro para restaurar esse backup em caso de problemas.

# Pré-Requisitos

   - AWS CLI instalada e configurada com suas credenciais
   - MySQL instalado e configurado
   - Permissões adequadas para acesso ao banco de dados MySQL
   - Acesso ao bucket S3 especificado.
   - Permissões de gravação/leitura no bucket S3 configuradas no usuario IAM a ser utilizado.

# Versão do bash

Versão do bash em que eu fiz os meus testes, em versões antigas alguns comandos e recursos podem não funcionar.

```bash
# $ bash --version
GNU bash, version 5.1.16(1)-release (x86_64-pc-linux-gnu)
Versão SO Linux Ubuntu 20.04.06 LTS
```

# Instalação

```bash
# Clone o repositorio 
git clone https://github.com/Glaucia-S-Castro/Shell-Script-Backup-e-Restore-de-Banco-de-Dados-com-AWS-S3.git

# Entre no diretório
cd Shell-Script-Backup-e-Restore-de-Banco-de-Dados-com-AWS-S3

# Conceda permissão de execução aos scripts
chmod +x backup_amazonS3.sh
chmod +x restore_amazon.sh

# Rode os scripts
bash backup_amazonS3.sh
bash restore_amazon.sh

```
 ----  
## Scripts

1. **backup_amazonS3.sh**
2. **restore_amazon.sh**

-----
## 1. Backup_amazonS3.sh

Este script realiza o backup das tabelas de um banco de dados MySQL e envia o backup para um bucket S3.

**Uso :**

1- Configure as Credenciais AWS: Certifique-se de que suas credenciais AWS estão configuradas corretamente em ~/.aws/credentials ou utilizando o comando:

    aws configure

2- Usando um editor de texto (nano ou vim) edite o arquivo do script realizando os ajustes abaixo.
```bash

# Ajuste o path:
    # nas linhas 3 e 11 altere os valores das variáveis indicando o path, coloque nelas o caminho conforme seu script estará salvo

    CAMINHO_HOME=/home/seu-usuario

    CAMINHO_BACKUP=/home/seu-usuario/seu-caminho/backup_amazonS3

# Ajuste o nome do db:
    # nas linhas 12 e 15 substitua o nome *pdv* pelo nome do database que você vai fazer o backup

    tabelas=$(mysql -u root nome_do_db -e "show tables;" | grep -v Tables)

    mysqldump -u root nome_do_db $tabela > $CAMINHO_BACKUP/$data/$tabela.sql

# Ajuste o nome do bucket no S3
    # na linha 18, ultima linha, ajuste altere o caminho com o nome do bucket, substituindo pelo caminho do bucket que você fará o uso

    aws s3 sync $CAMINHO_BACKUP s3://seu-bucket-S3-na-aws
```

3- Agendamento pra execução automática: Utilize o cron para agendar a execução deste script diariamente.

    sudo crontab -e

Adicione a linha abaixo para executar o script todos os dias às 2 da manhã:

    0 2 * * * /caminho/para/backup_amazonS3.sh


A depender de como foi feita a instalação do MySQL pode ser necessário a realização de ajustes na configuração para que a execução automática do script ocorra sem solicitar a senha do MySQL. 

Como meu projeto é acadêmico encontrei duas saídas válidas pro meu cenário, porém para um cenário real antes de usa-las devem ser feitas considerações em relação a segurança.

As opções seriam ou declarar uma variável a mais no script passando nela a senha do root do MySQL, ou configurar as permissões do MySQL para o usuário root concedendo previlégio total com o comando:

    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'my_password' WITH GRANT OPTION;
    FLUSH PRIVILEGES;

Substituindo my_password pela senha do seu usuário root do MySQL.

-----
## 2. Restore_amazon.sh

Este script restaura um backup do banco de dados a partir de um bucket S3 da AWS.

**Uso :**

1- Configure as Credenciais AWS: Certifique-se de que suas credenciais AWS estão configuradas corretamente em ~/.aws/credentials ou utilizando o comando:

    aws configure

2- Usando um editor de texto (nano ou vim) edite o arquivo do script realizando os ajustes abaixo.

```bash
# Ajuste o path:
    ## na linha 3 altere o path inserindo o caminho onde seu script esta salvo

    CAMINHO_RESTORE=/home/seu-usuario/seu-caminho/restore_amazon

# Ajuste o nome do bucket no S3
    ## na linha 4 altere o caminho com o nome do bucket, substituindo pelo caminho do seu bucket de onde vão vir os dados do restore

    aws s3 sync s3://seu-bucket-S3-na-aws/$(date +%F) $CAMINHO_RESTORE

# Ajuste o nome do db:
    ## na linha 9 ubstitua o nome *pdv* pelo nome do database onde que você vai fazer o restore

     mysql -u root nome_do_db < $1.sql
```

3- Execução do Script: Execute o script passando o nome da tabela a ser restaurada como parâmetro.

    bash restore_amazon.sh nome_da_tabela

-----
## Considerações

Certifique-se de que o usuário MySQL root tem permissão para realizar backup e restore das tabelas.

Verifique se o bucket S3 especificado existe e se você tem as permissões necessárias para acessar e enviar arquivos para ele.

-----
## Licença

Este projeto é um projeto pessoal e não possui uma licença específica.

----
## Contribuições

Sinta-se à vontade para contribuir

- Faça um fork do repositório
- Crie uma branch para sua modificação (git checkout -b feature/nova-feature)
- Faça commit das suas alterações (git commit -m 'Adiciona nova feature')
- Faça push para a branch (git push origin feature/nova-feature)
- Abra um Pull Request

-----
## Autor
Glaucia Castro - glauciacastro.dev@gmail.com