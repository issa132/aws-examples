#!/usr/bin/env bash

      #chmod u+x /workspaces/aws-examples/bin/terraform_cli_install.sh
      sudo apt-get install tree

      sudo apt update
      sudo apt install -y curl gnupg 


      curl -fsSL https://apt.releases.hashicorp.com/gpg | \
      gpg --dearmor | \
      sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
      https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
      sudo tee /etc/apt/sources.list.d/hashicorp.list

      sudo apt update
      sudo apt install terraform