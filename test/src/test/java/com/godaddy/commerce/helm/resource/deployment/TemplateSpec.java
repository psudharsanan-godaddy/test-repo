package com.godaddy.commerce.helm.resource.deployment;

import java.util.List;
import lombok.Data;

@Data
public class TemplateSpec {

  private Affinity affinity;
  private List<Container> containers;
  private long terminationGracePeriodSeconds;
  private List<Volume> volumes;

}
