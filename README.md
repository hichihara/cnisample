# cnisample
The cnisample has Kubernetes CNI sample plugins. They are very simple and useful to understand CNI mechanism.

## Preparation

You can try to run the sample with [cnitool](https://github.com/containernetworking/cni/tree/master/cnitool). 

Install cnitool:

```
go get github.com/containernetworking/cni/cnitool
```

Create a network namespace. This will be called `testing`:

```
sudo ip netns add testing
```

## Bash
Bash script depends on `jq`.

Git clone:

```
git clone https://github.com/hichihara/cnisample
cd cnisample
```

### Not chain

Try to run CNI `ADD` command:

```
sudo CNI_PATH=./bash/ NETCONFPATH=./bash/netconf/cnisample cnitool add mysample /var/run/netns/testing
```

Try to run CNI `DEL` command:

```
sudo CNI_PATH=./bash/ NETCONFPATH=./bash/netconf/cnisample cnitool del mysample /var/run/netns/testing
```

### Chain

Try to run chanin CNI `ADD` command:

```
sudo CNI_PATH=./bash/ NETCONFPATH=./bash/netconf/cnisample-chain cnitool add mysample /var/run/netns/testing
```

Try to run chain CNI `DEL` command:

```
sudo CNI_PATH=./bash/ NETCONFPATH=./bash/netconf/cnisample-chain cnitool del mysample /var/run/netns/testing
```

## Golang

### Noop

```
cd go/noop
mkdir bin
go build -o ./bin/noop
sudo CNI_PATH=./bin NETCONFPATH=./netconf cnitool add mysample /var/run/netns/testing
```

## Clean up

```
sudo ip netns del testing
```

