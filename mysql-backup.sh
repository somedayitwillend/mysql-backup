#!/bin/sh

YYYY=`/usr/bin/date '+%Y'`
MM=`/usr/bin/date '+%m'`
DD=`/usr/bin/date '+%d'`

BACKUP_DIR=/backup/mysql/${DD}-${MM}-${YYYY}

MYSQL_UNAME=root
MYSQL_PWORD=password

PATH=$PATH:/usr/local/mysql/bin

KEEP_BACKUPS_FOR=30

function delete_old_backups() {
  find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +$KEEP_BACKUPS_FOR -exec rm {} \;
}

function mysql_login() {
  local mysql_login="-u $MYSQL_UNAME"
  if [ -n "$MYSQL_PWORD" ]; then
    local mysql_login+=" -p$MYSQL_PWORD"
  fi
}

function backup_database() {
  mkdir -p $BACKUP_DIR
  $(mysqldump $(mysql_login) wordpress | gzip -9 > $BACKUP_DIR/wordpress.sql.gz)
  $(mysqldump $(mysql_login) drupal | gzip -9 > $BACKUP_DIR/drupal.sql.gz)
}

delete_old_backups
backup_database
