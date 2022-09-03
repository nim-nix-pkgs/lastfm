# Package

version       = "0.8.2"
author        = "ryukoposting & tandy1000"
description   = "Last.FM API bindings (documentation: https://tandy1000.gitlab.io/lastfm-nim/)"
license       = "Apache-2.0"
srcDir        = "src"

# Dependencies

when defined(js):
  requires "nim >= 1.5.0"
else:
  requires "nim >= 1.4.8"

task test, "run all tests":
  withDir "tests":
    exec "nim c -r test.nim"

task buildjs, "try build with js":
  withDir "src":
    exec "nim js lastfm.nim"

task docs, "generate docs!":
  exec "rm -rf docs/"
  exec "nim doc --project --git.commit:master --git.devel:master --git.url:https://gitlab.com/tandy1000/lastfm-nim --outdir:docs src/lastfm.nim || true"
  exec "rm --verbose --force --recursive docs/nimcache/*.*"
  exec "mv --verbose docs/lastfm.html docs/index.html"
