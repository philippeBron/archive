# Archivage cloud

Un projet de sauvegarde de fichiers dans le Cloud en utilisant la solution Public Cloud Archive d'OVH.

Le fonctionnement repose sur `rclone` qui permet de chiffrer données et transférer uniquement les modifications plutôt que l'ensemble des fichiers. 

## Configuration
### OVH
Il est préférable de créer un utilisateur spécifique qui ne diposera uniquement du rôle `ObjectStore operator` lui permettant d'avoir accès au conteneur d'archivage. Public Cloud Archive ne propose que les protocoles `scp` et `sftp` pour transférer des fichiers. Dans ce projets nous utiliseront `sft` et utiliseront les paramètres suivant pour la connexion :
* host : url dépendant du choix du data center : `gateways.storage.<location>.cloud.ovh.net`
* user : `pca`
* password : qui est la concaténation des informations : `TENANT_NAME.USERNAME.PASSWORD`

Ces paramètres sont repris dans la configuration de rclone.

### Rclone
Rclone permet de synchroniser des répertoires avec plus de 40 sctockages Cloud. Cependant, la solution Public Cloud Archive n'offre que le protocole `sftp` pour la connexion entre les deux sources.

Les différents paramètres nécessaire à la connexion sont les suivants :
* `sftp_host` : serveur de sauvegarde
* `sftp_user` : utilisateur OVH
* `sftp_pass` : mot de passe OVH encodé en base64
* `sftp_key-file` : fichier de la clé privée utilisée pour le chiffrement

Ces paramètres sont renseignés dans le fichier `param.conf` qui sera utilisé par le script d'archivage automatique. Ce fichier contient également des paramètres nécessaire à l'utilisation du stockage rclone :
* `local_dir` : chemin vers le répertoire à archiver
* `remote_bucket` : nom du stockage rclone (*identique à celui défini dans le fichier rclone.conf*)
* `bucket_path` : nom du répertoire dans lequel les archives seront stockées


Dans ce cas, le fichier de configuration `~/.config/rclone/rclone.conf` est réduit au minimum :
```bash
[remote]
type = sftp
set_modtime = false
```

*Remarque : le nom entre '[' doit être identique à celui défini dans la variable `remote_bucket`*

### Chiffrement des archives
Rclone propose de chiffrer les archives en utilisant un stockage rclone de type `crypt` qui fera l'intermédiaire entre les fichiers à archiver et le stockage Cloud défini dans l'étape précédente.

Les paramètres utilisés pour la configuration du stockage chiffrés sont :
* `remote_encrypt` : nom du stockage rclone chiffré
* `encrypt_path` : chemin vers le répertoire qui stockera les archives chifrées
* `encrypt_pass` : mot de passe de chiffrement encodé en base 64
* `encrypt_salt` : passphrase utilisée pour le sel du chiffrement encodée en base 64

Ces paramètre sont également définis dans le fichier `param.conf`.

Une entrée est ajoutée au fichier de configuration `~/.config/rclone/rclone.conf` :
```bash
[secret]
type = crypt
```

*Remarque : le nom entre '[' doit être identique à celui défini dans la variable `remote_encrypt`*

## Archivage
Pour tester la configuration on peut utiliser la commande suivante qui est un exemple de syntaxe pour lister le contenu du répertoire archive :

```bash
rclone lsl --sftp-host '<sftp-hots>' --sftp-user '<stfp-user>' --sftp-pass '<sftp-pass>' --sftp-key-file '<stfp-file-key>' '<rclone_bucket>':'<path_to_archive>'
```
