package com.godaddy.commerce.helm.resource;

public class Resources {

  private Limits requests;
  private Limits limits;

  public Limits getRequests() {
    return requests;
  }

  public void setRequests(Limits value) {
    this.requests = value;
  }

  public Limits getLimits() {
    return limits;
  }

  public void setLimits(Limits value) {
    this.limits = value;
  }
}
