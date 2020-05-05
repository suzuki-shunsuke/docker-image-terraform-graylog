FROM alpine:3.11.6 AS build-env
ARG TERRAFORM_VERSION
ARG GO_GRAYLOG_VERSION
Add https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp/
Add https://github.com/suzuki-shunsuke/go-graylog/releases/download/v${GO_GRAYLOG_VERSION}/go-graylog_${GO_GRAYLOG_VERSION}_linux_amd64.tar.gz /tmp/
RUN unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN tar xvzf /tmp/go-graylog_${GO_GRAYLOG_VERSION}_linux_amd64.tar.gz

FROM alpine:3.11.6
ARG GO_GRAYLOG_VERSION
COPY --from=build-env /terraform /usr/local/bin/terraform
COPY --from=build-env /terraform-provider-graylog /root/.terraform.d/plugins/terraform-provider-graylog_v${GO_GRAYLOG_VERSION}
RUN chmod a+x /usr/local/bin/* && \
    chmod u+x /root/.terraform.d/plugins/terraform-provider-graylog_v${GO_GRAYLOG_VERSION} && \
    apk add --no-cache ca-certificates git && \
    rm -rf /var/cache/apk/*
