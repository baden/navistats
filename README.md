navistats [![Build Status](https://travis-ci.org/baden/navistats.png)](https://travis-ci.org/baden/navistats)
=========

Statistic module for [navicc](https://github.com/baden/navicc) project.

## Dependencies

### Erlang

```shell
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
rm ./erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install -y erlang
```

## Build the library

```shell
make
```

## Testing

```shell
make elvis
make tests
# make xref
```

## Documentation

```shell
make docs
```
