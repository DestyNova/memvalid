FROM destynova/urweb:20250312

# build app
ADD src /app/src
ADD assets /app/assets
WORKDIR /app/src

RUN urweb memvalid -dbms sqlite -db db.sqlite -output /app/memvalid.exe
ENTRYPOINT ["/app/memvalid.exe", "-q", "-k", "-p", "10000"]
