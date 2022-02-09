# Use cases

## Launch a new service

1. Create a branch of cd-jobs, add an entry in the app-manifest.json and get it merged into master
2. Create a branch of the Helm chart repo, add all necessary values files, blocks and get it merged into master
3. Run app-setup to have app-speicific resources created, e.g. jks secret, hosts config secret, ECR repo, IngressRoute, HPA, NLB Ingress, ClusterIP Svc, Route 53 records, APIG etc.
4. Merge the app repo branch to master to trigger build and deploy the app repo to DP

## Update an existing service

### Update a config (hosts)

1. Create a branch of the Helm chart repo, update all necessary values files, blocks
2. Run the app-setup against that Helm chart branch (hosts)
3. Deploy the app using the Helm chart against that Helm chart branch (auth, db, etc.)
4. Access the branch-deployment of the app using port forwarding to the ClusterIP svc
5. Have the Helm chart branch merged into master (triggers an automatic cleanup)
6. Deploy the app with the updated Helm chart

### Update a config (auth, db, etc.)

1. Create a branch of the Helm chart repo, update all necessary values files, blocks
2. Deploy the app using the Helm chart against that Helm chart branch (auth, db, etc.)
3. Access the branch-deployment of the app using port forwarding to the ClusterIP svc
4. Have the Helm chart branch merged into master (triggers an automatic cleanup)
5. Deploy the app with the updated Helm chart

### Update the app code

1. Create a branch of the app repo and make updates
2. Deploy the app against that app repo branch
