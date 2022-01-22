package com.godaddy.commerce.helm.resource.deployment;

import lombok.Data;

@Data
public class Selector {

  private ConfigMapVolume matchLabels;

}
