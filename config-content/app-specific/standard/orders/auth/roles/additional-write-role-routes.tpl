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
    shardId:
      - "*"
  route: POST:/v2/customers/:customerId/orders/commonCart
- impact: medium
  route: POST:/v2/customers/:customerId/orders/:orderId/purchase
- impact: medium
  route: POST:/v2/customers/:customerId/orders/:orderId/markPaid
- impact: medium
  route: POST:/v2/customers/:customerId/orders/:orderId/markLegacyPaid
- impact: medium
  route: POST:/v2/customers/:customerId/orders/transfer
- impact: medium
  route: POST:/v2/customers/:customerId/orders/:orderId/linkSubscriptions
- impact: medium
  route: DELETE:/v2/customers/:customerId/orders/:orderId
- impact: medium
  queryString:
    newCustomer:
      - "*"
  route: POST:/v2/customers/:customerId/orders/:orderId/customerUpdate
- impact: medium
  queryString:
    previousCustomer:
      - "*"
  route: POST:/v2/customers/:customerId/orders/:orderId/customerUpdate/create
