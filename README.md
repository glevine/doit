# shortcuts

A collection of bash scripts to make things easier.

```shell
shortcuts <subcommand1> <subcommand2> <subcommand3> ... <subcommandN>
```

## Sugar Connect

Install and configure the collabspot-cadence project for local development.

```shell
shortcuts sugarconnect cadence develop
```

Build the collabspot-cadence application locally.

```shell
shortcuts sugarconnect cadence build
```

Deploy the collabspot-cadence application remotely.

```shell
shortcuts sugarconnect cadence deploy some_branch 4 -c k8s-usw2-dev -n sugarconnect -s
```
