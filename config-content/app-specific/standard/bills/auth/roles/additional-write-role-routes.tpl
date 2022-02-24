- route: POST:/v2/customers/:customerId/bills/:billId/processPayment
- queryString:
    operationIndex:
      - "*"
  route: POST:/v2/customers/:customerId/bills/:billId/cancel
- route: POST:/v2/customers/:customerId/bills/:billId/capture
- route: POST:/v2/customers/:customerId/bills/:billId/charge
- queryString:
    operationIndex:
      - "*"
  route: POST:/v2/customers/:customerId/bills/:billId/settle
- route: POST:/v2/customers/:customerId/bills/:billId/void
- queryString:
    newCustomer:
      - "*"
  route: POST:/v2/customers/:customerId/bills/:billId/customerUpdate
- queryString:
    previousCustomer:
      - "*"
  route: POST:/v2/customers/:customerId/bills/:billId/customerUpdate/create
