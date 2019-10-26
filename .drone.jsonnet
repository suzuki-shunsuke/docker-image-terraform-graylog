local docker_plugin = 'plugins/docker:18.09.0';
local repo = 'quay.io/suzuki_shunsuke/terraform-graylog';

local build(terraform_version, graylog_version) = {
  kind: 'pipeline',
  name: 'build-' + terraform_version + '__' + graylog_version,
  steps: [
    {
      name: 'build and push docker',
      image: docker_plugin,
      settings: {
        tags: [
          graylog_version + '__' + terraform_version + '__${DRONE_TAG##v}',
          graylog_version + '__' + terraform_version,
        ],
        repo: repo,
        registry: 'quay.io',
        username: {
          from_secret: 'quayio_username',
        },
        password: {
          from_secret: 'quayio_password',
        },
        build_args: [
          'GO_GRAYLOG_VERSION=' + graylog_version,
          'TERRAFORM_VERSION=' + terraform_version,
        ],
      },
      when: {
        event: ['tag'],
      },
    }, {
      name: 'test to build docker',
      image: docker_plugin,
      settings: {
        repo: repo,
	dry_run: true,
        registry: 'quay.io',
        build_args: [
          'GO_GRAYLOG_VERSION=' + graylog_version,
          'TERRAFORM_VERSION=' + terraform_version,
        ],
      },
      when: {
        event: ['pull_request', 'push'],
      },
    },
  ],
};

[
  {
    kind: 'pipeline',
    name: 'test',
    steps: [
      {
        name: 'test .drone.yml',
        image: 'suzukishunsuke/jsonnet-check:v1.1.2-v0.1.1',
        settings: {
          format: true,
          stream: true,
        },
      },
    ],
  },
  build('0.11.14', '8.1.1'),
  build('0.12.12', '8.1.1'),
]
