internalOnly:
  - impact: medium
    queryString:
      explicitOrderId:
        - "*"
      piiFilter:
        - "true"
        - "false"
      rateForPurchase:
        - "true"
        - "false"
      removeOpenOffers:
        - "true"
        - "false"
    route: POST:/v2/customers/:customerId/orders
purchase:
  - impact: medium
    route: POST:/v2/customers/:customerId/orders/:orderId/purchase
  - impact: medium
    route: POST:/v2/customers/:customerId/orders/:orderId/signup
readUpdate:
  - impact: medium
    queryString:
      piiFilter:
        - "true"
        - "false"
      rateForPurchase:
        - "true"
        - "false"
      removeOpenOffers:
        - "true"
        - "false"
    route: POST:/v2/customers/:customerId/orders/commonCart
  - impact: medium
    route: POST:/v2/customers/:customerId/orders/transfer
  - impact: low
    queryString:
      piiFilter:
        - "true"
        - "false"
    route: GET:/v2/customers/:customerId/orders/commonCart
  - impact: low
    queryString:
      piiFilter:
        - "true"
        - "false"
      rateForPurchase:
        - "true"
        - "false"
    route: GET:/v2/customers/:customerId/orders/:orderId
  - impact: medium
    queryString:
      piiFilter:
        - "true"
        - "false"
      rateForPurchase:
        - "true"
        - "false"
      removeOpenOffers:
        - "true"
        - "false"
    route: POST:/v2/customers/:customerId/orders
  - impact: medium
    queryString:
      piiFilter:
        - "true"
        - "false"
      rateForPurchase:
        - "true"
        - "false"
      removeOpenOffers:
        - "true"
        - "false"
    route: POST:/v2/customers/:customerId/orders/:orderId
readUpdateWithPiiFiltering:
  - impact: medium
    queryString:
      piiFilter:
        - "true"
      rateForPurchase:
        - "true"
        - "false"
      removeOpenOffers:
        - "true"
        - "false"
    route: POST:/v2/customers/:customerId/orders/commonCart
  - impact: medium
    route: POST:/v2/customers/:customerId/orders/transfer
  - impact: low
    queryString:
      piiFilter:
        - "true"
    route: GET:/v2/customers/:customerId/orders/commonCart
  - impact: low
    queryString:
      piiFilter:
        - "true"
      rateForPurchase:
        - "true"
        - "false"
    route: GET:/v2/customers/:customerId/orders/:orderId
  - impact: medium
    queryString:
      piiFilter:
        - "true"
      rateForPurchase:
        - "true"
        - "false"
      removeOpenOffers:
        - "true"
        - "false"
    route: POST:/v2/customers/:customerId/orders
  - impact: medium
    queryString:
      piiFilter:
        - "true"
      rateForPurchase:
        - "true"
        - "false"
      removeOpenOffers:
        - "true"
        - "false"
    route: POST:/v2/customers/:customerId/orders/:orderId
thirdPartyInAppPurchase:
  - impact: medium
    route: POST:/v2/customers/:customerId/orders/thirdPartyInAppPurchase
