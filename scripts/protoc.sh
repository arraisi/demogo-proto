#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
KEY="$1"

case $KEY in
    -p|--path)
    PROTO_PATH="$2"
    shift # past argument
    shift # past value
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ ! $PROTO_PATH ]]; then
    echo "Please specify proto folder with -p option"
    exit 1
fi

protoc -I proto/ \
--go_out=./golang/pb --go_opt=paths=source_relative \
--go-grpc_out=./golang/pb --go-grpc_opt=paths=source_relative \
--openapiv2_out=./docs/grpc-gateway --openapiv2_opt=json_names_for_fields=false,logtostderr=true \
--doc_out=./docs/grpc/$PROTO_PATH --doc_opt=html,$PROTO_PATH.html \
proto/$PROTO_PATH/*.proto

find ./golang/pb/$PROTO_PATH -maxdepth 1 -name "*_grpc.pb.go" | while read -r file; do \
  dir=$(dirname "$file"); \
  base=$(basename "$file" _grpc.pb.go); \
  dest="mocks/$PROTO_PATH/mock_${base}.go"; \
  mockgen -source="$file" -destination="$dest"; \
done

# execute generate swagger
sh ./scripts/generate_api_doc.sh