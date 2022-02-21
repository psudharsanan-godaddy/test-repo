# templates

This folder contains the actual Kubernetes resource definitions of the Helm chart in the Helm template format.

Sub-folders of this are used to categorize the template files.

## configs

This sub-folder contains application-framework-type-specific config Kubernetes resource templates. The actual content of each resource template is usually loaded using the `commerce-app-v2.configFileContent` helper function which loads, populates and renders the config content templates defined at `config-content/` following a naming convention (details covered [here](../config-content/README.md)).

The principles followed here are:

- Use Kubernetes `Secret`s for existing or sensitive config files for backward compatibility
- Use `ExternalSecret`s for configs that need to be populated with values defined in ASM or SSM
- Use Kubernetes `ConfigMap`s for new non-sensitive configs

## deployment

This sub-folder contains application-framework-type-specific deployment Kubernetes resource templates.

## job

This sub-folder contains application-framework-type-specific job Kubernetes resource templates.

## _helpers.tpl

This file contains re-usable helper functions used throughout this Helm chart.

## _spring-boot.tpl

This file contains re-usable helper functions used specifically for Spring Boot applications.

## _standard.tpl

This file contains re-usable helper functions used for all applications.

## _vertx.tpl

This file contains re-usable helper functions used specifically for Vert.x applications.
