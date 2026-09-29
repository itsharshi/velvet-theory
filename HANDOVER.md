# VELVET/THEORY — how to keep working on this site

Written for: whoever picks this up next — you, or an AI assistant you paste this into.

---

## 1. What this site is

A photography portfolio. **One HTML file, one CSS file, and a folder of
photographs.** No React, no Tailwind, no build step, no npm, no server.

| File | What it is |
|---|---|
| `V2-PORTFOLIO.html` | The entire site — HTML, CSS and JavaScript in one file (~5,850 lines) |
| `mobile.css` | Phone styles only. Everything inside `@media (max-width: 820px)` |
| `images/` | Every photograph, plus `_sprite.jpg` |
| `publish.ps1` | Builds the `PUBLISH/` folder for deploying |
| `PUBLISH/` | What actually goes on the web. Never edit by hand — it is generated |

**To see the site:** double-click `START-PORTFOLIO.bat`, or open
`V2-PORTFOLIO.html` in any browser. It works offline.

Everything else in this folder (`V1-*.html`, `*-SAMPLE.html`,
`*-STUDY.html`, `PARKED-*.txt`, `.bak`) is old experiments and drafts.
None of it is used by the live site. You can ignore it all.

---

## 2. How to deploy a change

1. Edit `V2-PORTFOLIO.html` (or `mobile.css`)
2. Open the file in a browser and check it
3. Run `publish.ps1` — right-click → *Run with PowerShell*
4. Go to https://app.netlify.com → your site → **Deploys**
5. **Drag the whole `PUBLISH` folder** onto the drop zone

The live site is https://velvet-theory.netlify.app

`publish.ps1` copies the page as `index.html`, copies `mobile.css`, and
shrinks every photograph to 1800px at quality 82 (about half the bytes,
no visible loss). It copies only the ~78 photographs the page actually
references, not all 114 in the folder.

---

## 3. THE IMPORTANT PART — working with an AI chat

The file is **245 KB / 5,850 lines. Do not paste the whole thing into a
chat.** It will be truncated without warning, and the assistant will then
confidently rewrite parts it cannot see and break things.

**Instead: paste this document, then paste only the section you want changed.**

### The routine, every single time

1. **Start a new chat** for each change. A long chat loses the early
   context, and it will forget the rules below exactly when it matters.
2. **Paste this whole document first.** It is short enough to fit.
3. **Paste only the section you are changing.** One CSS block, or one
   function. Use the line-number table above to find it.
4. **Ask for a REPLACEMENT for that section only**, plus the exact text to
   search for so you can find where it goes.
5. **Copy the file before you paste anything in.** One bad edit in a
   single-file site breaks everything.
6. **Open the page and look at it** before asking for the next change.

### The opening message

> This is a single-file HTML photography portfolio — about 5,900 lines,
> plain HTML/CSS/vanilla JavaScript, no build step, no React, no Tailwind,
> no npm. I cannot paste the whole file, so here is a handover document
> explaining the structure, followed by just the section I want changed.
>
> Give me back ONLY a replacement for that section. Tell me the exact text
> to search for so I know where it goes. Do not rewrite anything you
> cannot see, and do not suggest adding a framework or a build step.
>
> [paste HANDOVER.md]
>
> [paste the section]

### When it gives you something that does not work

Say what you SEE, not what you think is wrong. "The cards are now tall
white slabs with the text overflowing" gets a fix. "It's broken" does not.
A screenshot is better than either.

If it gives you a fix that makes things worse twice in a row, go back to
the copy you saved and start that change again in a fresh chat. It is
almost always faster than trying to unpick it.

### Things it will get wrong

- **It will suggest React, Tailwind or npm.** Say no. This site has none
  of them and does not need them.
- **It will rewrite code it cannot see.** If it hands you a whole file, or
  a function you did not paste, do not use it.
- **It will invent facts about you.** Check anything about your work,
  experience or clients before it goes on the site.
