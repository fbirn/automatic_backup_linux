Automatic Backup Script for Linux 
by Fabio Birnegger

----- Description -----
#backup.sh: This Script is able to automatically create a backupfile of the home directory of one or more users. It enrypts and signs the created file. It also does a Sanity check and counts the total number of back upped items.

This Script will output the encrypted file and a signature file in the /tmp/ directory. The key file files will be created in the home directory.

#restore_backup.sh: This script is able to automatically decrypt and restore the created backupfile. Before decryption it validates the signature.

This Script will output the decrypted and restored directory also in the /tmp/directory with the name 'home'.

----- Usage -----
You will have change the file permissions of the scripts so the are executable. You can do this by using
chmod +x SCRIPTNAME

You can run the script now by navigating to the directory where the scripts are stored with
cd /EXAMPLE/

Execute the files with
./SCRIPTNAME

----- Examples -----

backup.sh example:

For how many users do you want to create a backup file?
–> 2
For which user’s home directory do you want to create the backup? For default (current user) press Enter.
–> bob
…
Please type in the name for the key:
–> keyname
enter aes-256-cbc encryption password: --> password
Verifying - enter aes-256-cbc encryption password: --> password
Verified OK

For which user’s home directory do you want to create the backup? For default (current user) press Enter.
.
. The script will repeat now.
.

restore_backup.sh example:

Please type in the name of the file you want to decrypt without filextensions (.tar.gz.enc)
–> text_home_backup_2021-05-08_16:40:00
Please type in the name of the key
–> keyname
Verification validated!
…
Successfully encrypted

Hint: the fastest way to get the filename is to copy it from the /tmp/ directory.
Don’t forget to only copy and paste the file name without the directory and without filextensions like .tar.gz!

You will find the restored file in the /tmp/ directory and the name will be ‘home’!

Needed Parameters are marked with ‘–>’
