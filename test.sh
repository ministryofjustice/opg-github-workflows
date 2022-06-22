#!/bin/bash

input_string='[{"name":"helloworld1", "directory":"./service-app"}, {"name":"helloworld2", "directory":"./service-app"}]'
formatted_build_command='docker build -t {0}:latest .'

chained_command=""
while read row; do
    # use jq to get name & dir
    name=$(jq -c '.name' <<< ${row})
    directory=$(jq -c '.directory' <<< ${row})
    # string ""
    name=${name//\"/}
    # sub out
    cmd=${formatted_build_command//\{0\}/$name}
    chained_command="${chained_command} ; ${cmd}"
done << EOT
$(jq -c '.[]' <<< ${input_string})
EOT

echo ${chained_command}
