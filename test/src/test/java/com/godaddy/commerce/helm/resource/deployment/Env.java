package com.godaddy.commerce.helm.resource.deployment;

import lombok.Data;

@Data
public class Env {

  private String name;
  private String value;

  public static Env of(String name, String value) {
    Env env = new Env();
    env.setName(name);
    env.setValue(value);
    return env;
  }

}
