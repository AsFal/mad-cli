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

.PHONY: test-unit
bin:
	@mkdir -p bin
	@GOOS=linux GOARCH=amd64 go build -o bin/mad-cli-$(VERSION)-linux-amd64 -ldflags "-X github.com/MohamedBeydoun/mad-cli/cmd.version=$(shell cat VERSION)"
	@echo "Generated bin/mad-cli-$(VERSION)-linux-amd64"
	@GOOS=windows GOARCH=amd64 go build -o bin/mad-cli-$(VERSION)-windows-amd64 -ldflags "-X github.com/MohamedBeydoun/mad-cli/cmd.version=$(shell cat VERSION)"
	@echo "Generated bin/mad-cli-$(VERSION)-windows-amd64"
	@GOOS=darwin GOARCH=amd64 go build -o bin/mad-cli-$(VERSION)-darwin-amd64 -ldflags "-X github.com/MohamedBeydoun/mad-cli/cmd.version=$(shell cat VERSION)"
	@echo "Generated bin/mad-cli-$(VERSION)-darwin-amd6"4

.PHONY: release
release: version
	@bash scripts/release.sh $(shell cat VERSION)
	@echo "Release complete!