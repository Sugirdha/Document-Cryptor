#  Document Cryptor

#### Objective:
To build a file browser app that will allow user to encrypt and decrypt local files when the user is logged in.

#### Basic features:
1. [x] Login to the application using predetermined username and password
2. [x] Browse local files 
3. [x] Encrypt or decrypt files using AES encryption and PBKDF2
4. [x] Implement encrypt and decrypt menu options to execute the function

#### Bonus features: 
1. [ ] Rebuild using OAUTH2 user authentication - TBD
2. [ ] Build backend using REST API service for file browsing - TBD

#### External Frameworks/Libraries
* This project uses a basic document browser code provided by Apple Inc. The Document Browser View Controller has been modified to suit the project brief. More licensing details can be found in the license document.
* The encryption/decryption features are built using [RNCryptor][1] framework. 
[1]: https://github.com/RNCryptor/RNCryptor "RNCryptor on  GitHub"
    * Some modifications have been done to fix spec mismatches but more parameters need to be changed. Work in progress.
    * As such, using a common library like RNCryptor is not the safest way to encrypt and decrypt files. For maximum security, it is better to work on my own solution. To be done in the next stage.
        
#### Known issues / Improvement plans
* The app only supports text documents now. Modify to add more document types.
* Update library to meet spec requirements where mismatched.
* Encrypted documents cannot be decrypted if the user logs in again because encryption key has been changed. Find out how to persist the key for the particular document
