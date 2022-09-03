when defined(js):
  import std/[asyncjs, jsfetch, jsheaders, jsffi, jsmd5]
else:
  import std/[httpclient, asyncfutures, md5]
import std/[json, uri, algorithm, sugar, sequtils, macros]


const
  lastFmUrl = "https://ws.audioscrobbler.com/2.0/"


type
  AtMost*[L: static int; T] = concept TS
    TS[low(TS)] is T
    TS.len() <= L


when defined(js):
  type
    LastFM* = ref object
      key*, secret*, sk*: string

    SyncLastFM* = LastFM

    AsyncLastFM* = LastFM

    HttpRequestError* = object of IOError

else:
  type
    LastFM*[HttpType] = ref object
      key*, secret*, sk*: string
      http*: HttpType

    SyncLastFM* = LastFM[HttpClient]

    AsyncLastFM* = LastFM[AsyncHttpClient]


proc genSig(
  fm: SyncLastFM | AsyncLastFM,
  methd: string,
  params: var seq[(string, string)]): string =
  ##
  var hashstring = ""
  params.add ("method", methd)
  params.add ("api_key", fm.key)
  params.add ("sk", fm.sk)
  params.sort((x, y) => cmp(x[0], y[0]))
  for p in params:
    hashstring.add p[0]
    hashstring.add p[1]
  hashstring.add fm.secret
  result = $toMD5(hashstring)


proc genUrl*(
  fm: SyncLastFM | AsyncLastFM,
  methd: string,
  strs: varargs[(string,string)]): string =
  ##
  result = "?method=" & methd & "&api_key=" & fm.key & "&format=json&"
  for v in strs:
    result.add v[0] & "=" & encodeUrl(v[1]) & "&"
  result = lastFmUrl & result[0..result.high - 1]


proc genAuthUrl*(
  fm: SyncLastFM | AsyncLastFM,
  methd: string,
  strs: varargs[(string, string)]): string =
  ##
  var ps = strs.map((x) => x)
  result = fm.genUrl(methd, strs) & "&sk=" & fm.sk & "&api_sig=" & fm.genSig(methd, ps)


# macro arrln(l, h: BiggestInt, typ: untyped): untyped =
#   if intVal(l) == intVal(h):
#     return nnkBracketExpr.newTree(
#       newIdentNode("array"), l, typ)
#   else:
#     let li: BiggestInt = intVal(l) + 1
#     return nnkInfix.newTree(
#       newIdentNode("|"),
#       arrln(li, intVal(h), typ), typ)
