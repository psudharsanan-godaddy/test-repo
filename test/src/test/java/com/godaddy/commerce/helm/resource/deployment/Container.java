package com.godaddy.commerce.helm.resource.deployment;

import java.util.List;
import java.util.Map;
import lombok.Data;

@Data
public class Container {

  private String name;
  private Map<String, Object> lifecycle;
  private String image;
  private String imagePullPolicy;
  private List<VolumeMount> volumeMounts;
  private List<Port> ports;
  private SecurityContext securityContext;
  private Probe livenessProbe;
  private Probe readinessProbe;
  private DeploymentResources resources;
  private List<Env> env;

}
