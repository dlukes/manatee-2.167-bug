Reproducible examples for a bug in Manatee 2.167. The test data are in
`test.vrt` (a minimal version) and `test-big.vrt` (more context with
different behavior in some cases). The test queries are in `queries.sh`,
along with additional comments.

The examples require Docker to run, and probably need `sudo` on Linux
(because of Docker). Compare the output of the following runs:

```sh
# show bug on small data
./run.sh test
# show bug on bigger data (some test cases behave differently)
./run.sh test-big

# show original behavior on small data
./run.sh test orig
# show original behavior on bigger data
./run.sh test-big orig
```

Note also the duplicate matches in `./run.sh test orig` when the last
position is quantified with a `+` -- that probably isn't correct
behavior either? And maybe the current behavior where there's no match
instead of duplicate matches was introduced while trying to fix the
previous one?
