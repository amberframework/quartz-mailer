FROM drujensen/crystal:0.23.1

WORKDIR /app/user

ADD . /app/user

RUN crystal deps

ENV SMTP_URL localhost:25

CMD ["crystal", "spec"]

