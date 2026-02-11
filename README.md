# Repository Structure Guide for SOLID Principles & Design Pattern Analysis

This document provides an overview of the sixteen repositories assigned for refactoring analysis. Each repository represents a different programming language and architectural approach, offering diverse opportunities to identify SOLID principles violations and design pattern issues.

---

## Language Index

| # | Repository | Language | Domain |
|---|-----------|----------|--------|
| 1 | [catchorg/Catch2](#1-catch2-c) | C++ | Testing Framework |
| 2 | [fasterxml/jackson-core](#2-jackson-core-java) | Java | JSON Processing |
| 3 | [alibaba/fastjson2](#3-fastjson2-java) | Java | JSON Processing |
| 4 | [elastic/logstash](#4-logstash-java--ruby) | Java/Ruby | Data Pipeline |
| 5 | [google/gson](#5-gson-java) | Java | JSON Processing |
| 6 | [GoogleContainerTools/jib](#6-jib-java) | Java | Container Tooling |
| 7 | [ankidroid/Anki-Android](#7-anki-android-kotlin) | Kotlin | Android App |
| 8 | [wordpress-mobile/WordPress-Android](#8-wordpress-android-kotlin) | Kotlin | Android App |
| 9 | [Kotlin/kotlinx.coroutines](#9-kotlinxcoroutines-kotlin) | Kotlin | Concurrency Library |
| 10 | [Kotlin/kotlinx-datetime](#10-kotlinx-datetime-kotlin) | Kotlin | Datetime Library |
| 11 | [psf/requests](#11-requests-python) | Python | HTTP Client |
| 12 | [pallets/flask](#12-flask-python) | Python | Web Framework |
| 13 | [matplotlib/matplotlib](#13-matplotlib-python) | Python | Data Visualization |
| 14 | [pydata/xarray](#14-xarray-python) | Python | N-D Arrays |
| 15 | [mwaskom/seaborn](#15-seaborn-python) | Python | Statistical Visualization |
| 16 | [pytest-dev/pytest](#16-pytest-python) | Python | Testing Framework |

---

## C++

---

## 1. Catch2 (C++)
**Repository**: `catchorg/Catch2`
**Source**: `https://github.com/catchorg/Catch2/tree/devel/src`
**Language**: C++
**Build System**: CMake / Bazel / Meson
**Purpose**: A modern, C++-native test framework for unit-tests, TDD and BDD

### Project Structure
```
Catch2/
├── CMakeLists.txt                 # CMake build configuration
├── CMakePresets.json              # CMake presets
├── meson.build                    # Meson build support
├── BUILD.bazel                    # Bazel build support
├── src/
│   └── catch2/
│       ├── catch_all.hpp          # Convenience all-in-one header
│       ├── catch_session.hpp/cpp  # Test session management
│       ├── catch_test_case_info.hpp/cpp  # Test case metadata
│       ├── internal/
│       │   ├── catch_compiler_capabilities.hpp
│       │   ├── catch_config.hpp   # Configuration options
│       │   ├── catch_context.hpp  # Global context
│       │   ├── catch_interfaces_*.hpp  # Abstraction interfaces
│       │   ├── catch_reporter_*.hpp/cpp # Reporter implementations
│       │   ├── catch_run_context.hpp/cpp
│       │   └── ...               # Various internal components
│       ├── matchers/              # Matcher implementations (Hamcrest-style)
│       ├── reporters/             # Output reporters (console, JUnit, XML...)
│       ├── generators/            # Test data generators
│       └── benchmark/             # Micro-benchmarking support
├── tests/                         # Self-tests for the framework
├── examples/                      # Example usage files
├── benchmarks/                    # Benchmark code
├── extras/                        # Extra integrations and utilities
└── docs/                          # Documentation
```

### Build & Test Commands
```bash
# Configure and build
cmake -B build -S .
cmake --build build

# Run self-tests
cd build && ctest -V

# Build with Meson
meson setup build
ninja -C build

# Single-header include (if applicable)
g++ -std=c++14 my_tests.cpp -I path/to/Catch2/src -o my_tests
./my_tests
```

### Key Design Patterns to Analyze
- **Interface Segregation**: Multiple fine-grained `IReporter`, `ITestInvoker`, `IConfig` interfaces
- **Template Method pattern**: Base reporter with overridable hooks
- **Chain of Responsibility**: Nested section and test case execution
- **Strategy pattern**: Pluggable reporter and matcher strategies
- **Composite pattern**: Nested test sections and test groups

---

## Java

---

## 2. Jackson-Core (Java)
**Repository**: `fasterxml/jackson-core`
**Source**: `https://github.com/FasterXML/jackson-core/tree/3.x/src`
**Language**: Java
**Build System**: Maven
**Purpose**: Core abstractions and JSON streaming API for the Jackson data processing library

### Project Structure
```
jackson-core/
├── pom.xml                        # Maven build configuration
├── mvnw / mvnw.cmd                # Maven wrapper
├── src/
│   ├── main/
│   │   └── java/
│   │       └── com/fasterxml/jackson/core/
│   │           ├── JsonFactory.java       # Factory for creating parsers/generators
│   │           ├── JsonParser.java        # Streaming JSON parser (abstract)
│   │           ├── JsonGenerator.java     # Streaming JSON generator (abstract)
│   │           ├── JsonToken.java         # Token types enumeration
│   │           ├── TreeNode.java          # Tree model base interface
│   │           ├── ObjectCodec.java       # Bridge to databind
│   │           ├── io/                    # I/O abstractions
│   │           ├── json/                  # JSON-specific parser/generator impls
│   │           ├── sym/                   # Symbol tables (name caching)
│   │           ├── util/                  # Utility classes
│   │           ├── type/                  # Type handling
│   │           └── format/                # Data format abstractions
│   └── test/
│       └── java/                          # JUnit test suites
├── release-notes/                         # Changelog per version
└── docs/                                  # Documentation
```

### Build & Test Commands
```bash
# Build the project
./mvnw clean install

# Run tests only
./mvnw test

# Run a specific test class
./mvnw test -Dtest=TestJsonParser

# Generate coverage report
./mvnw jacoco:report

# Skip tests for quick build
./mvnw clean install -DskipTests
```

### Key Design Patterns to Analyze
- **Factory pattern**: `JsonFactory` creating parsers and generators
- **Template Method pattern**: Abstract `JsonParser`/`JsonGenerator` with concrete subclasses
- **Strategy pattern**: Pluggable input/output decorators
- **Flyweight pattern**: Symbol table caching for repeated field names
- **Open/Closed Principle**: Feature flags enum for extensible configuration

---

## 3. Fastjson2 (Java)
**Repository**: `alibaba/fastjson2`
**Source**: `https://github.com/alibaba/fastjson2/tree/main/core`
**Language**: Java
**Build System**: Maven
**Purpose**: A fast, feature-rich JSON library for Java with improved security and performance over fastjson v1

### Project Structure
```
fastjson2/
├── pom.xml                        # Root Maven POM
├── core/                          # Core fastjson2 library (primary module)
│   └── src/
│       └── main/java/com/alibaba/fastjson2/
│           ├── JSON.java              # Main public API entry point
│           ├── JSONArray.java         # JSON array model
│           ├── JSONObject.java        # JSON object model
│           ├── JSONReader.java        # Streaming reader (abstract)
│           ├── JSONWriter.java        # Streaming writer (abstract)
│           ├── JSONFactory.java       # Factory for readers/writers
│           ├── reader/                # Reader implementations (UTF-8, UTF-16...)
│           ├── writer/                # Writer implementations
│           ├── codec/                 # Type-specific codecs
│           ├── filter/                # Serialization filters
│           ├── annotation/            # Custom annotations
│           └── support/               # Framework integrations
├── kotlin/                        # Kotlin extensions
├── fastjson1-compatible/          # Compatibility layer for fastjson v1
├── extension/                     # General extensions
├── extension-spring5/             # Spring 5 integration
├── extension-spring6/             # Spring 6 integration
├── codegen/                       # Code generation utilities
└── benchmark/                     # Performance benchmarks
```

### Build & Test Commands
```bash
# Build the full project
./mvnw clean install

# Build only the core module
./mvnw clean install -pl core

# Run tests
./mvnw test -pl core

# Run benchmarks (JMH)
./mvnw clean install -pl benchmark -P benchmark
java -jar benchmark/target/benchmarks.jar

# Run with specific JDK
./mvnw test -pl core -Djava.version=17
```

### Key Design Patterns to Analyze
- **Factory pattern**: `JSONFactory` for reader/writer instantiation
- **Strategy pattern**: Pluggable type codecs and serialization filters
- **Adapter pattern**: `fastjson1-compatible` backwards compatibility layer
- **Template Method pattern**: Abstract reader/writer with format-specific subclasses
- **Open/Closed Principle**: Extension modules without modifying core

---

## 4. Logstash (Java / Ruby)
**Repository**: `elastic/logstash`
**Source**: `https://github.com/elastic/logstash/tree/main/logstash-core/src/main/java`
**Language**: Java (core), Ruby (pipeline DSL)
**Build System**: Gradle (Java), Rake (Ruby orchestration)
**Purpose**: Server-side data processing pipeline that ingests, transforms, and ships data

### Project Structure
```
logstash/
├── build.gradle                   # Gradle build configuration
├── settings.gradle
├── Rakefile                       # Rake orchestration tasks
├── logstash-core/
│   ├── src/main/java/
│   │   └── org/logstash/
│   │       ├── config/ir/         # Intermediate representation (IR) compiler
│   │       │   ├── compiler/      # Pipeline compiler
│   │       │   ├── graph/         # Pipeline graph representation
│   │       │   └── imperative/    # Imperative pipeline components
│   │       ├── plugins/           # Plugin management
│   │       ├── ackedqueue/        # Persistent queue implementation
│   │       ├── common/            # Common utilities and models
│   │       ├── ext/               # JRuby extension bridge
│   │       └── log4j2/            # Logging support
│   └── lib/                       # Core Ruby library files
├── lib/
│   ├── bootstrap/                 # Bootstrap initialization code
│   ├── pluginmanager/             # Plugin lifecycle manager
│   └── secretstore/               # Secret management
├── config/                        # Default configuration files
│   ├── logstash.yml
│   ├── pipelines.yml
│   └── log4j2.properties
├── bin/                           # CLI scripts
├── qa/                            # QA and integration tests
└── docker/                        # Docker build files
```

### Build & Test Commands
```bash
# Build the Java core
./gradlew :logstash-core:assemble

# Run Java unit tests
./gradlew :logstash-core:test

# Run specific Java test
./gradlew :logstash-core:test --tests "org.logstash.config.ir.*"

# Run Ruby/integration tests
rake test:unit
rake test:integration

# Run all tests
rake test

# Build a distribution tarball
./gradlew :distribution:archives:tar:assemble
```

### Key Design Patterns to Analyze
- **Pipeline pattern**: Input → Filter → Output processing pipeline
- **Plugin architecture**: Fully decoupled plugin system (SRP / OCP)
- **Interpreter pattern**: IR compiler for pipeline DSL
- **Graph pattern**: DAG representation of pipeline topology
- **Bridge pattern**: JRuby bridge between Java core and Ruby plugins

---

## 5. Gson (Java)
**Repository**: `google/gson`
**Source**: `https://github.com/google/gson/tree/main/gson/src/main`
**Language**: Java
**Build System**: Maven
**Purpose**: A Java library for serializing and deserializing Java objects to and from JSON

### Project Structure
```
gson/
├── pom.xml                        # Root Maven POM
├── gson/                          # Main Gson library module
│   └── src/
│       ├── main/java/com/google/gson/
│       │   ├── Gson.java              # Main API class
│       │   ├── GsonBuilder.java       # Builder for Gson instances
│       │   ├── JsonElement.java       # Abstract base for JSON tree nodes
│       │   ├── JsonObject.java        # JSON object tree node
│       │   ├── JsonArray.java         # JSON array tree node
│       │   ├── JsonPrimitive.java     # JSON primitive tree node
│       │   ├── TypeAdapter.java       # Read/write adapter (abstract)
│       │   ├── TypeAdapterFactory.java # Factory for type adapters
│       │   ├── annotations/           # @SerializedName, @Expose, etc.
│       │   ├── internal/              # Internal type resolution utilities
│       │   ├── reflect/               # Reflection-based adapters
│       │   └── stream/                # JsonReader and JsonWriter (streaming)
│       └── test/java/                 # JUnit tests
├── extras/                        # Extra utilities and extensions
├── proto/                         # Protocol Buffers integration
└── metrics/                       # Performance metrics module
```

### Build & Test Commands
```bash
# Build the project
./mvnw clean install

# Run tests
./mvnw test

# Run tests for a specific module
./mvnw test -pl gson

# Run a specific test class
./mvnw test -pl gson -Dtest=GsonTest

# Generate Javadoc
./mvnw javadoc:javadoc

# Run with coverage
./mvnw test jacoco:report
```

### Key Design Patterns to Analyze
- **Builder pattern**: `GsonBuilder` for configuring Gson instances
- **Factory pattern**: `TypeAdapterFactory` chain for adapter resolution
- **Strategy pattern**: Pluggable `TypeAdapter` per Java type
- **Composite pattern**: `JsonElement` tree (object, array, primitive)
- **Chain of Responsibility**: Ordered `TypeAdapterFactory` resolution chain

---

## 6. Jib (Java)
**Repository**: `GoogleContainerTools/jib`
**Source**: `https://github.com/GoogleContainerTools/jib`
**Language**: Java
**Build System**: Gradle
**Purpose**: Build optimized OCI/Docker container images for Java applications without a Docker daemon

### Project Structure
```
jib/
├── build.gradle                   # Root Gradle build
├── settings.gradle
├── jib-core/                      # Core library (build-tool-agnostic)
│   └── src/main/java/
│       └── com/google/cloud/tools/jib/
│           ├── api/               # Public API surface
│           ├── builder/           # Image build orchestration
│           ├── cache/             # Layer caching mechanism
│           ├── configuration/     # Build configuration models
│           ├── docker/            # Docker daemon client
│           ├── image/             # Image and layer models
│           ├── registry/          # OCI registry client
│           └── tar/               # Tar archive utilities
├── jib-gradle-plugin/             # Gradle plugin
│   └── src/main/java/
├── jib-maven-plugin/              # Maven plugin
│   └── src/main/java/
├── jib-cli/                       # CLI tool
│   └── src/main/java/
├── jib-plugins-common/            # Shared plugin functionality
│   └── src/main/java/
└── jib-build-plan/                # Build plan API (SPI)
    └── src/main/java/
```

### Build & Test Commands
```bash
# Build all modules
./gradlew build

# Run tests for core module
./gradlew :jib-core:test

# Run tests for Gradle plugin
./gradlew :jib-gradle-plugin:test

# Run integration tests
./gradlew :jib-core:integrationTest

# Run a specific test class
./gradlew :jib-core:test --tests "com.google.cloud.tools.jib.api.*"

# Build the CLI tool
./gradlew :jib-cli:assemble
```

### Key Design Patterns to Analyze
- **Builder pattern**: Fluent API for constructing `Containerizer` and image configs
- **Strategy pattern**: Pluggable `RegistryClient`, `DockerClient`, and `TarClient` targets
- **Layered architecture**: Strict separation between `jib-core`, plugins, and CLI
- **Cache pattern**: Content-addressable layer cache to avoid redundant pushes
- **Dependency Inversion**: `jib-build-plan` SPI decoupling core from build tools

---

## Kotlin

---

## 7. Anki-Android (Kotlin)
**Repository**: `ankidroid/Anki-Android`
**Source**: `https://github.com/ankidroid/Anki-Android/tree/main/AnkiDroid/src/main/java/com/ichi2`
**Language**: Kotlin (primary), Java
**Build System**: Gradle (Kotlin DSL)
**Purpose**: Open-source Android flashcard app using spaced repetition (SRS) for memorization

### Project Structure
```
Anki-Android/
├── build.gradle.kts               # Root build script
├── settings.gradle.kts
├── AnkiDroid/                     # Main application module
│   └── src/main/java/com/ichi2/
│       ├── anki/                  # Main application screens/activities
│       │   ├── DeckPicker.kt      # Main deck list screen
│       │   ├── Reviewer.kt        # Card review screen
│       │   ├── CardBrowser.kt     # Card browser
│       │   └── ...
│       ├── libanki/               # Anki library (collection, cards, decks)
│       │   ├── Collection.kt      # Core collection model
│       │   ├── Card.kt
│       │   ├── Deck.kt
│       │   └── ...
│       ├── ui/                    # Reusable UI components
│       ├── utils/                 # Utility classes
│       └── preferences/           # Settings and preferences
├── api/                           # Public API module for integrations
├── common/                        # Shared/common code module
├── libanki/                       # Anki library backend module
└── annotations/                   # Custom annotations
```

### Build & Test Commands
```bash
# Build debug APK
./gradlew assembleDebug

# Run unit tests
./gradlew :AnkiDroid:testDebugUnitTest

# Run instrumented tests (requires device/emulator)
./gradlew :AnkiDroid:connectedDebugAndroidTest

# Run lint checks
./gradlew :AnkiDroid:lint

# Run a specific test class
./gradlew :AnkiDroid:testDebugUnitTest --tests "com.ichi2.anki.CardBrowserTest"
```

### Key Design Patterns to Analyze
- **Repository pattern**: `Collection` as central data repository abstraction
- **MVVM pattern**: ViewModels with LiveData/StateFlow for UI state
- **Coroutines pattern**: Structured concurrency for database/network operations
- **Observer pattern**: LiveData and Flow for reactive data binding
- **Single Responsibility violations**: Large Activity classes mixing UI and business logic

---

## 8. WordPress-Android (Kotlin)
**Repository**: `wordpress-mobile/WordPress-Android`
**Source**: `https://github.com/wordpress-mobile/WordPress-Android/tree/trunk/WordPress/src/main/java/org/wordpress/android`
**Language**: Kotlin (primary), Java
**Build System**: Gradle
**Purpose**: Official WordPress Android app for publishing and managing WordPress sites

### Project Structure
```
WordPress-Android/
├── build.gradle                   # Root build script
├── settings.gradle
├── WordPress/                     # Main application module
│   └── src/main/java/org/wordpress/android/
│       ├── ui/                    # UI layer (Fragments, Activities, ViewModels)
│       │   ├── main/              # Main navigation
│       │   ├── posts/             # Posts management
│       │   ├── pages/             # Pages management
│       │   ├── stats/             # Site statistics
│       │   ├── reader/            # Reader feed
│       │   └── ...
│       ├── viewmodel/             # ViewModels (MVVM)
│       ├── fluxc/                 # Flux architecture store bridge
│       ├── networking/            # Network layer (Volley/Retrofit)
│       ├── push/                  # Push notification handling
│       ├── analytics/             # Analytics events
│       └── util/                  # Utility classes
├── libs/                          # Shared library modules
└── config/                        # Build/variant configuration
```

### Build & Test Commands
```bash
# Build debug APK
./gradlew assembleVanillaDebug

# Run unit tests
./gradlew testVanillaDebugUnitTest

# Run instrumented tests (requires device/emulator)
./gradlew connectedVanillaDebugAndroidTest

# Run lint
./gradlew lintVanillaDebug

# Run a specific test
./gradlew testVanillaDebugUnitTest --tests "org.wordpress.android.ui.posts.*"
```

### Key Design Patterns to Analyze
- **Flux architecture**: Unidirectional data flow via FluxC dispatcher/store
- **MVVM pattern**: ViewModels with LiveData throughout the UI layer
- **Repository pattern**: Data layer abstraction over REST API and local DB
- **Dependency Injection**: Dagger/Hilt for component wiring
- **Large class violations**: God Activities/Fragments accumulating responsibilities

---

## 9. kotlinx.coroutines (Kotlin)
**Repository**: `Kotlin/kotlinx.coroutines`
**Source**: `https://github.com/Kotlin/kotlinx.coroutines/tree/master/kotlinx-coroutines-core`
**Language**: Kotlin
**Build System**: Gradle (Kotlin DSL)
**Purpose**: Library support for Kotlin coroutines — structured concurrency, channels, flows, and more

### Project Structure
```
kotlinx.coroutines/
├── build.gradle.kts               # Root build script
├── settings.gradle.kts
├── kotlinx-coroutines-core/       # Core coroutines module (main source)
│   └── common/src/
│       └── kotlinx/coroutines/
│           ├── Builders.common.kt    # launch, async, runBlocking
│           ├── CoroutineScope.kt     # Scope interface & extensions
│           ├── Dispatchers.kt        # Default, IO, Main dispatchers
│           ├── Job.kt                # Job and lifecycle management
│           ├── channels/             # Channel implementations
│           │   ├── Channel.kt
│           │   ├── BufferedChannel.kt
│           │   └── ...
│           ├── flow/                 # Flow (cold stream) implementations
│           │   ├── Flow.kt
│           │   ├── operators/        # Flow operators (map, filter, zip...)
│           │   └── ...
│           └── internal/             # Internal scheduler & concurrency machinery
├── kotlinx-coroutines-test/       # Testing utilities (runTest, etc.)
├── kotlinx-coroutines-debug/      # Debug utilities
├── reactive/                      # Reactive streams bridge modules
├── ui/                            # UI dispatcher integrations (Android, JavaFx)
└── benchmarks/                    # JMH benchmarks
```

### Build & Test Commands
```bash
# Build all modules
./gradlew build

# Run tests for core module
./gradlew :kotlinx-coroutines-core:test

# Run tests for test utilities
./gradlew :kotlinx-coroutines-test:test

# Run all tests
./gradlew allTests

# Run JMH benchmarks
./gradlew :benchmarks:jmh

# Run a specific test class
./gradlew :kotlinx-coroutines-core:test --tests "kotlinx.coroutines.ChannelTest"
```

### Key Design Patterns to Analyze
- **Coroutine scope pattern**: Structured concurrency via scoping hierarchy
- **Strategy pattern**: Swappable `CoroutineDispatcher` implementations
- **Decorator/Wrapper pattern**: `CoroutineContext` element composition
- **Producer-Consumer pattern**: Channels for inter-coroutine communication
- **Pipeline pattern**: Flow operators forming composable data pipelines

---

## 10. kotlinx-datetime (Kotlin)
**Repository**: `Kotlin/kotlinx-datetime`
**Source**: `https://github.com/Kotlin/kotlinx-datetime/tree/master/core`
**Language**: Kotlin (Multiplatform)
**Build System**: Gradle (Kotlin DSL)
**Purpose**: A Kotlin Multiplatform library for working with dates and times across JVM, JS, and Native

### Project Structure
```
kotlinx-datetime/
├── build.gradle.kts               # Root build script
├── settings.gradle.kts
├── core/                          # Core datetime library (main module)
│   └── commonMain/src/
│       └── kotlinx/datetime/
│           ├── Instant.kt             # Absolute moment in time
│           ├── LocalDate.kt           # Date without timezone
│           ├── LocalDateTime.kt       # Date + time without timezone
│           ├── LocalTime.kt           # Time without date/timezone
│           ├── TimeZone.kt            # Timezone representation
│           ├── DateTimePeriod.kt      # Duration in calendar units
│           ├── DateTimeUnit.kt        # Units (days, months, hours...)
│           ├── Clock.kt               # Abstraction for current time
│           ├── format/                # Parsing and formatting
│           │   ├── DateTimeFormat.kt
│           │   └── ...
│           └── internal/              # Platform-bridging internals
├── timezones/                     # Timezone data module
├── benchmarks/                    # Performance benchmarks
└── integration-testing/           # Integration tests
```

### Build & Test Commands
```bash
# Build all targets
./gradlew build

# Run JVM tests
./gradlew :core:jvmTest

# Run JS tests
./gradlew :core:jsTest

# Run all multiplatform tests
./gradlew :core:allTests

# Run a specific test
./gradlew :core:jvmTest --tests "kotlinx.datetime.InstantTest"

# Run benchmarks
./gradlew :benchmarks:jvmBenchmark
```

### Key Design Patterns to Analyze
- **Value Object pattern**: Immutable date/time types (`Instant`, `LocalDate`, etc.)
- **Strategy pattern**: Platform-specific `TimeZone` implementations behind a common interface
- **Factory/Companion Object pattern**: `Clock.System`, `TimeZone.UTC` as named instances
- **Interface Segregation**: Separate `Clock` interface allowing testable time injection
- **Expect/Actual pattern**: Multiplatform abstraction over platform-native date APIs

---

## Python

---

## 11. Requests (Python)
**Repository**: `psf/requests`
**Source**: `https://github.com/psf/requests/tree/main/src/requests`
**Tests**: `https://github.com/psf/requests/tree/main/tests`
**Language**: Python
**Build System**: setuptools / pip
**Purpose**: Simple, elegant HTTP library for Python

### Project Structure
```
requests/
├── setup.py                       # Package configuration
├── setup.cfg
├── pyproject.toml                 # Modern Python packaging
├── src/
│   └── requests/
│       ├── __init__.py            # Package initialization
│       ├── api.py                 # Public API (get, post, put, etc.)
│       ├── sessions.py            # Session management & connection pooling
│       ├── models.py              # PreparedRequest & Response models
│       ├── adapters.py            # Transport adapters (HTTPAdapter)
│       ├── auth.py                # Authentication handlers
│       ├── cookies.py             # Cookie jar and handling
│       ├── exceptions.py          # Custom exception hierarchy
│       ├── hooks.py               # Event hook system
│       ├── structures.py          # CaseInsensitiveDict, etc.
│       ├── utils.py               # Utility functions
│       ├── status_codes.py        # HTTP status code lookup
│       ├── compat.py              # Python compatibility shims
│       └── certs.py               # SSL certificate handling
└── tests/
    ├── conftest.py
    ├── test_requests.py
    ├── test_hooks.py
    ├── test_lowlevel.py
    ├── test_structures.py
    └── test_utils.py
```

### Build & Test Commands
```bash
# Create and activate virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install in development mode
pip install -e ".[dev]"

# Run all tests
pytest tests/

# Run a specific test file
pytest tests/test_requests.py

# Run with coverage
pytest --cov=requests tests/

# Run linting
flake8 src/requests
```

### Key Design Patterns to Analyze
- **Session pattern**: Connection pooling and persistent cookie jar
- **Adapter pattern**: `HTTPAdapter` abstracting `urllib3` transport
- **Hook system**: Event-based extensibility without subclassing
- **Builder pattern**: `PreparedRequest` separating request preparation from dispatch
- **Facade pattern**: High-level `api.py` wrapping the `Session` internals

---

## 12. Flask (Python)
**Repository**: `pallets/flask`
**Source**: `https://github.com/pallets/flask/tree/main/src/flask`
**Tests**: `https://github.com/pallets/flask/tree/main/tests`
**Language**: Python
**Build System**: setuptools / pip
**Purpose**: Lightweight WSGI web application framework

### Project Structure
```
flask/
├── pyproject.toml                 # Modern Python packaging
├── src/
│   └── flask/
│       ├── __init__.py            # Public API surface & Flask class export
│       ├── app.py                 # Main Flask application class
│       ├── blueprints.py          # Blueprint for modular applications
│       ├── cli.py                 # Command-line interface (flask run, etc.)
│       ├── config.py              # Configuration management
│       ├── ctx.py                 # Application & request context machinery
│       ├── globals.py             # Thread-local proxies (g, request, session)
│       ├── helpers.py             # url_for, flash, send_file, etc.
│       ├── sessions.py            # Client-side session handling
│       ├── signals.py             # Blinker-based signal hooks
│       ├── templating.py          # Jinja2 environment integration
│       ├── testing.py             # FlaskClient test helper
│       ├── views.py               # Class-based views (MethodView)
│       ├── wrappers.py            # Request/Response wrappers
│       └── json/                  # JSON provider abstraction
└── tests/
    ├── conftest.py
    ├── test_basic.py
    ├── test_blueprints.py
    ├── test_appctx.py
    ├── test_config.py
    ├── test_session.py
    ├── test_signals.py
    ├── test_templating.py
    └── test_views.py
```

### Build & Test Commands
```bash
# Create and activate virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install in development mode
pip install -e ".[dev]"

# Run all tests
pytest tests/

# Run a specific test file
pytest tests/test_blueprints.py

# Run with coverage
pytest --cov=flask tests/

# Run linting
flake8 src/flask
```

### Key Design Patterns to Analyze
- **Application Factory pattern**: `create_app()` for testable, configurable instances
- **Blueprint pattern**: Modular sub-application components
- **Context Locals**: Thread/async-local proxies for `request`, `g`, `session`
- **Decorator pattern**: `@app.route`, `@app.before_request` for route/lifecycle hooks
- **Observer pattern**: Blinker signals for decoupled event notification

---

## 13. Matplotlib (Python)
**Repository**: `matplotlib/matplotlib`
**Source**: `https://github.com/matplotlib/matplotlib/tree/main/lib/matplotlib`
**Language**: Python (C extensions for performance)
**Build System**: setuptools / Meson
**Purpose**: Comprehensive library for creating static, animated, and interactive visualizations in Python

### Project Structure
```
matplotlib/
├── pyproject.toml
├── setup.py
├── lib/matplotlib/
│   ├── __init__.py                # Top-level API (pyplot, patches, etc.)
│   ├── figure.py                  # Figure class (top-level artist container)
│   ├── axes/                      # Axes class (the actual plot area)
│   │   ├── _axes.py               # Core Axes implementation (very large class)
│   │   ├── _base.py               # Base Axes class
│   │   └── _secondary_axes.py
│   ├── artist.py                  # Base Artist class (everything drawable)
│   ├── backend_bases.py           # Abstract backend interface
│   ├── backends/                  # Rendering backends
│   │   ├── backend_agg.py         # Rasterized (PNG) backend
│   │   ├── backend_svg.py         # SVG backend
│   │   ├── backend_pdf.py         # PDF backend
│   │   └── ...
│   ├── patches.py                 # Shape artists (Rectangle, Circle, etc.)
│   ├── lines.py                   # Line2D artist
│   ├── text.py                    # Text artist
│   ├── transforms.py              # Transformation framework
│   ├── colors.py                  # Color normalization and mapping
│   ├── cm.py                      # Colormaps
│   ├── ticker.py                  # Tick locators and formatters
│   ├── legend.py                  # Legend artist
│   ├── image.py                   # Image artists
│   ├── pyplot.py                  # Stateful pyplot interface
│   ├── style/                     # Style sheets
│   ├── animation.py               # Animation framework
│   ├── testing/                   # Test utilities
│   └── tests/                     # Test suite
└── src/                           # C/C++ extension source files
```

### Build & Test Commands
```bash
# Install in development mode (compiles C extensions)
pip install -e ".[dev]" --no-build-isolation

# Run all tests
pytest lib/matplotlib/tests/

# Run a specific test module
pytest lib/matplotlib/tests/test_axes.py

# Run with coverage
pytest --cov=matplotlib lib/matplotlib/tests/

# Run image comparison tests
pytest lib/matplotlib/tests/ -m "not network"

# Build documentation
cd doc && make html
```

### Key Design Patterns to Analyze
- **Composite pattern**: `Artist` hierarchy — `Figure` → `Axes` → `Line2D`, `Patch`, etc.
- **Strategy pattern**: Swappable rendering backends sharing `RendererBase`
- **Template Method pattern**: `Artist.draw()` framework with subclass-specific rendering
- **Observer pattern**: Event system for interactive plot callbacks
- **God class violation**: `_axes.py` with thousands of lines mixing many concerns

---

## 14. xarray (Python)
**Repository**: `pydata/xarray`
**Source**: `https://github.com/pydata/xarray/tree/main/xarray`
**Language**: Python
**Build System**: setuptools / pip
**Purpose**: N-D labeled arrays and datasets for scientific computing (extends NumPy with labels and metadata)

### Project Structure
```
xarray/
├── pyproject.toml
├── xarray/
│   ├── __init__.py                # Public API exports
│   ├── core/
│   │   ├── dataarray.py           # DataArray (labeled N-D array)
│   │   ├── dataset.py             # Dataset (dict of DataArrays)
│   │   ├── variable.py            # Variable (core array with dims)
│   │   ├── coordinates.py         # Coordinate management
│   │   ├── indexing.py            # Label-based indexing
│   │   ├── computation.py         # apply_ufunc and computation
│   │   ├── arithmetic.py          # Arithmetic operation mixins
│   │   ├── ops.py                 # Operator implementations
│   │   ├── resample.py            # Resampling operations
│   │   ├── rolling.py             # Rolling window operations
│   │   ├── groupby.py             # GroupBy operations
│   │   ├── merge.py               # Merge and alignment
│   │   └── common.py              # Shared mixin base classes
│   ├── backends/                  # I/O backends (NetCDF, Zarr, HDF5...)
│   │   ├── netCDF4_.py
│   │   ├── zarr.py
│   │   └── ...
│   ├── coding/                    # CF conventions encoding/decoding
│   ├── plot/                      # Plotting interface (wraps Matplotlib)
│   └── tests/                     # Test suite
```

### Build & Test Commands
```bash
# Install in development mode
pip install -e ".[dev]"

# Run all tests
pytest xarray/tests/

# Run a specific test module
pytest xarray/tests/test_dataset.py

# Run with coverage
pytest --cov=xarray xarray/tests/

# Run with parallel execution
pytest -n auto xarray/tests/

# Type checking
mypy xarray/
```

### Key Design Patterns to Analyze
- **Mixin pattern**: `Common`, `Arithmetic`, `Ops` mixins composing `DataArray`/`Dataset` behavior
- **Facade pattern**: `DataArray` and `Dataset` wrapping lower-level `Variable` and indexing logic
- **Strategy pattern**: Pluggable I/O backends for reading/writing different file formats
- **Decorator pattern**: `apply_ufunc` wrapping NumPy ufuncs for labeled arrays
- **Liskov violations**: Subtle behavioral differences between `Dataset` and `DataArray` shared methods

---

## 15. Seaborn (Python)
**Repository**: `mwaskom/seaborn`
**Source**: `https://github.com/mwaskom/seaborn/tree/master/seaborn`
**Tests**: `https://github.com/mwaskom/seaborn/tree/master/tests`
**Language**: Python
**Build System**: setuptools / pip
**Purpose**: Statistical data visualization library built on Matplotlib with a high-level interface

### Project Structure
```
seaborn/
├── pyproject.toml
├── seaborn/
│   ├── __init__.py                # Public API exports
│   ├── axisgrid.py                # FacetGrid and PairGrid (multi-axes layouts)
│   ├── relational.py              # relplot, scatterplot, lineplot
│   ├── distributions.py           # displot, histplot, kdeplot, ecdfplot
│   ├── categorical.py             # catplot, boxplot, violinplot, barplot, etc.
│   ├── regression.py              # lmplot, regplot, residplot
│   ├── matrix.py                  # heatmap, clustermap
│   ├── miscplot.py                # rugplot, dogplot
│   ├── _core/                     # New declarative Objects API (v0.12+)
│   │   ├── plot.py                # Plot class (entry point)
│   │   ├── scales.py              # Scale abstractions
│   │   ├── rules.py               # Statistical transformations
│   │   ├── moves.py               # Position adjustments
│   │   └── ...
│   ├── _stats/                    # Statistical computation layer
│   ├── palettes.py                # Color palette management
│   ├── utils.py                   # Shared utility functions
│   └── _compat.py                 # Compatibility shims
└── tests/
    ├── test_axisgrid.py
    ├── test_relational.py
    ├── test_categorical.py
    └── ...
```

### Build & Test Commands
```bash
# Install in development mode
pip install -e ".[dev]"

# Run all tests
pytest tests/

# Run a specific test file
pytest tests/test_categorical.py

# Run with coverage
pytest --cov=seaborn tests/

# Run image comparison tests
pytest tests/ --mpl

# Run linting
flake8 seaborn/
```

### Key Design Patterns to Analyze
- **Facade pattern**: High-level figure-level functions wrapping `FacetGrid` and `Axes`
- **Template Method pattern**: `VectorPlotter` base class with overridable plot-type hooks
- **Composite pattern**: `FacetGrid` and `PairGrid` managing multiple Axes subplots
- **Strategy pattern**: New `_core` Objects API with swappable `Scale`, `Stat`, and `Move` components
- **God object violations**: Large plotting modules combining data wrangling, stat computation, and rendering

---

## 16. pytest (Python)
**Repository**: `pytest-dev/pytest`
**Source**: `https://github.com/pytest-dev/pytest/tree/main/src/_pytest`
**Tests**: `https://github.com/pytest-dev/pytest/tree/main/testing`
**Language**: Python
**Build System**: setuptools / pip (Hatch)
**Purpose**: A mature, feature-rich Python testing framework with minimal boilerplate

### Project Structure
```
pytest/
├── pyproject.toml
├── src/
│   └── _pytest/
│       ├── __init__.py
│       ├── config/                # Configuration & INI parsing
│       │   ├── __init__.py        # Config class (central orchestrator)
│       │   ├── argparsing.py      # CLI argument parsing
│       │   └── findpaths.py       # Root and config file discovery
│       ├── python.py              # Python test collection (Module, Class, Function)
│       ├── runner.py              # Test item execution and outcome reporting
│       ├── fixtures.py            # Fixture system (dependency injection for tests)
│       ├── hookspec.py            # Hook specifications (plugin API contracts)
│       ├── hookimpl.py            # Hook implementation markers
│       ├── main.py                # Entry point and session orchestration
│       ├── nodes.py               # Test node hierarchy (Session, Module, Item)
│       ├── outcomes.py            # Passed, Failed, Skipped outcomes
│       ├── mark/                  # @pytest.mark system
│       ├── assertion/             # Assertion introspection and rewriting
│       │   ├── rewrite.py         # AST rewriter for rich assertion messages
│       │   └── ...
│       ├── capture.py             # stdout/stderr/fd capture
│       ├── logging.py             # Log capture and reporting
│       ├── reports.py             # TestReport data model
│       ├── terminal.py            # Terminal reporter
│       ├── junitxml.py            # JUnit XML reporter
│       ├── tmpdir.py              # tmp_path fixture implementation
│       └── monkeypatch.py         # monkeypatch fixture implementation
└── testing/                       # Tests for pytest itself
    ├── test_config.py
    ├── test_collection.py
    ├── test_fixtures.py
    └── ...
```

### Build & Test Commands
```bash
# Install in development mode
pip install -e ".[dev]"

# Run pytest's own test suite
pytest testing/

# Run a specific test file
pytest testing/test_fixtures.py

# Run with coverage
pytest --cov=_pytest testing/

# Run a specific test by keyword
pytest testing/ -k "test_fixture_scope"

# Run with verbose output
pytest testing/ -v

# Type checking
mypy src/_pytest/
```

### Key Design Patterns to Analyze
- **Plugin/Hook pattern**: `pluggy`-based hook specification and implementation for deep extensibility
- **Composite pattern**: `Session` → `Module` → `Class` → `Function` node tree
- **Dependency Injection pattern**: Fixture system provides dependencies to test functions by name
- **Chain of Responsibility**: Hook call chains allowing plugins to intercept and transform behavior
- **Open/Closed Principle**: All major behaviors (collection, reporting, fixtures) extensible via plugins without modifying core

---

## General Analysis Workflow

### Step 1: Understand the Codebase
1. Read the README and documentation
2. Understand the build system and dependency management
3. Run the tests to ensure everything works before touching any code
4. Identify the main entry points and core abstractions

### Step 2: Identify Violations
1. **Large Classes/Functions**: Look for classes/functions with too many responsibilities
2. **Tight Coupling**: Identify classes that depend heavily on concrete implementations
3. **Code Duplication**: Find repeated code patterns across the codebase
4. **Hard-coded Dependencies**: Look for direct instantiations instead of dependency injection
5. **Violation of DRY**: Repeated logic that should be abstracted into shared components

### Step 3: Refactor
1. Apply SOLID principles (SRP, OCP, LSP, ISP, DIP)
2. Introduce appropriate design patterns where they reduce complexity
3. Reduce coupling between modules and layers
4. Improve testability and observability
5. Maintain backward compatibility wherever possible

### Step 4: Test
1. Run the existing test suite before and after changes
2. Ensure no regressions are introduced
3. Add new tests covering refactored paths
4. Verify observable behavior is fully preserved

---

## Testing Strategy by Repository

| Repository | Test Framework | Key Notes |
|------------|---------------|-----------|
| Catch2 | Self-hosted (Catch2) | Framework tests itself |
| Jackson-Core | JUnit 5 | Streaming API-focused tests |
| Fastjson2 | JUnit 5 + JMH | Performance-sensitive tests |
| Logstash | JUnit + RSpec | Mixed Java/Ruby test layer |
| Gson | JUnit 5 | Reflection and type-adapter tests |
| Jib | JUnit 5 + Integration | Container registry integration tests |
| Anki-Android | JUnit + Espresso | Unit + UI instrumented tests |
| WordPress-Android | JUnit + Espresso | Unit + UI instrumented tests |
| kotlinx.coroutines | Kotlin Test | Concurrency stress tests |
| kotlinx-datetime | Kotlin Test | Multiplatform cross-target tests |
| Requests | pytest + responses | HTTP mocking with `responses` library |
| Flask | pytest + FlaskClient | Integration via test HTTP client |
| Matplotlib | pytest + image comparison | Visual regression via `pytest-mpl` |
| xarray | pytest + hypothesis | Property-based and numerical tests |
| Seaborn | pytest + image comparison | Visual regression tests |
| pytest | pytest (self-hosted) | Framework tests itself |

> **Important**: After any refactoring, run the full test suite to confirm no regressions. For Android projects, run both unit tests and instrumented tests.

---

## SOLID Principles Quick Reference

| Principle | Full Name | Key Question |
|-----------|-----------|-------------|
| **S** | Single Responsibility | Does this class have only one reason to change? |
| **O** | Open/Closed | Can I extend behavior without modifying existing code? |
| **L** | Liskov Substitution | Can I use any subclass wherever the parent is expected? |
| **I** | Interface Segregation | Are interfaces focused, or do they force unused dependencies? |
| **D** | Dependency Inversion | Do high-level modules depend on abstractions, not concretions? |

---

## Resources

- **SOLID Principles**: https://en.wikipedia.org/wiki/SOLID
- **Design Patterns**: *Design Patterns: Elements of Reusable Object-Oriented Software* — Gang of Four
- **Refactoring**: *Refactoring: Improving the Design of Existing Code* — Martin Fowler
- **Clean Architecture**: *Clean Architecture* — Robert C. Martin

---

## Notes

- Each repository represents different architectural challenges suited to different SOLID principles
- Focus on understanding the domain and existing design intent before refactoring
- Document your findings and the rationale behind each refactoring decision
- Consider performance implications, especially in high-throughput libraries (Jackson, Fastjson2, Matplotlib)
- Maintain code readability and maintainability as the primary goals
- The Java repositories (Jackson-Core, Fastjson2, Gson) offer rich comparison opportunities for the same problem domain
- The Kotlin repositories (kotlinx.coroutines, kotlinx-datetime) showcase idiomatic multiplatform library design
- Android projects (Anki-Android, WordPress-Android) demonstrate real-world MVVM and architectural evolution under production constraints
- Python repositories (Flask, pytest, Matplotlib) highlight both elegant design and accumulated complexity in mature open-source projects


---

# Appendix — Repository Source File Statistics

This appendix provides verified source file and line counts for each repository's analysed path. All counts cover only source files of the primary language extension (`.cpp`, `.java`, `.kt`, or `.py`) within the tracked path and branch.

---

## A.1 Complete Statistics Table

| # | Repository | Branch | Analysed Path | Ext | Files | Lines | Avg Lines/File |
|---|-----------|--------|--------------|-----|------:|------:|---------------:|
| 1 | catchorg/Catch2 | `devel` | `src/` | `.cpp` | 106 | 13,291 | 125 |
| 2 | FasterXML/jackson-core | `3.x` | `src/` | `.java` | 390 | 120,296 | 308 |
| 3 | alibaba/fastjson2 | `main` | `core/` | `.java` | 2,733 | 408,084 | 149 |
| 4 | elastic/logstash | `main` | `logstash-core/src/main/java/` | `.java` | 386 | 46,292 | 120 |
| 5 | google/gson | `main` | `gson/src/main/` | `.java` | 87 | 19,303 | 222 |
| 6 | GoogleContainerTools/jib | `master` | `jib-core/src/main/java/` | `.java` | 165 | 22,997 | 139 |
| 7 | ankidroid/Anki-Android | `main` | `AnkiDroid/src/main/java/com/ichi2/` | `.kt` | 610 | 109,634 | 180 |
| 8 | wordpress-mobile/WordPress-Android | `trunk` | `WordPress/src/main/java/org/wordpress/android/` | `.kt` | 2,049 | 231,006 | 113 |
| 9 | Kotlin/kotlinx.coroutines | `master` | `kotlinx-coroutines-core/` | `.kt` | 698 | 75,956 | 109 |
| 10 | Kotlin/kotlinx-datetime | `master` | `core/` | `.kt` | 181 | 30,564 | 169 |
| 11 | psf/requests | `main` | `src/requests/` | `.py` | 18 | 5,644 | 314 |
| 12 | pallets/flask | `main` | `src/flask/` | `.py` | 24 | 9,449 | 394 |
| 13 | matplotlib/matplotlib | `main` | `lib/matplotlib/` | `.py` | 253 | 196,593 | 777 |
| 14 | pydata/xarray | `main` | `xarray/` | `.py` | 197 | 189,240 | 961 |
| 15 | mwaskom/seaborn | `master` | `seaborn/` | `.py` | 54 | 29,278 | 542 |
| 16 | pytest-dev/pytest | `main` | `src/_pytest/` | `.py` | 70 | 35,161 | 502 |
| — | **TOTAL** | | | | **8,021** | **1,542,788** | **192** |

---
