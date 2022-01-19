package com.godaddy.commerce.helm.resource;

public class Spec {

  private long replicas;
  private long revisionHistoryLimit;
  private Selector selector;
  private Template template;

  public long getReplicas() {
    return replicas;
  }

  public void setReplicas(long value) {
    this.replicas = value;
  }

  public long getRevisionHistoryLimit() {
    return revisionHistoryLimit;
  }

  public void setRevisionHistoryLimit(long value) {
    this.revisionHistoryLimit = value;
  }

  public Selector getSelector() {
    return selector;
  }

  public void setSelector(Selector value) {
    this.selector = value;
  }

  public Template getTemplate() {
    return template;
  }

  public void setTemplate(Template value) {
    this.template = value;
  }
}
