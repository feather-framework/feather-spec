build:
	swift build

release:
	swift build -c release
	
test:
	swift test --parallel

test-with-coverage:
	swift test --parallel --enable-code-coverage

clean:
	rm -rf .build

format:
	swift-format -i -r ./Sources && swift-format -i -r ./Tests
	
doc:
	swift package --allow-writing-to-directory ./docs \
    generate-documentation --product FeatherSpec \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path feather-spec \
    --output-path ./docs
