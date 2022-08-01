# chores

A collection of bash scripts to automate routine or unpleasant tasks.

```shell
chores <subcommand1> <subcommand2> <subcommand3> ... <subcommandN>
```

## Sugar Connect

Install and configure the collabspot-cadence project for local development.

```shell
chores sugarconnect cadence develop
```

Build the collabspot-cadence application locally.

```shell
chores sugarconnect cadence build
```

Deploy the collabspot-cadence application remotely.

```shell
chores sugarconnect cadence deploy some_branch 4 -c k8s-usw2-dev -n sugarconnect -s
```
