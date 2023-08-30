#!/bin/bash

redshift_endpoint=$(aws redshift describe-clusters --cluster-identifier "${1}" --query "Clusters[0].Endpoint.Address" --output text)
redshift_port=$(aws redshift describe-clusters --cluster-identifier "${1}" --query "Clusters[0].Endpoint.Port" --output text)
redshift_dbname="${2}"
ops_user=$(echo "${3}" | tr '[:upper:]' '[:lower:]')
master_username="${4}"
master_password="${5}"
secret_id="${6}"

existing_secret=$(aws secretsmanager get-secret-value --secret-id "${secret_id}" --query SecretString --output text)
if [[ $existing_secret =~ $ops_user ]]; then
  echo "Ops user already exists in the secret. Skipping user creation."
  exit 0
fi

deploy_password=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | head -c12)

sql_command="CREATE USER ${ops_user} WITH PASSWORD '${deploy_password}'; \
              ALTER USER ${ops_user} CREATEDB; \
              ALTER USER ${ops_user} CREATEUSER; \
              CREATE ROLE ${ops_user}_ROLE;"


aws redshift-data execute-statement \
    --cluster-identifier "${1}" \
    --database "${redshift_dbname}" \
    --db-user "${master_username}" \
    --sql "${sql_command}"

updated_secret=$(jq -n --argjson existing_secret "$existing_secret" --arg username "${ops_user}" --arg password "$deploy_password" '$existing_secret + {"OPS_USERNAME": $username, "OPS_PASSWORD": $password}')
aws secretsmanager update-secret --secret-id "${secret_id}" --secret-string "$updated_secret"
