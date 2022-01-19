package com.godaddy.commerce.helm.resource;

public class Limits {

  private String cpu;
  private String memory;

  public String getCPU() {
    return cpu;
  }

  public void setCPU(String value) {
    this.cpu = value;
  }

  public String getMemory() {
    return memory;
  }

  public void setMemory(String value) {
    this.memory = value;
  }
}
