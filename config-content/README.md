# config-content

This folder is for storing the actual content of the config files.

There are 2 sub-folders under this folder:

## base

For storing application-framework-type-specific config **base templates**. They serve as department engineering standards so changes to anything under this folder will need to be approved by the @ecpinfra team.

The currently supported application framework types are:

- nodejs
- spring-boot
- standard
- vertx

Note that `standard` contains config templates that can be shared across different application framework types.

### <application-framework-type>

All the files here should have `.<originalExtension>.tpl` as the file extension, e.g. `.yaml.tpl`.

The files here are used as _Helm templates_ and that is why `.tpl` is added as a suffix to distinguish them from regular config files. Having them as Helm templates allows us to perform variable substitutions and toggling sections conditionally.

Note that YAML is the recommended format for defining new type of config files because it makes templatizing much easier than using of JSON. A YAML file can be converted to a JSON one prior to being sent to Kubernetes as Secrets or ConfigMaps.

The base templates supports 2 ways of customizations:

- By providing Helm values, e.g. setting `.Values.configs.standard.auth.roles.super.defaultRoutes.enabled` to false in the Helm values file will effectively exclude the default routes of the super role in an auth config file. The conditionals are implemented as part of the base templates.
- By providing app-specific _blocks_ of _placeholders_, the base templates defined here contains _"placeholders"_ that will later be inserted with customized values on an app by app basis. The below section will elaborate this in details.

If additional _"placeholders"_ are needed for further customizing the base templates, feel free to submit PRs to make the changes.

## app-specific

As opposed to the files under `base`, this folder is for storing application-framework-type-specific and application-specific config customizations, changes to anything under this folder will **NOT** need to be approved by the @ecpinfra team.

As mentioned in the above section, inside a `.tpl` file, there are occurrences of _"placeholders"_ like `include "commerce-app-v2.appSpecificConfigBlock" (merge (dict "configType" "auth" "blockName" "roles/additional-read-role-routes")`. The above code will load, populate and render the _"block"_ template defined at `config-content/app-specific/standard/currency-exchange/auth/roles/additional-read-role-routes.tpl` following the naming convention. This allows developers to customize the _base templates_ based on the needs of each application. Refer to the definition of `commerce-app-v2.appSpecificConfigBlock` in `templates/_helpers.tpl` for implementation details.
