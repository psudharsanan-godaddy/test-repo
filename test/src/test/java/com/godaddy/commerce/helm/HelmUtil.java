package com.godaddy.commerce.helm;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.LoaderOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;
import org.yaml.snakeyaml.representer.Representer;
import org.yaml.snakeyaml.resolver.Resolver;

public final class HelmUtil {

  private HelmUtil() {
    throw new UnsupportedOperationException("Forbidden");
  }

  private static String[] buildCommandArgs(String app, String env) {
    return new String[]{"helm",
        "template",
        ".",
        "-f", "./values/base/cp.yaml",
        "-f", String.format("./values/base/cp.%s.yaml", env),
        "-f", String.format("./values/base/cp.%s.gen.yaml", env),
        "-f", String.format("./values/base/cp.%s.gen.us-east-1.yaml", env),
        "-f", String.format("./values/base/cp.%s.gen.us-east-1.shared.yaml", env),
        "-f", String.format("./values/base/cp.%s.gen.us-east-1.shared.a.yaml", env),
        "-f", String.format("./values/app-specific/%s/cp.yaml", app),
        "-f", String.format("./values/app-specific/%s/cp.%s.yaml", app, env),
        "-f", String.format("./values/app-specific/%s/cp.%s.us-east-1.yaml", app, env),
        "--set", "deployment.image.tag=1.1.1",
        "--set", "deploymentSuffix=-test",
        "--set", "currentPrimaryRegion=us-east-1"};
  }

  public static ProcessBuilder helmProcessBuilder(String app, String env) {
    ProcessBuilder processBuilder = new ProcessBuilder();
    return processBuilder.command(buildCommandArgs(app, env)).directory(new File("../"));
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
