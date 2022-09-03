when defined(js):
  import std/[jsffi, asyncjs]
else:
  import std/[httpclient, asyncdispatch]
import std/[json, uri]
import private/tools


proc geoTopArtists*(
  fm: SyncLastFM | AsyncLastFM,
  country: string,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `geo.getTopArtists<https://www.last.fm/api/show/geo.getTopArtists>`_.
  ## `country` is an ISO 3166-1 country code.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("geo.getTopArtists",
                    ("country", country),
                    ("limit", $limit),
                    ("page", $page))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc geoTopTracks*(
  fm: SyncLastFM | AsyncLastFM,
  country: string,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `geo.getTopTracks<https://www.last.fm/api/show/geo.getTopTracks>`_.
  ## `country` is an ISO 3166-1 country code.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("geo.getTopTracks",
                    ("country", country),
                    ("limit", $limit),
                    ("page", $page))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc geoTopTracks*(
  fm: SyncLastFM | AsyncLastFM,
  country, location: string,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `geo.getTopTracks<https://www.last.fm/api/show/geo.getTopTracks>`_.
  ## `country` is an ISO 3166-1 country code. `location` is optional, and there is a
  ## variant of this function that does not require it.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("geo.getTopTracks",
                    ("country", country),
                    ("location", location),
                    ("limit", $limit),
                    ("page", $page))
    content = await fm.http.postContent(url)
  result = parseJson(content)
