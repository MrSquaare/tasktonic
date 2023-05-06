# Contributing

## Table of Contents

- [Guidelines](#guidelines)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Building](#building)
- [Developing](#developing)
- [Testing](#testing)

## Guidelines

See [GUIDELINES.md](GUIDELINES.md) for more information.

## Getting started

### Prerequisites

1. [Install Flutter](https://docs.flutter.dev/get-started/install):

### Installation

1. Clone the repository:

```shell script
git clone https://github.com/MrSquaare/tasktonic.git
```

2. Install dependencies:

```shell script
flutter pub get
```

## Building

1. Run `build_runner`

```shell script
flutter pub run build_runner build
```

2. Build the app:

```shell script
flutter build <target>
# See flutter build --help for help
```

## Developing

1. Run `build_runner`

```shell script
flutter pub run build_runner watch
```

2. Run the app:

```shell script
flutter run
# See flutter run --help for help
```

## Testing

Run coding style tests:

```shell script
flutter analyze
```

Run functional and unit tests:

```shell script
flutter test
```
