package com.godaddy.commerce.helm.resource;

public class Probe {

  private HTTPGet httpGet;
  private long initialDelaySeconds;
  private long periodSeconds;
  private long timeoutSeconds;
  private long successThreshold;
  private long failureThreshold;

  public HTTPGet getHTTPGet() {
    return httpGet;
  }

  public void setHTTPGet(HTTPGet value) {
    this.httpGet = value;
  }

  public long getInitialDelaySeconds() {
    return initialDelaySeconds;
  }

  public void setInitialDelaySeconds(long value) {
    this.initialDelaySeconds = value;
  }

  public long getPeriodSeconds() {
    return periodSeconds;
  }

  public void setPeriodSeconds(long value) {
    this.periodSeconds = value;
  }

  public long getTimeoutSeconds() {
    return timeoutSeconds;
  }

  public void setTimeoutSeconds(long value) {
    this.timeoutSeconds = value;
  }

  public long getSuccessThreshold() {
    return successThreshold;
  }

  public void setSuccessThreshold(long value) {
    this.successThreshold = value;
  }

  public long getFailureThreshold() {
    return failureThreshold;
  }

  public void setFailureThreshold(long value) {
    this.failureThreshold = value;
  }
}
