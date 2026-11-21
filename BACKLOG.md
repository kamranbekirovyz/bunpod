# Backlog

Things to build and subtle things to improve.

- [ ] Adaptive Android app icon
- [ ] Add a native splash screen
- [ ] Add localization
- [ ] Add a home screen widget
- [ ] Derive color scheme from the phone wallpaper
- [ ] Assign a random expressive avatar as the profile picture
- [ ] CarPlay
- [ ] Desktop
- [ ] Add UserOrient as a sponsor
- [ ] cache audios
- [ ] ask for review
- [ ] display 400's error message (like invalid opml file)
- [ ] localization
- [ ] home widgets
- [ ] share to social media
- [ ] favorites

## RSS performance

- [ ] Parse feeds off the UI thread (`Isolate.run`), big feeds like The Daily are 3000+ items
- [ ] Stop parsing once ~20 already-stored guids in a row are seen
- [ ] Stream the response instead of holding the whole body in memory
- [ ] Skip rewriting episodes that didn't change (only insert new guids)
- [ ] Load "All" from one query instead of one per channel on restore
- [ ] Cap stored episodes per feed, or drop feeds of channels only visited, not followed
- [ ] Refresh feeds in the background so the app opens already fresh

## Local-first review

- [ ] `FollowPicksCubit.follow` doesn't catch errors, so one failed lookup leaves onboarding loading forever
- [ ] Offline launches wait the full 5s migration budget until every legacy subscription has moved; skip when offline or cap the attempts
- [ ] Legacy subscriptions Podcast Index never finds are retried forever; give up after a few launches
- [ ] Upgrading users see the welcome page again; skip it when they already have subscriptions
- [ ] Firebase init fails without Firebase keys, so contributors can't run with only a Podcast Index key
- [ ] Apple retries the US store on any error, offline included, doubling failed requests; only fall back on 4xx
- [ ] Feeds that move (301 or `itunes:new-feed-url`) aren't followed, and progress is keyed by feed URL so it would be lost
- [ ] Feeds Podcast Index doesn't know can't be followed, since subscriptions are keyed by its id; consider keying by feed URL
- [ ] OPML import of 500 feeds can cost ~2500 Podcast Index calls; check their rate limit
- [ ] Unit tests for the pure parts: `RssParser`, `OpmlParser`, `OpmlMatcher` queries, `mapWithLimit`
