#!/bin/bash
# Vimal A.R

RESULT_FILE='/home2/vimal/Server-Test.txt'
echo
echo -e "ENTER SCAN TYPE: (Monthly, Weekly, Daily etc...): \c"
read SCAN_TYPE;echo

echo -e "SCAN TYPE        : ${SCAN_TYPE}\n" | tee -a $RESULT_FILE;

######
#  Host Information :

echo -e ">--------------------------HOST INFORMATION---------------------------<\n" | tee -a $RESULT_FILE;

echo -e "SERVER HOSTNAME  : `hostname`\n" | tee -a $RESULT_FILE;
echo -e "SERVER IP        : `hostname -i`\n" | tee -a $RESULT_FILE;
echo -e "SERVER OS        : `uname -o`\n" | tee -a $RESULT_FILE;
echo -e "SERVER PLATFORM  : `uname -i`\n" | tee -a $RESULT_FILE;
echo -e "KERNEL VERSION   : `uname -r`\n" | tee -a $RESULT_FILE;
echo -e "SERVER DATE      : `date +%d-%b-%Y---%r`\n"|tee -a $RESULT_FILE;
echo -e "SERVER UPTIME    : `uptime |awk '{print $3, $4}'|cut -f1 -d ","`\n "|tee -a $RESULT_FILE;
echo -e "SERVER LOAD      : `uptime |awk '{print $10}'|cut -f1 -d ","`\n"|tee -a $RESULT_FILE;

######
#  Boot Loader

dd if=$A bs=512 count=1 2>&1|grep GRUB > /dev/null;
if [ $? = 0 ];then
echo -e "SERVER BOOTLOADER: GRUB.\n"|tee -a $RESULT_FILE;fi
dd if=$A bs=512 count=1 2>&1|grep LILO > /dev/null;
if [ $? = 0 ];then
echo -e "SERVER BOOTLOADER: LILO.\n"|tee -a $RESULT_FILE;fi
echo

######
#  Virtual Interfaces

echo -e "VIRTUAL INTERFACES CONFIGURED :-\n"
ifconfig| grep "inet addr:"|grep -v 127.0.0.1|grep -v `hostname -i`;echo

######
#  Disk Usage

echo -e "------------------------SERVER DISC USAGE----------------------------\n"|tee -a $RESULT_FILE;
A=`mount|awk '{print $1}'|grep -n /dev/|grep "1:"|cut -f2 -d ":"|cut -c 1-8`
B=`mount|awk '{print $1}'|grep -n /dev/|grep "1:"|cut -f2 -d ":"`

echo;echo -e " / mounted on $B \n";
df -h|grep /dev|awk '{print $1,echo"mounted on",$6,echo"has used up",$3,echo "of",$2}'|tee -a $RESULT_FILE;echo

######
#  CSF Firewall Install Script

echo -e "-----------------CONFIGSERVER SECURITY & FIREWALL (CSF)--------------\n" | tee -a $RESULT_FILE;

./csf.sh

######
#  Scanning ports

echo -e "------------------------SCANNING FOR OPEN PORTS----------------------\n"|tee -a $RESULT_FILE;echo

nc -z `hostname` 01-35000|awk '{print $4, $6}'|tee -a $RESULT_FILE;echo
echo -e "Please block the unwanted ports from the list above.\n"|tee -a $RESULT_FILE;

######
#  Chkrootkit Install Script

echo -e "----------------------CHK-ROOTKIT INSTALL/CHECK----------------------\n"|tee -a $RESULT_FILE;echo

./chkrootkit.sh

######
#  Rkhunter Install

echo -e "---------------------RK-HUNTER INSTALL/CHECK----------------------\n"|tee -a $RESULT_FILE;echo

./rkhunter.sh

######
#  Check running services

echo -e "----------------------CHECKING RUNNING SERVICES-------------------\n"|tee -a $RESULT_FILE;

R=`runlevel |awk '{print $2}'`

echo; echo -e "YOU CURRENT RUNLEVEL IS $R\n" | tee -a $RESULT_FILE;
echo; echo -e "THE SERVICES RUNNING IN THIS LEVEL ARE : \n"|tee -a $RESULT_FILE;echo

chkconfig --list|grep $R:on|awk '{print $1}'|tee -a $RESULT_FILE;echo

echo -e "PLEASE USE 'chkconfig servicename off' TO DISABLE THE DESIRED SERVICES.\n"|tee -a $RESULT_FILE;echo

######
#  Accounts with Bash shell


