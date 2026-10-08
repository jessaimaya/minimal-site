---
title: "Count Echula"
description: "A rhythm game I designed and built in five days with a coding agent, then finished by hand. My entry for the Rive Halloween Challenge 2026."
date: 2026-10-07
cover: "/blog/count-echula/cover.jpg"
embed:
  src: "https://game-production-96d0.up.railway.app/web/"
  title: "Count Echula"
  poster: "/blog/count-echula/poster.jpg"
  aspect: "9 / 16"
stack:
  - Rive CLI and Markup Language
  - GPU Canvas (WGSL shaders)
  - Luau
  - Rive Editor
  - Claude Code
  - Python
  - Railway
links:
  - label: "Play full screen"
    url: "https://game-production-96d0.up.railway.app/"
  - label: "Source on GitHub"
    url: "https://github.com/jessaimaya/count-echula"
---

On Halloween night, Count Echula, a vampire turned into a tiny bat with oversized headphones, flies down a street he can't see. Bats find their way by echolocation, so the only light in the game is his sonar, and it only fires when he catches candy on the beat. Swipe between three lanes, keep the trail lit, and dodge the garlic hiding in the dark.

It's my entry for the Rive Halloween Challenge 2026, which runs until October 12. Play it above. It works best on a phone.

## At a glance

- **My role:** game design, art direction, illustration, motion, code and deployment.
- **Timeline:** first commit on September 30, feature freeze on October 4.
- **Scope:** three songs with their own beatmaps, a title screen with a record shelf, pause, results and a finale.
- **How:** a coding agent wrote most of the scene markup, game logic and shaders from my specs. I drew the character, animated him by hand and made the calls on what to cut.

<video src="/blog/count-echula/gameplay.mp4" poster="/blog/count-echula/gameplay.jpg" autoplay muted loop playsinline aria-label="Gameplay: the bat follows a candy trail down a dark street"></video>

## The idea

The design started from one sentence: *I can see because I'm on the beat.* The music is both the input and the lighting. Catch the candy on the beat and the sonar lights the next stretch of street. Miss it and you fly blind into the garlic.

The audience was contest judges and people scrolling social media, so the brief I gave myself was "understandable in 5 seconds, fun in 30". That rule decided most of the cuts. An echo meter and a manual sonar tap both made it into early builds and both came out: once catching candy fired the sonar on its own, the extra controls only made the game harder to read.

## Working with a coding agent

Rive's CLI and markup language are newer than any model's training data, so the agent couldn't rely on memory. Most of the work was giving it the right context and limits:

- **Specs as context.** Before any code, I wrote a game design document and a technical spec: mechanics, timing windows, the data model, the render passes and a schedule. Every change in direction went into them with a date, so the agent always worked from the current decision, not an old one.
- **Rules for every edit.** Look up types in the CLI's own docs instead of guessing, compile and inspect after each change, and render a screenshot whenever appearance matters. A clean build isn't enough: check the output against what was asked.
- **The riskiest part first.** Day one was a throwaway prototype of the hardest unknown: a depth-tested 3D street with a sonar post-process, running in Rive on WebGL2. Each spike had a pass criterion and a fallback written down before starting.
- **A release gate.** Nothing goes to a public host until I say the game is finished. The agent could build, test and sign local builds, but had to ask before uploading to my Rive account, and public publishing was off limits.
- **Prompting beyond code.** The three songs were generated with YuE2. Those prompts carried hard constraints from the engine, like a steady 120 BPM and straight eighth notes, because the beat clock assumes a constant tempo.

## Where I took over by hand

The agent was fast at systems. The character, the feel and the taste were mine:

- **Art.** I drew Echula and the props as SVG. A small converter turns my drawings into Rive artboards, and the renderer takes every piece of art as an input, so new art drops in without touching the game code.
- **Motion.** I drew Echula's front view and animated his salute by hand in the Rive Editor, then pulled that work back into the code project. The round trip has sharp edges: a push overwrites Editor work, and a pull rewrites asset paths. I wrote each one down as I hit it, so neither the agent nor I would lose work twice.
- **Juice.** Squash and stretch on lane changes, a spring roll, barrel rolls when the music bursts into color, and a reaction for everything: he gulps candy, gets dizzy on garlic and sweats after a miss.

## Checking it before anyone else does

- **Tests.** The rules (beat clock, beatmaps, gestures, scoring) are covered by logic tests that run from the CLI.
- **Visual checks.** Screenshots from the CLI and from headless Chrome confirm what renders, not just that it compiles.
- **Real phones.** Phones have no devtools, so the page shows its own FPS, worst frame and an error panel. Testing on a real iPhone found what no emulator did: the runtime's single-touch lock could drop a touch end and freeze every control after it. Sound also only starts inside a user gesture, so the page unlocks audio on every tap.
- **Edge cases.** Turn the phone sideways or switch apps mid-song and the game pauses, then comes back on its pause menu.

## Shipping in stages

Local signed builds first, then my phone over the local network, then a hosted test build for friends: a static page behind Caddy with a small Python API, deployed to Railway with one script. The public release happens only after I sign off.

The hosted build also records anonymous play stats, with no cookies and no IP addresses: sessions, which record people pick, how far they get, scores, session length and device. It's a small funnel, from opening the page to finishing a song, and a password-protected dashboard I built to read it.

## What the first players did

I shared the test build with friends, and the stats started counting on October 4. In the first four days:

- **22 players and 33 sessions.** 8 players came back for another go.
- **32 songs played.** Half were finished, and 10 ended in game over.
- **26 of the 32 plays were the first record.** Most players never swiped the shelf to the other two songs.
- **73% played on desktop,** although I designed the game for phones first. The desktop backdrop I added on day five turned out to frame most of the plays.

<img src="/blog/count-echula/stats.jpg" alt="The play stats dashboard: players, sessions, songs played and finished, plays per song, devices, systems and browsers" loading="lazy" />

It's a small, friendly sample, so I read these numbers as signals, not results. Two of them tell me what to test next. The record shelf hides the best moments, like the Cold Moon freeze and the blackout, so the next build should make the other records easier to find, for example by teasing the next song on the results screen. And the easy song ends in game over about a third of the time (9 of 26 plays), which suggests the first garlic comes too early for someone who is still learning the controls.

## What carries over

The same habits apply to shipping web pages with AI. Give the agent the brief and the constraints up front. Make it verify its own output. Keep a human gate before anything goes public. Test on real devices. Measure what people actually do. And know which parts the tools should do and which ones need your own hands.

Music generated with [YuE2](https://github.com/multimodal-art-projection/YuE). Fonts: Creepster and Fredoka, both under the SIL Open Font License.
