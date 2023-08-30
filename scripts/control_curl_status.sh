
#!/usr/bin/env bash

#chmod 0755 ./jq; cp ./jq /usr/bin/; jq --version
#####################################
#         Fonctions                 #
#####################################
usage()
{
cat << EO
    Usage: $PROGNAME [options]

    Options:
EO
cat <<EO | column -s\& -t

   -h|--help                  Print help
   -c|--curl_script_name      Specify
   -g|--gitlabpersonaltoken   Specify
   -i|--project_id            Specify
.
.
EO
}

display_error()
# Displaying for error
# Arguments:
# MSG (string): error message
{
echo -e "\n\e[1;31m${MSG}\e[0m\n"
}

display_web_url(){
echo -e "common-kube-app PIPELINE WEB URL => \033[33;1;4;5;7m${WEB_URL}\033[0m\n" | sed -e 's/"//g'
}

get_status()
{
PIPELINE_ID=`jq .id ${CURL_SCRIPT_NAME}.json`
echo "PIPELINE_ID: $PIPELINE_ID"
if [[ "$PIPELINE_ID" == "null" ]] || [[ "$PIPELINE_ID" == "" ]]; then
    MSG="The app pipeline has failed !: unable to get PIPELINE_ID"
    exit 1;
fi
STATUS_PIPELINE=$(curl --header "PRIVATE-TOKEN: ${GITLAB_PERSONAL_ACCESS_TOKEN}" "https://gitlab.ims.io/api/v4/projects/${PROJECT_ID}/pipelines/${PIPELINE_ID}" | jq .status | sed -e 's/"//g')
echo "STATUS_PIPELINE common-kube-app: ${STATUS_PIPELINE}"

WEB_URL=$(curl --header "PRIVATE-TOKEN: ${GITLAB_PERSONAL_ACCESS_TOKEN}" "https://gitlab.ims.io/api/v4/projects/${PROJECT_ID}/pipelines/${PIPELINE_ID}" | jq .web_url | sed -e 's/"//g')
display_web_url ${WEB_URL}
if [[ "$WEB_URL" == "null" ]] || [[ "$WEB_URL" == "" ]]; then
    MSG="The app pipeline has failed !: unable to get WEB_URL"
    display_error ${MSG}
    display_web_url ${WEB_URL}
    exit 1;
fi

while [[ ${STATUS_PIPELINE} == "pending" ]] || [[ ${STATUS_PIPELINE} == "running" ]] || [[ ${STATUS_PIPELINE} == "created" ]] || [[ ${STATUS_PIPELINE} == "waiting_for_resource" ]] || [[ ${STATUS_PIPELINE} == "preparing" ]]
do
    STATUS_PIPELINE=$(curl --header "PRIVATE-TOKEN: ${GITLAB_PERSONAL_ACCESS_TOKEN}" "https://gitlab.ims.io/api/v4/projects/${PROJECT_ID}/pipelines/${PIPELINE_ID}" | jq .status | sed -e 's/"//g')
    echo "STATUS_PIPELINE common-kube-app: `date +%F-%T` : ${STATUS_PIPELINE}"
    sleep 10
done

if [ "${STATUS_PIPELINE}" == "failed" ];then
    MSG="The common-kube-app pipeline has failed !"
    display_error ${MSG}
    display_web_url ${WEB_URL}
    echo ${MSG} > web_error.txt
    echo ${WEB_URL} > web_url.txt
    echo ${STATUS_PIPELINE} > statuspipeline.txt
    echo "1" > rc.txt
    exit 1
elif [ "${STATUS_PIPELINE}" == "null" ];then
    MSG="Check that: app version exist OR gitlab_pipeline_url and gitlab_token are correct OR branch name IS NOT equal to tag name"
    display_error ${MSG}
    echo ${MSG} > web_error.txt
    echo ${STATUS_PIPELINE} > statuspipeline.txt
    echo "1" > rc.txt
    exit 1
else
    echo -e "\nThe common-kube-app pipeline has succeded !\n"
    echo "${STATUS_PIPELINE}"
    display_web_url ${WEB_URL}
    echo ${WEB_URL} > web_url.txt
    echo ${STATUS_PIPELINE} > statuspipeline.txt
    echo "0" > rc.txt
fi

echo "check_status stop: `date +%F-%T`"

}

############################
#       MAIN               #
############################
if [ $# -eq 0 ];then
  usage
  exit 1
fi

PROGNAME=${0##*/}
SHORTOPTS="hc:g:i:"
LONGOPTS="help,curl_script_name:,gitlabpersonaltoken:,project_id:"

ARGS=$(getopt -s bash --options $SHORTOPTS  --longoptions $LONGOPTS --name $PROGNAME -- "$@" )
eval set -- "$ARGS"

while true; do
  case $1 in
    -h|--help)
      usage
      exit 0
      ;;
    -c|--curl_script_name)
         CURL_SCRIPT_NAME=$2;
         shift 2
      ;;
    -g|--gitlabpersonaltoken)
         GITLAB_PERSONAL_ACCESS_TOKEN=$2;
         shift 2
      ;;
    -i|--project_id)
         PROJECT_ID=$2;
         shift 2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    --) shift ; break ;;
    *) echo "Internal error!, Contact Support" ; exit 1 ;;
  esac
done

get_status
