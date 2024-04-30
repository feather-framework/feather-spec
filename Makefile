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
	
docc:
	swift package --allow-writing-to-directory ./docs \
    generate-documentation --target FeatherSpec \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path https://feather-framework.github.io/feather-spec/ \
    --output-path ./docs
