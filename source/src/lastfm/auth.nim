when defined(js):
  import std/[jsffi, asyncjs]
else:
  import std/[os, md5, httpclient, asyncdispatch]
import std/[json, uri, strformat]
import private/tools

const
  LASTFM_API_KEY = getEnv("LASTFM_API_KEY")
  LASTFM_API_SECRET = getEnv("LASTFM_API_SECRET")


proc sharedInit(base: LastFM, apiKey, apiSecret, sessionKey: string) =
  base.key = apiKey
  base.secret = apiSecret
  base.sk = sessionKey


proc newSyncLastFM*(
  apiKey: string = LASTFM_API_KEY,
  apiSecret: string = LASTFM_API_SECRET,
  sessionKey: string = ""): SyncLastFM =
  ## Produces a sync Last.FM session that can be used to...
  ##
  ## - query any track, artist, or album metadata
  ## - query any public metadata about a Last.FM user account
  ## - generate one or more authenticated Last.FM sessions, which can
  ##   then be used for scrobbling, "favouriting," etc.
  ##
  new(result)
  result.sharedInit(apiKey, apiSecret, sessionKey)
  result.http = newHttpClient()


proc newAsyncLastFM*(
  apiKey: string = LASTFM_API_KEY,
  apiSecret: string = LASTFM_API_SECRET,
  sessionKey: string = ""): AsyncLastFM =
  ## Produces an async Last.FM session that can be used to...
  ##
  ## - query any track, artist, or album metadata
  ## - query any public metadata about a Last.FM user account
  ## - generate one or more authenticated Last.FM sessions, which can
  ##   then be used for scrobbling, "favouriting," etc.
  ##
  new(result)
  result.sharedInit(apiKey, apiSecret, sessionKey)
  result.http = newAsyncHttpClient()


proc loadAuth*(
  fm: SyncLastFM | AsyncLastFM,
  sessionKey: string) =
  ## Generate a client-authenticated session from a pre-existing
  ## session key.
  ##
  ## Last.FM session keys do not expire, unless revoked by the user.
  ## As such, an application may get authorization using desktopAuth
  ## or mobileAuth, then save that session key in a file. The next
  ## time the user opens the application, this session key can be
  ## reused.
  fm.sk = sessionKey


proc mobileAuth*(
  fm: SyncLastFM | AsyncLastFM,
  username, password: string) {.multisync.} =
  ## Generate a client-authenticated session following Last.FM's mobile
  ## authentication flow. Using this API is not recommended under normal
  ## circumstances, as it requires access to the user's password in
  ## plaintext.
  let
    reqstr = fm.genUrl("auth.getMobileSession",
                      ("username", username),
                      ("password", password))
    sig = $toMD5("api_key" & fm.key &
                 "methodauth.getMobileSessionpassword" &
                 password & "username" & username & fm.secret)
    req = await fm.http.postContent(reqstr & sig)
  fm.sk = parseJson(req)["session"]["key"].getStr


proc desktopAuth*(
  fm: SyncLastFM | AsyncLastFM,
  keepGoing: proc(_: string): Future[bool]) =
  ## Generate a client-authenticated session following Last.FM's "desktop"
  ## authentication flow.
  ##
  ## `keepGoing` is passed a URL that should be opened in the client's
  ## browser so that they can grant permission to your application.
  ##
  ## - If the user successfully grants permission to your application,
  ##   keepGoing should return true.
  ## - If the user does NOT authorize your application, keepGoing must
  ##   return false. If keepGoing returns false, an IOError is thrown.
  ##
  let
    tokenreq = await fm.http.postContent(fm.genUrl("auth.gettoken"))
    token = tokenreq.parseJson()["token"].getStr
    didAuth = await keepGoing("http://www.last.fm/api/auth/?api_key=" &
                              fm.key & "&token=" & token)

  if not didAuth:
    raise newException(IOError, "future keepGoing gave false")
  else:
    let
      sessrequrl = fm.genUrl("auth.getSession", ("token", token))
      sig = $toMD5("api_key" & fm.key & "methodauth.getSessiontoken" &
                   token & fm.secret)
      req = await fm.http.postContent(sessrequrl & "&api_sig=" & sig)
    fm.sk = parseJson(req)["session"]["key"].getStr