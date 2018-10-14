FROM crystallang/crystal:0.26.1

WORKDIR /app/user

ADD . /app/user

RUN shards install

ENV SMTP_URL localhost:25

CMD ["crystal", "spec"]

