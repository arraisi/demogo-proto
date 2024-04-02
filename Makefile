generate-pb-go :
	./scripts/protoc.sh -p $(PROTO)

generate-swagger-page :
	./scripts/generate_api_doc.sh