# chores

A collection of bash scripts to automate routine or unpleasant tasks.

```shell
chores <subcommand1> <subcommand2> <subcommand3> ... <subcommandN>
```

## multiverse

Build projects.

```shell
chores sugarcrm multiverse build -p bankshot,connections,scloud
```

Deploy a project to the dev cluster.

```shell
chores sugarcrm multiverse deploy -p connections
```

Test projects.

```shell
chores sugarcrm multiverse test -p bankshot,connections,golib
```

View projects.

```shell
chores sugarcrm multiverse view -c prod -r usw2 -p bankshot,connections
```

## Sugar Connect

Build the `collabspot-cadence` application.

```shell
chores sugarcrm connect cadence build
```

Deploy the `collabspot-cadence` application.

```shell
chores sugarcrm connect cadence deploy some_branch 4 -n sugarconnect -s
```
