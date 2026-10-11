# CHANGES

## 2026.10.10 — Removed `pcall` from `TeleporterChecker.lua`

### Goal
Per maintainer request, remove the `pcall` protective wrappers from `BeamMeUp/core/TeleporterChecker.lua` so errors surface to ESO's error handler / LibAsync's own error protection instead of being silently swallowed by the addon.

### Changes
- `BeamMeUp/core/TeleporterChecker.lua` — removed all 10 `pcall` calls:
  - `BMU.getNumSetCollectionProgressPieces`: removed the LibSets "can-you-call" probes. The LibSets call is now direct, guarded by the existing `if BMU.LibSets and ...` type check. The parent-zone fallback (delves / public dungeons) is unchanged.
  - `BMU.startOwnHousesCacheBuild` / `collectEntry`: `BMU.createOwnHouseCacheEntry` is called directly. An error aborts the LibAsync loop; LibAsync's own `pcall` then runs the `OnError`/`Finally` handlers (kept as-is, they set `buildFailed` and never publish a partial cache).
  - `BMU.getAllHouseTourHouseIds`: `ZO_COLLECTIBLE_DATA_MANAGER:GetAllCollectibleDataObjects`, `COLLECTIONS_BOOK_SINGLETON.GetAllCollectibleDataObjects`, and `house.GetReferenceId` are called directly. The original `ZO_COLLECTIBLE_DATA_MANAGER and ZO_CollectibleCategoryData and ZO_CollectibleData` guards are preserved, now combined with the `type(...) == "function"` method check; the singleton fallback chain is unchanged.
  - `BMU.setHouseTourHouseIdFilters`: bulk / clear / add filter methods are called directly. The `result ~= false` acceptance checks and the bulk → clear+add → fail fallback chain are unchanged.
  - `BMU.enrichHouseTourListing`: removed the `pcall(function() ... end)` wrapper and the `if not ok then BMU_printToChat(...) end` branch. The body is dedented one level. An error propagates to LibAsync, which aborts the remaining loop and runs the existing `OnError`/`Finally` handlers (finalize the build and restore the game's House Tours filters with the listings enriched so far).
- Removed the corresponding "protected by pcall" comments and updated the function-level doc comments.

### Limits
- The synchronous fallback (no LibAsync) path is now unprotected: if `enrichHouseTourListing` raises, `finishBuild` never runs and `houseTourSearchPending` stays true for the session (House Tours search blocked until reload). The user asked for `pcall` to be removed, which makes this a known regression on that path, not a silently accepted trade-off; the LibAsync path (recommended) is still protected by LibAsync's own error handling.
- LibAsync 3.1.5's internal `runProtectedCall` was verified to call `OnError`/`Finally` on a raised step error and clear the callstack.
- Not tested in game; verified by compiling and executing an adapted copy of the file under Lua 5.5 in an offline ESO-simulated test harness (ESO is Lua 5.1, so the harness applies a small pre-existing-idiom shim for the Lua 5.5 runtime; the shipped file itself is unchanged in those idioms). This validates the modified code paths; it does not substitute for in-game testing.

## 2026.10.08 — LibAsync becomes a pure optional dependency

### Goal
LibAsync was embedded in the addon (`lib/LibAsync/`) as a fallback copy. It is now a pure optional external dependency: the embedded copy is removed, and the startup verifies that a standalone LibAsync is present and loaded before BeamMeUp.

### Changes
- Removed the embedded library: `BeamMeUp/lib/LibAsync/` deleted, and the `lib/LibAsync/LibAsync.lua` entry removed from `BeamMeUp.addon.template` and `BeamMeUp/BeamMeUp.addon`. `LibAsync` remains in `OptionalDependsOn`, so ESO loads a standalone LibAsync BEFORE BeamMeUp when it is installed.
- `BeamMeUp/core/TeleporterChecker.lua`: new `BMU.checkLibAsyncLoaded()` — returns true when LibAsync was found; otherwise prints a localized chat hint (always visible, once at startup) explaining that LibAsync should be installed as a standalone addon loaded before BeamMeUp, and that the background caches fall back to a synchronous build (lists stay correct, startup frames busier).
- `BeamMeUp/BeamMeUp.lua` (`OnAddOnLoaded`): the check runs right after `BMU.GetLibraries()`.
- New localization string `SI_TELE_CHAT_LIBASYNC_MISSING` added to all 10 languages (EN, DE, FR, ES, IT, BR, PL, RU, JP, ZH).
- Code paths unchanged otherwise: every LibAsync consumer already had a synchronous fallback (own houses cache, House Tours enrichment), so nothing changes for users who keep LibAsync installed; without it, everything still works synchronously.

### Limits
- Verified through static analysis and automated tests with simulated ESO APIs (check returns true/false, hint printed exactly once without LibAsync, no hint with LibAsync); not tested in game.

## 2026.10.08 — Tooltip on the house name

### Goal
House entries showed their tooltip only on the zone-name column. The displayed house/owner name now has its own tooltip.

### Changes
- `BeamMeUp/core/List.lua` (`ListView:update`, house branch `message.houseId ~= nil`):
  - `OnMouseEnter` / `OnMouseExit` handlers on `ColumnPlayerNameTex` (the overlay of the displayed house name), following the existing player-name tooltip pattern: the content is the entry's existing `message.houseTooltip` (house name + nickname for own houses; house name + nickname + colorized owner for House Tours; rich content in the Houses tab: zone, nickname, parent zone, icon, category, furniture count).
  - The tooltip text is linked to the control (`tooltipText`) so it follows the same refresh-on-scroll path as the other tooltips, and pauses auto-refresh while hovered.
  - Entries without a `houseTooltip` keep the previous behavior (no handlers).

### Limits
- Verified through static analysis (pattern identical to the player-name tooltip, same data source as the zone-name tooltip); the list row rendering is not covered by the automated ESO-API test harness and was not tested in game.

## 2026.10.08 — Timing checkpoints for the LibAsync cache builds

### Goal
Verify the latency gain of using LibAsync for the background cache builds, in game.

### Changes
- `BeamMeUp/core/TeleporterChecker.lua`
  - New timing helpers (file-local, shared by both background builds):
    - `createCacheBuildStats` / `timeCacheBuildStep` / `logCacheBuildStats`.
  - Both LibAsync builds now measure, per build:
    - `workMs`: accumulated time actually spent inside the build steps;
    - `maxStepMs`: longest single step — with LibAsync this is (close to) the per-frame cost, while the synchronous fallback blocks ONE frame for the whole `workMs`;
    - `totalMs`: wall-clock time from build start to finalization;
    - plus `entries` (published rows), `steps` (items processed) and `async` (build mode).
  - The numbers are always stored on `BMU` for programmatic checks (`BMU.ownHousesCacheStats`, `BMU.houseTourCacheStats`) and printed to chat in Debug Mode (`BMU.debugMode`), e.g.:
    `[BMU <version> HouseToursCache] LibAsync: 412 entries in 413 steps, work 380.42 ms (max step 1.85 ms), total 4120.00 ms`.
  - The synchronous fallback measures the same numbers, so both modes can be compared directly (the fallback's `totalMs` ≈ its `workMs`, all in one frame).
- Instrumented: own houses cache build (`BMU.startOwnHousesCacheBuild`, task `BMU_OwnHousesCache`) and House Tours enrichment (`BMU.buildHouseToursCacheEntries`, task `BMU_HouseToursCache`), in both the LibAsync path and the synchronous fallback.

### Limits
- Verified through static analysis and automated tests with simulated ESO APIs (stats stored, fields consistent with the build, debug line logged, own houses build and synchronous fallback covered); not tested in game. The in-simulator timings validate the checkpoints, not real-world performance.

## 2026.10.08 — House Tours: initial search at addon load

### Goal
The House Tours cache only started on the first list refresh (section 5b of `BMU.createTable` triggering `RequestHouseTourSearch`). The initial search is now started as soon as the addon loads.

### Changes
- `BeamMeUp/BeamMeUp.lua` (`OnAddOnLoaded`, right after the House Tours search callback registration): if the `showHouseTours` setting is enabled, `BMU.RequestHouseTourSearch()` is called directly.
  - The search runs on the server; the enrichment of the results stays in the background via LibAsync (`BMU.buildHouseToursCacheEntries`), so the startup time is not penalized.
  - `refreshListAuto` is a no-op while the teleporter window is hidden (existing guard), so the refreshes triggered when results arrive are harmless during login.
  - The existing safeguards apply: `RequestHouseTourSearch` ignores redundant calls ("search in progress" state), and a disabled `showHouseTours` setting starts no search at all.

### Limits
- Verified through static analysis and an automated test with simulated ESO APIs (initial launch, no duplicate search, background fill, state release); not tested in game.

## 2026.10.08 — House Tours: background cache enrichment

### Goal
At the end of a House Tours BROWSE search, the `onHouseTourSearchComplete` callback used to enrich every listing synchronously (ESO API calls: house zone, parent zone, formatted names, nickname, map index, `applyHouseFixedMapData`, special cases 102/124...); with several hundred houses this work blocked the frame. The enrichment now runs in the background via LibAsync, following the model of the owned houses cache.

### Changes
- `BeamMeUp/core/TeleporterChecker.lua`
  - `onHouseTourSearchComplete` now only collects the cheap raw data (houseId, owner, name, collectibleId), with the same exclusions as before (owned houses, duplicates by houseId, the player's own listings).
  - New functions:
    - `BMU.enrichHouseTourListing`: computes all static fields of one raw listing (identical to the old path, including the house 102 "world map" variant and the parent zone overrides); protected by pcall — a failing listing is skipped without interrupting the build.
    - `BMU.buildHouseToursCacheEntries`: spreads the enrichment over several frames via LibAsync (task `BMU_HouseToursCache`); a new search during the enrichment cancels the running task (generation guard: a cancelled task can never finalize its replacement's build, and the finalization runs exactly once even if the completion callback fails); without LibAsync, synchronous fallback.
    - `BMU.finishHouseTourSearch`: merge (deduplication by houseId + context zone, existing entries first) then the filter batch chain, as before.
  - The "search in progress" state (`houseTourSearchPending`) is held for the whole enrichment: `RequestHouseTourSearch` stays blocked, so no concurrent search can restart the batch chain (batch index, game filters) in the middle of a build; it is released at finalization (or on the error paths).
  - For house 102, the "world map" variant is now built before insertion: an error while building it skips the whole house instead of publishing an incomplete entry.
  - The previous cache stays in use until the enrichment finishes; the batch chain continues even when listings fail, so the game's House Tours filters are always restored.
- `BeamMeUp/TeleporterGlobals.lua`: background enrichment state (`houseTourCacheBuilding`, `houseTourCacheBuildTask`, `houseTourCacheBuildGeneration`) and updated comment for `houseTourListings` (enriched listings).
- Updated the comment of section 5b of `BMU.createTable` (background enrichment).

### Limits
- Verified through static analysis and automated tests with simulated ESO APIs (LibAsync enrichment spread over several frames, publication, blocking of concurrent searches during the build, cancellation of a running task with the new task's results published exactly, batch transition, error in the finalization without double finalization, synchronous fallback without LibAsync, exclusions/deduplication, cases 102/124, per-listing error skipped); not tested in game. The tests with a simulated scheduler validate the sequence of operations, not a frame-level performance measurement.

## 2026.10.08 — Optimized house display

### Goal
The display of owned houses (main list and Houses tab) used to recompute, on every refresh, all the static data of each house through the ESO APIs (GetHouseZoneId, GetCollectibleIdForHouse, GetZoneNameById, GetCollectibleDefaultNickname, GetCollectibleInfo, LibZone lookups, name formatting...). This data is static for a game session: it is now computed once, at startup, in a cache filled in the background.

### Changes
- `BeamMeUp/core/TeleporterChecker.lua`
  - New `BMU.ownHousesCache`: static entries per house (house/zone/collectible identifiers, formatted and unformatted zone names — with and without articles —, formatted default nickname, parent map, category, category type, icon, preview background image), built in the background at startup via LibAsync (`BMU.startOwnHousesCacheBuild`, task `BMU_OwnHousesCache` spread over several frames).
  - The main list (`BMU.createTable`, "Own houses" section) and the Houses tab (`BMU.createTableHouses`) now copy the static values from the cache; the (renameable) nickname, the primary residence and the furniture count are still read live. Filters, sorting and per-entry enrichment (addInfo_2, applyHouseFixedMapData) are still applied on every refresh.
  - The traversal order of the cached houses is identical to the direct path (the original enumeration is kept, no sorting by identifier), so the house kept per zone ("one entry per zone only" setting / per-zone house preference) does not change.
  - Automatic background rebuild on collection changes, with a 2 s debounce and queueing if a build is already running (never lost). Events listened to (matching the game's collectible manager, [collectibledatamanager.lua](https://raw.githubusercontent.com/esoui/esoui/live/esoui/ingame/collections/collectibledatamanager.lua)): EVENT_COLLECTIBLE_UPDATED (renames), EVENT_COLLECTIBLES_UNLOCK_STATE_CHANGED (unlocks: purchases) and EVENT_COLLECTION_UPDATED (full refresh).
  - Safe fallback: as long as the cache is not built (or on an error during the build — each house is processed in a protected way and the existing cache is kept), the old code path is used — the lists stay correct in all circumstances.
  - Fixed along the way: in the main list, `houseNameFormatted` was computed with a collectible identifier read before its assignment; the identifier is now assigned before the call, as in the Houses tab.
- `BeamMeUp/BeamMeUp.lua`: cache build started at the player's first activation (`PlayerInitAndReady`) and registration of the collection event handlers.
- `BeamMeUp/TeleporterGlobals.lua`: declaration of the cache state.
- LibAsync 3.1.5 embedded in the addon (`BeamMeUp/lib/LibAsync/LibAsync.lua`) with a double-load guard and direct (non-persistent) variable initialization: if a standalone LibAsync is installed, it is used instead of the embedded copy (declared as `OptionalDependsOn`). Without LibAsync, fallback to a synchronous build (cheap: only the owned houses are iterated).
- `BeamMeUp.addon.template` / `BeamMeUp/BeamMeUp.addon`: entry for the embedded LibAsync file and optional dependency.

### Limits
- Verified through static analysis and automated tests with simulated ESO APIs (build, publication, error, rebuild, path equivalence with/without cache, identical traversal order); not tested in game. The tests with a real scheduler validate the sequence of operations, not a frame-level performance measurement.