- **It cannot test anything.** Every change it gives you is a guess until
  you open the page and look.

### Where things live

Open the file in Notepad++ or VS Code and use **Ctrl+G** to jump to a line.
These shift as the file is edited — if a number looks wrong, search for the
section NAME instead. Every section has a banner comment in capitals.

**Styles** (inside one big `<style>` block near the top)

| Line | Section |
|---|---|
| 173 | Top bar |
| 193 | Theme button (light/dark) |
| 425 | Hero — the pixel grid |
| 1253 | Hidden frames |
| 1810 | Reactions |
| 2217 | About — the scattered cards |
| 2505 | Footer |
| 2560 | Responsive (desktop breakpoints) |

**Markup** — search for these:

- `<section class="hero"` — the opening screen
- `<main id="work">` — filled by JavaScript, empty in the source
- `<section class="about"` — **the seven cards. Edit the copy here.**
- `<section class="foot" id="contact">` — enquiry form
- `<div class="lb"` — the full-screen photo view

**JavaScript** (one `<script>` block, lower down)

| Line | Section |
|---|---|
| 3016 | Builds the category sections |
| 3058 | Navigation dial (the marker in the top bar) |
| 3491 | Category view — opening a collection |
| 3637 | The About cards — drag, deal-in, long-press |
| 3871 | Parallax on the columns |
| 4688 | Enquiries (contact form) |
| 5118 | The back button |
| 5411 | Reactions |
| 5704 | Swiping through frames |
| 5969 | Layout editor |

### Things that will bite an AI assistant that cannot see the whole file

Tell it these, or it will get them wrong:

1. **No frameworks.** Plain HTML, CSS and vanilla JavaScript. If it
   suggests React, Tailwind, npm or a build step, it has misunderstood.

2. **`mobile.css` is a separate file** loaded after the main `<style>`.
   Everything in it sits inside `@media (max-width: 820px)`. Mobile
   changes go there, not in the main file.

3. **`window.READONLY`** hides the editing tools from visitors. It is true
   on the live site and false locally. The "Add photos" and "Arrange"
   buttons must never appear to the public — they did once, and it looked
   like an unfinished admin page.

4. **Columns are height-balanced.** `defaultLayout()` sorts photographs
   tallest-first and places each into the shortest column, so the three
   columns end level. Do not replace this with simple round-robin — it
   leaves a large white gap at the bottom of the grid.

5. **`_sprite.jpg` must never be re-encoded.** It is a precisely aligned
   11×11 grid of 113 thumbnails used by the hero. Re-saving it shifts the
   tile boundaries and the hero breaks. `publish.ps1` copies it untouched.

6. **The parallax must return to zero at both ends of the scroll.** It
   follows a parabola for exactly this reason. A constant drift pulls the
   columns' feet apart and reopens the white gap.

7. **Overlays push history entries** so Android's Back button closes them
   instead of leaving the site. Any new overlay needs `pushOverlay()` when
   it opens, `popOverlay()` when it closes, and a branch in the `popstate`
   handler. See `THE BACK BUTTON`, around line 5118.

8. **The About cards must NOT get a square image window.** A real Polaroid
   has one, and it was tried — it stranded a small dark box at the top of a
   very tall white slab, because text cannot fill a square tied to the
   card's width. The plate sizes itself to its words. Do not set
   `aspect-ratio` on `.acard-plate`.

9. **The card padding must be fixed units, not percentages.** Percentage
   padding resolves against the WIDTH on all four sides, so a percentage
   foot margin scales with width while the content does not — the same bug
   as above. `.acard` uses `.85rem .85rem 2.4rem`.

10. **On a phone, a card is picked up by HOLDING it (350ms), not by
    touching it.** Dragging and scrolling are the same gesture; a card that
    grabbed the first touch would swallow the scroll and make that whole
    section a dead zone. `touch-action` is flipped to `none` on the element
    only at the moment the card is claimed, never before. If you change
    this, test that normal scrolling still works with a finger on a card.

