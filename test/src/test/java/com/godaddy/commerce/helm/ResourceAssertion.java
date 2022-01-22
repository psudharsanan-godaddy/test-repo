package com.godaddy.commerce.helm;

import com.godaddy.commerce.helm.resource.configmap.ConfigMapResource;
import com.godaddy.commerce.helm.resource.deployment.DeploymentResource;
import com.godaddy.commerce.helm.resource.externalsecret.ExternalSecretResource;
import com.godaddy.commerce.helm.resource.secret.SecretResource;
import java.util.Map;

public interface ResourceAssertion {

  void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
      Map<String, ExternalSecretResource> externalSecrets,
      Map<String, ConfigMapResource> configMaps, DeploymentResource deployment);
}
