FROM alpine:latest
RUN apk --no-cache upgrade && \
	apk --no-cache add \
		tini \
		apg \
		rsync \
		openssh-client \
		openssh-server && \
	mkdir -p /root/.ssh && \
	chown -R root:root /root && \
	find /root -type d -exec chmod 700 {} + && \
	find /root -type f -exec chmod 600 {} +;
COPY start.sh /start.sh
ENTRYPOINT ["tini", "/start.sh"]
