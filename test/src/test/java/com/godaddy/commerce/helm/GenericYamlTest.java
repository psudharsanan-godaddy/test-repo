package com.godaddy.commerce.helm;

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

import java.io.IOException;
import org.junit.jupiter.api.Test;
import org.yaml.snakeyaml.Yaml;

public class GenericYamlTest extends BaseTest {

  private static final Yaml yamlLoader = YamlUtil.buildYamlLoader();
  private static final String TEST_APP_NAME = "helm-unit-test-app";
  private static final String TEST_APP_VALUES_FOLDER = "/test/src/test/resources/" + TEST_APP_NAME;

  @Override
  protected Yaml getYamlLoader() {
    return yamlLoader;
  }

  @Override
  protected String getAppName() {
    return TEST_APP_NAME;
  }

  @Test
  void test_springAndStandard() throws IOException, InterruptedException {
    //Given
    ProcessBuilder helmProcessBuilder = HelmUtil.helmProcessBuilder(
        "case_spring_standard",
        "dp",
        TEST_APP_VALUES_FOLDER);
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
        STANDARD_WILDCARD,
        SPRING_BOOT_APPLICATION,
        SPRING_BOOT_LOG);

    assertContainsNoneOf(generatedResources, VERTX_OPTIONS);
  }


  @Test
  void test_standard() throws IOException, InterruptedException {
    //Given
    ProcessBuilder helmProcessBuilder = HelmUtil.helmProcessBuilder(
        "case_standard",
        "dp",
        TEST_APP_VALUES_FOLDER);
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
        STANDARD_WILDCARD);

    assertContainsNoneOf(generatedResources,
        VERTX_OPTIONS,
        SPRING_BOOT_APPLICATION,
        SPRING_BOOT_LOG);
  }


  @Test
  void test_vertxAndStandard() throws IOException, InterruptedException {
    //Given
    ProcessBuilder helmProcessBuilder = HelmUtil.helmProcessBuilder(
        "case_vertx_standard",
        "dp",
        TEST_APP_VALUES_FOLDER);
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
//        STANDARD_WILDCARD, //TODO temporarily disabled because unknown
        VERTX_OPTIONS);

    assertContainsNoneOf(generatedResources,
        SPRING_BOOT_APPLICATION,
        SPRING_BOOT_LOG);
  }

}
