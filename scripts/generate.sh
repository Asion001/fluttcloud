#!/bin/bash

# FluttCloud Serverpod Generation Script
# Usage: ./scripts/generate.sh [server|flutter|all]

target=${1:-all}

generate_server() {
    echo "🔄 Generating Serverpod protocol files..."
    cd fluttcloud_server || exit 1
    puro dart pub -v global run serverpod_cli:serverpod_cli generate
    if [ $? -eq 0 ]; then
        echo "✅ Server protocol generation completed"
    else
        echo "❌ Server protocol generation failed"
        exit 1
    fi
    cd ..
}

generate_flutter() {
    echo "🔄 Generating Flutter files..."
    cd fluttcloud_flutter || exit 1
    make pre_build
    if [ $? -eq 0 ]; then
        echo "✅ Flutter generation completed"
    else
        echo "❌ Flutter generation failed"
        exit 1
    fi
    cd ..
}

case "$target" in
    "server")
        generate_server
        ;;
    "flutter")
        generate_flutter
        ;;
    "all")
        generate_server
        generate_flutter
        ;;
    *)
        echo "Usage: ./scripts/generate.sh [server|flutter|all]"
        echo "  server  - Generate only Serverpod protocol files"
        echo "  flutter - Generate only Flutter files"
        echo "  all     - Generate both (default)"
        exit 1
        ;;
esac

echo "🎉 Generation complete!"