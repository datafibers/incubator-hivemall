#!/bin/sh
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

if [ "$HIVEMALL_HOME" = "" ]; then
  if [ -e ../bin/${0##*/} ]; then
    HIVEMALL_HOME=".."
  elif [ -e ./bin/${0##*/} ]; then
    HIVEMALL_HOME="."
  else
    echo "env HIVEMALL_HOME not defined"
    exit 1
  fi
fi

set -ev

cd $HIVEMALL_HOME/spark

export MAVEN_OPTS="-XX:MaxPermSize=256m"

mvn -q scalastyle:check -pl spark-2.1 -am test

# spark-2.2 runs on Java 8+
if [[ ! -z "$(java -version 2>&1 | grep 1.8)" ]]; then
  mvn -q scalastyle:check clean -Djava.source.version=1.8 -Djava.target.version=1.8 \
    -pl spark-2.2,spark-2.3 -am test
fi

exit 0

