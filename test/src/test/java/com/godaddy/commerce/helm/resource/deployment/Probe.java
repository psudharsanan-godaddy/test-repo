package com.godaddy.commerce.helm.resource.deployment;

import lombok.Data;

@Data
public class Probe {

  private HTTPGet httpGet;
  private long initialDelaySeconds;
  private long periodSeconds;
  private long timeoutSeconds;
  private long successThreshold;
  private long failureThreshold;

}
