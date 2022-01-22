package com.godaddy.commerce.helm.resource.deployment;

import lombok.Data;

@Data
public class HTTPGet {

  private String path;
  private long port;
  private String scheme;
  private Env[] httpHeaders;

}
