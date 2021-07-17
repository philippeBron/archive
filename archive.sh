#!/bin/bash

echo "##### Chargement des parametres....."
source param.conf

echo "##### Liste du contenu du conteneur ${bucket_path}/test"
rclone lsl --sftp-host ${sftp_host} --sftp-user ${sftp_user} --sftp-pass ${sftp_pass} --sftp-key-file ${sftp_key_file} ${remote_bucket}:${bucket_path}/test

echo "##### Synchronisation du contenu des fichiers"
echo "rclone sync --update --progress --sftp-host ${sftp_host} --sftp-user ${sftp_user} --sftp-pass ${sftp_pass} --sftp-key-file ${sftp_key_file} ${local_dir} ${remote_bucket}:${bucket_path}/test"

rclone sync --update --progress --sftp-host ${sftp_host} --sftp-user ${sftp_user} --sftp-pass ${sftp_pass} --sftp-key-file ${sftp_key_file} ${local_dir} ${remote_bucket}:${bucket_path}/test

echo "##### Liste du contenu du conteneur ${bucket_path}/test"
rclone lsl --sftp-host ${sftp_host} --sftp-user ${sftp_user} --sftp-pass ${sftp_pass} --sftp-key-file ${sftp_key_file} ${remote_bucket}:${bucket_path}/test

echo "##### Synchronisation & chiffrement du contenu des fichiers"
echo "rclone sync --update --progress --sftp-host ${sftp_host} --sftp-user ${sftp_user} --sftp-pass ${sftp_pass} --sftp-key-file ${sftp_key_file} --crypt-remote ${remote_bucket}:${encrypt_path} --crypt-password ${encrypt_pass} --crypt-password2 ${encrypt_salt} ${local_dir} ${remote_encrypt}:${encrypt_path}"

rclone sync --update --progress --sftp-host ${sftp_host} --sftp-user ${sftp_user} --sftp-pass ${sftp_pass} --sftp-key-file ${sftp_key_file} --crypt-remote ${remote_bucket}:${encrypt_path} --crypt-password ${encrypt_pass} --crypt-password2 ${encrypt_salt} ${local_dir} ${remote_encrypt}:${encrypt_path}

echo "##### Liste du contenu du conteneur chiffre ${encrypt_path}"
rclone lsl --sftp-host ${sftp_host} --sftp-user ${sftp_user} --sftp-pass ${sftp_pass} --sftp-key-file ${sftp_key_file} --crypt-remote ${remote_bucket}:${encrypt_path} --crypt-password ${encrypt_pass} --crypt-password2 ${encrypt_salt} ${remote_encrypt}:${encrypt_path}