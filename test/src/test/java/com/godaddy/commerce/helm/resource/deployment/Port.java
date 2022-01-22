package com.godaddy.commerce.helm.resource.deployment;

import lombok.Data;

@Data
public class Port {

  private long containerPort;
  private String protocol;

}
