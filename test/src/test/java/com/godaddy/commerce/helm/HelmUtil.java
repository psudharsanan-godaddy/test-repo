package com.godaddy.commerce.helm;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Stream;
import lombok.SneakyThrows;

public final class HelmUtil {

  public static final String YAML_EXTENSION = ".yaml";

  public static final String DELIMITER = ".";

  public static final String DEFAULT_AWS_REGION = "us-east-1";

  private HelmUtil() {
    throw new UnsupportedOperationException("Forbidden");
  }

  private static List<String> buildCommandArgs(
      String env,
      String app,
      List<String> appSpecificValuesFiles) {

    List<String> allValuesFiles =
        Stream.concat(
            Stream.concat(
                Stream.of("/values/base/cp.yaml"),
                appSpecificValuesFiles.stream()
            ),
            Stream.of(
                "/values/protected-base/cp.yaml",
                String.format("/values/protected-base/cp.%s.yaml", env),
                String.format("/values/protected-base/cp.%s.gen.yaml", env),
                String.format("/values/protected-base/cp.%s.gen.us-east-1.yaml", env),
                String.format("/values/protected-base/cp.%s.gen.us-east-1.shared.yaml", env)
            )
        ).toList();

    List<String> commandArgs = new ArrayList<>();
    commandArgs.add("helm");
    commandArgs.add("template");
    commandArgs.add(".");
    for (String valuesFile : allValuesFiles) {
      commandArgs.add("-f");
      commandArgs.add("." + valuesFile);
    }
    commandArgs.add("--set");
    commandArgs.add("deployment.image.tag=1.1.1");
    commandArgs.add("--set");
    commandArgs.add("deploymentSuffix=-test");
    commandArgs.add("--set");
    commandArgs.add("clusterSide=a");
    commandArgs.add("--set");
    commandArgs.add("liveClusterSide=a");
    commandArgs.add("--set");
    commandArgs.add(String.format("app.name=%s", app));
    commandArgs.add("--set");
    commandArgs.add("app.apiVersion=v2");
    commandArgs.add("--set");
    commandArgs.add(String.format("app.pathNoun=%s", app));
    commandArgs.add("--set");
    commandArgs.add("app.resourceIdPathParamName=fakeResourceId");
    commandArgs.add("--set");
    commandArgs.add(String.format("app.artifactId=%s-service", app));
    commandArgs.add("--set");
    commandArgs.add("app.type=service");
    commandArgs.add("--set");
    commandArgs.add("currentPrimaryRegion=us-east-1");

    return commandArgs;
  }

  private static List<String> findValuesFiles(
      String env,
      String app,
      String appValuesFolder,
      String awsRegion) {
    String relativeAppFilesFolder = String.format("../%s/%s", appValuesFolder, app);
    String appFilesFolder = String.format("/%s/%s/", appValuesFolder, app);
    return findFilesFilteredBy(relativeAppFilesFolder,
        fileName -> fileName.endsWith("cp.yaml")
            || fileName.endsWith(env + YAML_EXTENSION)
            || fileName.endsWith(env + DELIMITER + awsRegion + YAML_EXTENSION))
        .map(fileName -> appFilesFolder + fileName)
        .toList();
  }

  @SneakyThrows
  private static Stream<String> findFilesFilteredBy(String folder,
      Predicate<String> fileNameFilter) {
    return Files.walk(Paths.get(folder))
        .filter(Files::isRegularFile)
        .map(path -> path.getFileName().toString())
        .filter(fileNameFilter)
        .sorted(Comparator.reverseOrder());
  }

  public static ProcessBuilder helmProcessBuilder(String app, String env) {
    List<String> valuesFiles = findValuesFiles(env, app, "/values/app-specific",
        DEFAULT_AWS_REGION);
    ProcessBuilder processBuilder = new ProcessBuilder();
    return processBuilder.command(buildCommandArgs(env, app, valuesFiles).toArray(String[]::new))
        .directory(new File("../"));
  }

  public static ProcessBuilder helmProcessBuilder(String app, String env, String appValuesFolder) {
    List<String> valuesFiles = findValuesFiles(env, app, appValuesFolder, DEFAULT_AWS_REGION);
    ProcessBuilder processBuilder = new ProcessBuilder();
    return processBuilder.command(buildCommandArgs(env, app, valuesFiles).toArray(String[]::new))
        .directory(new File("../"));
  }

  public static ProcessBuilder helmProcessBuilder(String app, String env, String appValuesFolder,
      String awsRegion) {
    List<String> valuesFiles = findValuesFiles(env, app, appValuesFolder, awsRegion);
    ProcessBuilder processBuilder = new ProcessBuilder();
    return processBuilder.command(buildCommandArgs(env, app, valuesFiles).toArray(String[]::new))
        .directory(new File("../"));
  }

  public static String readSuccessOutput(Process helmProcess) {
    try {
      return new String(helmProcess.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static String readErrorOutput(Process helmProcess) {
    try {
      return new String(helmProcess.getErrorStream().readAllBytes(), StandardCharsets.UTF_8);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

}
