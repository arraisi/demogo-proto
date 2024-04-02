#!/bin/bash

SWAGGER_DIR="./docs/grpc-gateway"

# Output directory
OUTPUT_DIR="./docs/grpc-gateway"

# Start creating the main HTML file based on the provided template
cat <<EOL > "$OUTPUT_DIR/index.html"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="description" content="SwaggerUI" />
  <title>SwaggerUI</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui.css" />
</head>
<body>
<div id="swagger-ui"></div>
<script src="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui-bundle.js" crossorigin></script>
<script src="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui-standalone-preset.js" crossorigin></script>
<script>
  window.onload = () => {
    window.ui = SwaggerUIBundle({
      urls: [
EOL

find "$SWAGGER_DIR" -name "*.swagger.json" | while read -r swagger_file; do

    relative_path=$(echo "$swagger_file" | sed "s|$SWAGGER_DIR/||g")

    echo "        {url: '/swagger-files/$relative_path', name: '$relative_path'}," >> "$OUTPUT_DIR/index.html"
done

cat <<EOL >> "$OUTPUT_DIR/index.html"
      ],
      dom_id: '#swagger-ui',
      presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIStandalonePreset
      ],
      layout: "StandaloneLayout",
      queryConfigEnabled: true,
    });
  };
</script>
</body>
</html>
EOL
