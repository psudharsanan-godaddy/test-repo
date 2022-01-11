- route: 'GET:/v2/currency-exchange/baserates'
- route: 'GET:/v2/customers/:customerId/currency-exchange/:currencyExchangeId/rate'
  queryString:
    source:
      - '*'
    target:
      - '*'
    triangulation:
      - '*'
- route: 'GET:/v2/currency-exchange/baserates/rate'
  queryString:
    source:
      - '*'
    target:
      - '*'
    triangulation:
      - '*'
- route: 'GET:/v2/currency-exchange/journal'
  queryString:
    clock:
      - '*'
    limit:
      - '*'
    journalId:
      - '*'
