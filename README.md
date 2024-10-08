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
      - boostsecurityio/boostsec-scanner#v1:
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

### `additional_args` (Optional, string)

Additional CLI args to pass to the `boost` cli.

### `api_endpoint` (Optional, string)

Overrides the API endpoint url

### `api_token` (Required, string)

The Boost Security API token secret.

**NOTE**: We recommend you not put the API token directly in your pipeline.yml
file. Intead, either expose the environment variable or refer to Builtkite's
[secrets management document](https://buildkite.com/docs/pipelines/secrets).

### `cli_version` (Optional, string)

Overrides the cli version to download when performing scans. If undefined,
this will default to pulling "1".

### `registry_module` (string)

The relative path of a module within the [scanner registry](https://github.com/boostsecurityio/scanner-registry).

### `scanner_id` (Optional, string)

Optional identifier to uniquely identify the scanner

### `scan_label` (Optional, string)

Optional identifier to identify a a monorepo component

### `scan_path` (Optional, string)

Optional path within the git repository to execute scanners in.

When this parameter is specified, you must also provide a `scan_label` to identify the component.

### `scan_diff_timeout` (Optional, number)

Optional timeout on a diff scan after which the Github check will be marked as failed. This defaults to 120 seconds.

### `scan_main_timeout` (Optional, number)

Optional timeout on a main scan after which the Github check will be marked as failed. This defaults to 2 hours.

## Developing

To run the tests:

```shell
make lint
make tests
```
