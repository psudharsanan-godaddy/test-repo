package com.godaddy.commerce.helm.app;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.DynamicTest.dynamicTest;

import com.godaddy.commerce.helm.HelmUtil;
import com.godaddy.commerce.helm.YamlUtil;
import com.godaddy.commerce.helm.framework.StandardYamlTest;
import com.godaddy.commerce.helm.resource.secret.SecretResource;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.Collection;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import org.everit.json.schema.Schema;
import org.everit.json.schema.ValidationException;
import org.everit.json.schema.loader.SchemaLoader;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.TestFactory;
import org.yaml.snakeyaml.Yaml;

/**
 * This class dynamically creates test cases by scanning app names under ../values/app-specific/
 */
public class AllAppsTest {

  private static final String AUTH_CONFIG_SCHEMA_PATH = "/schemas/auth-config-schema.json";
  private static final String AUTH_CONFIG_FILE_NAME = "auth-config.json";
  private static final String APP_SPECIFIC_VALUES_FILE_FOLDER = "/values/app-specific";
  private static final String TARGETING_ENV = "dp";

  @TestFactory
  Collection<DynamicTest> authConfigSchemaValidationTests() throws IOException {
    final Yaml yamlLoader = YamlUtil.buildYamlLoader();

    final Schema authConfigSchema =
        SchemaLoader.load(
            new JSONObject(
                new JSONTokener(StandardYamlTest.class.getResourceAsStream(AUTH_CONFIG_SCHEMA_PATH))
            )
        );

    final Path appSpecificValuesPath = Paths.get("../values/app-specific/");

    try (Stream<Path> paths = Files.walk(appSpecificValuesPath, 1)) {
      return paths
          .filter(path -> Files.isDirectory(path) && !path.equals(appSpecificValuesPath))
          .map(path -> {
            final String app = path.getFileName().toString();

            return dynamicTest(String.format("Auth config schema validation - %s", app), () -> {
              ProcessBuilder helmProcessBuilder = HelmUtil.helmProcessBuilder(
                  app,
                  TARGETING_ENV,
                  APP_SPECIFIC_VALUES_FILE_FOLDER
              );

              //When
              Process helmProcess = helmProcessBuilder.start();
              String successOutput = HelmUtil.readSuccessOutput(helmProcess);
              String errorOutput = HelmUtil.readErrorOutput(helmProcess);
              helmProcess.waitFor();

              assertTrue(errorOutput.isBlank(), errorOutput);
              assertFalse(successOutput.isBlank());

              //Then
              assertNotNull(successOutput);
              final String[] generatedResources = successOutput.split("---");

              final Map<String, SecretResource> secrets = YamlUtil.readResources(
                  yamlLoader,
                  generatedResources,
                  SecretResource.class);
              final String authConfigKey = String.format("%s-auth-config-test", app);

              if (secrets.containsKey(authConfigKey)) {
                final SecretResource authConfigSecret = secrets.get(authConfigKey);
                assertTrue(authConfigSecret.getData().containsKey(AUTH_CONFIG_FILE_NAME));

                final String authConfigContentEncoded =
                    (String) authConfigSecret.getData().get(AUTH_CONFIG_FILE_NAME);
                final String decodedString = new String(
                    Base64.getDecoder().decode(authConfigContentEncoded));
                final JSONObject generatedAuthConfigJson = new JSONObject(new JSONTokener(decodedString));

                try {
                  authConfigSchema.validate(generatedAuthConfigJson);
                } catch (ValidationException validationException) {
                  System.out.println(validationException.toJSON().toString(2));
                  throw validationException;
                }
              } else {
                System.out.printf("Skipping %s due to missing auth-config.", app);
              }
            });
          })
          .collect(Collectors.toList());
    }
  }
}
