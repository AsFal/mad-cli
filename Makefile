VERSION := $(shell bash scripts/version.sh; cat VERSION)

.PHONY: vet
vet:
	go vet ./...

.PHONY: lint
lint:
	golint ./...

.PHONY: lint
format:
	go fmt ./...

.PHONY: verify
verify: vet lint

.PHONY: test-unit
test-unit:
	@mkdir -p .coverage
	go test -coverprofile .coverage/cover.out ./...
	@go tool cover -html=.coverage/cover.out -o .coverage/cover.html

.PHONY: test-unit
version:
	@bash scripts/version.sh
	@echo "Version: $(shell cat VERSION)"

bin-%:
	@mkdir -p bin
	@GOOS=$* GOARCH=amd64 go build -o bin/mad-cli-$(VERSION)-$*-amd64 
	@echo "Generated bin/mad-cli-$(VERSION)-$*-amd64"

.PHONY: test-unit
bin: bin-linux bin-windows bin-darwin

.PHONY: release
release: version
	@bash scripts/release.sh $(shell cat VERSION)
	@echo "Release complete!

.PHONY: run
run: bin-darwin
	@./bin/mad-cli-$(VERSION)-darwin-amd64 generate screen --app Menu --name MenuForm
