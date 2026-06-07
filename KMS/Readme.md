# Key Management Service (KMS)Key Management Service (KMS)

Create and manage encryption keys
Use with a variety of AWS services and in your apps
checkbox secure ✅ and start encrypting

# Introduction to KMS
KMS makes it easy for you to create, control and rotate encryption keys used to encrypt your data on AWS.
KMS is a multi-tenant Hardware Security Module (HSM).
Most AWS services can just:

Checkbox on Encryption
And then choose a KMS key

# KMS is a multi-tenant Hardware Security Module (HSM)

What is Hardware Security Module (HSM)?

Hardware that is specialized for storing your encryption keys.
Its designed to be tamper-proof
It stores keys in-memory, so they are never written to disk.


What is Multi-tenant?
Multi-tenant means that multiple customers are utilizing the same piece of hardware. Customers are isolated from each other virtually. If one customer used the entire pieces of Hardware (dedicated) that would be called single-tenant.

CloudHSM is a single-tenant HSM which gives you full control.CloudHSM is a single-tenant HSM which gives you full control. A dedicated HSM means you can meet stricter compliance FIPS 140-2 Level 3.
KMS is only FIPS FIPS 140-2 Level 2.

# KMS – Customer Master Key
What is encryption? The process of encoding a message or information in such a way that only authorized parties can access it and those who are not authorized cannot.

What are cryptographic keys (data key)? A string of data that is used to lock or unlock cryptographic functions, including authentication, authorization and encryption.

What is a Master Key? Stored in secure hardware. Master keys are used to encrypt all other keys on a system.

What is Envelope Encryption? A key used to encrypt another key.


Customer master keys are the primary resources in AWS KMS. A customer master key (CMK) is a logical representation of a master key.

The CMK includes metadata, such as:

    the key ID
    creation date
    description
    and key state

The CMK also contains the key material used to:

    encrypt
    and decrypt data.
    AWS KMS supports symmetric and asymmetric CMKs.

Symmetric Key A 256-bit key that is used for encryption and decryption. Uses One Key

Encrypting a S3 bucket using AES-256

Asymmetric Key
An RSA key pair that is used for encryption and decryption or signing and verification (but not both).
Uses Two Keys (key pair eg. public and private)

*EC2 key pairs used to SSH into a server

# KMS – AWS CLI
You can perform many KMS actions through the AWS CLI. It's worth mentioning some of these API commands since they may appear on the exam:

aws kms create-key — Creates a unique customer managed customer master key (CMK) in your AWS account and Region

aws kms encrypt — Encrypts plaintext into ciphertext by using a customer master key (CMK)

aws kms decrypt — Decrypts ciphertext that was encrypted by a AWS KMS customer master key (CMK)

aws kms re-encrypt — Decrypts ciphertext and then re-encrypts it within AWS KMS.

manually rotate a CMK
change the CMK that protects a ciphertext
change the encryption context of a ciphertext
aws kms enable-key-rotation — Enables automatic rotation of the key material for the specified symmetric customer master key (CMK). You cannot perform this operation on a CMK in a different AWS account.

