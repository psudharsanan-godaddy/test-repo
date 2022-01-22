package com.godaddy.commerce.helm.resource;

import com.godaddy.commerce.helm.resource.configmap.ConfigMapResource;
import com.godaddy.commerce.helm.resource.deployment.DeploymentResource;
import com.godaddy.commerce.helm.resource.externalsecret.ExternalSecretResource;
import com.godaddy.commerce.helm.resource.secret.SecretResource;
import java.util.Map;
import java.util.function.Predicate;
import lombok.Data;

@Data
public abstract class Resource {

  private static final Map<Class<?>, Predicate<String>> RESOURCE_MATCH_MAPPING =
      Map.of(
          DeploymentResource.class, s -> s.contains("kind: Deployment"),
          SecretResource.class, s -> s.contains("kind: Secret"),
          ConfigMapResource.class, s -> s.contains("kind: ConfigMap"),
          ExternalSecretResource.class, s -> s.contains("kind: ExternalSecret"));

  protected Metadata metadata;
  protected String apiVersion;
  protected String kind;

  public static <T extends Resource> Predicate<String> getMatchCondition(Class<T> resourceClass) {
    return RESOURCE_MATCH_MAPPING.getOrDefault(resourceClass, (s) -> false);
  }

}
