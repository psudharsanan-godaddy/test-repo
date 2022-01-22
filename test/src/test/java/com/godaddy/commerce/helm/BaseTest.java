package com.godaddy.commerce.helm;

import static org.assertj.core.api.Assertions.assertThat;

import com.godaddy.commerce.helm.resource.configmap.ConfigMapResource;
import com.godaddy.commerce.helm.resource.deployment.DeploymentResource;
import com.godaddy.commerce.helm.resource.deployment.Env;
import com.godaddy.commerce.helm.resource.deployment.Volume;
import com.godaddy.commerce.helm.resource.deployment.VolumeMount;
import com.godaddy.commerce.helm.resource.externalsecret.ExternalSecretResource;
import com.godaddy.commerce.helm.resource.secret.SecretResource;
import java.util.Map;
import org.yaml.snakeyaml.Yaml;

public abstract class BaseTest {

  protected abstract Yaml getYamlLoader();

  protected abstract String getAppName();

  protected String getBaseMountPath() {
    return "/tmp";
  }

  protected String withAppPrefix(String value) {
    return getAppName() + "-" + value;
  }

  protected Map<String, ConfigMapResource> getConfigMaps(String[] generatedResources) {
    return YamlUtil.readResources(
        getYamlLoader(),
        generatedResources,
        ConfigMapResource.class);
  }

  protected Map<String, ExternalSecretResource> getExternalSecrets(String[] generatedResources) {
    return YamlUtil.readResources(
        getYamlLoader(),
        generatedResources,
        ExternalSecretResource.class);
  }

  protected Map<String, DeploymentResource> getDeployments(String[] generatedResources) {
    return YamlUtil.readResources(
        getYamlLoader(),
        generatedResources,
        DeploymentResource.class);
  }

  protected Map<String, SecretResource> getSecrets(String[] generatedResources) {
    return YamlUtil.readResources(
        getYamlLoader(),
        generatedResources,
        SecretResource.class);
  }

  protected void assertContainsAllOf(String[] generatedResources, AssertType... assertTypes) {
    Map<String, SecretResource> secrets = getSecrets(generatedResources);
    Map<String, ExternalSecretResource> externalSecrets = getExternalSecrets(generatedResources);
    Map<String, ConfigMapResource> configMaps = getConfigMaps(generatedResources);
    Map<String, DeploymentResource> deployments = getDeployments(generatedResources);
    assertThat(deployments).containsKey(withAppPrefix("deployment-test"));
    DeploymentResource deployment = deployments.get(withAppPrefix("deployment-test"));
    for (AssertType assertType : assertTypes) {
      try {
        assertType.executeAssertion(this, secrets, externalSecrets, configMaps, deployment);
      } catch (AssertionError e) {
        throw new AssertionError("Failure during assertion of " + assertType, e);
      }
    }
  }

