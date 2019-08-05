.drone.yml: .drone.jsonnet
	drone jsonnet --format --stream
image:
	docker build --build-arg TERRAFORM_VERSION=0.12.6 --build-arg GO_GRAYLOG_VERSION=6.1.2 -t suzukishunsuke/terraform-graylog:local .
ci-local:
	drone exec --event pull_request --pipeline build