11. **The deal-in animation must never beat the drag.** A dragged card
    keeps its position because an inline `style.transform` outranks any
    stylesheet rule. If you move the drag to a CSS class, a card you moved
    will snap home the next time the deal transition applies.

---

## 4. Unfinished — what still needs doing

### Needs an account (a one-line paste each)

**Contact form.** Enquiries currently open the visitor's own mail app. On
a phone without mail set up, the enquiry is lost. Fix: make a free form at
https://formspree.io, then set

```js
const FORM_ENDPOINT = 'https://formspree.io/f/xxxxxxxx';
```

Search for `FORM_ENDPOINT` (around line 4165).

**Analytics.** You currently have no idea how many people visit. Fix: sign
up at https://goatcounter.com (free, no cookies, no personal data), then set

```js
const ANALYTICS_CODE = 'yoursubdomain';
```

Search for `ANALYTICS_CODE`.

**Reactions (optional).** The old Supabase project was deleted, so nothing
is collected centrally — reactions still save in each visitor's own
browser. To collect again: make a project at https://supabase.com, add a
table `reactions` with columns `photo, reaction, category, visitor, at`,
set a row-level policy allowing INSERT and no SELECT, then fill in
`DB_URL` and `DB_KEY` (search for `DB_URL`, around line 4900). Or delete
the feature — it is not load-bearing.

### Needs your judgement, not code

**Cut the selection.** There are 78 photographs across six categories.
This is the single biggest improvement left, and no AI can do it for you:
a portfolio shows your best work, not all of it. Around 40 strong frames
would be a better site than 78 uneven ones.

To remove one: open the site locally, open a category, right-click a
photograph → Remove. Or edit the `CATS` arrays in the file directly.

**Check the About copy.** Search for `<section class="about"`. Seven cards:
a portrait, then The work / The light / The name / The approach /
Recognition / Working together. Some of it was drafted before the facts
were confirmed, so read every line and make sure it is true. In
particular, card 05 says "several photography competitions" — if you know
the number, say it; "three" is more credible than "several".

**Test the About cards on a real phone.** The long-press-to-drag was
verified as logic, not under a real thumb. Check that normal scrolling
still feels right when a finger lands on a card, and that holding one
picks it up cleanly.

### Suggested, not started

From an earlier review: frame numbering (`FRAME 018 / 113`), a
"Director's Cut" of your ten best, behind-the-scenes process notes, and
commission types with rough prices on the contact page.

---

## 5. If something breaks

The site is one file, so a bad edit can break everything. Before editing,
copy `V2-PORTFOLIO.html` somewhere safe.

Quick checks when something stops working:

- **Blank page or nothing responds** — open the browser console (F12) and
  look for a red error. A missing bracket usually shows there.
- **Unbalanced brackets** — in PowerShell, from this folder:
  ```powershell
  $t = [IO.File]::ReadAllText("V2-PORTFOLIO.html")
  ($t.ToCharArray()|?{$_ -eq '{'}).Count
  ($t.ToCharArray()|?{$_ -eq '}'}).Count
  ```
  The two numbers must match. Same for `(` and `)`.
- **Editing tools showing on the live site** — `window.READONLY` is not
  being set, or a reveal is missing its `if (!window.READONLY)` guard.
- **Hero pixel grid looks scrambled** — `_sprite.jpg` was re-encoded.
  Restore it from `PUBLISH/images/_sprite.jpg` or the backup.
- **A big white gap at the bottom of a category** — something overrode the
  column balancing. Check `BASE_LAYOUTS` is still `{}` and that
  `defaultLayout` still sorts tallest-first.

## 6. Keep a backup

Everything here is on one computer. Copy the folder to a USB drive or
Google Drive. At minimum keep `V2-PORTFOLIO.html`, `mobile.css`,
`publish.ps1` and the `images/` folder — that is the whole site.

Better: put it on GitHub (free). Then you have a full history of every
change, and Netlify can deploy straight from it instead of you dragging a
folder.
