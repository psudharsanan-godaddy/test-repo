package com.godaddy.commerce.helm.resource.externalsecret;

import com.godaddy.commerce.helm.resource.Metadata;
import java.util.Map;

@lombok.Data
public class Template {

  private Metadata metadata;
  private Map<String, Object> stringData;

}
