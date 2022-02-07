package com.godaddy.commerce.helm.resource.deployment;

import lombok.Data;

@Data
public class DeploymentResources {

  private Limits requests;
  private Limits limits;

}
