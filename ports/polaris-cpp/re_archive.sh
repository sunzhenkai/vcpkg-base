set -e

mkdir -p objects/polaris && cd objects/polaris && ar -x ../../build64/lib/libpolaris_api.a && cd ../..
mkdir -p objects/re2 && cd objects/re2 && ar -x ../../third_party/re2/build64/libre2.a && cd ../..
mkdir -p objects/protobuf && cd objects/protobuf && ar -x ../../third_party/protobuf/build64/libprotobuf.a && cd ../..

ar crs libpolaris_api.a objects/polaris/*.o objects/protobuf/*.o objects/re2/*.o third_party/yaml-cpp/build64/*.o