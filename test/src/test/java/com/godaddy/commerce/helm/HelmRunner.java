package com.godaddy.commerce.helm;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NonNull;
import lombok.SneakyThrows;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;

/**
 * Class is designed to build and run helm process. Usage example (with defaults, except `app` which
 * is required)
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
 *    .protectedAppValuesFolder("/values/protected-app-specific")
 *    .build()
 *    .run()
 *    .getGeneratedResources();
 * </pre>
 */
@ToString
@Getter
@EqualsAndHashCode
@Slf4j
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
  @NonNull private final String protectedAppValuesFolder;

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
      final String appValuesFolder,
      final String protectedAppValuesFolder) {
    this.app = app;
    this.accountType = getOrDefault(accountType, "gen");
    this.awsRegion = getOrDefault(awsRegion, "us-east-1");
    this.appType = getOrDefault(appType, "service");
    this.apiVersion = getOrDefault(apiVersion, "v1");
    this.imageTag = getOrDefault(imageTag, "0.0.1");
    this.env = getOrDefault(env, "dp");
    this.appValuesFolder = getOrDefault(appValuesFolder, "values/app-specific");
    this.protectedAppValuesFolder =
        getOrDefault(protectedAppValuesFolder, "values/protected-app-specific");
  }

  @SneakyThrows
  private static Stream<String> findFilesFilteredBy(
      String folder, Predicate<String> fileNameFilter) {
    Path folderPath = Paths.get(folder);
    if (Files.notExists(folderPath)) {
      return Stream.empty();
    }
    return Files.walk(folderPath)
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
    log.info("Command successfully executed");
    return this;
  }

  /** At the moment it searches only for such files: cp.yaml, $ENV.yaml, $ENV.$AWS_REGION.yaml */
  private List<String> findAppValuesFiles(String folderForSearch) {
    String relativeAppFilesFolder = String.format("../%s/%s", folderForSearch, app);
    String appFilesFolder = String.format("/%s/%s/", folderForSearch, app);
    return findFilesFilteredBy(
            relativeAppFilesFolder,
            fileName ->
                fileName.endsWith("cp" + YAML_EXTENSION)
                    || fileName.endsWith(env + YAML_EXTENSION)
                    || fileName.endsWith(env + DELIMITER + awsRegion + YAML_EXTENSION))
        .map(fileName -> appFilesFolder + fileName)
        .toList();
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
    List<String> appValuesFiles = findAppValuesFiles(appValuesFolder);
    List<String> protectedAppValuesFiles = findAppValuesFiles(protectedAppValuesFolder);

    ProcessBuilder processBuilder = new ProcessBuilder();
    return processBuilder
        .command(buildCommandArgs(appValuesFiles, protectedAppValuesFiles).toArray(String[]::new))
        .directory(new File("../"));
  }

  private List<String> buildCommandArgs(
      List<String> appSpecificValuesFiles, List<String> protectedAppSpecificValuesFiles) {

    List<String> commandArgs = new ArrayList<>();
    commandArgs.add("helm");
    commandArgs.add("template");
    commandArgs.add(".");

    // The order matters
    Stream.of(
            Stream.of("/values/base/cp.yaml"),
            appSpecificValuesFiles.stream(),
            buildProtectedBaseValuesFiles().stream(),
            protectedAppSpecificValuesFiles.stream())
        .flatMap(Function.identity())
        .peek(valuesFile -> commandArgs.add("-f"))
        .forEach(valuesFile -> commandArgs.add("." + valuesFile));

    Stream.of(
            String.format("deployment.image.tag=%s", imageTag),
            "deploymentSuffix=-test",
            "currentPrimaryRegion=us-east-1",
            "clusterSide=a",
            "liveClusterSide=a",
            String.format("app.name=%s", app),
            String.format("app.apiVersion=%s", apiVersion),
            String.format("app.pathNoun=%s", app),
            "app.resourceIdPathParamName=fakeResourceId",
            String.format("app.artifactId=%s-service", app),
            String.format("app.type=%s", appType))
        .peek(arg -> commandArgs.add("--set"))
        .forEach(commandArgs::add);
    log.info("Running command: {}", String.join(" ", commandArgs));
    return commandArgs;
  }

  private List<String> buildProtectedBaseValuesFiles() {
    return Stream.of(
            "/values/protected-base/cp.yaml",
            String.format("/values/protected-base/cp.%s.yaml", env),
            String.format("/values/protected-base/cp.%s.%s.yaml", env, accountType),
            String.format("/values/protected-base/cp.%s.%s.%s.yaml", env, accountType, awsRegion),
            String.format(
                "/values/protected-base/cp.%s.%s.%s.shared.yaml", env, accountType, awsRegion))
        .collect(Collectors.toList());
  }
}
