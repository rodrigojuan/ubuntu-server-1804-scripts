#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 09/11/2018
# Data de atualização: 29/01/2019
# Versão: 0.04
# Testado e homologado para a versão do Ubuntu Server 18.04.x LTS x64
# Kernel >= 4.15.x
#
# Vídeo de instalação do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
#
# Vídeo de instalação do LAMP Server no Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=6EFUu-I3u4s
#
# Wordpress: é um sistema livre e aberto de gestão de conteúdo para internet (do inglês: Content Management System - CMS),
# baseado em PHP com banco de dados MySQL, executado em um servidor interpretador, voltado principalmente para a criação de
# páginas eletrônicas (sites) e blogs online. Criado a partir do extinto b2/cafelog, por Ryan Boren e Matthew Mullenweg, e
# distribuído gratuitamente sob a GNU General Public License.
#
# Site oficial: https://wordpress.org/
#
# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=`date +%T`
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
# Declarando as variaveis para o download do Wordpress
WORDPRESS="https://wordpress.org/latest.zip"
#
# Declarando as variaveis para criação da Base de Dados do Wordpress
USER="root"
PASSWORD="Zohar34@blue*2019"
# opção do comando create: create (criação), database (base de dados), base (banco de dados)
DATABASE="CREATE DATABASE wordpress;"
# opção do comando create: create (criação), user (usuário), identified by (indentificado por - senha do usuário), password (senha)
USERDATABASE="CREATE USER 'costabrava' IDENTIFIED BY 'Zohar34@blue*2019';"
# opção do comando grant: grant (permissão), usage (uso em | uso na), *.* (todos os bancos/tabelas), to (para), user (usário)
# identified by (indentificado por - senha do usuário), password (senha)
GRANTDATABASE="GRANT USAGE ON *.* TO 'costabrava' IDENTIFIED BY 'Zohar34@blue*2019';"
# opões do comando GRANT: grant (permissão), all (todos privilegios), on (em ou na | banco ou tabela), *.* (todos os bancos/tabelas)
# to (para), user@'%' (usuário @ localhost), identified by (indentificado por - senha do usuário), password (senha)
GRANTALL="GRANT ALL PRIVILEGES ON wordpress.* TO 'costabrava';"
# opção do comando FLUSH: flush (atualizar), privileges (recarregar as permissões)
FLUSH="FLUSH PRIVILEGES;"
#
# Verificando se o usuário e Root, Distribuição e >=18.04 e o Kernel >=4.15 <IF MELHORADO)
# [ ] = teste de expressão, && = operador lógico AND, == comparação de string, exit 1 = A maioria dos erros comuns na execução
clear
if [ "$USUARIO" == "0" ] && [ "$UBUNTU" == "18.04" ] && [ "$KERNEL" == "4.15" ]
	then
		echo -e "O usuário e Root, continuando com o script..."
		echo -e "Distribuição e >=18.04.x, continuando com o script..."
		echo -e "Kernel e >= 4.15, continuando com o script..."
		sleep 5
	else
		echo -e "Usuário não e Root ($USUARIO) ou Distribuição não e >=18.04.x ($UBUNTU) ou Kernel não e >=4.15 ($KERNEL)"
		echo -e "Caso você não tenha executado o script com o comando: sudo -i"
		echo -e "Execute novamente o script para verificar o ambiente."
		exit 1
fi
#
# Script de instalação do Wordpress no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (enable) habilita interpretador, \n = (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando sleep: 5 (seconds
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
clear
#
echo -e "Instalação do Wordpress no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "Após a instalação do Wordpress acessar a URL: http://`hostname -I`/wp/\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet..."
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
echo -e "Instalando as dependências do Wordpress, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes)
	apt -y install unzip &>> $LOG
echo -e "Dependências instaladas com sucesso!!!, continuando com o script"
sleep 5
echo
#
echo -e "Removendo os software desnecessários, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando apt: -y (yes)
	apt -y autoremove &>> $LOG
echo -e "Software removidos com Sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o Wordpress, aguarde..."
echo
#
echo -e "Baixando o Wordpress do site oficial, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	wget $WORDPRESS &>> $LOG
echo -e "Wordpress baixado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Descompactando o Wordpress, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	unzip latest.zip &>> $LOG
echo -e "Descompactação feita com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Copiando os arquivos de configuração do Wordpress, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando mv: -v (verbose)
	# opção do comando cp: -v (verbose)
	mv -v wordpress/ /var/www/html/wordpress &>> $LOG
	cp -v conf/htaccess /var/www/html/wordpress/.htaccess &>> $LOG
	cp -v conf/wp-config.php /var/www/html/wordpress/ &>> $LOG
echo -e "Arquivos copiados com sucesso!!!, continuando com o script..."
sleep 5
echo
#				 
echo -e "Alterando as permissões dos arquivos e diretórios do Wordpress, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando chmod: -R (recursive), -f (silent), -v (verbose), 755 (Dono=RWX,Grupo=R-X,Outros=R-X)
	# opção do comando chown: -R (recursive), -f (silent), -v (verbose), dono.grupo (alteraçaõ do dono e grupo)
	chmod -Rfv 755 /var/www/html/wordpress/ &>> $LOG
	chown -Rfv www-data.www-data /var/www/html/wordpress/ &>> $LOG
echo -e "Permissões alteradas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Criando a Base de Dados do Wordpress, aguarde..."
	# opção do comando: &>> (redirecionar a entrada padrão)
	# opção do comando mysql: -u (user), -p (password) -e (execute)
	mysql -u $USER -p$PASSWORD -e "$DATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$USERDATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$GRANTDATABASE" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$FLUSH" mysql &>> $LOG
echo -e "Base de Dados criada com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Wordpress feita com sucesso!!! Pressione <Enter> para continuar."
read
sleep 3
clear
#
echo -e "Editando o arquivo de configuração da Base de Dados do Wordpress, aguarde..."
	echo -e "Pressione <Enter> para editar o arquivo: wp-config.php"
		# opção do comando sleep: 3 (seconds)
		read
		sleep 3
	vim /var/www/html/wordpress/wp-config.php
echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Editando o arquivo de configuração do htaccess do Wordpress, aguarde..."
	echo -e "Pressione <Enter> para editar o arquivo: .htaccess"
		# opção do comando sleep: 3 (seconds)
		read
		sleep 3
	vim /var/www/html/wordpress/.htaccess
echo -e "Arquivo editado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalação do Wordpress feito com Sucesso!!!"
	# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
	# opção do comando date: +%T (Time)
	HORAFINAL=`date +%T`
	# opção do comando date: -u (utc), -d (date), +%s (second since 1970)
	HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
	HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
	# opção do comando date: -u (utc), -d (date), 0 (string command), sec (force second), +%H (hour), %M (minute), %S (second), 
	TEMPO=`date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S"`
	# $0 (variável de ambiente do nome do comando)
	echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Fim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
read
exit 1