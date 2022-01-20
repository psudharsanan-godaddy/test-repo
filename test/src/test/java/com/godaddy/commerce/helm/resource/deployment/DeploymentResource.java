package com.godaddy.commerce.helm.resource.deployment;

import com.godaddy.commerce.helm.resource.Resource;
import java.util.List;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class DeploymentResource extends Resource {

  private DeploymentSpec spec;

  public List<Volume> getVolumes() {
    return getSpec().getTemplate().getSpec().getVolumes();
  }

  public List<VolumeMount> getVolumeMounts() {
    return getSpec().getTemplate().getSpec().getContainers().get(0).getVolumeMounts();
  }

  public List<Env> getEnvs() {
    return getSpec().getTemplate().getSpec().getContainers().get(0).getEnv();
  }

}


