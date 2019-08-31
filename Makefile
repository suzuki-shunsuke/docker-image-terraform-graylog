.drone.yml: .drone.jsonnet
	drone jsonnet --format --stream
image:
	docker build --build-arg TERRAFORM_VERSION=0.12.7 --build-arg GO_GRAYLOG_VERSION=7.1.0 -t suzukishunsuke/terraform-graylog:local .
ci-local:
	drone exec --event pull_request --pipeline build
