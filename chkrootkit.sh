####################################
# Chk-RootKit Install/Check Script #
#                                  #
# Written By Vimal Kumar A.R       #
####################################

#!/bin/bash
#set -x

DOWNLOAD_LOCATION='/home2/vimal/Downloads'
CHKROOTKIT_WGET='ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit.tar.gz'
RESULT_FILE='/home2/vimal/Server-Test.txt'

echo
echo -e "The default location for downloads is $DOWNLOAD_LOCATION/\n"
if [ ! -e $DOWNLOAD_LOCATION/chkrootkit.tar.gz ]; then
        echo -e "CHK-ROOTKIT not found in $DOWNLOAD_LOCATION/\n" | tee -a $RESULT_FILE;
fi

while true; do
echo -e "Do you want me to download and compile CHK-ROOTKIT [yes/no] ? : \c" | tee -a $RESULT_FILE;
       	read answer;
	echo $answer >> $RESULT_FILE;

        case $answer in
		yes )
		echo
		if [ ! -e $DOWNLOAD_LOCATION ]; then
		echo -e "$DOWNLOAD_LOCATION does not exist, creating.......\n";sleep 1s
		mkdir -p $DOWNLOAD_LOCATION;
		fi
	  	rm -rf $DOWNLOAD_LOCATION/chkrootkit* > /dev/null;
	  	echo -e "Downloading CHK-ROOTKIT....\n" | tee -a $RESULT_FILE;sleep 1s
          	cd $DOWNLOAD_LOCATION && wget --progress=dot $CHKROOTKIT_WGET;sleep 2s
                if [ $? -eq 0 ] ; then echo -e "Download finished..\n";fi;echo
                echo -e "Unpacking and compiling CHK-ROOTKIT..........\n";sleep 2s
	  	cd $DOWNLOAD_LOCATION && tar -xvf chkrootkit*;
          	mv $DOWNLOAD_LOCATION/chkrootkit*gz $DOWNLOAD_LOCATION/1-chkrootkit.tar.gz;sleep 2s
          	cd $DOWNLOAD_LOCATION/chkrootki* && make sense > /dev/null;
	        if [ $? -eq 0 ] ; then echo -e "CHK-ROOTKIT compiled successfully..\n"| tee -a $RESULT_FILE;
	 	else echo -e "CHK-ROOTKIT compilation failed, Quiting....\n" | tee -a $RESULT_FILE;
		exit
	  	fi
	  while true; do
	  echo -e "Do you want to run CHK-ROOTKIT now [yes/no] ? : \c" | tee -a $RESULT_FILE;
			read reply
			echo $reply >> $RESULT_FILE;

				case $reply in
				yes )
				echo
				echo -e "Starting CHK-ROOTKIT....\n" | tee -a $RESULT_FILE;sleep 2s;echo
				echo -e "----------------CHK-ROOTKIT SCAN RESULT-----------------\n"
				$DOWNLOAD_LOCATION/chkrootk*/chkrootkit | tee -a $RESULT_FILE;sleep 1s
				echo;echo -e "CHK-ROOTKIT check finished......\n";echo
				exit
				;;
				no )
				echo
				echo -e "DON'T FORGET TO RUN CHK-ROOTKIT PERIODICALLY.\n"
				exit
	   			;;
				*)
				echo
				echo -e "Please enter either 'yes' OR 'no'..: \c"
				;;
				esac
                    done
		;;
		no )
		echo
		echo -e "Ok..As you wish....Aborting.\n"
		break
		;;
		*)
		echo
		echo -e "Please enter either 'yes' OR 'no'..: \c"
		;;
          esac
	  done

#set +x

