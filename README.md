# Boost Security Scanner BuildKite Plugin

Executes the Boost Security Scanner cli tool to scan repositories for
vulnerabilities and uploads results to the Boost API. This plugin
runs as a command hook.

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - label: "BoostSecurity Scanner"
    plugins:
      - boostsecurityio/boostsec-scanner#v3:
          api_token: 'TOKEN'
```

## Plugin versioning

The plugin may use a version pin containing either the Major, Major.Minor or Major.Minor.Patch in order to control what updates get dynamically pulled in. It is, however, important to understand that Buildkite will not pull in any updates for a plugin it has already downloaded and cached within the agent unless either the agent is restarted or the version pin is changed.

## Configuration

All pipeline options listed below may be configured either by specying the
`key:value` pair in the plugin configuration or by exporting environment
variables in your buildkite environment. All such environment variables should
be capitalized and prefixed with either `BOOST` or
`BUILDKITE_PLUGIN_BOOST_SECURITY_SCANNER`.

### `action` (Required, string)

The action to perform by the plugin:
- `scan`: Executes the BoostSecurity native scanner with a number of plugins
- `exec`: Executes a custom command which outputs Sarif to stdout.

### `additional_args` (Optional, string)

Additional CLI args to pass to the `boost` cli.

Optional arguments:
- `--partial`: Enables partial mode, allowing you to combine the results of multiple scans.

### `api_endpoint` (Optional, string)

Overrides the API endpoint url

### `api_token` (Required, string)

The Boost Security API token secret.

**NOTE**: We recommend you not put the API token directly in your pipeline.yml
file. Intead, either expose the environment variable or refer to Builtkite's
[secrets management document](https://buildkite.com/docs/pipelines/secrets).

### `cli_version` (Optional, string)

Overrides the cli version to download when performing scans. If undefined,
this will default to pulling "2.0".

### `docker_create_args` (Optional, string)

Optional additional arguments to pass to `docker create` when preparing the
scanner container.

### `exec_command` (Optional, string)

A custom command to run in by the `exec` action. This should be a command which executes a custom scanner and outputs only a Sarif document to stdout.

The value may additionally contain the `%CWD%` placeholder which will be replaced by the correct working directory during evaluation. The is especially useful when combined with volume mounts in a docker command.

### `exec_full_scan` (Optional, boolean)

By default, when performing a scan on a non-master branch, all files not having been modified as part of the PR will be deleted. This optimization may not always work for certain scanners. Enabling this option, will ensure that the `exec_command` runs against the full repository branch.

### `diff_scan_timeout` (Optional, integer)

Optional override indicating to the API how many seconds should be waited before failing the scan. This defaults to 120 seconds.

### `project_slug` (Optional, string)

Optional override for the project unique identifier. If undefined, this will
default to the relative path derived from BUILDKITE\_REPO.

### `scanner_image` (Optional, string)

Overrides the docker image url to load when performing scans

### `scanner_version` (Optional, string)

Overrides the docker image tag to load when performing scans. If undefined,
this will default to pulling the latest image from the current release channel.

### `step_name` (Optional, string)

Defines an identifier that differentiates findings uploaded by this specific
step from other potential steps. This step is **required** when using the
`exec` action.

## Developing

To run the tests:

```shell
make lint
make tests
```
