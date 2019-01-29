#!/bin/bash
# Autor: Rodrigo Costabrava
# Site: https://optimizedata.info
# Facebook: facebook.com/OptimizeData
# Facebook: facebook.com/OptimizeData
# YouTube: youtube.com/OptimizeData
# Data de criação: 29/01/2019
# Data de atualização: 20/01/2019
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# # APACHE-2.4 (Apache HTTP Server) -Servidor de Hospedagem de Páginas web
# MYSQL-5.7 (SGBD) - Sistemas de Gerenciamento de Banco de Dados
# PHP-7.2 (Personal Home Page - PHP: Hypertext Preprocessor) - Linguagem de Programação Dinâmica para Web
# PERL-5.26 - Linguagem de programação multiplataforma
# PYTHON-2.7 - Linguagem de programação de alto nível
# PHPMYADMIN-4.6 - Aplicativo desenvolvido em PHP para administração do MySQL pela Internet
#
# Debconf - Sistema de configuração de pacotes Debian
# Site: http://manpages.ubuntu.com/manpages/bionic/man7/debconf.7.html
# Debconf-Set-Selections - insere novos valores no banco de dados debconf
# Site: http://manpages.ubuntu.com/manpages/bionic/man1/debconf-set-selections.1.html
#
# Opção: lamp-server^ Recurso existente no GNU/Ubuntu Server para facilitar a instalação do Servidor LAMP
# A opção de circunflexo no final do comando e obrigatório, considerado um meta-caracter de filtragem para
# a instalação correta de todos os serviços do LAMP.
# Recurso faz parte do software Tasksel: https://help.ubuntu.com/community/Tasksel
#
# O módulo do PHP Mcrypt na versão 7.2 está descontinuado, para fazer sua instalação e recomendado utilizar
# o comando o Pecl e adicionar o repositório pecl.php.net, a instalação e baseada em compilação do módulo.
#
# Observação: Nesse script está sendo feito a instalação do Oracle MySQL, hoje os desenvolvedores estão migrando
# para o MariaDB, nesse script o mesmo deve ser reconfigurado para instalar e configurar o MariaDB no Ubuntu.
#
# Variável da Data Inicial para calcular o tempo de execução do script
# opção do comando date: +%s (seconds since)
DATAINICIAL=`date +%s`
#
# Variáveis para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel
# opções do comando id: -u (user), opções do comando: lsb_release: -r (release), -s (short), 
# opções do comando uname: -r (kernel release), opções do comando cut: -d (delimiter), -f (fields)
# opção do caracter: | (piper) Conecta a saída padrão com a entrada padrão de outro comando
# opção do shell script: acento crase ` ` = Executa comandos numa subshell, retornando o resultado
# opção do shell script: aspas simples ' ' = Protege uma string completamente (nenhum caractere é especial)
# opção do shell script: aspas duplas " " = Protege uma string, mas reconhece $, \ e ` como especiais
USUARIO=`id -u`
UBUNTU=`lsb_release -rs`
KERNEL=`uname -r | cut -d'.' -f1,2`
#
# Variável do caminho do Log dos Script utilizado nesse curso
VARLOGPATH="/var/log/"
#
# Variável para criação do arquivo de Log dos Script
# $0 (variável de ambiente do nome do comando)
# opção do caracter: | (piper) Conecta a saída padrão com a entrada padrão de outro comando
# opção do shell script: acento crase ` ` = Executa comandos numa subshell, retornando o resultado
# opção do shell script: aspas simples ' ' = Protege uma string completamente (nenhum caractere é especial)
# opções do comando cut: -d (delimiter), -f (fields)
LOGSCRIPT=`echo $0 | cut -d'/' -f2`
#
# Variável do caminho para armazenar os Log's de instalação
LOG=$VARLOGPATH/$LOGSCRIPT
#
# Variáveis de configuração do MySQL e liberação de conexão remota para o usuário Root
USER="root"
PASSWORD="Zohar34@blue*2019"
AGAIN=$PASSWORD
# opões do comando GRANT: grant (permissão), all (todos privilegios), on (em ou na | banco ou tabela), *.* (todos os bancos/tabelas)
# to (para), user@'%' (usuário @ localhost), identified by (indentificado por - senha do usuário)
GRANTALL="GRANT ALL ON *.* TO $USER@'%' IDENTIFIED BY '$PASSWORD';"
# opção do comando FLUSH: privileges (recarregar as permissões)
FLUSH="FLUSH PRIVILEGES;"
#
# Variáveis de configuração do PhpMyAdmin
ADMINUSER=$USER
ADMIN_PASS=$PASSWORD
APP_PASSWORD=$PASSWORD
APP_PASS=$PASSWORD
WEBSERVER="apache2"
#
# Exportando o recurso de Noninteractive do Debconf para não solicitar telas de configuração
export DEBIAN_FRONTEND="noninteractive"
#
# Verificando se o usuário e Root
# == comparação de string, exit 1 = A maioria dos erros comuns na execução
if [ "$USUARIO" == "0" ]
	then
		echo -e "O usuário e Root, continuando com o script..."
	else
		echo -e "Usuário não e Root, execute o comando: sudo -i, execute novamente o script."
		exit 1
