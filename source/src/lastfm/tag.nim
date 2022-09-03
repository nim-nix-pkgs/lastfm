when defined(js):
  import std/[jsffi, asyncjs]
else:
  import std/[httpclient, asyncdispatch]
import std/[json, uri]
import private/tools


proc tagInfo*(
  fm: SyncLastFM | AsyncLastFM,
  tag: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `Tag.getInfo<https://www.last.fm/api/show/tag.getInfo>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("tag.getInfo",
                    ("tag", tag))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc tagInfo*(
  fm: SyncLastFM | AsyncLastFM,
  tag, lang: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `Tag.getInfo<https://www.last.fm/api/show/tag.getInfo>`_.
  ## This variant fo the function includes the lang parameter, which is
  ## the ISO 639 alpha-2 code corresponding to the desired response language.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("tag.getInfo",
                    ("tag", tag),
                    ("lang", lang))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc similarTags*(
  fm: SyncLastFM | AsyncLastFM,
  tag: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `Tag.getSimilar<https://www.last.fm/api/show/tag.getInfo>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("tag.getSimilar",
                    ("tag", tag))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc topAlbumsForTag*(
  fm: SyncLastFM | AsyncLastFM,
  tag: string,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `Tag.getTopAlbums<https://www.last.fm/api/show/tag.getTopAlbums>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("tag.getSimilar",
                    ("tag", tag),
                    ("page", $page),
                    ("limit", $limit))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc topArtistsForTag*(
  fm: SyncLastFM | AsyncLastFM,
  tag: string,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `Tag.getTopArtists<https://www.last.fm/api/show/tag.getTopArtists>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("tag.getTopArtists",
                    ("tag", tag),
                    ("page", $page),
                    ("limit", $limit))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc topTracksForTag*(
  fm: SyncLastFM | AsyncLastFM,
  tag: string,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `Tag.getTopTracks<https://www.last.fm/api/show/tag.getTopTracks>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("tag.getTopTracks",
                    ("tag", tag),
                    ("page", $page),
                    ("limit", $limit))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc topTags*(
  fm: SyncLastFM | AsyncLastFM): Future[JsonNode] {.multisync.} =
  ## Breakout of `Tag.getTopTags<https://www.last.fm/api/show/tag.getTopTags>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("tag.getTopTags")
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc weeklyChartsForTag*(
  fm: SyncLastFM | AsyncLastFM,
  tag: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `Tag.getWeeklyChartList<https://www.last.fm/api/show/tag.getWeeklyChartList>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("tag.getTopTags",
                    ("tag", tag))
    content = await fm.http.postContent(url)
  result = parseJson(content)
