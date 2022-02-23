- impact: low
  queryString:
    depth:
      - "*"
    piiFilter:
      - "true"
      - "false"
    rateForPurchase:
      - "true"
      - "false"
  route: GET:/v2/customers/:customerId/orders/:orderId
- impact: low
  queryString:
    piiFilter:
      - "true"
      - "false"
  route: GET:/v2/customers/:customerId/orders/commonCart
