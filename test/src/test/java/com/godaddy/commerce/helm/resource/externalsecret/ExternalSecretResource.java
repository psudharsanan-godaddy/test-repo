package com.godaddy.commerce.helm.resource.externalsecret;

import com.godaddy.commerce.helm.resource.Resource;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class ExternalSecretResource extends Resource {

  private Spec spec;

}