fi
#
# Verificando se a distribuição e 18.04.x
# == comparação de string, exit 1 = A maioria dos erros comuns na execução
if [ "$UBUNTU" == "18.04" ]
	then
		echo -e "Distribuição e 18.04.x, continuando com o script..."
	else
		echo -e "Distribuição não homologada, instale a versão 18.04.x e execute novamente o script."
		exit 1
fi
#		
# Verificando se o Kernel e 4.15
# == comparação de string, exit 1 = A maioria dos erros comuns na execução
# opção do comando sleep: 5 (seconds)
# opção do comando exit: 1 (A maioria dos erros comuns na execução)
if [ "$KERNEL" == "4.15" ]
	then
		echo -e "Kernel e >= 4.15, continuando com o script..."
		sleep 5
	else
		echo -e "Kernel não homologado, instale a versão do Ubuntu 18.04.x e atualize o sistema."
		exit 1
fi
#
# Script de instalação do LAMP-Server no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable) habilita interpretador, \n = (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando sleep: 5 (seconds)
clear
echo -e "Instalação do LAMP-SERVER no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "APACHE (Apache HTTP Server) - Servidor de Hospedagem de Páginas Web - Porta 80/443"
echo -e "Após a instalação do Apache2 acessar a URL: http://`hostname -I`/\n"
echo -e "MYSQL (SGBD) - Sistemas de Gerenciamento de Banco de Dados - Porta 3306\n"
echo -e "PHP (Personal Home Page - PHP: Hypertext Preprocessor) - Linguagem de Programação Dinâmica para Web\n"
echo -e "PERL - Linguagem de programação multi-plataforma\n"
echo -e "PYTHON - Linguagem de programação de alto nível\n"
echo -e "PhpMyAdmin - Aplicativo desenvolvido em PHP para administração do MySQL pela Internet"
echo -e "Após a instalação do PhpMyAdmin acessar a URL: http://`hostname -I`/phpmyadmin\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet..."
sleep 5
echo
#
echo -e "Adicionando o Repositório Universal do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	add-apt-repository universe &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando as listas do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando o sistema, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes)
	apt -y upgrade &>> $LOG
echo -e "Sistema atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Removendo software desnecessários, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes)
	apt -y autoremove &>> $LOG
echo -e "Software removidos com Sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o LAMP-SERVER, aguarde..."
echo
#
echo -e "Configurando as variáveis do Debconf do MySQL para o Apt, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando | (piper): (Conecta a saída padrão com a entrada padrão de outro comando)
	echo "mysql-server-5.7 mysql-server/root_password password $PASSWORD" |  debconf-set-selections
	echo "mysql-server-5.7 mysql-server/root_password_again password $AGAIN" |  debconf-set-selections
	debconf-show mysql-server-5.7 &>> $LOG
echo -e "Variáveis configuradas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o LAMP-SERVER, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes)
	# opção do comando ^ (circunflexo): (expressão regular - Casa o começo da linha)
	apt -y install lamp-server^ perl python &>> $LOG
echo -e "Instalação do LAMP-SERVER feito com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o PhpMyAdmin, aguarde..."
echo
#
echo -e "Configurando as variáveis do Debconf do PhpMyAdmin para o Apt, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando | (piper): (Conecta a saída padrão com a entrada padrão de outro comando)
	echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASSWORD" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect $WEBSERVER" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-user string $ADMINUSER" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ADMIN_PASS" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_PASS" |  debconf-set-selections
	debconf-show phpmyadmin &>> $LOG
