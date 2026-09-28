List z/OS UNIX processes in tree form (like `pstree` on Linux).

z/OS-only: it enumerates processes via the `BPX4GTH` callable service
(`bpx.s` bridges Go to the BPX vector table) and prints parent/child
relationships with the full command line of each process.

## Prerequisites

- z/OS UNIX System Services with a shell (bash or sh)
- IBM Open Enterprise SDK for Go for z/OS, 1.25 or newer
  (`go 1.21` in `go.mod` was end-of-life, so the minimum language
  version is now `go 1.25`)
- Optional: `goz-util` (used by the `Makefile` to set code pages)

There are no third-party Go dependencies.

## Build

```
go build -o pstree
```

or

```
make
```

`make` embeds the version via `-X main.version=...`, taken from
`$ZOSPSTREE_VERSION` or else `git describe --tags --always --dirty`.
A plain `go build` without `-ldflags` reports `dev`.

## Run

```
./pstree
```

Use ASCII-only line drawing (for terminals without Unicode support):

```
./pstree -A
```

Print the embedded version:

```
./pstree -V
./pstree -version
```

## Sample output

```
├─(67114797) /usr/sbin/sshd -R
│ └─(33560395) bash -c ...
│   ├─(50337355) head -8
│   └─(50337386) ./go-pstree
└─(67113716) /usr/sbin/sshd -R
```

With `-A` the same tree renders with `|`, `+`, `-` characters.

## How it works

- `bpx.s` — s390x assembly stub that calls into the BPX vector table.
- `pstree.go` — walks the process table with `BPX4GTH`
  (`PGTHA_FIRST`/`PGTHA_NEXT`), requesting `PGTHA_PROCESS` +
  `PGTHA_COMMANDLONG` records, converts command lines from EBCDIC to
  ASCII, builds a PID map, and prints the tree. Orphaned processes
  (parent not visible) are attached to a synthetic `--root--` node.
- Only processes visible to the caller's UID are listed.

## Downstream

Packaged port: [zopencommunity/zospstreeport](https://github.com/zopencommunity/zospstreeport) —
tracks this repo's releases via a `ZOSPSTREE_VERSION` bump.

## Security notes

- This module has no external dependencies, so there is nothing to
  update via `go get -u`; keeping the Go toolchain itself current is
  the relevant maintenance.
- Defensive guards reject corrupt `BPX4GTH` records (missing sections,
  out-of-range command lengths) and cap rendering depth instead of
  panicking.

## License

Apache License 2.0 — see [LICENSE](LICENSE).
