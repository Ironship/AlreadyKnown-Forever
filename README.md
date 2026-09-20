# Already Known? — Forever

[Already Known?](https://github.com/ahakola/AlreadyKnown) by Sanex (ahakola),
running on **World of Warcraft: Forever** (build 1.60.x). It tints the items a
vendor, the auction house or a guild bank offers that you already know, so you
do not buy a second copy of a recipe you have.

## Why it needed a port at all

Upstream ships two files and lets the client choose between them:

```
AlreadyKnown.lua        [AllowLoadGameType mainline]
AlreadyKnownClassic.lua [AllowLoadGameType classic]
```

Forever answers `WOW_PROJECT_ID` like Retail, so it takes the mainline file —
which asks `C_MountJournal`, `C_PetJournal` and `C_TransmogCollection` what is
collected. This client has none of those. The Classic file is the one that
fits: it reads the red *Already known* line off the tooltip, which is how a
Vanilla client says it, and it guards every collections call it makes.

## What is different from upstream

| change | why |
| --- | --- |
| `## Interface: 16001` | the number this client loads addons for; upstream's list is Retail, MoP, Cata, TBC and Era |
| only `AlreadyKnownClassic.lua` ships, with no game-type condition | the condition would hand this client the Retail file |
| one line in that file: `isClassic` also true when `AlreadyKnownForever.isForever` | every Vanilla path in the file hangs off `isClassic` — warlock grimoires, the old auction house, no guild bank — and `WOW_PROJECT_ID` says Retail here |
| the cosmetic-item branch now checks that `C_TransmogCollection` exists | it was the one collections call in the file without a guard; harmless where there are no cosmetic items, an error the day there are |
| the guild bank hook is kept on Forever | the same `isClassic` that turns on the Vanilla paths also says "no guild bank, stop listening", which is true of Classic Era and not known to be true here |
| `forever.lua` | ours: works out whether this is Forever, and `/akforever` says what the client has |

Everything else is upstream's, unchanged. The Retail file is not shipped.

## What the client actually answered

Measured in the game on 2026-09-20, build 1.60.1 (69913), interface 16001:

```
WOW_PROJECT_ID = 1                                    -- Retail's value
PetJournal=true MountJournal=true Transmog=true TooltipInfo=true
```

So Forever is not the bare Classic Era surface this port was built on the
assumption of: the collections journals are all there. It does not change
which file belongs here, and gives a better reason than the original one. The
Classic file guards every journal call with `if C_PetJournal then` rather than
with a flavour test, so on this client it uses the journals *and* the tooltip;
and its `ADDON_LOADED` handler hooks both auction houses, the Vanilla one and
the Retail one, whichever this client opens. The Retail file assumes the
journals and the Retail auction house, and would miss whatever this game does
the old way.

## Commands

`/alreadyknown` or `/ak` — colours, monochrome, debug, as upstream.
`/akforever` or `/akf` — what this client is, whether it was recognised as
Forever, which collections exist, and whether the vendor hook took.

## Licence

MIT, upstream's, in `LICENSE.md` — Copyright (c) 2015-2026 ahakola. This folder
is a modified redistribution; the changes are the table above.

Upstream at the time of the port: 1.102.
