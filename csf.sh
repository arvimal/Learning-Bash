#!/bin/bash
# Vimal A.R

DOWNLOAD_LOCATION='/home2/vimal/Downloads/'
RESULT_FILE='/home2/vimal/Server-Test.txt'
CSF_WGET='http://www.configserver.com/free/csf.tgz'
#set -x
if [ ! -e /usr/sbin/csf ]; then
        echo -e "<<<<WARNING>>>> The CSF binary '/usr/sbin/csf' is missing..\n" | tee -a $RESULT_FILE;sleep 1s

  while true; do
		echo -e "Do you want to install CSF..[yes/no]\n" | tee -a $RESULT_FILE;
		read csfanswer;echo
		echo $csfanswer >> $RESULT_FILE
			case $csfanswer in
				yes )
                		if [ ! -e $DOWNLOAD_LOCATION ]; then
                		echo -e "$DOWNLOAD_LOCATION does not exist, creating.......\n";sleep 1s
               			mkdir -p $DOWNLOAD_LOCATION;
                		fi
				echo -e "Downloading CSF from www.configserver.com..\n";sleep 2s
                		cd $DOWNLOAD_LOCATION && wget --progress=dot $CSF_WGET;sleep 1s
				echo -e "Unpacking.........\n";sleep 2s
				cd $DOWNLOAD_LOCATION && tar -zxvf csf.*;
				mv $DOWNLOAD_LOCATION/csf*gz $DOWNLOAD_LOCATION/1-csf.tgz;
				echo -e "Installing CSF....\n" | tee -a $RESULT_FILE;sleep 1s
				cd $DOWNLOAD_LOCATION/csf/ && sh install.sh | tee -a $RESULT_FILE;echo;
				echo -e "Configure CSF as per your needs by editing the conf file manually.\n"
				exit
				;;
				no )
				echo;echo -e "Ok... Aborting..\n";
				exit;echo
				;;
				* )
				echo;echo -e "Please enter either 'yes' or 'no'.\n"
				;;
			esac

		done


else
	echo
	echo -e "CSF is installed on the server.. Found the binary /usr/sbin/csf.\n"|tee -a $RESULT_FILE;echo;sleep 1s
	echo -e "Enabling CSF, if disabled....\n"|tee -a $RESULT_FILE;sleep 2s;
	/usr/sbin/csf --enable > /dev/null;
	echo -e "Updating CSF....\n" | tee -a $RESULT_FILE;sleep 2s;
	/usr/sbin/csf --update > /dev/null;
	echo -e "Restarting CSF...\n" | tee -a $RESULT_FILE;echo;sleep 1s;
	/usr/sbin/csf --restart > /dev/null;
	echo -e "The IP addresses blocked via CSF are:-\n" | tee -a $RESULT_FILE;sleep 1s
	echo -e "---------------------------------------\n" | tee -a $RESULT_FILE;
	cat /etc/csf/csf.deny |awk '{print $1}'|grep -v '#' | tee -a $RESULT_FILE;
	echo -e "---------------------------------------\n" | tee -a $RESULT_FILE;
	echo -e "Please use 'csf --help' for more info on CSF usage.\n"
fi
#set +x

