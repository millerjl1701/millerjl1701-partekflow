#!/bin/sh

DIR="/home/flow/backups"
DATECODE=`date +%Y%m%d`

if [[ ! -e $DIR ]]; then
  mkdir $DIR
fi

tar -czvf $DIR/flowdbbackup-$DATECODE.tar.gz /home/flow/.partekflow/

exit
