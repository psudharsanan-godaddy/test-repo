package com.godaddy.commerce.helm.resource.deployment;

import lombok.Data;

@Data
public class DeploymentSpec {

  private long replicas;
  private long revisionHistoryLimit;
  private Selector selector;
  private DeploymentTemplate template;

}