echo -e "Variáveis configuradas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o PhpMyAdmin, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes)
	apt -y install phpmyadmin php-mbstring php-gettext php-dev libmcrypt-dev php-pear &>> $LOG
echo -e "Instalação do PhpMyAdmin feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#				 
echo -e "Atualizando as dependências do PHP para o PhpMyAdmin, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando echo: | = (faz a função de Enter)
	# opção do comando cp: -v (verbose)
	pecl channel-update pecl.php.net &>> $LOG
	echo | pecl install mcrypt-1.0.1 &>> $LOG
	cp -v conf/mcrypt.ini /etc/php/7.2/mods-available/ &>> $LOG
	phpenmod mcrypt &>> $LOG
	phpenmod mbstring &>> $LOG
echo -e "Atualização das dependêncais feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Criando o arquivo de teste do PHP phpinfo.php, aguarde..."
	# opção do comando: > (redirecionar a entrada padrão)
	# opção do comando chown: -v (verbose)
	touch /var/www/html/phpinfo.php
	echo -e "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
	chown -v www-data.www-data /var/www/html/phpinfo.php
echo -e "Arquivo criado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do LAMP-Server e PhpMyAdmin feito com sucesso!!! Pressione <Enter> para continuar."
read
sleep 3
clear
#
echo -e "Atualizando e editando o arquivo de configuração do Apache2, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando cp: -v (verbose)
	# opção do comando sleep: 3 (seconds)
	cp -v /etc/apache2/apache2.conf /etc/apache2/apache2.conf.old &>> $LOG
	cp -v conf/apache2.conf /etc/apache2/apache2.conf &>> $LOG
	echo -e "Pressione <Enter> para editar o arquivo: apache2.conf"
		read
		sleep 3
	vim /etc/apache2/apache2.conf
echo -e "Arquivo atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando e editando o arquivo de configuração do PHP, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando cp: -v (verbose)
	# opção do comando sleep: 3 (seconds)
	cp -v /etc/php/7.2/apache2/php.ini /etc/php/7.2/apache2/php.ini.old &>> $LOG
	cp -v conf/php.ini /etc/php/7.2/apache2/php.ini &>> $LOG
	echo -e "Pressione <Enter> para editar o arquivo: php.ini"
		read
		sleep 3
	vim /etc/php/7.2/apache2/php.ini
echo -e "Arquivo atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Reinicializando o serviço do Apache2, aguarde..."
	sudo service apache2 restart
echo -e "Serviço reinicializado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Permitindo o Root do MySQL se autenticar remotamente, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando mysql: -u (user), -p (password) -e (execute)
	mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$FLUSH" mysql &>> $LOG
echo -e "Permissão alterada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando e editando o arquivo de configuração do MySQL, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando cp: -v (verbose)
	# opção do comando sleep: 3 (seconds)
	cp -v /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.old &>> $LOG
	cp -v conf/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf &>> $LOG
	echo -e "Pressione <Enter> para editar o arquivo: mysqld.cnf"
		read
		sleep 3
	vim /etc/mysql/mysql.conf.d/mysqld.cnf
echo -e "Arquivo atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Reinicializando os serviços do MySQL, aguarde..."
	sudo service mysql restart
echo -e "Serviço reinicializado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Verificando as portas de Conexão do Apache2 e do MySQL, aguarde..."
	# opção do comando netstat: a (all), n (numeric)
	# opção do comando grep: ' ' (aspas simples) protege uma string, \| (Escape e opção Ou)
	netstat -an | grep '80\|3306'
echo -e "Portas verificadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do LAMP-SERVER feito com Sucesso!!!"
	#opção do comando date: +%s (seconds since)
	#opção do caracter ` ` (crase): executa o comando em um subshell 
	DATAFINAL=`date +%s`
	SOMA=`expr $DATAFINAL - $DATAINICIAL`
	#opção do comando expr: 10800 segundos, usada para arredondamento de cálculo
	RESULTADO=`expr 10800 + $SOMA`
	#opção do comando date: -d (date), +%H (hour), %M (minute), %S (second)
	TEMPO=`date -d @$RESULTADO +%H:%M:%S`
echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
read
exit 1
