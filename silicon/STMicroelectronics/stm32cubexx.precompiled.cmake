# tag will find the precompiled library
message (STATUS "${libName}: using precompiled tag ${PRECOMPILED_TAG_${libName}}")
cpmaddpackage (
  NAME
  ${libName}
  VERSION
  ${PRECOMPILED_TAG_${libName}}
  URL
  ${PRECOMPILED_RESOURCE_${libName}}
  URL_HASH
  SHA256=${PRECOMPILED_TAG_${libName}})

find_package (${libName})
