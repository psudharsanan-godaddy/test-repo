package com.godaddy.commerce.helm;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.function.Predicate;
import java.util.stream.Stream;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NonNull;
import lombok.SneakyThrows;
import lombok.ToString;

/**
 * Class is designed to build and run helm process.
 * Usage example (with defaults, except `app` which is required)
 *
 * <pre>
 *  HelmRunner.builder()
 *    .app("your-required-app-name")
 *    .env("dp")
 *    .accountType("gen")
 *    .awsRegion("us-east-1")
 *    .apiVersion("v1")
 *    .imageTag("0.0.1")
 *    .appValuesFolder("/values/app-specific")
 *    .build()
 *    .run()
 *    .getGeneratedResources();
 * </pre>
 *
 */
@ToString
@Getter
@EqualsAndHashCode
public class HelmRunner {

  private static final String YAML_EXTENSION = ".yaml";

  private static final String DELIMITER = ".";

  @NonNull private final String app;
  @NonNull private final String accountType;
  @NonNull private final String awsRegion;
  @NonNull private final String appType;
  @NonNull private final String apiVersion;
  @NonNull private final String imageTag;
  @NonNull private final String env;
  @NonNull private final String appValuesFolder;

  @Getter(AccessLevel.NONE)
  private Process helmProcess;

  @Getter(AccessLevel.NONE)
  private String successOutput;

  @Builder
  private HelmRunner(
      final String app,
      final String accountType,
      final String awsRegion,
      final String appType,
      final String apiVersion,
      final String imageTag,
      final String env,
      final String appValuesFolder) {
    this.app = app;
    this.accountType = getOrDefault(accountType, "gen");
    this.awsRegion = getOrDefault(awsRegion, "us-east-1");
    this.appType = getOrDefault(appType, "service");
    this.apiVersion = getOrDefault(apiVersion, "v1");
    this.imageTag = getOrDefault(imageTag, "0.0.1");
    this.env = getOrDefault(env, "dp");
    this.appValuesFolder = getOrDefault(appValuesFolder, "/values/app-specific");
  }

  private static List<String> findValuesFiles(
      String env, String app, String appValuesFolder, String awsRegion) {
    String relativeAppFilesFolder = String.format("../%s/%s", appValuesFolder, app);
    String appFilesFolder = String.format("/%s/%s/", appValuesFolder, app);
    return findFilesFilteredBy(
            relativeAppFilesFolder,
            fileName ->
                fileName.endsWith("cp.yaml")
                    || fileName.endsWith(env + YAML_EXTENSION)
                    || fileName.endsWith(env + DELIMITER + awsRegion + YAML_EXTENSION))
        .map(fileName -> appFilesFolder + fileName)
        .toList();
  }

  @SneakyThrows
  private static Stream<String> findFilesFilteredBy(
      String folder, Predicate<String> fileNameFilter) {
    return Files.walk(Paths.get(folder))
        .filter(Files::isRegularFile)
        .map(path -> path.getFileName().toString())
        .filter(fileNameFilter)
        .sorted(Comparator.reverseOrder());
  }

  @SneakyThrows
  public HelmRunner run() {
    helmProcess = buildHelmProcess().start();
    successOutput = readSuccessOutput();
    String errorOutput = readErrorOutput();
    helmProcess.waitFor();
    assertTrue(errorOutput.isBlank(), errorOutput);
    assertFalse(successOutput.isBlank());
    assertNotNull(successOutput);
    return this;
  }

  public String[] getGeneratedResources() {
    String[] generatedResources = successOutput.split("---");
    assertNotNull(generatedResources);
    return generatedResources;
  }

  private String getOrDefault(String value, String fallback) {
    return Optional.ofNullable(value).orElse(fallback);
  }

  @SneakyThrows
  private String readSuccessOutput() {
    return new String(helmProcess.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
  }

  @SneakyThrows
  private String readErrorOutput() {
    return new String(helmProcess.getErrorStream().readAllBytes(), StandardCharsets.UTF_8);
  }

  private ProcessBuilder buildHelmProcess() {
    List<String> valuesFiles = findValuesFiles(env, app, appValuesFolder, awsRegion);
    ProcessBuilder processBuilder = new ProcessBuilder();
    return processBuilder
        .command(buildCommandArgs(valuesFiles).toArray(String[]::new))
        .directory(new File("../"));
  }

  private List<String> buildCommandArgs(List<String> appSpecificValuesFiles) {

    List<String> allValuesFiles =
        Stream.concat(
                Stream.concat(Stream.of("/values/base/cp.yaml"), appSpecificValuesFiles.stream()),
                Stream.of(
                    "/values/protected-base/cp.yaml",
                    String.format("/values/protected-base/cp.%s.yaml", env),
                    String.format("/values/protected-base/cp.%s.%s.yaml", env, accountType),
                    String.format(
                        "/values/protected-base/cp.%s.%s.%s.yaml", env, accountType, awsRegion),
                    String.format(
                        "/values/protected-base/cp.%s.%s.%s.shared.yaml",
                        env, accountType, awsRegion)))
            .toList();

    List<String> commandArgs = new ArrayList<>();
    commandArgs.add("helm");
    commandArgs.add("template");
    commandArgs.add(".");
    for (String valuesFile : allValuesFiles) {
      commandArgs.add("-f");
      commandArgs.add("." + valuesFile);
    }
    commandArgs.add("--set");
    commandArgs.add(String.format("deployment.image.tag=%s", imageTag));
    commandArgs.add("--set");
    commandArgs.add("deploymentSuffix=-test");
    commandArgs.add("--set");
    commandArgs.add("currentPrimaryRegion=us-east-1");
    commandArgs.add("--set");
    commandArgs.add("clusterSide=a");
    commandArgs.add("--set");
    commandArgs.add("liveClusterSide=a");
    commandArgs.add("--set");
    commandArgs.add(String.format("app.name=%s", app));
    commandArgs.add("--set");
    commandArgs.add(String.format("app.apiVersion=%s", apiVersion));
    commandArgs.add("--set");
    commandArgs.add(String.format("app.pathNoun=%s", app));
    commandArgs.add("--set");
    commandArgs.add("app.resourceIdPathParamName=fakeResourceId");
    commandArgs.add("--set");
    commandArgs.add(String.format("app.artifactId=%s-service", app));
    commandArgs.add("--set");
    commandArgs.add(String.format("app.type=%s", appType));
    return commandArgs;
  }
}
