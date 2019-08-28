FROM alpine:3.10.2 AS build-env
ARG TERRAFORM_VERSION
ARG GO_GRAYLOG_VERSION
Add https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp/
Add https://github.com/suzuki-shunsuke/go-graylog/releases/download/v${GO_GRAYLOG_VERSION}/terraform-provider-graylog_v${GO_GRAYLOG_VERSION}_linux_amd64.gz /tmp/
RUN unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN gzip -d /tmp/terraform-provider-graylog_v${GO_GRAYLOG_VERSION}_linux_amd64.gz
RUN mv /tmp/terraform-provider-graylog_v${GO_GRAYLOG_VERSION}_linux_amd64 /tmp/terraform-provider-graylog

FROM alpine:3.10.2
ARG GO_GRAYLOG_VERSION
COPY --from=build-env /terraform /usr/local/bin/terraform
COPY --from=build-env /tmp/terraform-provider-graylog /root/.terraform.d/plugins/terraform-provider-graylog_v${GO_GRAYLOG_VERSION}
RUN chmod a+x /usr/local/bin/* && \
    chmod u+x /root/.terraform.d/plugins/terraform-provider-graylog_v${GO_GRAYLOG_VERSION} && \
    apk add --no-cache ca-certificates git && \
    rm -rf /var/cache/apk/*
