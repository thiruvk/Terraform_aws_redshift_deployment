
#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Author(s)    : DevOps Team --- 08/10/2020
#------------------------------------------------------------------------------
# Copyright (c) iqvia
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#
###############################################################################

###############################################################################
# team
###############################################################################
# Description  : To Launch destroy environment
# Replace null ressource , local exec on destroy to avoid cycle resources warnings
#
################################################################################
#
################################################################################

#####################################
#         Fonctions                 #
#####################################
export PATH_FILE_VARIABLE=$(find / -type f -name .$WORKSPACE_NAME.final.variables.auto.tfvars -print | head -n 1)
echo "PATH_FILE_VARIABLE is : ${PATH_FILE_VARIABLE}"

get_workspace_variable_command(){
    VARIABLE_NAME=$1
    grep "${VARIABLE_NAME}" $PATH_FILE_VARIABLE | awk -F "=" '{print $2}' | sed -e 's/^"//g' -e 's/"$//g'
}

check_action()
{
  echo "check action selected"
  echo "ACTION $ACTION"
  if [ "${ACTION}" != "DESTROY" ]; then
     echo "Not destroying action, exit"
     exit 0
  fi
}

get_workspace_variables()
{
   echo "get workspace variables start: `date +%F-%T`"

   export RDS_IDENTIFIER_KPI=$(get_workspace_variable_command "rds_identifier-kpi")
   echo "rds_identifier-kpi: ${RDS_IDENTIFIER_KPI}"

   export RDS_IDENTIFIER_IDP=$(get_workspace_variable_command "rds_identifier-idp")
   echo "rds_identifier-idp: ${RDS_IDENTIFIER_IDP}"

   export ENV_WORKSPACE_NAME=$(get_workspace_variable_command "workspace_name")
   echo "workspace_name: ${ENV_WORKSPACE_NAME}"

  echo "get workspace variables end: `date +%F-%T`"
}

check_status()
{
echo "check workspace status start: `date +%F-%T`"

DATE=$(date +%Y)
sleep 5

echo "Launching destroy"
get_workspace_variables; sleep 3
destroy_backup_vault_snaps_kpi
destroy_backup_vault_snaps_idp

echo "check workspace status stop: `date +%F-%T`"
}

destroy_backup_vault_snaps_kpi()
{
echo "destroy_backup_vault_snaps_kpi start: `date +%F-%T`"

echo "VAULT : ${ENV_WORKSPACE_NAME}_kpi"
for ARN in $(aws backup list-recovery-points-by-backup-vault --backup-vault-name ${ENV_WORKSPACE_NAME}_kpi --query 'RecoveryPoints[].RecoveryPointArn' --output text --region ${AWS_DEFAULT_REGION}); do
  echo "deleting ${ARN} ..."
  aws backup delete-recovery-point --backup-vault-name "${ENV_WORKSPACE_NAME}_kpi" --recovery-point-arn "${ARN}" --region "${AWS_DEFAULT_REGION}"
  sleep 10
done

echo "destroy_backup_vault_snaps_kpi stop: `date +%F-%T`"
}

destroy_backup_vault_snaps_idp()
{
echo "destroy_backup_vault_snaps_idp start: `date +%F-%T`"

echo "VAULT : ${ENV_WORKSPACE_NAME}_idp"
for ARN in $(aws backup list-recovery-points-by-backup-vault --backup-vault-name ${ENV_WORKSPACE_NAME}_idp --query 'RecoveryPoints[].RecoveryPointArn' --output text --region ${AWS_DEFAULT_REGION}); do
  echo "deleting ${ARN} ..."
  aws backup delete-recovery-point --backup-vault-name "${ENV_WORKSPACE_NAME}_idp" --recovery-point-arn "${ARN}" --region "${AWS_DEFAULT_REGION}"
  sleep 10
done

echo "destroy_backup_vault_snaps_idp stop: `date +%F-%T`"
}

display_error()
# Displaying for error
# Arguments:
# MSG (string): error message
{
echo -e "\n\e[1;31m${MSG}\e[0m\n"
}

display_web_url(){
echo -e "oa-tenants-app PIPELINE WEB URL => \033[33;1;4;5;7m${WEB_URL}\033[0m\n" | sed -e 's/"//g'
}

############################
#       MAIN               #
############################
check_action
get_workspace_variables
check_status
