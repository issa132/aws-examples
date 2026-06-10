# Hardware Security Module (HSM)

Un Hardware Security Module (HSM) est un équipement matériel conçu pour stocker des clés de chiffrement. Les HSM conservent les clés en mémoire et ne les écrivent jamais sur disque.

Federal Information Processing Standard (FIPS) Norme du gouvernement américain et canadien qui spécifie les exigences de sécurité pour les modules cryptographiques protégeant les informations sensibles.

Les HSM multi-locataires sont conformes FIPS 140-2 Niveau 2 (plusieurs clients virtuellement isolés sur un HSM)
Les HSM mono-locataires sont conformes FIPS 140-2 Niveau 3 (un seul client sur un HSM dédié)

# CloudHSM
CloudHSM is a single-tenant HSM as a service that automates hardware provisioning, software patching, high availability and backups.
AWS CloudHSM enables you to generate and use your encryption keys on a FIPS 140-2 Level 3 validated hardware.
Built on Open HSM industry standards to integrate with:

PKCS#11
Java Cryptography Extensions (JCE)
Microsoft CryptoNG (CNG) libraries

You can also transfer your keys to other commercial HSM solutions to make it easy for you to migrate keys on or off of AWS.
Configure AWS KMS to use AWS CloudHSM cluster as a custom key store rather than the default KMS key store.
