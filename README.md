# Elixir environment

In this repo I'm practicing with Mix and OTP; Agents, GenServers, Task, Supervisors, Distributed tasks, etc.

I've configured a Dev container project for VS Code, when you open this project make sure to use "open in a container" option.

# KV Umbrella
This project is based into project [Mix and OPT](https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html)


# RKV Umbrella

This project is a variant of *KV Umbrella*; I've used **phoenix_pubsub_redis** to discover Rkv nodes Dynamically

## Playing with RKV Umbrella

##### 1) Start main server
```
cd rkv_umbrella
iex --sname server_rkv -S mix
```

##### 2) Start worker processes (Key Value processes)
Open a terminal for each one

Ej:
**Terminal 1**
```
cd rkv_umbrella/apps/rkv
iex --sname worker0_rkv -S mix
```
Ej:
**Terminal 2**
```
cd rkv_umbrella/apps/rkv
iex --sname worker1_rkv -S mix
```

##### 3) Connect to server with telnet
In other terminal install telnet (if you don't have it)

```
apt-get update
apt-get install telnet
```

**then:**

```
telnet 127.0.0.1 4040
```

**now:** you can play with these commands via telnet (tcp)

```
CREATE BUCKET my_bucket
LOOKUP BUCKET my_bucket

PUT my_bucket milk 4
GET my_bucket milk
DEL my_bucket milk

DELETE BUCKET my_bucket
```