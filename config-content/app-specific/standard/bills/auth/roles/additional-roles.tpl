chargebackWrite:
  - route: POST:/v2/customers/:customerId/bills/:billId/processPayment
  - route: POST:/v2/customers/:customerId/bills/:billId/cancel
  - route: POST:/v2/customers/:customerId/bills/:billId/settle
create:
  - queryString:
      shard:
        - "*"
    requireAllQueryStrings: "true"
    route: POST:/v2/customers/:customerId/bills
externalRead:
  - queryString:
      view:
        - external
    requireAllQueryStrings: "true"
    route: GET:/v2/customers/:customerId/bills/:billId
refundWrite:
  - route: POST:/v2/customers/:customerId/bills/:billId/processPayment
  - route: POST:/v2/customers/:customerId/bills/:billId/cancel
update:
  - route: PUT:/v2/customers/:customerId/bills/:billId
