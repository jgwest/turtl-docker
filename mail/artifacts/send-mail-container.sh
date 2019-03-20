#!/bin/bash


#export SUBJECT="$2"
#export TARGET_ADDR="$1"

#printf "To: $TARGET_ADDR\nFrom: $TARGET_ADDR\nSubject: $SUBJECT\n\nHello there. This is email test from MSMTP." | msmtp $TARGET_ADDR

cp /msmtprc-input/msmtprc /etc/msmtprc

cat /input/email.txt  | msmtp $1

