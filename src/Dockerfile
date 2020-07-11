FROM alpine:latest
RUN apk --no-cache upgrade && \
	apk --no-cache add \
		tini \
		apg \
		rsync \
		openssh-client \
		openssh-server;
COPY start.sh /start.sh
ENTRYPOINT ["tini", "/start.sh"]
