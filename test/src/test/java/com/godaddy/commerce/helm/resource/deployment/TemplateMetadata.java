package com.godaddy.commerce.helm.resource.deployment;

import java.util.Map;
import lombok.Data;

@Data
public class TemplateMetadata {

  private Map<String, String> labels;
  private Map<String, Object> annotations;

}
