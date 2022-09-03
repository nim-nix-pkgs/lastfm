when defined(js):
  import std/[jsffi, asyncjs]
else:
  import std/[httpclient, asyncdispatch]
import std/[json, uri]
import private/tools


proc chartTopArtists*(
  fm: SyncLastFM | AsyncLastFM,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `chart.getTopArtists<https://www.last.fm/api/show/chart.getTopArtists>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("chart.getTopArtists",
                    ("limit", $limit),
                    ("page", $page))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc chartTopTags*(
  fm: SyncLastFM | AsyncLastFM,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `chart.getTopTags<https://www.last.fm/api/show/chart.getTopTags>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("chart.getTopTags",
                    ("limit", $limit),
                    ("page", $page))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc chartTopTracks*(
  fm: SyncLastFM | AsyncLastFM,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `chart.getTopTracks<https://www.last.fm/api/show/chart.getTopTracks>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("chart.getTopTracks",
                    ("limit", $limit),
                    ("page", $page))
    content = await fm.http.postContent(url)
  result = parseJson(content)
