FROM crystallang/crystal:0.33.0

WORKDIR /app/user

ADD . /app/user

RUN shards install

ENV SMTP_URL localhost:25

CMD ["crystal", "spec"]
