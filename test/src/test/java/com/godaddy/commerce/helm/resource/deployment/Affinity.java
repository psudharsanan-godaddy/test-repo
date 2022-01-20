package com.godaddy.commerce.helm.resource.deployment;

import java.util.Map;
import javax.management.monitor.StringMonitor;
import lombok.Data;

@Data
public class Affinity {

  private Map<String, Object> podAntiAffinity;
}
