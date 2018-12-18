FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

COPY . /app
RUN chown -R nobody:nogroup /app

EXPOSE 4547
USER nobody
CMD [ "./up.sh" ]