  protected void assertStandardAppConfig(Map<String, SecretResource> secrets,
      DeploymentResource deployment) {

    assertThat(secrets).containsKey(withAppPrefix("app-config-test"));

    assertThat(secrets.get(withAppPrefix("app-config-test")).getData()).containsKey("config.json");

    assertThat(deployment.getVolumes())
        .contains(Volume.secretVolume("app-config-secret", withAppPrefix("app-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("app-config-secret", getBaseMountPath() + "/app"));

    assertThat(deployment.getEnvs()).contains(Env.of("CONFIG_PATH", getBaseMountPath() + "/app"));
  }

  protected void assertStandardAuthConfig(Map<String, SecretResource> secrets,
      DeploymentResource deployment) {

    assertThat(secrets).containsKey(withAppPrefix("auth-config-test"));

    assertThat(secrets.get(withAppPrefix("auth-config-test")).getData())
        .containsKey("auth-config.json");

    assertThat(deployment.getVolumes())
        .contains(Volume.secretVolume("auth-config-secret", withAppPrefix("auth-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("auth-config-secret", getBaseMountPath() + "/auth"));
  }

  protected void assertStandardPrometheusConfig(Map<String, SecretResource> secrets,
      DeploymentResource deployment) {

    assertThat(secrets).containsKey(withAppPrefix("prometheus-config-test"));

    assertThat(secrets.get(withAppPrefix("prometheus-config-test")).getData())
        .containsKey("prometheus_agent.yaml");

    assertThat(deployment.getVolumes())
        .contains(Volume.secretVolume("prometheus-config-secret",
            withAppPrefix("prometheus-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("prometheus-config-secret", getBaseMountPath() + "/prometheus"));
  }

  protected void assertStandardDbConfig(Map<String, ExternalSecretResource> externalSecrets,
      DeploymentResource deployment) {

    assertThat(externalSecrets).containsKey(withAppPrefix("db-config-test"));

    assertThat(deployment.getVolumes())
        .contains(Volume.secretVolume("db-config-secret", withAppPrefix("db-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("db-config-secret", getBaseMountPath() + "/db"));
  }

  protected void assertStandardClassicDbConfig(Map<String, ExternalSecretResource> externalSecrets,
      DeploymentResource deployment) {

    assertThat(externalSecrets).containsKey(withAppPrefix("classic-db-configexternal-test"));

    assertThat(deployment.getVolumes()).contains(Volume.secretVolume("classic-db-config",
        withAppPrefix("classic-db-configexternal-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("classic-db-config", getBaseMountPath() + "/classic-db"));
  }

  protected void assertStandardCryptoConfig(Map<String, ExternalSecretResource> externalSecrets,
      DeploymentResource deployment) {

    assertThat(externalSecrets).containsKey(withAppPrefix("crypto-config-test"));

    assertThat(deployment.getVolumes())
        .contains(Volume.secretVolume("crypto-config-secret", withAppPrefix("crypto-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("crypto-config-secret", getBaseMountPath() + "/crypto"));
  }

  protected void assertStandardLogConfig(Map<String, ConfigMapResource> configMaps,
      DeploymentResource deployment) {

    assertThat(configMaps).containsKey(withAppPrefix("log-config-test"));

    assertThat(configMaps.get(withAppPrefix("log-config-test")).getData())
        .containsKey("log4j2.xml");

    assertThat(deployment.getVolumes())
        .contains(Volume.configMapVolume("log-config-configmap", withAppPrefix("log-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("log-config-configmap", getBaseMountPath() + "/logconfig"));
  }

  protected void assertStandardClientCertConfig(Map<String, ExternalSecretResource> externalSecrets,
      DeploymentResource deployment) {

    assertThat(deployment.getVolumes())
        .contains(Volume.secretVolume("client-cert-config-secret",
            withAppPrefix("client-cert-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("client-cert-config-secret", getBaseMountPath() + "/pki"));
  }

  protected void assertStandardClientCertContextConfig(
      Map<String, ExternalSecretResource> externalSecrets,
      DeploymentResource deployment) {

    assertThat(deployment.getVolumes())
        .contains(Volume.secretVolume("client-cert-context-secret",
            withAppPrefix("client-cert-context-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("client-cert-context-secret", getBaseMountPath() + "/pki-context"));
  }

  protected void assertStandardHostsConfig(Map<String, ExternalSecretResource> externalSecrets,
      DeploymentResource deployment) {

    assertThat(deployment.getVolumes())
        .contains(Volume.secretVolume("hosts-config-secret", withAppPrefix("hosts-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("hosts-config-secret", getBaseMountPath() + "/hosts"));
  }

  protected void assertStandardSensitiveConfig(Map<String, ExternalSecretResource> externalSecrets,
      DeploymentResource deployment) {

    assertThat(deployment.getVolumes()).contains(Volume.secretVolume("sensitive-config-secret",
        withAppPrefix("sensitive-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("sensitive-config-secret", getBaseMountPath() + "/sensitive"));
  }

  protected void assertStandardTlsConfig(Map<String, ExternalSecretResource> externalSecrets,
      DeploymentResource deployment) {

    assertThat(deployment.getVolumes())
        .contains(Volume.secretVolume("tls-config-secret", withAppPrefix("tls-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("tls-config-secret", getBaseMountPath() + "/tls"));
  }

  protected void assertStandardCaCertsConfig(Map<String, ExternalSecretResource> externalSecrets,
      DeploymentResource deployment) {

    assertThat(deployment.getVolumes()).contains(Volume.secretVolume(
        withAppPrefix("cacerts-test"), withAppPrefix("cacerts-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of(withAppPrefix("cacerts-test"), getBaseMountPath() + "/cacerts"));
    assertThat(deployment.getEnvs()).contains(Env.of("CACERTS", withAppPrefix("cacerts-test")));
  }

  protected void assertStandardStoreKeysConfig(Map<String, ExternalSecretResource> externalSecrets,
      DeploymentResource deployment) {

    assertThat(deployment.getVolumes()).contains(Volume.secretVolume(
        withAppPrefix("storekeys-test"), withAppPrefix("storekeys-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of(withAppPrefix("storekeys-test"), getBaseMountPath() + "/storekeys"));
    assertThat(deployment.getEnvs()).contains(Env.of("STOREKEYS", withAppPrefix("storekeys-test")));
  }

  protected void assertStandardWildcardConfig(Map<String, ExternalSecretResource> externalSecrets,
      DeploymentResource deployment) {
    assertThat(deployment.getVolumes()).contains(Volume.secretVolume("wildcard-cert",
        withAppPrefix("wildcard-cert-test")));
  }

  protected void assertSpringBootLogConfig(Map<String, ConfigMapResource> configMaps,
      DeploymentResource deployment) {

    assertThat(configMaps).containsKey(withAppPrefix("spring-boot-logging-config-test"));

    assertThat(configMaps.get(withAppPrefix("spring-boot-logging-config-test")).getData())
        .containsKey("logback-spring.xml");

    assertThat(deployment.getVolumes())
        .contains(Volume.configMapVolume("spring-boot-logging-config-configmap",
            withAppPrefix("spring-boot-logging-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("spring-boot-logging-config-configmap",
            getBaseMountPath() + "/spring-boot-logging-config"));

    assertThat(deployment.getEnvs()).contains(
        Env.of("LOGGING_CONFIG",
            getBaseMountPath() + "/spring-boot-logging-config/logback-spring.xml"));
  }

  protected void assertSpringBootApplicationConfig(Map<String, SecretResource> secrets,
      DeploymentResource deployment) {
    assertThat(secrets).containsKey(withAppPrefix("spring-boot-application-config-test"));

    assertThat(secrets.get(withAppPrefix("spring-boot-application-config-test")).getData())
        .containsKey("application.yaml");

    assertThat(deployment.getVolumes())
        .contains(Volume.secretVolume("spring-boot-application-config-secret",
            withAppPrefix("spring-boot-application-config-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("spring-boot-application-config-secret",
            getBaseMountPath() + "/spring-boot-application-config"));

    assertThat(deployment.getEnvs()).contains(
        Env.of("SPRING_CONFIG_ADDITIONAL_LOCATION",
            getBaseMountPath() + "/spring-boot-application-config/"));
  }


  protected void assertVertxOptionsConfig(Map<String, SecretResource> secrets,
      DeploymentResource deployment) {
    assertThat(secrets).containsKey(withAppPrefix("vertx-options-test"));

    assertThat(secrets.get(withAppPrefix("vertx-options-test")).getData())
        .containsKey("config.json");

    assertThat(deployment.getVolumes())
        .contains(Volume.secretVolume("vertx-options-secret",
            withAppPrefix("vertx-options-test")));

    assertThat(deployment.getVolumeMounts()).contains(
        VolumeMount.of("vertx-options-secret",
            getBaseMountPath() + "/vertx-options"));
  }


}
