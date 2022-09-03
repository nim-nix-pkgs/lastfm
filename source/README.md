**lastfm-nim** [![pipeline status](https://gitlab.com/tandy1000/lastfm-nim/badges/master/pipeline.svg)](https://gitlab.com/tandy1000/lastfm-nim/-/commits/master)

```nim
import lastfm
import lastfm/[track, artist, album, tag, geo, user]
```

**[Full documentation is available here.](https://tandy1000.gitlab.io/lastfm-nim/)**

This library contains multisync-friendly bindings to the Last.FM web API. The library returns API data as JsonNodes.

The list below shows each API method exposed by the package, the function implementing that method, and the submodule in which it is implemented:

**API methods in `lastfm/track`**

 - track.addTags: `trackAddTags`
 - track.getCorrection: `trackCorrection`
 - track.getInfo: `trackInfo`
 - track.getSimilar: `similarTracks`
 - track.getTags: `trackTags`
 - track.getTopTags: `trackTopTags`
 - track.love: `loveTrack`
 - track.removeTag: `trackRemoveTag`
 - track.scrobble: `scrobble`
 - track.search: `searchTracks`
 - track.unlove: `unloveTrack`
 - track.updateNowPlaying: `setNowPlaying`

**API methods in `lastfm/artist`**
 - artist.addTags: `artistAddTags`
 - artist.getCorrection: `artistCorrection`
 - artist.getInfo: `artistInfo`
 - artist.getSimilar: `similarArtists`
 - artist.getTags: `artistTags`
 - artist.getTopAlbums: `artistTopAlbums`
 - artist.getTopTags: `artistTopTags`
 - artist.getTopTracks: `artistTopTracks`
 - artist.removeTag: `artistRemoveTag`
 - artist.search: `searchArtists`

**API methods in `lastfm/album`**
 - album.getInfo: `albumInfo`
 - album.addTags: `albumAddTags`
 - album.removeTag: `albumRemoveTag`
 - album.getTags: `albumTags`
 - album.getTopTags: `albumTopTags`
 - album.search: `searchAlbums`

**API methods in `lastfm/tag`**
 - tag.getInfo: `tagInfo`
 - tag.getSimilar: `similarTags`
 - tag.getTopAlbums: `topAlbumsForTag`
 - tag.getTopArtists: `topArtistsForTag`
 - tag.getTopTracks: `topTracksForTag`
 - tag.getTopTags: `topTags`
 - tag.getWeeklyChartList: `weeklyChartsForTag`

**API methods in `lastfm/chart`**
 - chart.getTopTracks: `chartTopTracks`
 - chart.getTopTags: `chartTopTags`
 - chart.getTopArtists: `chartTopArtists`

**API methods in `lastfm/geo`**
 - geo.getTopTracks: `geoTopTracks`
 - geo.getTopArtists: `geoTopArtists`

**API methods in `lastfm/user`**
 - user.getInfo: `userInfo`
 - user.getLovedTracks: `userLovedTracks`
 - user.getRecentTracks: `userRecentTracks`
 - user.getPersonalTags: `userPersonalTags`
 - user.getTopTracks: `userTopTracks`
 - user.getTopArtists: `userTopArtists`
 - user.getTopAlbums: `userTopAlbums`
 - user.getTopTags: `userTopTags`

Furthermore, the following client authentication flows are supported:

 - [Desktop Application Flow](https://www.last.fm/api/desktopauth) using the `desktopAuth` proc.
 - [Mobile Application Flow](https://www.last.fm/api/mobileauth) using the `mobileAuth` proc.
 - Or, provide an already-authenticated session key directory using the `loadAuth` proc.
