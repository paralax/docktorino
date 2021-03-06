BIN_DIR := $(GOPATH)/bin
PLATFORMS := darwin windows linux 

OS ?= darwin
VERSION ?= latest
BUMP ?= minor

BINARY := docktorino
GOVERAGE := $(BIN_DIR)/goverage 
GOLINT := $(BIN_DIR)/golint

PKGS := $(shell go list ./... | grep -v /vendor)
os = $(word 1, $@)


.PHONY: test 
test: 
	@go test $(PKGS)

$(GOLINT): 
	@go get -u golang.org/x/lint/golint

.PHONY: lint
lint: $(GOLINT)
	@echo "+ $@"
	@golint ./... | grep -v '.pb.go:' | grep -v vendor | tee /dev/stderr
	
.PHONY: vet
vet: 
	@echo "+ $@"
	@go vet $(shell go list ./... | grep -v vendor) | grep -v '.pb.go:' | tee /dev/stderr


release: 
	mkdir -p release 

.PHONY: $(PLATFORMS) 
$(PLATFORMS): 
	@- cd cmd && GOOS=$(os) GOARCH=amd64 go build -o ../release/$(BINARY)-$(VERSION)-$@-amd64

.PHONY: install 
install: releases
ifeq ($(OS),darwin)
	cp release/$(BINARY)-$(VERSION)-darwin-amd64 $(GOPATH)/bin/$(BINARY)
else ifeq ($(OS),linux)
	cp release/$(BINARY)-$(VERSION)-linux-amd64 $(GOPATH)/bin/$(BINARY)
else 
	cp release/$(BINARY)-$(VERSION)-windows-amd64 $(GOPATH)/bin/$(BINARY)
endif

# .PHONY: lint 
# lint: $(GOMETALINTER)
# 	gometalinter --disable-all --enable=errcheck --enable=vet --enable=vetshadow ...
# 	gometalinter ./... --vendor --errors

.PHONY: releases 
releases: release darwin windows linux

.PHONY: dry
dry: 
	@- cd cmd && CGO_ENABLED=0 GOOS=$(OS) GOARCH=amd64 go build -o ../$(BINARY)

.PHONY: doc 
doc: dry 
	@-./$(BINARY)  > /dev/null  2>&1 || true  

.PHONY: bumpversion 
bumpversion: 
	@- chmod +x versionutils/bumpversion.sh
	@- ./versionutils/bumpversion.sh $(PWD)/VERSION $(BUMP)
