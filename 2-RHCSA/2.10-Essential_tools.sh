1-Understand and use essential tools
Access a shell prompt and issue commands with correct syntax
Use input-output redirection (>, >>, |, 2>, etc.)
Use grep and regular expressions to analyze text
Access remote systems using SSH
Log in and switch users in multiuser targets
Archive, compress, unpack, and uncompress files using tar, star, gzip, and bzip2
Create and edit text files
Create, delete, copy, and move files and directories
Create hard and soft links
List, set, and change standard ugo/rwx permissions
Locate, read, and use system documentation including man, info, and files in /usr/share/doc

yum-ultils
yumdownloader stress



ARCHIVING_COMPRESSION, SYSTEM_DOCUMENTATION, LOGS, FILE_LINKS, UMASK

if apropos perm -> mothing appropriate
DOCs
$yum install -y man-pages
$yum install -y makewhatis (regenerate manpage database search through apropos)
$updatedb
$mandb -c  <----fixes nothing appropriate issue

NOW.....
$apropos perm
"Shows a list of commands that has something to do with perm"




ARCHIVING
Remove clutter from /home directory
tar,star ARCHIVING
gzip,bzip2 COMPRESSION

ARCHIVING
tar cvf /home/archives/rupert.tar rupert/
tar tvf rupert.tar | wc -l
gzip rupert.tar
ls -alh
ARCHIVING + COMPRESSION
tar cvfj /home/archieves/rupert.tar.bz2 rupert/
tar cvfz /home/archieves/rupert.tar.gz rupert/      z is gzip

pwd - extraction will be in working directory
tar xvfj archives/rupert.tar.bz2
tar xvfz archives/rupert.tar.gz
how to uncompress single zip file (which is not archieved)
bzip2 -d archives/centos.iso.bz2
bzip2 -d archives/centos.iso.gz

LAB
 1001  tar -cvf documentation.tar /usr/share/doc
 1002  ll
 1003  tar -tf documentation.tar
 1004  tar -tvf documentation.tar
 1005  tar -zcvf documentation.tar.gz /usr/share/doc
 1006  du -sh *.tar
 1007  du -sh *.tar*
 1008  tar -jcvf documentation.tar.bz2 /usr/share/doc
 1009  du -sh *.tar*
 1010  tar -tvf documentation.tar.gz
 1011  tar -zxvf documentation.tar.gz
UNPACK a single file
[root@x230 doc]# tar -tvf documentation.tar.gz
[root@x230 doc]# tar -xzvf documentation.tar.gz usr/share/doc/skopeo/README.md
1047  gzip stress-1.0.4-29.el9.x86_64.rpm
 1048  ll
 1049  gunzip stress-1.0.4-29.el9.x86_64.rpm.gz
 1050  ll
 1051  bzip2 stress-1.0.4-29.el9.x86_64.rpm
 1052  ll
 1053  bunzip stress-1.0.4-29.el9.x86_64.rpm.bz2
 1054  bunzip2 stress-1.0.4-29.el9.x86_64.rpm.bz2
 1055  ll
 gzip * convert all files into gzip
 gunzip *

SYSTEM DOCUMENTATION
MAN PAGES   search by /name
whatis httpd
apropos httpd   list everything related keywords
    apachectl (8)        - Server control interface for httpd
    httpd (8)            - Apache Hypertext Transfer Protocol Server
    httpd@.service (8)   - httpd unit files for systemd
    httpd.conf (5)       - Configuration files for httpd
    httpd.service (8)    - httpd unit files for systemd
    httpd.socket (8)     - httpd unit files for systemd
    ostree-trivial-httpd (1) - Simple webserver
man 8 httpd.socket
INFO DOCS
man info
/USR/SHARE/DOC
ls -la /usr/share/doc/httpd
more licence


