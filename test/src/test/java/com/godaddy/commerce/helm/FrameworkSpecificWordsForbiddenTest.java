package com.godaddy.commerce.helm;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

public class FrameworkSpecificWordsForbiddenTest {

  private static final String[] FRAMEWORKS = new String[]{"vertx", "spring-boot", "nodejs"};

  @Test
  void test_standardDeployment() throws IOException {
    //Given
    byte[] allBytes = Files.readAllBytes(
        Paths.get("../templates/deployment/standard/deployment.yaml"));

    //When
    String fileContent = new String(allBytes, StandardCharsets.UTF_8);

    //Then
    assertThat(fileContent).doesNotContainIgnoringCase(FRAMEWORKS);
  }

  @Test
  void test_standardTpl() throws IOException {
    //Given
    byte[] allBytes = Files.readAllBytes(
        Paths.get("../templates/_standard.tpl"));

    //When
    String fileContent = new String(allBytes, StandardCharsets.UTF_8);

    //Then
    assertThat(fileContent).doesNotContainIgnoringCase(FRAMEWORKS);
  }


  @ParameterizedTest
  @ValueSource(strings = {"app.yaml", "auth.yaml", "classic-db.yaml", "crypto.yaml", "db.yaml",
      "log.yaml", "prometheus.yaml"})
  void test_standardConfigs(String configName) throws IOException {
    //Given
    byte[] allBytes = Files.readAllBytes(
        Paths.get("../templates/configs/standard/" + configName));

    //When
    String fileContent = new String(allBytes, StandardCharsets.UTF_8);

    //Then
    assertThat(fileContent).doesNotContainIgnoringCase(FRAMEWORKS);
  }
}
