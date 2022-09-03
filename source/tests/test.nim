when defined(c):
  import
    std/[unittest, json, os, asyncdispatch, browsers],
    lastfm,
    lastfm/[track, artist]


  suite "sync":
    setup:
      let
        apiKey = getEnv("LASTFM_API_KEY")
        apiSecret = getEnv("LASTFM_API_SECRET")
        fm = newSyncLastFM()
        spaceCadet = (trackInfo(fm, "Space Cadet", "Kyuss")){"track"}
        correction = (trackCorrection(fm, "Space Cadet", "Kyuss")){"corrections", "correction", "track"}

    test "successful queries":
      check (not spaceCadet.isNil)
      check (not correction.isNil)

    test "trackInfo":
      check spaceCadet.contains "name"
      check spaceCadet.contains "listeners"
      check spaceCadet.contains "url"
      check spaceCadet.contains "artist"
      check spaceCadet["artist"].contains "name"
      check spaceCadet["artist"].contains "mbid"
      check spaceCadet["artist"].contains "url"
      check spaceCadet.contains "album"
      check spaceCadet["album"].contains "artist"
      check spaceCadet["album"].contains "title"
      check spaceCadet["album"].contains "mbid"
      check spaceCadet.contains "mbid"
      check spaceCadet.contains "toptags"
      check spaceCadet.contains "playcount"
      check spaceCadet.contains "streamable"

    test "trackCorrection":
      check correction.contains "name"
      check correction.contains "mbid"
      check correction.contains "artist"
      check correction["artist"].contains "name"
      check correction["artist"].contains "mbid"
      check correction["artist"].contains "url"

    test "artistTags":
      check "{}" == $(fm.artistAddTags("Kyuss", ["test"]))
      check "{}" == $(fm.artistRemoveTag("Kyuss", "test"))


  suite "async":
    setup:
      let
        fm = newAsyncLastFM()
        spaceCadet = (waitFor trackInfo(fm, "Space Cadet", "Kyuss")){"track"}
        correction = (waitFor trackCorrection(fm, "Space Cadet", "Kyuss")){"corrections", "correction", "track"}

      proc waitForInput(url: string): Future[bool] =
        result = newFuture[bool]("inputCallback")
        openDefaultBrowser(url)
        echo "did user accept authentication? [Y/n]"
        let i = readLine(stdin)
        result.complete(i == "Y")

    test "successful queries":
      check (not spaceCadet.isNil)
      check (not correction.isNil)

    test "trackInfo":
      check spaceCadet.contains "name"
      check spaceCadet.contains "listeners"
      check spaceCadet.contains "url"
      check spaceCadet.contains "artist"
      check spaceCadet["artist"].contains "name"
      check spaceCadet["artist"].contains "mbid"
      check spaceCadet["artist"].contains "url"
      check spaceCadet.contains "album"
      check spaceCadet["album"].contains "artist"
      check spaceCadet["album"].contains "title"
      check spaceCadet["album"].contains "mbid"
      check spaceCadet.contains "mbid"
      check spaceCadet.contains "toptags"
      check spaceCadet.contains "playcount"
      check spaceCadet.contains "streamable"

    test "trackCorrection":
      check correction.contains "name"
      check correction.contains "mbid"
      check correction.contains "artist"
      check correction["artist"].contains "name"
      check correction["artist"].contains "mbid"
      check correction["artist"].contains "url"

    test "artistTags":
      check "{}" == $(waitFor fm.artistAddTags("Kyuss", ["test"]))
      check "{}" == $(waitFor fm.artistRemoveTag("Kyuss", "test"))