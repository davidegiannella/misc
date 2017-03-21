#! /bin/bash
set -e

# output the dependencies of a specific oak version
#
# Usage:
#    bash oak-dependencies.sh <oak-version>

CHECKOUT_DIR="oak-dep-checkout"
VERSION=$1

if [ -z "$VERSION" ]
then
    echo "ERROR Missing version. See script comment for usage details"
    exit 1
fi

if [ -e ${CHECKOUT_DIR} ]
then
    echo "Deleting previous checkout"
    rm -rf ${CHECKOUT_DIR}
fi

mkdir ${CHECKOUT_DIR}
echo "Checking out Oak ${VERSION}"
svn co -q https://svn.apache.org/repos/asf/jackrabbit/oak/tags/jackrabbit-oak-${VERSION}/oak-parent ./${CHECKOUT_DIR}/oak-parent

echo "Dependencies..."
grep "jackrabbit.version" ./${CHECKOUT_DIR}/oak-parent/pom.xml
grep "lucene.version" ./${CHECKOUT_DIR}/oak-parent/pom.xml
grep "<h2.version>" ./${CHECKOUT_DIR}/oak-parent/pom.xml
commonsmath=`grep "math3" -A 2 ./${CHECKOUT_DIR}/oak-parent/pom.xml | sed 'N; s/.*<version>\([^<]*\).*/\1/g'`
echo "    <commons.math>${commonsmath}<commons.math>"
grep "<mongo.driver.version>" ./${CHECKOUT_DIR}/oak-parent/pom.xml

echo "Deleting checkout dir"
rm -rf ${CHECKOUT_DIR}

