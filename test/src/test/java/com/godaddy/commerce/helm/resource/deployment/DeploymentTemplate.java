package com.godaddy.commerce.helm.resource.deployment;

import lombok.Data;

@Data
public class DeploymentTemplate {

  private TemplateMetadata metadata;
  private TemplateSpec spec;

}
