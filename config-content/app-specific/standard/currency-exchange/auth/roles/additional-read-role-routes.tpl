- route: GET:/v2/currency-exchange/baserates
- queryString:
    source:
      - "*"
    target:
      - "*"
    triangulation:
      - "*"
  route: GET:/v2/customers/:customerId/currency-exchange/:currencyExchangeId/rate
- queryString:
    source:
      - "*"
    target:
      - "*"
    triangulation:
      - "*"
  route: GET:/v2/currency-exchange/baserates/rate
- queryString:
    clock:
      - "*"
    journalId:
      - "*"
    limit:
      - "*"
  route: GET:/v2/currency-exchange/journal
