- route: POST:/v2/customers/:customerId/tax-rates/find
- queryString:
    clock:
      - "*"
    journalId:
      - "*"
    limit:
      - "*"
  route: GET:/v2/tax-rates/journal
