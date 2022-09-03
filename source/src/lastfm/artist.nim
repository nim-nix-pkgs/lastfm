when defined(js):
  import std/[jsffi, asyncjs]
else:
  import std/[httpclient, asyncdispatch]
import json, sequtils, strformat
import private/tools


proc artistCorrection*(
  fm: SyncLastFM | AsyncLastFM,
  artist: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `Artist.getCorrection<https://www.last.fm/api/show/artist.getCorrection>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("artist.getCorrection",
                    ("artist", artist))
    content = await fm.http.postContent(url)
  result = parseJson(content)

proc artistInfo*(
  fm: SyncLastFM | AsyncLastFM,
  artist: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Artist.getInfo<https://www.last.fm/api/show/artist.getInfo>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("artist.getInfo",
                    ("artist", artist),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)  # ["artist"]


proc searchArtists*(
  fm: SyncLastFM | AsyncLastFM,
  artist: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Artist.search<https://www.last.fm/api/show/artist.search>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("artist.search",
                    ("artist", artist),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)  # ["results"]["artistmatches"]["artist"]


proc similarArtists*(
  fm: SyncLastFM | AsyncLastFM,
  artist: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Artist.getSimilar<https://www.last.fm/api/show/artist.getSimilar>`_.
  ## Currently missing the optional mbid field. However, core functionality is working.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("artist.getSimilar",
                    ("artist", artist),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc artistTags*(
  fm: SyncLastFM | AsyncLastFM,
  artist, user: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Artist.getTags<https://www.last.fm/api/show/artist.getTags>`_.
  ## This version of the function may be used for both unauthenticated and authenticated
  ## sessions, and thus requires that a user parameter be specified.
  ## Currently missing the optional mbid field. However, core functionality is working.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("artist.getTags",
                    ("artist", artist),
                    ("user", user),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc artistTags*(
  fm: SyncLastFM | AsyncLastFM,
  artist: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Artist.getTags<https://www.last.fm/api/show/artist.getTags>`_.
  ## This version of the function can only be used with an authenticated Last.FM session.
  ## Currently missing the optional mbid field.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genAuthUrl("artist.getTags",
                        ("artist", artist),
                        ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc artistTopTags*(
  fm: SyncLastFM | AsyncLastFM,
  artist: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Artist.getTopTags<https://www.last.fm/api/show/artist.getTopTags>`_.
  ## Currently missing the optional mbid field.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("artist.getTopTags",
                    ("artist", artist),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc artistTopTracks*(
  fm: SyncLastFM | AsyncLastFM,
  artist: string,
  autocorrect = on,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `Artist.getTopTracks<https://www.last.fm/api/show/artist.getTopTracks>`_.
  ## Currently missing the optional mbid field.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("artist.getTopTracks",
                    ("artist", artist),
                    ("page", $page),
                    ("limit", $limit),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc artistTopAlbums*(
  fm: SyncLastFM | AsyncLastFM,
  artist: string,
  autocorrect = on,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `Artist.getTopAlbums<https://www.last.fm/api/show/artist.getTopAlbums>`_.
  ## Currently missing the optional mbid field.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("artist.getTopAlbums",
                    ("artist", artist),
                    ("page", $page),
                    ("limit", $limit),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc artistAddTags*(
  fm: SyncLastFM | AsyncLastFM,
  artist: string,
  tags: AtMost[10, string]): Future[JsonNode] {.multisync.} =
  ## Breakout of `Artist.addTags<https://www.last.fm/api/show/artist.addTags>`_.
  ## `tags` is of type AtMost[10, string], which is any array of strings with
  ## length <= 10.
  ## Returns the JsonNode of the contents of the response.
  let
    tagstr = foldl(tags, a & "," & b)
    url = fm.genAuthUrl("artist.addTags",
                        ("artist", artist),
                        ("tags", tagstr))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc artistRemoveTag*(
  fm: SyncLastFM | AsyncLastFM,
  artist, tag: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `Artist.removeTag<https://www.last.fm/api/show/artist.removeTags>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genAuthUrl("artist.removeTag",
                        ("artist", artist),
                        ("tag", tag))
    content = await fm.http.postContent(url)
  result = parseJson(content)
