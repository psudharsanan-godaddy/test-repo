package com.godaddy.commerce.helm.resource;

import java.util.Map;
import lombok.Data;

@Data
public class Metadata {

  private String name;
  private Map<String, String> labels;

}
