#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

shortcuts::sugarconnect::cadence::local::ide::configure() {
    mkdir -p "${CADENCE}/.vscode"

    cat <<EOF >"${CADENCE}/.vscode/settings.json"
{
    "python.linting.enabled": true,
    "python.linting.flake8Enabled": true,
    "python.linting.pylintEnabled": true,
    "python.pythonPath": "\${env:HOME}/.pyenv/versions/${CADENCE_PYTHON_VERSION}/envs/sugarconnect@${CADENCE_PYTHON_VERSION}/bin/python"
}
EOF

    cat <<EOF >"${CADENCE}/.vscode/launch.json"
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Webserver",
            "type": "python",
            "request": "launch",
            "justMyCode": false,
            "program": "\${workspaceFolder}/backend/main/src/manage.py",
            "console": "integratedTerminal",
            "args": [
                "runsslserver",
                "0.0.0.0:28081",
                "--noreload",
                "--nothreading"
            ],
            "env": {
                "DJANGO_SETTINGS_MODULE": "config.settings.debug"
            },
            "django": true
        },
        {
            "name": "Celery Worker",
            "type": "python",
            "request": "launch",
            "program": "\${env:HOME}/.pyenv/versions/${CADENCE_PYTHON_VERSION}/envs/sugarconnect@${CADENCE_PYTHON_VERSION}/bin/celery",
            "console": "integratedTerminal",
            "cwd": "\${workspaceFolder}/backend/main/src",
            "args": [
                "--app=config.celery:app",
                "worker",
                "--loglevel=DEBUG",
                "-O",
                "fair",
                "-P",
                "solo"
            ],
            "env": {
                "DJANGO_SETTINGS_MODULE": "config.settings.debug"
            }
        },
        {
            "name": "Refresh SA Tokens",
            "type": "python",
            "request": "launch",
            "justMyCode": false,
            "program": "\${workspaceFolder}/backend/main/src/manage.py",
            "console": "integratedTerminal",
            "args": [
                "refresh_sa_tokens"
            ],
            "env": {
                "DJANGO_SETTINGS_MODULE": "config.settings.debug"
            },
            "django": true
        },
        {
            "name": "Shell Plus",
            "type": "python",
            "request": "launch",
            "justMyCode": false,
            "program": "\${workspaceFolder}/backend/main/src/manage.py",
            "console": "integratedTerminal",
            "args": [
                "shell_plus",
                "--ipython"
            ],
            "env": {
                "DJANGO_SETTINGS_MODULE": "config.settings.debug"
            },
            "django": true
        },
        {
            "name": "Integration Tests",
            "type": "python",
            "request": "launch",
            "justMyCode": false,
            "program": "\${workspaceFolder}/backend/main/src/manage.py",
            "console": "integratedTerminal",
            "args": [
                "test",
                "two_way_sync.calendar"
            ],
            "env": {
                "DJANGO_SETTINGS_MODULE": "config.settings.debug"
            },
            "django": true
        }
    ]
}
EOF
}
