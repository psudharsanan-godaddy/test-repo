package com.godaddy.commerce.helm.framework;

import static com.godaddy.commerce.helm.AssertType.SPRING_BOOT_APPLICATION;
import static com.godaddy.commerce.helm.AssertType.SPRING_BOOT_LOG;
import static com.godaddy.commerce.helm.AssertType.STANDARD_APP;
import static com.godaddy.commerce.helm.AssertType.STANDARD_AUTH;
import static com.godaddy.commerce.helm.AssertType.STANDARD_CA_CERTS;
import static com.godaddy.commerce.helm.AssertType.STANDARD_CLIENT_CERT;
import static com.godaddy.commerce.helm.AssertType.STANDARD_CLIENT_CERT_CONTEXT;
import static com.godaddy.commerce.helm.AssertType.STANDARD_HOSTS;
import static com.godaddy.commerce.helm.AssertType.STANDARD_PROMETHEUS;
import static com.godaddy.commerce.helm.AssertType.STANDARD_SENSITIVE;
import static com.godaddy.commerce.helm.AssertType.STANDARD_TLS;
import static com.godaddy.commerce.helm.AssertType.VERTX_OPTIONS;
import static com.godaddy.commerce.helm.AssertType.WRITABLE_DIRECTORY;

import com.godaddy.commerce.helm.BaseTest;
import com.godaddy.commerce.helm.HelmRunner;
import com.godaddy.commerce.helm.YamlUtil;
import com.godaddy.commerce.helm.resource.deployment.Env;
import org.junit.jupiter.api.Test;
import org.yaml.snakeyaml.Yaml;

public class NodejsYamlTest extends BaseTest {

  private static final Yaml yamlLoader = YamlUtil.buildYamlLoader();
  private static final String TEST_APP_NAME = "case_nodejs_standard";
  private static final String TEST_APP_VALUES_FOLDER =
      "/test/src/test/resources/framework-test-apps/";

  @Override
  protected Yaml getYamlLoader() {
    return yamlLoader;
  }

  @Override
  protected String getAppName() {
    return TEST_APP_NAME;
  }

  @Test
  void test_nodejsAndStandard() {
    // Given When
    String[] generatedResources = HelmRunner.builder()
        .app(TEST_APP_NAME)
        .env("dp")
        .appValuesFolder(TEST_APP_VALUES_FOLDER)
        .imageTag("1.1.1")
        .build()
        .run()
        .getGeneratedResources();

    // Then
    assertContainsAllOf(generatedResources,
        STANDARD_APP,
        STANDARD_AUTH,
        STANDARD_PROMETHEUS,
        STANDARD_CLIENT_CERT,
        STANDARD_CLIENT_CERT_CONTEXT,
        STANDARD_HOSTS,
        STANDARD_SENSITIVE,
        STANDARD_TLS,
        STANDARD_CA_CERTS,
        WRITABLE_DIRECTORY);

    assertContainsNoneOf(generatedResources,
        VERTX_OPTIONS,
        SPRING_BOOT_APPLICATION,
        SPRING_BOOT_LOG);

    assertContainsAllEnvsOf(generatedResources,
        Env.of("AWS_REGION", "us-east-1"),
        Env.of("APP_VERSION", "1.1.1"),
        Env.of("APP_NAME", TEST_APP_NAME),
        Env.of("MOUNT_PATH", "/tmp"),
        Env.of("NODE_ENV", "development")
    );
  }

}
