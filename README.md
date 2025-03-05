# doit

A collection of bash scripts to automate routine or unpleasant tasks.

```shell
doit <subcommand1> <subcommand2> <subcommand3> ... <subcommandN>
```

## multiverse

Build projects.

```shell
doit sugarcrm multiverse build -p connections,scloud
```

Deploy a project to the dev cluster.

```shell
doit sugarcrm multiverse deploy -p connections
```

Test projects.

```shell
doit sugarcrm multiverse test -p connections,golib
```

View projects.

```shell
# Show all resources.
doit sugarcrm multiverse view -c prod -r usw2 -p connections,cxp

# Show select resources.
doit sugarcrm multiverse view -c dev -r usw2 -w pod,job,svc -p connections
```

## Sugar Connect

Build the `collabspot-cadence` application.

```shell
doit sugarcrm connect cadence build
```

Deploy the `collabspot-cadence` application.

```shell
doit sugarcrm connect cadence deploy some_branch 4 -n sugarconnect -s
```
