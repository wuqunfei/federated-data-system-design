docker run --name trino -d \
    -p 8080:8080 \
    --volume $PWD/etc:/etc/trino \
    --volume $PWD/data:/data/trino \
    -e CATALOG_MANAGEMENT=dynamic \ 
    trinodb/trino:latest