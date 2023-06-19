# equadrat Licensing CLI

Use this tool/task to sign and validate licenses.

## tool/task

dotnet tool install --global equadrat.Licensing.CLI

## Commands

### keypair

generate a new key-pair (public/private)

- public: public key file
- private: private key file
- password: password for the private key file

### template

write a new template file for a license.

- template: template file
- format: XML/JSON

### sign

sign a template to create a license file.

- template: template file
- license: license file
- format: XML/JSON
- private: private key file
- password: password of the private key file

### validate

validate a license file

- license: license file
- format: XML/JSON
- public: public key file