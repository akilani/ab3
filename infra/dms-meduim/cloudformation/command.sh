aws cloudformation deploy \
    --template-file efs.yaml \
    --stack-name teedy-meduim-stack \
    --tags file://tags.json \
    --region "us-west-1" \
    --parameter-overrides file://params.json
