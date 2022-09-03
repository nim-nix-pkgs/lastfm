when defined(js):
  import std/[jsffi, asyncjs]
else:
  import std/[httpclient, asyncdispatch]
import std/json
import private/tools


type
  TaggingType* = enum
    ## Used by `userPersonalTags` to specify what type of tags should be returned by
    ## the API method call.
    ttArtist = "artist",
    ttAlbum = "album",
    ttTrack = "track"

  Period* = enum
    ## Used by `userTopAlbums`, `userTopArtists`, and `userTopTracks` to represent
    ## the "period" field.
    pOverall = "overall",
    p7day = "7day",
    p1month = "1month",
    p3month = "3month",
    p6month = "6month",
    p12month = "12month"


proc userLovedTracks*(
  fm: SyncLastFM | AsyncLastFM,
  user: string,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getLovedTracks<https://www.last.fm/api/show/User.getLovedTracks>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getLovedTracks",
                    ("user", user),
                    ("page", $page),
                    ("limit", $limit))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc userRecentTracks*(
  fm: SyncLastFM | AsyncLastFM,
  user: string,
  page = 1,
  limit = 50,
  extended = off): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getRecentTracks<https://www.last.fm/api/show/user.getRecentTracks>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getRecentTracks",
                    ("user", user),
                    ("page", $page),
                    ("limit", $limit),
                    ("extended", if extended: "1" else: "0"))
  result = parseJson(await fm.http.postContent(url))


proc userPersonalTags*(
  fm: SyncLastFM | AsyncLastFM,
  user, tag: string,
  taggingtype: TaggingType,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getPersonalTags<https://www.last.fm/api/show/user.getPersonalTags>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getPersonalTags",
                    ("user", user),
                    ("tag", tag),
                    ("taggingtype", $taggingtype),
                    ("page", $page),
                    ("limit", $limit))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc userInfo*(
  fm: SyncLastFM | AsyncLastFM,
  user: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getInfo<https://www.last.fm/api/show/User.getInfo>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getInfo",
                    ("user", user))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc userTopAlbums*(
  fm: SyncLastFM | AsyncLastFM,
  user: string,
  period = pOverall,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getTopAlbums<https://www.last.fm/api/show/User.getTopAlbums>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getTopAlbums",
                    ("user", user),
                    ("period", $period),
                    ("page", $page),
                    ("limit", $limit))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc userTopArtists*(
  fm: SyncLastFM | AsyncLastFM,
  user: string,
  period = pOverall,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getTopArtists<https://www.last.fm/api/show/User.getTopArtists>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getTopArtists",
                    ("user", user),
                    ("period", $period),
                    ("page", $page),
                    ("limit", $limit))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc userTopTracks*(
  fm: SyncLastFM | AsyncLastFM,
  user: string,
  period = pOverall,
  page = 1,
  limit = 50): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getTopTracks<https://www.last.fm/api/show/User.getTopTracks>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getTopTracks",
                    ("user", user),
                    ("period", $period),
                    ("page", $page),
                    ("limit", $limit))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc userTopTags*(
  fm: SyncLastFM | AsyncLastFM,
  user: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getTopTags<https://www.last.fm/api/show/User.getTopTags>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getTopTags",
                    ("user", user))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc weeklyAlbumChart*(
  fm: SyncLastFM | AsyncLastFM,
  user: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getWeeklyAlbumChart<https://www.last.fm/api/show/user.getWeeklyAlbumChart>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getWeeklyAlbumChart",
                    ("user", user))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc weeklyArtistChart*(
  fm: SyncLastFM | AsyncLastFM,
  user: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getWeeklyArtistChart<https://www.last.fm/api/show/user.getWeeklyArtistChart>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getWeeklyArtistChart",
                    ("user", user))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc weeklyTrackChart*(
  fm: SyncLastFM | AsyncLastFM,
  user: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getWeeklyTrackChart<https://www.last.fm/api/show/user.getWeeklyTrackChart>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getWeeklyTrackChart",
                    ("user", user))
    content = await fm.http.postContent(url)
  result = parseJson(content)


proc weeklyChartList*(
  fm: SyncLastFM | AsyncLastFM,
  user: string): Future[JsonNode] {.multisync.} =
  ## Breakout of `User.getWeeklyChartList<https://www.last.fm/api/show/user.getWeeklyChartList>`_.
  ## Returns the JsonNode of the contents of the response.
  let
    url = fm.genUrl("user.getWeeklyChartList",
                    ("user", user))
    content = await fm.http.postContent(url)
  result = parseJson(content)