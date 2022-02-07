package com.godaddy.commerce.helm.resource.deployment;

import java.util.Map;
import lombok.Data;

@Data
public class Affinity {

  private Map<String, Object> podAntiAffinity;
}
