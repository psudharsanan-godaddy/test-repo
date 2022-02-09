# values

This folder holds all the static Helm values files. There are 2 sub-folders under this one:

- `base`, contains default values files, changes to files under this folder require approvals from the @ecpinfra team
- `app-specific`, contains app-specific override values files, changes to files under this folder do **NOT** require approvals from the @ecpinfra team
- `protected-base`, contains protected values files that should not be overridden by `app-specific` ones for most of the time, changes to files under this folder require approvals from the @ecpinfra team
- `protected-app-specific`, contains protected app-specific values files which are used for overriding values in `protected-base` as exceptions, changes to files under this folder require approvals from the @ecpinfra team

The following values files are stacked during a Helm deployment. Most of the files below are optional, when they are present, they will be picked up. Here is the stacking sequence:

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
- protected-base/cp.yaml
- protected-base/cp.$ENV.yaml
- protected-base/cp.$ENV.$ACCOUNT_TYPE.yaml
- protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.yaml
- protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$ENV_TYPE.yaml
- protected-base/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$ENV_TYPE.$CLUSTER_SIDE.yaml
- protected-app-specific/$APP_NAME/cp.yaml
- protected-app-specific/$APP_NAME/cp.$ENV.yaml
- protected-app-specific/$APP_NAME/cp.$ENV.$ACCOUNT_TYPE.yaml
- protected-app-specific/$APP_NAME/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.yaml
- protected-app-specific/$APP_NAME/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$ENV_TYPE.yaml
- protected-app-specific/$APP_NAME/cp.$ENV.$ACCOUNT_TYPE.$AWS_REGION.$ENV_TYPE.$CLUSTER_SIDE.yaml

Note that more specific values files will override less specific ones; `protected-app-specific` ones override those under `protected-base`; `protected-base` ones override those under `app-specific`; `app-specific` ones override those under `base`.
