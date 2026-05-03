# AWS Service Catalog enables organizations to create and manage catalogs of products that are approved for use on AWS to achieve consistent governance and meet compliance requirements.
The AWS Service Catalog is an alternative to granting direct access to AWS resources via the AWS Console.

Standardization
Self-service discovery and launch
Fine-grain access control
Extensibility and version control



Analogie : c'est comme un menu de restaurant interne — les équipes ne cuisinent pas elles-mêmes (pas d'accès direct AWS Console), elles choisissent parmi des plats pré-approuvés par l'organisation.
Fonctionnalité              Description
Standardization             Tous utilisent les mêmes templates approuvés
Self-service                Les équipes déploient elles-mêmes sans attendre l'IT
Fine-grain access control   Contrôle précis de qui peut lancer quoiVersion controlGestion des versions des produits du catalogue

# AWS Service Catalog – Users
Cheat sheets, Practice Exams and Flash cards 👉 www.exampro.co/ssa-c03
There are two types of Service Catalog users:

Catalog Administrator : They managed the catalog
End Users : They use the catalog

Catalog Administrators
Manage a catalog of products, organizing them into portfolios and granting access to the end users. An administrator technical responsibilities include:

Preparing CloudFormation templates
Configuring constraints
Managing IAM roles assigned to products

End Users
Use the AWS Management Console to launch products that admins have granted access to end user.

Résumé visuel :
Catalog Administrator          End User
       │                           │
       ▼                           ▼
  Crée les produits          Choisit dans
  (CloudFormation)    ──►    le catalogue
  Configure les              et lance le
  contraintes                produit
  Gère les IAM roles
                        Catalog Administrator               End User    
Rôle                    Crée et gère                        Consomme
Outils                  CloudFormation, IAM, Constraints    AWS Console
Accès                   Total sur le catalogue              Limité aux produits approuvésAnalogieChef cuisinierClient du restaurant

# A product is a CloudFormation template that defines the resources that will be launched
yaml
Resources:
  WebServer:
    Type: 'AWS::EC2::Instance'
    Properties:
      ImageId: ami-02354e95b39ca8dec
      InstanceType: t2.micro

# le End User lance un produit → CloudFormation s'exécute en arrière-plan → les ressources AWS sont créées automatiquement, sans que l'utilisateur touche à la console AWS directement.

# Once a product is created it cannot be edited only deleted.
Also a product must be removed from the portfolio and not provisioned by a user in order to delete.
In order for products to be made visible to users it needs to be added to a portfolio.

# A Portfolio is a collection of products.
Constraints can restrict how products are used.
To determine who can see and launch products is by associating either Groups, roles or users.

# Analogie : le Portfolio = un catalogue de magasin, les Constraints = les conditions d'utilisation, les Groups/Roles/Users = la liste des clients autorisés.

# To grant access so end-users can see products in the catalog you need to associate to a portfolio Groups, Users or Roles.
All Products in the portfolio will be shared to the added identities.
You cannot limit some products to some users in a portfolio.

# Règle de design : organise les produits en portfolios selon les profils d'utilisateurs, pas selon les types de produits — puisque l'accès est tout-ou-rien par portfolio.

# WS Service Catalog – Administrator Constraints
You can create Constraints for specific products in your portfolio.
Launch
Use a specified IAM role instead the end-user credentials. This way you can you don't have to grant the end-user permissions to services directly and this will be less-permissive and more secure.

Notifications
Send product notifications to a stack.

Template
Limit the options that are provided to the end user when launching a product. Set restrictions on the underlying CloudFormation parameter inputs.
eg. Only allow t2.micro

StackSet
Allows you to configure product deployment across accounts and regions using AWS CloudFormation StackSets.

TagUpdate
choose to allow or disallow your end users to update tags on resources associated with a provisioned product

# AWS Service Catalog – Service Actions
Service Actions are SSM Documents associated with a Product to allow the end user perform maintenance.
Sans Service Actions → l'End User ne peut que lancer ou terminer un produit.
Avec Service Actions → l'End User peut aussi maintenir le produit (redémarrage, patch, etc.) sans accès direct à la console AWS.

1. Administrator user chooses an SSM Document and create a service action
2. Administrator user associates the action to a product
3. The service action will appear on the Provisioned Product and the end-user can run the action. → ACTIONS 






