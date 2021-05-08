#!/bin/bash
#Fabio Birnegger

#functions

nrFiles(){
       ls $1 | wc -l
}

nrDirectories(){
        ls -lR $1 | wc -l
}


#ask user
echo "For how many users do you want to create a backup file?"
read numdir

#for loop for the possibility to backup more than one directory
for ((i=1 ; i <= $numdir ; i++))
do

# ask user
echo "For which user's home directory do you want to create the backup? For default press Enter."
# read and save the given input in variable
read anotherusername

# if the user exists
if id -u "$anotherusername" >/dev/null 2>&1; then
  input=/home/$anotherusername
  username=$anotherusername
# else if user pressed enter without typing anything
elif [ -z "$anotherusername" ]; then
  input=/home/$user
  username=$USER
else
  echo "User not found. Backup will be created from default."
  input=/home/$user
  username=$USER
fi

# variable for file output
output=/tmp/${username}_home_backup_"$(date +"%Y-%m-%d_%H:%M:%S").tar.gz"

# count files before backup
before=$(nrFiles "$input")

# create tar
tar -zcvf $output $input 2>/dev/null

# count files after backup
after=$(nrFiles "$input")

# count backed up items
let files+=$(nrFiles "$input")
let dirs+=$(nrDirectories "$input")
let numus=$i
let total=$(( files + dirs + numus))

#sanity check and output
if [ $before -eq $after ]
then
  printf "\n\r+++++++++++++++++++++++++"
  printf "\n\rsuccess"
  printf "\n\rThe file is stored in $output.enc"
  printf "\n\rNumber of back upped Files: $files"
  printf "\n\rNumber of back upped Directories: $dirs"
  printf "\n\rNumber of back upped users: $numus"
  printf "\n\rTotal Number of back upped items: $total"
  printf "\nDetails about the created backup file:" 
  stat $output
elif [ $before -ne $after ]
then
  printf "\n\r+++++++++++++++++++++++++"
  printf "\n\rbackup failed"
fi

#ask user for keyname
echo "Please type in the name for the key:"
read keyname

#create private key
openssl genrsa -out "$keyname-private.pem" 2048

#create public key
openssl rsa -pubout -in "$keyname-private.pem" -out "$keyname-public.pem"

#encrypt the directory
openssl enc -aes-256-cbc -iter 100000 -in "$output" -out "$output.enc"

#Sign the file
openssl dgst -sha256 -sign "$keyname-private.pem" -out "$output.sign" "$output.enc"
openssl dgst -sha256 -verify "$keyname-public.pem" -signature "$output.sign" "$output.enc"

#delete the unencrypted file
rm $output


done
