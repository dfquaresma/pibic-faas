#!/bin/bash

date
set -x

# Build model
cd model/
rm -rf target/
mvn clean install || exit $?
cd ../

# Build function
cd function/
rm -rf target/
mvn clean install  || exit $?
cd ../

# Build entrypoint
cd entrypoint/
rm -rf target/
mvn clean install  || exit $?
cd ../

