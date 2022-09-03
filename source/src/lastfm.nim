## .. code-block:: nim
##  import lastfm
##  import lastfm/[track, artist, album, tag, chart]
##
## lastfm is a Nim library for the Last.FM web API. It leverages multisync,
## and provides multiple methods for setting up client-authenticated sessions.
##
## By default, API keys are loaded from the ENV variables `LASTFM_API_KEY`, and `LASTFM_API_SECRET`.
##
## lastfm consists of multiple submodules:
##
## - `artist<./lastfm/artist.html>`_
## - `track<./lastfm/track.html>`_
## - `album<./lastfm/album.html>`_
## - `tag<./lastfm/tag.html>`_
## - `chart<./lastfm/chart.html>`_
## - `geo<./lastfm/geo.html>`_
## - `user<./lastfm/user.html>`_
##

# TODO: add support for JS toolchain?

include lastfm/auth
import lastfm/[track, artist, album, tag, chart, geo, user]

export LastFM, AsyncLastFM, SyncLastFM