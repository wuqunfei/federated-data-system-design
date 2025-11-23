docker run --name trino -d \
    -p 8080:8080 \
    --volume $PWD/etc:/etc/trino \
    --volume $PWD/data:/data/trino \
    trinodb/trino:477