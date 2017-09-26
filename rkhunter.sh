#####################################
#   RK-HUNTER INSTALL/SCAN SCRIPT   #
# 			                        #
#    Written By Vimal Kumar A.R     #
#			                        #
#####################################
#set -x

DOWNLOAD_LOCATION='/home2/vimal/Downloads'
RKHUNTER_WGET='http://downloads.rootkit.nl/rkhunter-1.2.8.tar.gz'
RESULT_FILE='/home2/vimal/Server-Test.txt'

echo
echo -e "The default location for downloads is $DOWNLOAD_LOCATION/\n"
if [ ! -e $DOWNLOAD_LOCATION/rkhunter*.gz ]; then
        echo -e "RKHUNTER not found in $DOWNLOAD_LOCATION/\n" | tee -a $RESULT_FILE;
fi

while true; do
echo -e "Do you want to download and compile RKHUNTER [yes/no] ? : \c" | tee -a $RESULT_FILE;
        read answer;
        echo $answer >> $RESULT_FILE;

	case $answer in
                yes|YES)
                echo
                if [ ! -e $DOWNLOAD_LOCATION ]; then
		echo -e "$DOWNLOAD_LOCATION does not exist, creating........\n";
                mkdir -p $DOWNLOAD_LOCATION;
                fi
	        rm -rf $DOWNLOAD_LOCATION/rkhunter* > /dev/null;
                echo -e "Downloading RKHUNTER....\n" | tee -a $RESULT_FILE;sleep 1s
                cd $DOWNLOAD_LOCATION && wget --progress=dot $RKHUNTER_WGET;sleep 2s
		if [ $? -eq 0 ] ; then echo -e "Download finished...\n";fi;echo
                echo -e "Unpacking and compiling RKHUNTER..........\n";sleep 2s
                cd $DOWNLOAD_LOCATION && tar -xvf rkhunter*;
                mv $DOWNLOAD_LOCATION/rkhunter*gz $DOWNLOAD_LOCATION/1-rkhunter.tar.gz;
		echo -e "Removing previous installations, if any...\n";sleep 2s|tee -a $RESULT_FILE;
		rm -rf /usr/local/rkhunter;
		echo -e "Installing RKHUNTER...\n";sleep 2s
                cd $DOWNLOAD_LOCATION/rkhunter* && ./installer.sh > /dev/null;
                if [ $? -eq 0 ] ; then echo -e "RKHUNTER compilation finished...\n"| tee -a $RESULT_FILE;
                else echo -e "RKHUNTER COMPILATION FAILED..PLEASE CHECK MANUALLY..\n" | tee -a $RESULT_FILE;
                exit
                fi

while true; do
          echo -e "Do you want to run RKHUNTER now [yes/no] ? : \c" | tee -a $RESULT_FILE;
                        read reply
                        echo $reply >> $RESULT_FILE;
				case $reply in
                                yes|YES)
                                echo
                                echo -e "Updating the signature files..\n"
                                /usr/local/bin/rkhunter --update | tee -a $RESULT_FILE;
				echo -e "Starting RKHUNTER....\n";sleep 2s|tee -a $RESULT_FILE;echo
				/usr/local/bin/rkhunter -c --nocolors --skip-keypress | tee -a $RESULT_FILE;
                                exit
                                ;;
                                no|NO)
                                echo
                                echo -e "DON'T FORGET TO RUN RK-HUNTER PERIODICALLY.\n" | tee -a $RESULT_FILE;
                                exit
                                ;;
                                *)
                                echo
                                echo -e "Please enter either 'yes' OR 'no'..: \c"
                                ;;
                                esac
                    done
		;;
                no|NO)
                echo
                echo -e "Ok..Aborting...\n" | tee -a $RESULT_FILE;
                break
                ;;
                *)
                echo
                echo -e "Please enter either 'yes' OR 'no'..: \c"
                ;;
        esac
        done
#set +x
