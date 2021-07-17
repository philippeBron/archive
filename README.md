# Archivage cloud

Un projet de sauvegarde de fichiers dans le Cloud en utilisant la solution Public Cloud Archive d'OVH.

Le fonctionnement repose sur `duplicity` qui permet de chiffrer données et transférer uniquement les modifications plutôt que l'ensemble des fichiers. 

## Configuration
### OVH
Il est préférable de créer un utilisateur spécifique qui ne diposera uniquement du rôle `ObjectStore operator` lui permettant d'avoir accès au conteneur d'archivage.
Le fichier `param.conf` contient les informations de connexion :
* `user`
* `mot de passe` qui est la concaténation des informations : `TENANT_NAME.USERNAME.PASSWORD`

Duplicity utilise une `PASSPHRASE` pour le chiffrement et le déchiffrement des archives.

### Rclone
Rclone permet de synchroniser des répertoires avec plus de 40 sctockages Cloud. Cependant, la solution Public Cloud Archive n'offre que le protocole `sftp` pour la connexion entre les deux sources.

Les différents paramètres nécessaire à la connexion sont les suivants :
* sftp-host : serveur de sauvegarde
* sftp-user : utilisateur
* sftp-pass : mot de passe encodé en base64
* sftp-key-file : fichier de la clé privée utilisée pour le chiffrement

Ces paramètres sont renseignés dans le fichier `param.conf` qui sera utilisé par le script d'archivage automatique.


Dans ce cas, le fichier de configuration `~/.config/rclone/rclone.conf` est réduit au minimum :
```bash
[remote]
type = sftp
set_modtime = false
```

## Archivage
Pour tester la configuration on peut utiliser la commande suivant est un exemple de syntaxe pour lister le contenu du répertoire archive :

```bash
rclone lsl --sftp-host '<sftp-hots>' --sftp-user '<stfp-user>' --sftp-pass '<sftp-pass>' --sftp-key-file '<stfp-file-key>' remote:archive
```

