# Pytorchnanigans

Experimenting with Pytorch and related libraries and frameworks

## Setup
1. Install [magic](https://docs.modular.com/magic/)

```
curl -ssL https://magic.modular.com/deb16053-d972-4668-8267-c3b15bf88019 | bash
```

2. Install dependencies

```
magic install
```

## CPU environment
If only CPU available the `default` environment

```
magic shell
```

## GPU environment
If GPU available activate the `cuda` environment

```
magic shell -e cuda
```