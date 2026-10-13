mkdir -p build
find src -name "*.java" | xargs javac -d build
if [[ "$OSTYPE" == "darwin"* ]]; then
    find src -type f -not -name "*.java" -exec rsync -R {} build \;
else
    find src -type f -not -name "*.java" -exec cp --parents {} build \;
fi
cp -rf build/src/* build
rm -r build/src
cp README.md License.txt build
cd build
git describe > version
jar cfm ../rars.jar ./META-INF/MANIFEST.MF *
cd ..
mv rars.jar RARS_CPRE3810.jar
