# this scrip is not meant to be run automatically it is supposed to be reference for commands to copy paste based on choice
# Greenfield Deployment
# migrating an existing 
# Small
# pod for app
# pod for db
# ebs for storage
# ssl for endpoint
# create document amangement system
# Cert
export CERT="arn:aws:acm:us-west-1:393856860140:certificate/2a918285-5d0d-4773-b05d-2ec837d811ee"
kubectl apply -f docker-internal-networkpolicy.yaml
kubectl apply -f internet-networkpolicy.yaml
kubectl apply -f docs-persistentvolumeclaim.yaml
kubectl apply -f teedy-db-claim0-persistentvolumeclaim.yaml
kubectl apply -f teedy-db-deployment_withInit.yaml
kubectl apply -f teedy-db-service.yaml
kubectl apply -f teedy-server-deployment.yaml
envsubst < ssl-service.yaml | kubectl apply -f -
# End of Creation
# delete document management system
# Cert and RDSEND
export CERT="arn:aws:acm:us-west-1:393856860140:certificate/2a918285-5d0d-4773-b05d-2ec837d811ee"

kubectl delete -f docker-internal-networkpolicy.yaml
kubectl delete -f internet-networkpolicy.yaml
envsubst < ssl-service.yaml | kubectl apply -f -
kubectl delete -f teedy-db-service.yaml
kubectl delete -f teedy-server-deployment.yaml
kubectl delete -f teedy-db-deployment_withInit.yaml
kubectl delete -f docs-persistentvolumeclaim.yaml
kubectl delete -f teedy-db-claim0-persistentvolumeclaim.yaml
# End of Deletion
##############################################################
# meduim
# create document amangement system
# pre-requist to have RDS for Postgres
export CERT="arn:aws:acm:us-west-1:393856860140:certificate/2a918285-5d0d-4773-b05d-2ec837d811ee"
export RDSEND=`aws rds describe-db-instances --db-instance-identifier tmed  --output text | grep ENDPOINT | cut -f 2`
kubectl apply -f docs-persistentvolumeclaim.yaml
envsubst < teedy-server-deployment.yaml   | kubectl apply -f -
envsubst < ssl-service.yaml               | kubectl apply -f -
# End of Creation

# delete document management system
envsubst < ssl-service.yaml               | kubectl delete -f -
envsubst < teedy-server-deployment.yaml   | kubectl delete -f -
kubectl delete -f docs-persistentvolumeclaim.yaml
# End of Deletion
######################################################################
# Large
# create document amangement system
# pre-requist to have RDS for Postgres and EFS for storage
export CERT="arn:aws:acm:us-west-1:393856860140:certificate/2a918285-5d0d-4773-b05d-2ec837d811ee"
export RDSEND=`aws rds describe-db-instances --db-instance-identifier tmed  --output text | grep ENDPOINT | cut -f 2`
export EFS=`aws efs describe-file-systems --query "FileSystems[*].{FileSystemID:FileSystemId, Name:Name, SizeinBytes: SizeInBytes.Value}| []|reverse(sort_by(@, &SizeinBytes))"  --output text |grep tmed |cut -f 1`

envsubst < docs-persistentvolumeclaim.yaml | kubectl apply -f -
envsubst < teedy-server-deployment.yaml    | kubectl apply -f -
envsubst < ssl-service.yaml                | kubectl apply -f -
# End of Creation

# delete document management system
envsubst < ssl-service.yaml                | kubectl delete -f -
envsubst < teedy-server-deployment.yaml    | kubectl delete -f -
envsubst < docs-persistentvolumeclaim.yaml | kubectl delete -f -

# End of Deletion




