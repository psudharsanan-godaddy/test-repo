package com.godaddy.commerce.helm.framework;

import static com.godaddy.commerce.helm.AssertType.SPRING_BOOT_APPLICATION;
import static com.godaddy.commerce.helm.AssertType.SPRING_BOOT_LOG;
import static com.godaddy.commerce.helm.AssertType.STANDARD_APP;
import static com.godaddy.commerce.helm.AssertType.STANDARD_AUTH;
import static com.godaddy.commerce.helm.AssertType.STANDARD_CA_CERTS;
import static com.godaddy.commerce.helm.AssertType.STANDARD_CLASSIC_DB;
import static com.godaddy.commerce.helm.AssertType.STANDARD_CLIENT_CERT;
import static com.godaddy.commerce.helm.AssertType.STANDARD_CLIENT_CERT_CONTEXT;
import static com.godaddy.commerce.helm.AssertType.STANDARD_CRYPTO;
import static com.godaddy.commerce.helm.AssertType.STANDARD_DB;
import static com.godaddy.commerce.helm.AssertType.STANDARD_HOSTS;
import static com.godaddy.commerce.helm.AssertType.STANDARD_LOG;
import static com.godaddy.commerce.helm.AssertType.STANDARD_PROMETHEUS;
import static com.godaddy.commerce.helm.AssertType.STANDARD_SENSITIVE;
import static com.godaddy.commerce.helm.AssertType.STANDARD_STORE_KEYS;
import static com.godaddy.commerce.helm.AssertType.STANDARD_TLS;
import static com.godaddy.commerce.helm.AssertType.VERTX_OPTIONS;

import com.godaddy.commerce.helm.BaseTest;
import com.godaddy.commerce.helm.HelmRunner;
import com.godaddy.commerce.helm.YamlUtil;
import com.godaddy.commerce.helm.resource.deployment.Env;
import org.junit.jupiter.api.Test;
import org.yaml.snakeyaml.Yaml;

public class VertxYamlTest extends BaseTest {

  private static final Yaml yamlLoader = YamlUtil.buildYamlLoader();
  private static final String TEST_APP_NAME = "case_vertx_standard";
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
  void test_vertxAndStandard() {
    // Given When
    String[] generatedResources =
        HelmRunner.builder()
            .app(TEST_APP_NAME)
            .env("dp")
            .appValuesFolder(TEST_APP_VALUES_FOLDER)
            .imageTag("1.1.1")
            .build()
            .run()
            .getGeneratedResources();

    // Then
    assertContainsAllOf(
        generatedResources,
        STANDARD_APP,
        STANDARD_AUTH,
        STANDARD_DB,
        STANDARD_CLASSIC_DB,
        STANDARD_PROMETHEUS,
        STANDARD_LOG,
        STANDARD_CRYPTO,
        STANDARD_CLIENT_CERT,
        STANDARD_CLIENT_CERT_CONTEXT,
        STANDARD_HOSTS,
        STANDARD_SENSITIVE,
        STANDARD_TLS,
        STANDARD_CA_CERTS,
        STANDARD_STORE_KEYS,
        VERTX_OPTIONS);

    assertContainsNoneOf(generatedResources,
        SPRING_BOOT_APPLICATION,
        SPRING_BOOT_LOG);
    assertContainsAllEnvsOf(generatedResources,
        Env.of("LOG4J_FORMAT_MSG_NO_LOOKUPS", "true"),
        Env.of("AWS_REGION", "us-east-1"),
        Env.of("APP_VERSION", "1.1.1"),
        Env.of("APP_NAME", TEST_APP_NAME),
        Env.of("MOUNT_PATH", "/tmp")
    );
  }

}
