package com.godaddy.commerce.helm.resource.configmap;

import com.godaddy.commerce.helm.resource.Resource;
import java.util.Map;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class ConfigMapResource extends Resource {

  private Map<String, Object> data;

}