echo -e "-------------------ACCOUNTS WITH /bin/bash AS LOGIN SHELL------------------\n"|tee -a $RESULT_FILE;echo

echo "Accounts outside /home/ having /bin/bash:-"
echo "----------------------------------------";echo
cat /etc/passwd|grep /bin/bash|grep -v /home;echo
echo "Accounts within /home/ having /bin/bash :-"
echo "----------------------------------------";echo
cat /etc/passwd|grep /bin/bash|grep /home;echo
echo "Finding invalid user accounts        :-"
echo "----------------------------------------";echo
find /home -maxdepth 1 -nouser -ls;echo
echo "Finding invalid mail directories     :-"
echo "----------------------------------------";echo
find /var/mail -nouser -ls;echo
echo "*************************************************************************"
echo "Please do the needed, if you find anything suspicious in the list above."
echo "*************************************************************************"

######
#  Securing commonly used download tools

echo -e "CHANGING PERMISSIONS ON COMMONLY USED DOWNLOAD TOOLS TO 750 FROM 755 FOR ADDED SECURITY.\n"|tee -a $RESULT_FILE;
chmod 750 /usr/bin/rcp;echo "Changed permission of /usr/bin/rcp to 750" |tee -a $RESULT_FILE;
chmod 750 /usr/bin/wget;echo "Changed permission of /usr/bin/wget to 750"|tee -a $RESULT_FILE;
chmod 750 /usr/bin/lynx;echo "Changed permission of /usr/bin/lynx to 750"|tee -a $RESULT_FILE;
chmod 750 /usr/bin/scp;echo "Changed permission of /usr/bin/scp to 750"|tee -a $RESULT_FILE;
chmod 750 /usr/bin/curl;echo "Changed permission of /usr/bin/curl to 750"|tee -a $RESULT_FILE;

######
# Checking Compiler permissions for local users

/scripts/compilers off;echo

######
#  Apache Status

echo -e "------------------------- APACHE STATUS ---------------------------\n" | tee -a $RESULT_FILE;echo

echo "CHECKING APACHE VERSION :-"|tee -a $RESULT_FILE;
echo "--------------------------"|tee -a $RESULT_FILE;
/usr/local/apache/bin/httpd -v|tee -a $RESULT_FILE;echo

echo "CHECKING APACHE CONF: FILE FOR SYNTAX SANITY :-"|tee -a $RESULT_FILE;
echo "-----------------------------------------------"|tee -a $RESULT_FILE;echo
/usr/local/apache/bin/apachectl configtest|tee -a $RESULT_FILE;echo

echo "APACHE COMPILE-TIME SETTINGS :-"|tee -a $RESULT_FILE;
echo "-------------------------------"|tee -a $RESULT_FILE;
/usr/local/apache/bin/httpd -V | tee -a $RESULT_FILE;echo

echo "APACHE COMPILED-IN MODULES :-"|tee -a $RESULT_FILE;
echo "-----------------------------"|tee -a $RESULT_FILE;
/usr/local/apache/bin/httpd -l | tee -a $RESULT_FILE;echo

######
#  PHP status

echo -e "----------------------------PHP STATUS----------------------------\n"|tee -a $RESULT_FILE;echo

echo "PHP VERSION INSTALLED :-"|tee -a $RESULT_FILE;
echo "------------------------"|tee -a $RESULT_FILE;
/usr/bin/php -v;echo
echo "PHP MODULES COMPILED  :-"|tee -a $RESULT_FILE;
echo "------------------------"|tee -a $RESULT_FILE;
/usr/bin/php -m;echo

######
#  Exim Stats

echo -e "----------------------------EXIM STATUS----------------------------\n"|tee -a $RESULT_FILE;echo

echo -e "Replacing :blackhole: to :fail:.\n"
replace :blackhole: :fail: -- /etc/valiases/*

######
#  Dns stats

echo -e "-----------------------------DNS STATUS----------------------------\n"|tee -a $RESULT_FILE;echo

echo -e "BIND VERSION : `/usr/sbin/named -v`\n";
echo -e "NAMED STATUS :\n"
/etc/init.d/named status;echo
echo -e "CHECKING SYNTAX SANITY OF /etc/named.conf\n";
echo "NO: OF ZONES : ` /etc/init.d/named status|grep number|awk '{print $4}'`"
named-checkconf /etc/named.conf;
if [ $? = 0 ];then echo "SYNTAX OK....";fi
echo -e "CHECKING MASTER ZONE FILES.\n";
named-checkconf -z;
echo;echo "ZONE CHECK FINISHED."

