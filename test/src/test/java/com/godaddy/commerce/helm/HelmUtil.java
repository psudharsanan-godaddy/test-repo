package com.godaddy.commerce.helm;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

public final class HelmUtil {

  private HelmUtil() {
    throw new UnsupportedOperationException("Forbidden");
  }

  private static String[] buildCommandArgs(String app, String env, String appValuesFolder) {
    return new String[]{"helm",
        "template",
        ".",
        "-f", "./values/base/cp.yaml",
        "-f", String.format("./values/base/cp.%s.yaml", env),
        "-f", String.format("./values/base/cp.%s.gen.yaml", env),
        "-f", String.format("./values/base/cp.%s.gen.us-east-1.yaml", env),
        "-f", String.format("./values/base/cp.%s.gen.us-east-1.shared.yaml", env),
        "-f", String.format("./values/base/cp.%s.gen.us-east-1.shared.a.yaml", env),
        "-f", String.format(".%s/%s/cp.yaml", appValuesFolder, app),
        "-f", String.format(".%s/%s/cp.%s.yaml",appValuesFolder, app, env),
        "-f", String.format(".%s/%s/cp.%s.us-east-1.yaml",appValuesFolder,  app, env),
        "--set", "deployment.image.tag=1.1.1",
        "--set", "deploymentSuffix=-test",
        "--set", "liveClusterSide=a",
        "--set", "currentPrimaryRegion=us-east-1"};
  }

  public static ProcessBuilder helmProcessBuilder(String app, String env) {
    ProcessBuilder processBuilder = new ProcessBuilder();
    return processBuilder.command(buildCommandArgs(app, env, "/values/app-specific")).directory(new File("../"));
  }

  public static ProcessBuilder helmProcessBuilder(String app, String env, String appValuesFolder) {
    ProcessBuilder processBuilder = new ProcessBuilder();
    return processBuilder.command(buildCommandArgs(app, env, appValuesFolder))
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
