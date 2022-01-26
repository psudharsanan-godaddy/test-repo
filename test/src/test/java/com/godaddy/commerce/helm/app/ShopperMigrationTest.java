package com.godaddy.commerce.helm.app;

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
import static com.godaddy.commerce.helm.AssertType.STANDARD_WILDCARD;
import static com.godaddy.commerce.helm.AssertType.VERTX_OPTIONS;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.godaddy.commerce.helm.BaseTest;
import com.godaddy.commerce.helm.HelmUtil;
import com.godaddy.commerce.helm.YamlUtil;
import java.io.IOException;
import org.junit.jupiter.api.Test;
import org.yaml.snakeyaml.Yaml;

public class ShopperMigrationTest extends BaseTest {

  private static final Yaml yamlLoader = YamlUtil.buildYamlLoader();
  private static final String APP_NAME = "shopper-migration";

  @Override
  protected Yaml getYamlLoader() {
    return yamlLoader;
  }

  @Override
  protected String getAppName() {
    return APP_NAME;
  }

  @Test
  void test_shopperMigrationDpEnv() throws IOException, InterruptedException {
    //Given
    ProcessBuilder helmProcessBuilder = HelmUtil.helmProcessBuilder(APP_NAME, "dp");
    //When
    Process helmProcess = helmProcessBuilder.start();
    String successOutput = HelmUtil.readSuccessOutput(helmProcess);
    String errorOutput = HelmUtil.readErrorOutput(helmProcess);
    helmProcess.waitFor();

    assertTrue(errorOutput.isBlank(), errorOutput);
    assertFalse(successOutput.isBlank());

    //Then
    assertNotNull(successOutput);
    String[] generatedResources = successOutput.split("---");
    assertNotNull(generatedResources);

    assertContainsAllOf(generatedResources,
        STANDARD_APP,
        STANDARD_CLASSIC_DB,
        STANDARD_PROMETHEUS,
        STANDARD_CLIENT_CERT,
        STANDARD_CLIENT_CERT_CONTEXT,
        STANDARD_HOSTS,
        STANDARD_SENSITIVE,
        STANDARD_TLS,
        STANDARD_CA_CERTS,
        STANDARD_STORE_KEYS,
        STANDARD_WILDCARD,
        SPRING_BOOT_APPLICATION,
        SPRING_BOOT_LOG);

    assertContainsNoneOf(generatedResources,
        STANDARD_DB,
        STANDARD_CRYPTO,
        STANDARD_LOG,
        STANDARD_AUTH,
        VERTX_OPTIONS);
  }
}
