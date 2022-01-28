package com.godaddy.commerce.helm;

import com.godaddy.commerce.helm.resource.configmap.ConfigMapResource;
import com.godaddy.commerce.helm.resource.deployment.DeploymentResource;
import com.godaddy.commerce.helm.resource.externalsecret.ExternalSecretResource;
import com.godaddy.commerce.helm.resource.secret.SecretResource;
import java.util.Map;

public enum AssertType implements ResourceAssertion {

  STANDARD_APP {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardAppConfig(secrets, deployment);
    }
  },

  STANDARD_AUTH {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardAuthConfig(secrets, deployment);
    }
  },

  STANDARD_PROMETHEUS {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardPrometheusConfig(secrets, deployment);
    }
  },

  STANDARD_LOG {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardLogConfig(configMaps, deployment);
    }
  },

  STANDARD_DB {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardDbConfig(externalSecrets, deployment);
    }
  },

  STANDARD_CLASSIC_DB {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardClassicDbConfig(externalSecrets, deployment);
    }
  },

  STANDARD_CRYPTO {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardCryptoConfig(externalSecrets, deployment);
    }
  },

  STANDARD_CLIENT_CERT {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardClientCertConfig(externalSecrets, deployment);
    }
  },

  STANDARD_CLIENT_CERT_CONTEXT {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardClientCertContextConfig(externalSecrets, deployment);
    }
  },

  STANDARD_HOSTS {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardHostsConfig(externalSecrets, deployment);
    }
  },

  STANDARD_SENSITIVE {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardSensitiveConfig(externalSecrets, deployment);
    }
  },

  STANDARD_TLS {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardTlsConfig(externalSecrets, deployment);
    }
  },

  STANDARD_CA_CERTS {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardCaCertsConfig(externalSecrets, deployment);
    }
  },

  STANDARD_STORE_KEYS {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertStandardStoreKeysConfig(externalSecrets, deployment);
    }
  },

  SPRING_BOOT_LOG {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertSpringBootLogConfig(configMaps, deployment);
    }
  },

  SPRING_BOOT_APPLICATION {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertSpringBootApplicationConfig(secrets, deployment);
    }
  },

  VERTX_OPTIONS {
    @Override
    public void executeAssertion(BaseTest baseTestInstance, Map<String, SecretResource> secrets,
        Map<String, ExternalSecretResource> externalSecrets,
        Map<String, ConfigMapResource> configMaps, DeploymentResource deployment) {
      baseTestInstance.assertVertxOptionsConfig(secrets, deployment);
    }
  }
}
