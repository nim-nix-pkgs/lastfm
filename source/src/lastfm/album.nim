when defined(js):
  import std/[jsffi, asyncjs]
else:
  import std/[httpclient, asyncdispatch, md5]
import std/[json, uri, sequtils, strformat]
import private/tools


proc albumInfo*(
  fm: SyncLastFM | AsyncLastFM,
  album, artist: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Album.getInfo<https://www.last.fm/api/show/album.getInfo>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("album.getInfo",
                    ("album", album),
                    ("artist", artist),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc albumInfo*(
  fm: SyncLastFM | AsyncLastFM,
  album, artist, username: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Album.getInfo<https://www.last.fm/api/show/album.getInfo>`_.
  ## This variation of the function allows for a user's playcount for the album
  ## to be returned.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("album.getInfo",
                    ("album", album),
                    ("artist", artist),
                    ("username", username),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc albumAddTags*(
  fm: SyncLastFM | AsyncLastFM,
  album, artist: string,
  tags: AtMost[10, string]): Future[JsonNode] {.multisync.} =
  ## Breakout of `Album.addTags<https://www.last.fm/api/show/album.addTags>`_.
  ## `tags` is of type AtMost[10, string], which is any array of strings with
  ## length <= 10.
  ## Returns the JsonNode of the contents of the response.
  let
    tagstr = foldl(tags, a & "," & b)
    url = fm.genAuthUrl("album.addTags",
                        ("album", album),
                        ("artist", artist),
                        ("tags", tagstr))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc albumRemoveTag*(
    fm: SyncLastFM | AsyncLastFM,
  album, artist: string,
  tag: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `Album.removeTags<https://www.last.fm/api/show/album.removeTags>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genAuthUrl("album.removeTag",
                        ("album", album),
                        ("artist", artist),
                        ("tag", tag))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc albumTags*(
  fm: SyncLastFM | AsyncLastFM,
  album, artist, user: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Album.getTags<https://www.last.fm/api/show/album.getTags>`_.
  ## This version of the function may be used for both unauthenticated and authenticated
  ## sessions, and thus requires that a user parameter be specified.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("album.getTags",
                    ("album", album),
                    ("artist", artist),
                    ("user", user),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc albumTags*(
  fm: SyncLastFM | AsyncLastFM,
  album, artist: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Album.getTags<https://www.last.fm/api/show/album.getTags>`_.
  ## This version of the function can only be used with an authenticated Last.FM session.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genAuthUrl("album.getTags",
                        ("album", album),
                        ("artist", artist),
                        ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc albumTopTags*(
  fm: SyncLastFM | AsyncLastFM,
  album, artist: string,
  autocorrect = on): Future[JsonNode] {.multisync.} =
  ## Breakout of `Album.getTopTags<https://www.last.fm/api/show/album.getTopTags>`_.
  ## Currently missing the optional mbid field.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("album.getTopTags",
                    ("album", album),
                    ("artist", artist),
                    ("autocorrect", if autocorrect: "1" else: "0"))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc searchAlbums*(
  fm: SyncLastFM | AsyncLastFM,
  album: string,
  page = 1,
  limit = 30): Future[JsonNode] {.multisync.} =
  ## Breakout of `Album.search<https://www.last.fm/api/show/album.search>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("album.search",
                    ("album", album),
                    ("page", $page),
                    ("limit", $limit))
    content = await fm.http.postContent(url)
  result = parseJson(content)
