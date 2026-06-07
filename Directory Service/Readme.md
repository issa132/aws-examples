# Directory Service
What is a directory service?
A directory service maps the names of network resources to their network addresses.

A directory service is shared information infrastructure for locating, managing, administering and organizing resources:
    Volumes
    Folders
    Files
    Printers
    Users
    Groups
    Devices
    Telephone numbers
    Other objects

A directory service is a critical component of a network operating system. A directory server (name server) is a server which provides a directory service.
Each resource on the network is considered an object by the directory server. Information about a particular resource is stored as a collection of attributes associated with that resource or object.

# Active Directory
Microsoft introduced Active Directory Domain Services in Windows 2000 to give organizations the ability to manage multiple on-premises infrastructure components and systems using a single identity per user.

# LDAP
Lightweight Directory Access Protocol (LDAP) is an open, vendor-neutral, industry standard application protocol for accessing and maintaining distributed directory information services over an Internet Protocol (IP) network.
A common use of LDAP is to provide a central place to store usernames and passwords.
LDAP enables for same-sign on. Same sign-on allows users to single ID and password, but they have to enter it in every time they want to login.

# Why use LDAP when SSO is more convenient?Why use LDAP when SSO is more convenient?
Most SSO systems are using LDAP.
LDAP was not designed natively to work with web-applications.
Some systems only support integration with LDAP and not SSO.

AWS Directory Service provides multiple ways to use Microsoft Active Directory (AD).

Lets you use existing Microsoft AD–aware or Lightweight Directory Access Protocol (LDAP)–aware applications in the cloud.

Simple AD (Not available in all regions)
A Microsoft AD compatible directory powered by Samba 4. Supports basics AD features.
Samba is an open-source implementation of Server Message Block (SMB)

AD Connector A proxy service to connect your existing on-premise AD Directory.

AWS Managed Microsoft AD
A full feature managed version of Microsoft Windows Server Active Directory (AD).

Amazon CognitoAmazon Cognito
Integrate signup and sign-in into your web-applications.