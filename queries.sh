#!/bin/sh

do_query() {
  echo "$1"
  if grep 'STRUCTURE s' /corpora/registry/test >/dev/null; then
    echo '... detected larger data, omitting non-target results for clarity ...'
    corpquery test "$1" -a word,tag -c0 |
      grep -P "< díky /.{16}  tomuto /.{16}  popisu /.{16} >"
  else
    corpquery test "$1" -a word,tag -c0
  fi
}

python -c '
import manatee
ver = "Manatee version: " + manatee.version()
print("=" * len(ver))
print(ver)
print("=" * len(ver))
'

echo 'The purpose of the query is to match structures like the following:'
echo '  -> díky popisu'
echo '  -> díky tomuto popisu'
echo '  -> díky báječnému popisu'
echo '  -> díky tomuto báječnému popisu'
echo '  -> díky tomuto báječnému , skvělému popisu'
echo 'etc.'

echo
echo 'The following query fails to find "díky tomuto popisu" on 2.167,'
echo 'even though it should:'
do_query '[tag="R.*"][tag="P.*"]?[tag="[^R].*"]*[tag="N...3.*"]+'

echo
echo 'Removing the + on the last position, the search succeeds:'
do_query '[tag="R.*"][tag="P.*"]?[tag="[^R].*"]*[tag="N...3.*"]'

echo
echo "Disabling optimizations doesn't seem to help. // There was a bug"
echo 'in regex optimizations, cf.:'
echo 'https://groups.google.com/a/sketchengine.co.uk/d/msg/noske/tn8AvE8FODk/ytM3Rzr1AgAJ'
do_query '[tag="((R.*))"][tag="((P.*))"]?[tag="(([^R].*))"]*[tag="((N...3.*))"]+'

# The last two are only true when a larger context is present; the issue
# is clearly very sensitive to the actual contents of the corpus.

if grep 'STRUCTURE s' /corpora/registry/test >/dev/null; then

  echo
  echo 'WARNING: ONLY TRUE FOR THE TEST-BIG DATA'
  echo 'Another way to make the search succeed is to remove the case'
  echo 'constraint on the last position (which is however fulfilled by '
  echo 'the data); in this case, you can even keep the +:'
  do_query '[tag="R.*"][tag="P.*"]?[tag="[^R].*"]*[tag="N.*"]+'

  echo
  echo 'WARNING: ONLY TRUE FOR THE TEST-BIG DATA'
  echo 'Or to further constrain the first position (this suggests an interaction'
  echo 'with previous matches, because this constraint eliminates them?):'
  do_query '[tag="R.*" & lemma="díky"][tag="P.*"]?[tag="[^R].*"]*[tag="N...3.*"]+'

fi
