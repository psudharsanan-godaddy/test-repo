# values

This folder holds all the static Helm values files. There are 2 sub-folders under this one:

- `base`, contains default values files, changes to files under this folder require approvals from the @ecpinfra team
- `app-specific`, contains app-specific override values files, changes to files under this folder do **NOT** require approvals from the @ecpinfra team

The values files are stacked during a Helm deployment and here is the stacking sequence:

- base/cp.yaml
- base/cp.$ENV.yaml
- base/cp.$ENV.$ACCOUNT_TYPE.yaml
- base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.yaml
- base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$ENV_TYPE.yaml
- base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$ENV_TYPE.$CLUSTER_SIDE.yaml
- app-specific/$APP_NAME/cp.yaml
- app-specific/$APP_NAME/cp.$ENV.yaml
- app-specific/$APP_NAME/cp.$ENV.$ACCOUNT_TYPE.yaml
- app-specific/$APP_NAME/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.yaml
- app-specific/$APP_NAME/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$ENV_TYPE.yaml
- app-specific/$APP_NAME/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$ENV_TYPE.$CLUSTER_SIDE.yaml

Note that the latter files will override the previous ones and app-specific values files are optional.
