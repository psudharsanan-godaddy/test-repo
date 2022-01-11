- route: 'POST:/v2/customers/:customerId/tax-rates/find'
- route: 'GET:/v2/tax-rates/journal'
  queryString:
    clock:
    - '*'
    limit:
    - '*'
    journalId:
    - '*'
