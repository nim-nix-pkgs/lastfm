when defined(js):
  import std/[jsffi, asyncjs]
else:
  import std/[httpclient, asyncdispatch]
import std/[json, uri, options, times, sequtils]
import private/tools


proc trackCorrection*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.getCorrection<https://www.last.fm/api/show/track.getCorrection>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("track.getCorrection",
                   ("track", track),
                   ("artist", artist))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc trackInfo*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.getInfo<https://www.last.fm/api/show/track.getInfo>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("track.getInfo",
                     ("track", track),
                     ("artist", artist),
                     ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc trackInfo*(
  fm: SyncLastFM | AsyncLastFM,
  mbid: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.getInfo<https://www.last.fm/api/show/track.getInfo>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("track.getInfo",
                    ("mbid", mbid),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc searchTracks*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.getInfo<https://www.last.fm/api/show/track.search>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("track.search",
                    ("track", track),
                    ("artist", artist),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)  # ["results"]["trackmatches"]["track"]


proc searchTracks*(
  fm: SyncLastFM | AsyncLastFM,
  track: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.getInfo<https://www.last.fm/api/show/track.search>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("track.search",
                    ("track", track),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)  # ["results"]["trackmatches"]["track"]


proc scrobble*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string,
  timestamp = getTime().toUnix(),
  album, context, streamId, mbid, albumArtist: string = "",
  chosenByUser: Option[bool] = none(bool),
  trackNumber, duration: Option[int] = none(int)): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.scrobble<https://www.last.fm/api/show/track.scrobble>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genAuthUrl("track.scrobble",
                        ("track", track),
                        ("artist", artist),
                        ("timestamp", $timestamp),
                        ("album", album),
                        ("context", context),
                        ("streamId", streamId),
                        ("chosenByUser", $get(chosenByUser)),
                        ("trackNumber", $get(trackNumber)),
                        ("mbid", mbid),
                        ("albumArtist", albumArtist),
                        ("duration", $get(duration)))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc loveTrack*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.love<https://www.last.fm/api/show/track.love>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genAuthUrl("track.love",
                        ("track", track),
                        ("artist", artist))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc unloveTrack*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.unlove<https://www.last.fm/api/show/track.unlove>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genAuthUrl("track.unlove",
                        ("track", track),
                        ("artist", artist))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc setNowPlaying*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string,
  album, context, mbid, albumArtist: string = "",
  trackNumber, duration: Option[int] = none(int)): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.updateNowPlaying<https://www.last.fm/api/show/track.updateNowPlaying>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genAuthUrl("track.updateNowPlaying",
                        ("track", track),
                        ("artist", artist),
                        ("album", album),
                        ("context", context),
                        ("trackNumber", $get(trackNumber)),
                        ("mbid", mbid),
                        ("albumArtist", albumArtist),
                        ("duration", $get(duration)))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc similarTracks*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string,
  autocorrect = on,
  mbid: string = "",
  limit: Option[int] = none(int)): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.unlove<https://www.last.fm/api/show/track.updateNowPlaying>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("track.getSimilar",
                    ("track", track),
                    ("artist", artist),
                    ("autocorrect", if autocorrect: "1" else: "0"),
                    ("mbid", mbid),
                    ("limit", $get(limit)))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc trackAddTags*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string,
  tags: AtMost[10, string]): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.addTags<https://www.last.fm/api/show/track.addTags>`_.
  ## `tags` is of type AtMost[10, string], which is any array of strings with
  ## length <= 10.
  ## Returns the JsonNode of the contents of the response.
  let
    tagstr = foldl(tags, a & "," & b)
    url = fm.genAuthUrl("track.addTags",
                        ("track", track),
                        ("artist", artist),
                        ("tags", tagstr))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc trackRemoveTag*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string,
  tag: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.removeTags<https://www.last.fm/api/show/track.removeTag>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genAuthUrl("track.removeTag",
                        ("track", track),
                        ("artist", artist),
                        ("tag", tag))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc trackTags*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist, user: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.getTags<https://www.last.fm/api/show/track.getTags>`_.
  ## This version of the function may be used for both unauthenticated and authenticated
  ## sessions, and thus requires that a user parameter be specified.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("track.getTags",
                    ("track", track),
                    ("artist", artist),
                    ("user", user),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc trackTags*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.getTags<https://www.last.fm/api/show/track.getTags>`_.
  ## This version of the function can only be used with an authenticated Last.FM session.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genAuthUrl("track.getTags",
                        ("track", track),
                        ("artist", artist),
                        ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc trackTopTags*(
  fm: SyncLastFM | AsyncLastFM,
  track, artist: string,
  mbid: string = "",
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Track.getTopTags<https://www.last.fm/api/show/track.getTopTags>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("track.getTopTags",
                    ("track", track),
                    ("artist", artist),
                    ("autocorrect", if autocorrect: "1" else: "0"),
                    ("mbid", mbid))
    content = await fm.http.postContent(url)
  result = parseJson(content)
