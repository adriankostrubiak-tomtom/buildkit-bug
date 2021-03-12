# buildkit-bug

## Prerequisite

Configure docker registry appropriately in `/build.sh`.

## Repro

To reproduce, start the server
```bash
./run-server.sh
```
then in a new console, run the build
```
./build.sh
```
It seems that the first build successed.  Adjust `cmd/sample/main.go` in any way - add an extra `!` to the logger :)
Then run the build again,
```bash
./build.sh
```
And this will result in the server panic.

Of note, I saw at least one time when this did not result in a panic.  In that case, it seems that the server performed snapshot garbage collection between the two builds.  Additionally, a third build caused the same panic.
