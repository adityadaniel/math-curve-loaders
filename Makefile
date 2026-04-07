PROJECT_NAME := MathCurveLoaders
PROJECT_FILE := $(PROJECT_NAME).xcodeproj
SCHEME := MathCurveLoadersApp
CONFIGURATION := Debug
SIMULATOR_NAME := iPhone 17
DESTINATION := platform=iOS Simulator,name=$(SIMULATOR_NAME)
DERIVED_DATA := .build/DerivedData
APP_PATH := $(DERIVED_DATA)/Build/Products/$(CONFIGURATION)-iphonesimulator/$(SCHEME).app
BUNDLE_ID := com.adityadaniel.MathCurveLoaders
SWIFT_FORMAT := xcrun swift-format
SWIFT_FORMAT_CONFIG := .swift-format
SWIFT_SOURCES := MathCurveKit MathCurveLoadersApp

.PHONY: generate build run test lint format

generate:
	xcodegen generate

build: generate
	xcodebuild build \
		-project "$(PROJECT_FILE)" \
		-scheme "$(SCHEME)" \
		-configuration "$(CONFIGURATION)" \
		-destination "$(DESTINATION)" \
		-derivedDataPath "$(DERIVED_DATA)"

run: build
	open -a Simulator
	xcrun simctl boot "$(SIMULATOR_NAME)" || true
	xcrun simctl bootstatus "$(SIMULATOR_NAME)" -b
	xcrun simctl install booted "$(APP_PATH)"
	xcrun simctl launch booted "$(BUNDLE_ID)"

test: generate
	xcodebuild test \
		-project "$(PROJECT_FILE)" \
		-scheme "$(SCHEME)" \
		-destination "$(DESTINATION)"

lint:
	$(SWIFT_FORMAT) lint --strict --recursive --configuration "$(SWIFT_FORMAT_CONFIG)" $(SWIFT_SOURCES)

format:
	$(SWIFT_FORMAT) format --in-place --recursive --configuration "$(SWIFT_FORMAT_CONFIG)" $(SWIFT_SOURCES)
