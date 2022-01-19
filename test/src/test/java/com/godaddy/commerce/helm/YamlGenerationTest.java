package com.godaddy.commerce.helm;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.godaddy.commerce.helm.resource.DeploymentResource;
import com.godaddy.commerce.helm.resource.SecretResource;
import java.io.IOException;
import java.util.Map;
import org.junit.jupiter.api.Test;
import org.yaml.snakeyaml.Yaml;

public class YamlGenerationTest {

  private static final Yaml yamlLoader = YamlUtil.buildYamlLoader();

  @Test
  void compare() throws IOException, InterruptedException {
    //Given
    ProcessBuilder helmProcessBuilder = HelmUtil.helmProcessBuilder("shopper-migration", "dp");
    //When
    Process helmProcess = helmProcessBuilder.start();
    String successOutput = HelmUtil.readSuccessOutput(helmProcess);
    String errorOutput = HelmUtil.readErrorOutput(helmProcess);
    helmProcess.waitFor();

    assertTrue(errorOutput.isBlank());
    assertFalse(successOutput.isBlank());
    //Then
    assertNotNull(successOutput);
    String[] generatedResources = successOutput.split("---");
    assertNotNull(generatedResources);

    Map<String, SecretResource> secrets = YamlUtil.readSecretResources(yamlLoader,
        generatedResources);
    Map<String, DeploymentResource> deployments = YamlUtil.readDeploymentResources(yamlLoader,
        generatedResources);
    assertFalse(secrets.isEmpty());
    assertFalse(deployments.isEmpty());
    //TODO 19.01.2022
  }


}
