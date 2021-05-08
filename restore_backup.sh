#!/bin/bash
#Fabio Birnegger

echo "Please type in the name of the file you want to decrypt without filextensions (.tar.gz.enc)"
read file

echo "Please type in the name of the key."
read keyname

PUBKEY=/home/$USER/$keyname-public.pem
PRIVKEY=/home/$USER/$keyname-private.pem
FILENAME="/tmp/$file.tar.gz"
SIGNNAME=$FILENAME.sign
ENCNAME=$FILENAME.enc

#verify
if [[ $(openssl dgst -sha256 -verify $PUBKEY -signature $SIGNNAME $ENCNAME 2>&1) = *"Verified OK"* ]]
then
  echo "Verification validated"
#decrypt
  openssl enc -d -aes-256-cbc -iter 100000 -in $ENCNAME -out $FILENAME

#remove encrypted tar ball and signature file
  rm $SIGNNAME
  rm $ENCNAME

#restore the directory
  tar -xzvf $FILENAME --directory /tmp/

  echo "Successfully encrypted"
  echo "The encrypted and restored backup file is stored in /tmp/home"

else
  echo "Verification failed!"
fi
