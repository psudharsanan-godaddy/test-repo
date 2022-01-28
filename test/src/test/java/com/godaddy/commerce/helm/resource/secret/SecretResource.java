package com.godaddy.commerce.helm.resource.secret;

import com.godaddy.commerce.helm.resource.Resource;
import java.util.Map;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class SecretResource extends Resource {

  private Map<String, Object> data;

}
