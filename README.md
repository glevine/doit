# chores

A collection of bash scripts to automate routine or unpleasant tasks.

```shell
chores <subcommand1> <subcommand2> <subcommand3> ... <subcommandN>
```

## multiverse

Common `multiverse` tasks (TBD).

```shell
chores sugarcrm multiverse ?
```

## Sugar Connect

Build the `collabspot-cadence` application.

```shell
chores sugarcrm connect cadence build
```

Deploy the `collabspot-cadence` application.

```shell
chores sugarcrm connect cadence deploy some_branch 4 -c k8s-usw2-dev -n sugarconnect -s
```
