## Créer un bucket S3
aws s3 mb s3://class-fun-ab-6346


## Créer un fichier local
echo "Hello World" > hello.txt

## Envoyer le fichier vers S3
aws s3 cp hello.txt s3://class-fun-ab-6346 --storage-class STANDARD_IA