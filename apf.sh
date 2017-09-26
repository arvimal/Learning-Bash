#!/bin/bash
# Vimal A.R

DOWNLOAD_LOCATION='/root/Downloads/'
RESULT_FILE='/root/Server-Test.txt'
APF_WGET='http://www.r-fx.ca/downloads/apf-current.tar.gz'
DATE=`date +%d-%m-%y`


apf-install () {
	echo
while true; do
	echo -e "DO YOU WANT TO DOWNLOAD AND INSTALL APF..? [yes/no] : \c"|tee -a $RESULT_FILE;
	read apfanswer;echo
	echo $apfanswer >> $RESULT_FILE
		case $apfanswer in
				yes)
				echo -e "The default download location is $DOWNLOAD_LOCATION.\n";
				if [ ! -e $DOWNLOAD_LOCATION ]; then
                                echo -e "$DOWNLOAD_LOCATION does not exist, creating.......\n"|tee -a $RESULT_FILE;
				fi;sleep 1s
                                mkdir -p $DOWNLOAD_LOCATION;echo
				if [ -d /etc/apf ];then
				echo -e "Moving the previous config: directory to /root \n"|tee -a $RESULT_FILE;
				cd /etc && tar -cf /root/apf_$DATE.tar apf/
				echo -e "The previous apf directory is in /root/ as apf_$DATE.tar\n"|tee -a \
				$RESULT_FILE
				echo -e "Removing previous installations...\n"|tee -a $RESULT_FILE;
				rm -rf /etc/apf/ /usr/local/sbin/apf /var/log/apf_log > /dev/null;
				fi
				echo -e "Getting the APF TARBALL.\n"|tee -a $RESULT_FILE;
				cd $DOWNLOAD_LOCATION && wget  --progress=dot $APF_WGET;
				echo -e "Extracting...........\n" | tee -a $RESULT_FILE;
				cd $DOWNLOAD_LOCATION && tar -zxvf apf*gz && mv apf*gz 1-apf.tar.gz;echo
				echo -e "Loading the needed modules.....\n"|tee -a $RESULT_FILE
				for i in ip_conntrack ip_conntrack_ftp ip_conntrack_irc iptable_filter \
				iptable_mangle ip_tables ipt_limit ipt_LOG ipt_multiport ipt_REJECT ipt_state \
				ipt_TOS;
				do modprobe -v $i;done
				cd $DOWNLOAD_LOCATION/apf* && /bin/bash install.sh
				# Add the Ingress ports and remind to change the development mode
				exit
				;;
				no)
				echo -e "Ok..Aborting.\n"|tee -a $RESULT_FILE
				exit
				;;
				*)
				echo -e "Please enter either 'yes' or 'no'.\n"
				;;
		esac
	done
}

if [ ! -f /etc/apf/apf ];then
	apf-install;
	else echo;
	echo -e "@@@@@@@@@@@@@@@@@ << APF IS INSTALLED >> @@@@@@@@@@@@@@@@\n"|tee -a $RESULT_FILE;sleep 2s
	echo "APF STATUS:-" | tee -a $RESULT_FILE
	echo "------------" | tee -a $RESULT_FILE
	tail -n1 /var/log/apf_log;echo | tee -a $RESULT_FILE
	tail -n1 /var/log/apf_log|grep -q offline;
		if [ $? -eq 0 ];then
			echo -e "APF IS OFFLINE..... STARTING...\n"
			/usr/local/sbin/apf --restart;
		fi
#	echo "APF Usage :-";
#	echo "------------";
#	/usr/local/sbin/apf --help;echo
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";
	apf-install;
fi
