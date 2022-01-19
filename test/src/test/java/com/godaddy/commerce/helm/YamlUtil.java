package com.godaddy.commerce.helm;

import com.godaddy.commerce.helm.resource.DeploymentResource;
import com.godaddy.commerce.helm.resource.SecretResource;
import java.util.HashMap;
import java.util.Map;
import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.LoaderOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;
import org.yaml.snakeyaml.representer.Representer;
import org.yaml.snakeyaml.resolver.Resolver;

public final class YamlUtil {

  private YamlUtil() {
    throw new UnsupportedOperationException("Forbidden");
  }

  public static Yaml buildYamlLoader() {
    LoaderOptions loaderOptions = new LoaderOptions();
    loaderOptions.setProcessComments(true);
    Representer representer = new Representer();
    representer.getPropertyUtils().setSkipMissingProperties(true);
    return new Yaml(new Constructor(),
        representer,
        new DumperOptions(),
        loaderOptions,
        new Resolver());
  }

  public static Map<String, SecretResource> readSecretResources(
      Yaml yamlLoader,
      String[] resources) {

    Map<String, SecretResource> secrets = new HashMap<>();
    for (String resource : resources) {
      if (resource.contains("kind: Secret")) {
        SecretResource secret = yamlLoader.loadAs(resource, SecretResource.class);
        secrets.put(secret.getMetadata().getName(), secret);
      }
    }
    return secrets;
  }


  public static Map<String, DeploymentResource> readDeploymentResources(
      Yaml yamlLoader,
      String[] resources) {
    Map<String, DeploymentResource> deployments = new HashMap<>();
    for (String resource : resources) {
      if (resource.contains("kind: Deployment")) {
        DeploymentResource secret = yamlLoader.loadAs(resource, DeploymentResource.class);
        deployments.put(secret.getMetadata().getName(), secret);
      }
    }
    return deployments;
  }

}
