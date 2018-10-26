#!/bin/bash

set -e
set -x

#if [[ "$(uname -s)" == 'Darwin' ]]; then
#
#fi
rootd=$PWD
for config in Debug Release
do
   for shared_lib in OFF ON
   do
      echo Build bzip2 ${config}-shared-${shared_lib}
      cd ${rootd}
      buildir=${config}-shared-${shared_lib}
      mkdir ${buildir}
      cd ${buildir}
      cmake -G"Unix Makefiles" ..
      make
      make test
   done
done