LOGS
/var/log
create a new system log to track httpd events on our server
tree /var/log
mkdir -p log_project/raw_logs
grep httpd /var/log/* > raw_logs/master.log 2> raw_logs/error_log
wc -l raw_logs/master.log
grep systemd raw_logs/master.log > httpd_logs/systemd.log
egrep -v "dnf|secure" raw_logs/master.log > httpd_logs/no_dnf_secure.log
-v is exclude dnf and secure
rm -rf error_logs

VI
we have been asked to document /etc/hosts file on our servers
cp /etc/hosts .
vi hosts
make it comma separated insert headings

FILE LINKING
Web team needs a new content location setup shared storage 4 group
we cannot create hard link for directories
mv -v /var/www /content
ln -s /content/* /var/www (soft link)
ls -li /var/www (shows links and inodes)
ln /content/db_user/README . (created a hard link in current dir)
rm -f original file
link still exit in copied location 
if you remove file which has a soft link, it breaks symlink which needs to be removed
rm -f /var/www/db_stuff
LAB
[root@x230 ~]# mkdir links
[root@x230 ~]# cd links
[root@x230 links]# touch original
[root@x230 links]# mkdir original_dir
[root@x230 links]# ln -s original softlink
[root@x230 links]# ln -s original_dir softlink_dir
[root@x230 links]# ls -li
total 0
 67111007 -rw-r--r--. 1 root root  0 May 29 02:29 original
134715247 drwxr-xr-x. 2 root root  6 May 29 02:29 original_dir
 67111468 lrwxrwxrwx. 1 root root  8 May 29 02:30 softlink -> original
 671122g87 lrwxrwxrwx. 1 root root 12 May 29 02:30 softlink_dir -> original_dir


UMASK
permanently change permissions for user azam
owner should have read permissions on new files 
others have no permissions. same for directories
vim /etc/.bash_profile
umask 277
(total permission value - desired permission = umask value)
         6 ---- 4 owner should have read permission = 2
         7 ---- 0 group has NO permission = 7
         7 ---- 0 others have no permission = 7
for old files run === chmod -R 0-rwx ~
as ROOT, change umask for all users at once === /etc/profile


# Configure Umask to Ensure All Files Created by Any User Cannot Be Accessed by "other" Users
The default umask for all users is set in the /etc/profile and /etc/bashrc files.
change 002 to 026
change 022 to 026 
on both files


UMASK
change umask for a user persistant
echo 'umask 0027' >> ~/.bashrc
logout and login
umask = 0027

NEW USERS  created should have password expiry of 20 days 
/etc/login.defs
PASS_MAX_DAYS 99999 -> 20
chage -l new

[root@x230 ~]# cat > useradd.txt
azam
hassan
faizi
shahrukh
[root@x230 ~]# cat useradd.txt
azam
hassan
faizi
shahrukh

REGULAR Expresions
[root@x230 ~]# echo " " ; echo "==== `date` on `hostname` ===="

==== Sun May 28 10:20:44 PM PKT 2023 on x230 ====
[root@x230 ~]# echo " " ; echo "==== `date` on `hostname` ====" ; echo " "

==== Sun May 28 10:20:58 PM PKT 2023 on x230 ====

[root@x230 ~]# echo " " ; echo "==== `date` on `hostname` ====" ; df -h ; echo " "

==== Sun May 28 10:21:11 PM PKT 2023 on x230 ====
Filesystem            Size  Used Avail Use% Mounted on
devtmpfs              4.0M     0  4.0M   0% /dev
tmpfs                 3.6G  168K  3.6G   1% /dev/shm
tmpfs                 1.5G  1.8M  1.5G   1% /run
/dev/sda4              75G  7.1G   68G  10% /
/dev/sda3             2.0G  501M  1.6G  25% /boot
/dev/sda6             200G  3.3G  197G   2% /home
/dev/mapper/VG1-VDO1 1000G  7.1G  993G   1% /mnt/TB
tmpfs                 1.0M     0  1.0M   0% /run/stratisd/ns_mounts
tmpfs                 737M  376K  737M   1% /run/user/1000
tmpfs                 737M   36K  737M   1% /run/user/0

echo " " ; echo "==== `date` on `hostname` ====" ; df -h ; echo " " > `hostname`-health.txt
==ERROR

[root@x230 ~]# { echo " " ; echo "==== `date` on `hostname` ====" ; df -h ; echo " " ; } > `hostname`-
health.txt
[root@x230 ~]# cat x230-health.txt

==== Sun May 28 10:24:38 PM PKT 2023 on x230 ====
Filesystem            Size  Used Avail Use% Mounted on
devtmpfs              4.0M     0  4.0M   0% /dev
tmpfs                 3.6G  168K  3.6G   1% /dev/shm
tmpfs                 1.5G  1.8M  1.5G   1% /run
/dev/sda4              75G  7.1G   68G  10% /
/dev/sda3             2.0G  501M  1.6G  25% /boot
/dev/sda6             200G  3.3G  197G   2% /home
/dev/mapper/VG1-VDO1 1000G  7.1G  993G   1% /mnt/TB
tmpfs                 1.0M     0  1.0M   0% /run/stratisd/ns_mounts
tmpfs                 737M  376K  737M   1% /run/user/1000
tmpfs                 737M   36K  737M   1% /run/user/0

NUMBERED LISTS, SORTED, -exec runs on every line of output to calculate size
 find /etc -maxdepth 1 -iname "*.*" -exec du -sh {} \; | sort -h > ect_dir_file_sizes.txt
 nl ect_dir_file_sizes.txt > numbered.txt
 cat numbered.txt

 ====121  76K     /etc/bash_completion.d
   122  80K     /etc/logrotate.d
   123  80K     /etc/php.d
   124  96K     /etc/yum.repos.d
   125  112K    /etc/grub.d
   126  112K    /etc/profile.d
   127  136K    /etc/pam.d
   128  356K    /etc/sane.d


GREP & REGULAR EXPRESSION
[root@x230 ~]# find /home -user reason | grep -i file
/home/reason/.bash_profile
VS
[root@x230 ~]# find /home -user reason -exec grep -i file {} \;
grep: /home/reason: Is a directory
grep: /home/reason/.mozilla: Is a directory
grep: /home/reason/.mozilla/extensions: Is a directory
grep: /home/reason/.mozilla/plugins: Is a directory
# .bash_profile
touch reasonfile
rm rupertfile
rm reasonfile
VS
[root@x230 ~]# grep -ir file /home/reason/
/home/reason/.bash_profile:# .bash_profile
/home/reason/.bash_history:touch reasonfile
/home/reason/.bash_history:rm rupertfile
/home/reason/.bash_history:rm reasonfile
[rupert@server2 ~]$ ps -few | grep sleep | awk '{print $2}'
17351
97359
97680
[rupert@server2 ~]$ ps -few | grep sleep | awk '{print $2}' | head -1
17351


LAB
MANAGING FILES - copy/move
 mkdir -p ~/code/mortimer/{cloudform,xml} ~/code/ursula/json
 1058  tree code
 1059  touch ~/code/ursula/file{1,2,3,4}.xml ~/code/mortimer/file{1,2,3}.json
 1060  touch ~/code/mortimer/file{1,2,3}.cp
 1061  tree
 1062  tree code
 1063  mv ~/code/ursula/file* ~/code/mortimer/xml/
 1064  mv ~/code/mortimer/file*.cp ~/code/mortimer/cloudform/
 1065  mv ~/code/mortimer/file*.json ~/code/ursula/json/
 1066  tree code
 1067  cp -r ~/code/mortimer/cloudform/ ~/code/ursula/

 
 "*************************************************************"
 3 versions of regular expressions
 BRE: Basic Regular expressions
 ERE: Extended Regular expressions
 PRCE: Perl Regular expressions

"BRE"
using grep, you can force the use of BRE by using -G option
"ERE"
using grep, you can force the use of ERE by using -E option
"PRCE"
using grep, you can force the use of PRCE by using -P option

grep a$ names.txt
tania
valentina
   
grep ^val names.txt
valentina

grep over files.txt
governor is governing 
winter is over

grep -w over files.txt
winter is over