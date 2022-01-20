package com.godaddy.commerce.helm;

import com.godaddy.commerce.helm.resource.Resource;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Predicate;
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

  public static <T extends Resource> Map<String, T> readResources(
      Yaml yamlLoader,
      String[] resources, Class<T> targetResource) {
    Predicate<String> matchCondition = Resource.getMatchCondition(targetResource);
    Map<String, T> matchedResources = new HashMap<>();
    for (String resource : resources) {
      if (matchCondition.test(resource)) {
        T matchedResource = yamlLoader.loadAs(resource, targetResource);
        matchedResources.put(matchedResource.getMetadata().getName(), matchedResource);
      }
    }
    return matchedResources;
  }


}
