#!/bin/bash
set -e
SCRIPTS_PATH="."
source "config/scripts/ci/notificationutil.sh"
source "config/scripts/ci/globalutil.sh"
source "config/scripts/ci/deployutil.sh"
source "config/scripts/ci/packageutil.sh"

function create() {
    SOURCEPATH="sales"
    PACKAGE="salesforce-global-sales"
    DEFINITIONFILE="config/scratch-org-config/project-scratch-def.json"
    COMMITTAG="97262a8"
    TARGETDEVHUBUSERNAME="sagedev"
    local CMD_CREATE="sfdx force:package:version:create --path=$SOURCEPATH --package=$PACKAGE \
        --tag=$COMMITTAG --targetdevhubusername=$TARGETDEVHUBUSERNAME \
        --definitionfile=$DEFINITIONFILE --codecoverage --installationkeybypass --json"
    echo "Initiating package creation.."
    echo $CMD_CREATE
    local RESP_CREATE=$(echo $($CMD_CREATE)) # create package and collect response
    echo $RESP_CREATE | jq
    handleSfdxResponse "$RESP_CREATE"
    local JOBID=$(echo $RESP_CREATE | jq -r ".result.Id")
    echo "Initilised with job id: $JOBID"
    CMD_REPORT="sfdx force:package:version:create:report --targetdevhubusername=$TARGETDEVHUBUSERNAME --packagecreaterequestid=$JOBID --json"
    echo $CMD_REPORT
    while true
    do
        RESP_REPORT=$(echo $($CMD_REPORT))
        echo $RESP_REPORT
        handleSfdxResponse "$RESP_REPORT"
        if [ "$(echo $RESP_REPORT | jq -r ".status")" = "1" ]
        then
            handleSfdxResponse "$RESP_REPORT"
            break
        else
            local REQ_STATUS=$(echo $RESP_REPORT | jq -r ".result[0].Status")
            if [ $REQ_STATUS = "Success" ]
            then
                sendNotification --statuscode "0" \
                    --message "Package creation successful" \
                    --details "New beta version of $VERSIONNUMBER for $PACKAGE created successfully with following details. \n\r $(echo $RESPONSE_REPORT | jq -r ".result")"
                break
            else
                sleep 5
                echo "Request status $REQ_STATUS"
                RESP_REPORT=$($CMD_REPORT)
            fi
        fi
    done
}

function parseData() {
    jsonData
    echo $DATA | jq
    sendNotification --statuscode "0" \
                    --message "Package creation successful" \
                    --details "New beta version of $VERSIONNUMBER for $PACKAGE created successfully with following details.
                        <BR/><b>PackageId</b> - $(echo $DATA | jq -r ".result[0].Package2Id")
                        <BR/><b>Package2VersionId</b> - $(echo $DATA | jq -r ".result[0].Package2VersionId")
                        <BR/><b>SubscriberPackageVersionId</b> - $(echo $DATA | jq -r ".result[0].SubscriberPackageVersionId")
                        <BR/><b>CommitId</b> - $(echo $DATA | jq -r ".result[0].Tag")"
}

function jsonData() {
    DATA="{
        \"status\": 0,
        \"result\": [
            {
            \"Id\": \"08c4K0000004CsTQAU\",
            \"Status\": \"Success\",
            \"Package2Id\": \"0Ho4K0000004CFWSA2\",
            \"Package2VersionId\": \"05i4K0000004CYMQA2\",
            \"SubscriberPackageVersionId\": \"04t4K000002akhyQAA\",
            \"Tag\": null,
            \"Branch\": null,
            \"Error\": [],
            \"CreatedDate\": \"2021-07-02 09:57\",
            \"HasMetadataRemoved\": false
            }
        ]
        }"
}
#create
#parseData
# TARGETDEVHUBUSERNAME="sagegroup"
# deployPackage --targetusername "uat2" --instanceurl $INSTANCE

#git diff --name-only 1001cb1 550ac77
#git diff --name-only --ignore-submodules --diff-filter=AM 1001cb1 550ac77 | tee gitdiff
#git diff --name-only --ignore-submodules --diff-filter=AM 1001cb1 550ac77
# | tee gitdiff
#cat gitdiff
#rm gitdiff

#git diff --name-only --ignore-submodules --diff-filter=AM badfa67 54e53c1 *.field-meta.xml *.recordType-meta.xml

# VALUE=$(cat tempfile)
# echo $VALUE | jq
# PACKAGE_QUERY_FIELDS="Name, Package2Id, Tag, Package2.Name, SubscriberPackageVersion.Dependencies, IsReleased, MajorVersion, MinorVersion, PatchVersion, BuildNumber, CreatedDate, LastModifiedDate, AncestorId, Ancestor.MajorVersion, Ancestor.MinorVersion, Ancestor.PatchVersion"
# prepareQueryString "Package2Version" \
#     "$PACKAGE_QUERY_FIELDS" \
#     "Package2.Name = 'salesforce-global-sales'" \
#     "LastModifiedDate DESC, CreatedDate DESC"
# TARGETDEVHUBUSERNAME="sagegroup"
# queryLatestPackageVersionByName "salesforce-global-sales" | jq

# json='{ "status": 0, "result": { "username": "mukhija.bhupesh@gmail.com.pdtwosb", "orgId": "00D1t000000F83QEAS", "accessToken": "00D1t000000F83Q!AQcAQH83SJc6ep97cz3ajM5igiPnJdaZK2Bq1cMb17PeaE71LvMbFnbheXJBgiW_UhM5XD09HI23yN6nLiHTa09YspHNjfM5", "instanceUrl": "https://pdtwosb-dev-ed.my.salesforce.com", "loginUrl": "https://pdtwosb-dev-ed.my.salesforce.com", "refreshToken": "5Aep8610F.RUa2F48DDD4.zqhJzQ7FvXp0FTEcTSzweB1le46EBCrP9KDM6jDtFHGL7ZogxWghEI4j1mjRq6vvk", "clientId": "PlatformCLI", "clientSecret": "" } }'
# INSTANCE=$(echo $json | jq -r '.result.instanceUrl')
# echo $INSTANCE
# x='https://sagegroup--ecomm2dev.lightning.force.com/lightning/o/Lead/list?filterName=Recent'

# awk -F/ '{print $3}'
# MAIN_VERSION_DEVHUB=1.13.1
# VERSION_SFDX_JSON=2.13.1
# ARR_DH=${MAIN_VERSION_DEVHUB//"."/ }
# ARR_JSON=${VERSION_SFDX_JSON//"."/ }
# echo "&&&&&&&&&&&&&&&&&&&&&&&"
# echo ${ARR_DH}
# echo ${ARR_JSON}
# echo "&&&&&&&&&&&&&&&&&&&&&&&"
# isUpgrade $MAIN_VERSION_DEVHUB $VERSION_SFDX_JSON
