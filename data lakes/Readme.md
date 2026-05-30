# Introduction to Data Lakes
 
A data lake is a centralized data repository for unstructured and semi-structured data
A Data Lake is intended to store vast amounts of data
Data lakes generally use object (blobs) or files as its storage medium.
Transform
    Change or blend data Into new semi-structured data using ELT/ETL engines
Collect
    Pulling from various data sources
Distribution
    Allow access to data to various Programs or APIs


# AWS Lake Formation

AWS Lake Formation is a data lake to centrally govern, secure, and globally share data for analytics and machine learning

    Manage fine-grained access control for your data lake data on Amazon S3
    Mange metadata in AWS Glue Data Catalog
    Lake Formation provides its own permissions model that augments the IAM permissions model

        through a simple grant or revoke mechanism similar to relational database management system (RDBMS)
    
    allows you to share data internally and externally across multiple AWS accounts, AWS organizations or directly with IAM principals in another account
    permissions are enforced using granular controls at the column, row, and cell-levels across

        Athena
        Quicksight
        Redshift Spectrum
        EMR
        Glue

AWS Lake Formation and AWS Glue share the same Data CatalogAWS Lake Formation and AWS Glue share the same Data Catalog

