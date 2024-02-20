xcodebuild docbuild -scheme EasyRichText-Package -destination 'platform=iOS Simulator,name=iPhone 15' -parallelizeTargets -derivedDataPath docsData
echo "Copying DocC archives to doc_archives..."
mkdir docArchives
cp -R `find docsData -type d -name "*.doccarchive"` docArchives

# Loop over all directories ending with ".doccarchive"
for dir in docArchives/*/; do
    if [[ "$dir" == *.doccarchive/ ]]; then
        ARCHIVE=${dir%/} # Remove trailing slash
        ARCHIVE_NAME=${ARCHIVE%.doccarchive}
        echo "Processing archive: $ARCHIVE_NAME"

        $(xcrun --find docc) process-archive transform-for-static-hosting "$ARCHIVE" --hosting-base-path $ARCHIVE_NAME --output-path ./public/$ARCHIVE_NAME
    fi
done