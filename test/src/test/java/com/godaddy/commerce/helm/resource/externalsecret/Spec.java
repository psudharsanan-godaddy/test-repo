package com.godaddy.commerce.helm.resource.externalsecret;

import java.util.List;

@lombok.Data
public class Spec {

  private String backendType;
  private String region;
  private List<Data> data;
  private Template template;

}
