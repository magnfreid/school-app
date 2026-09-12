# Project: School Schedule Wall Display

This document is the product brief — what the app is for and why. For code
structure and conventions, see [`CLAUDE.md`](../CLAUDE.md).

## Goal

Wall-mounted device in son's (Hidde, åk 7, Kunskapsskolan Uppsala Norra) room
showing upcoming tests, homework, and school events, sourced automatically
from the school's communications — no manual data entry.

## Data sources (confirmed viable)

### 1. Weekly newsletter ("Veckobrev") — via Gmail

- Sent by class team (Henrik Norrby et al.), roughly weekly (observed:
  Fri/Thu, week-to-week, not a fixed day/time).
- Contains an "Arbetsmål" (work goals) table per subject (Ma, Sv, MS, NO, SO,
  IDH) — this is the primary source for **homework** and short-notice items.
- Caveat: "MS" = all three language tracks (ty/fr/sp) lumped together in one
  line — cannot reliably extract Spanish-specific homework from this alone.
- Occasionally has a PDF attachment ("Information från rektor") with
  school-wide news — may contain relevant whole-school events, mixed in with
  irrelevant admin news.
- Access: Gmail connector, search query like
  `from:henrik.norrby@kunskapsskolan.se`.

### 2. Term calendar ("Kalendarium") — via Google Drive

- A shared Google Doc, one table per grade (Åk 7/8/9), linked from the
  newsletter.
- Contains **tests, deadlines, field trips, theme weeks** — curated "notable
  events" only, NOT routine weekly homework (structural limitation, not a
  parsing bug).
- Format is messy: raw markdown-ish table, merged/blank rows,
  `\*\*bold\*\*` markers, `&#10;` line-break entities instead of clean
  delimiters, no real dates — only Swedish week numbers (need ISO week → date
  mapping for 2026/27).
- Access: Google Drive connector, `read_file_content` on the doc.
- Fragility: doc access depends on the school continuing to share it;
  ID/structure may not persist term-to-term.

### Both sources needed together

Newsletter = homework + short-notice items. Kalendarium = tests/deadlines/
events with longer horizon. They're not always in sync (confirmed one real
gap: a homework item appeared in the newsletter but not the doc — expected
behavior, not a bug). Treat as two independent inputs into the same calendar;
dedupe on (subject + week) when both mention the same item.

## Dead end (don't pursue)

Tried getting data via the parent portal (`portal.kunskapsskolan.se`, BankID
via `login.grandid.com`) — it's a pure **Blazor Server** app (confirmed via
WebSocket connection to `/_blazor`). No REST/JSON API exists; data is pushed
via SignalR in a non-JSON format. Not worth reverse-engineering. Also, BankID
auth resists automation (designed to require human/device confirmation), so
scripted login isn't realistic either. Abandoned in favor of the email/doc
approach above.

## Target architecture

```
[Gmail: Veckobrev]  ---\
                        >--> Claude Cowork scheduled task (1-2x/week)
[Drive: Kalendarium] --/         - polls both sources
                                  - curates & dedupes into events
                                  - writes events via Google Calendar connector
                                          |
                                          v
                          [Shared Google Calendar: "Hidde – Skola"]
                                          |
                                          v
                     [Flutter app on wall-mounted Android tablet]
                        - periodic pull from Google Calendar API
                        - simple read-only display UI
```

Rationale: use a real calendar as the sync layer instead of a custom
home-wifi push — calendars already solve multi-device sync, offline caching,
and permissions for free. The Flutter app's scope shrinks to "render this
calendar nicely," not "build a sync protocol."

Status: Gmail and Drive connectors already in use and working. Google
Calendar connector confirmed available (has `create_event`) but not yet
connected — connect before building the Cowork task's write step.

## Device & framework decisions

- **Device**: old Samsung Galaxy Tab S3, model SM-T825. Maxes out at
  **Android 9 (Pie), API level 28** — this is a hardware ceiling, not a
  choice. Set both `minSdkVersion` and `targetSdkVersion` to 28. Sideloaded,
  not Play Store, so no yearly targetSdk bump requirement applies.
- **Framework: Flutter** (over native Kotlin/Compose). Decision rationale:
  performance is a non-factor for this app on this device — it's a single
  dedicated-purpose display (no competing apps for the 4GB RAM), UI is a
  simple calendar view with periodic network refreshes (no heavy
  scrolling/animation/camera work), and it boots once and stays running
  (cold-start cost irrelevant). Given performance is a wash, went with
  Flutter as the stronger developer preference/skill.
- Avoid: persistent foreground services, heavy background polling. Use a
  periodic background fetch pattern (e.g. `workmanager` package) instead.

## Open items / next steps for build phase

1. Connect the Google Calendar connector (for the Cowork scheduled task to
   write to).
2. Design the Cowork task prompt: what exact curation/dedup logic, how far
   ahead to look, how to convert Swedish week numbers to real dates for
   HT26/27.
3. Decide read approach for the Flutter app: Google Calendar REST API
   directly, or a Flutter calendar package (e.g. `googleapis` Dart package) —
   needs OAuth/service account setup for a device with no interactive Google
   sign-in flow ideally (consider a service account with calendar shared to
   it, to avoid repeated login on the tablet).
4. Kiosk/always-on setup for the tablet (Android 9-compatible kiosk mode or
   lock task mode) — not yet investigated.
5. Basic UI: what to show (this week vs. upcoming), how to visually
   distinguish homework vs. tests vs. events.
