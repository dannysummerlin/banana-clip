# Banana Clip
load MailGun from Salesforce

Apex Component
* retrieves templates from MailGun
    - ? automatic or manual refresh ?
* saves templates as Custom Metadata
* processes template description for field use
* takes a collection of records as input
* allows setting of recipient values from collection of records
* allows setting of template values from user inputs
    - template values such as body, right column, etc
    - ? how to interpolate recipient values into template values ?
* creates job on MailGun
