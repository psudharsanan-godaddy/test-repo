package com.godaddy.commerce.helm.resource;

public class SecurityContext {

  private boolean readOnlyRootFilesystem;

  public boolean getReadOnlyRootFilesystem() {
    return readOnlyRootFilesystem;
  }

  public void setReadOnlyRootFilesystem(boolean value) {
    this.readOnlyRootFilesystem = value;
  }
}
