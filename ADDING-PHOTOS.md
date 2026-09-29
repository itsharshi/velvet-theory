# Adding and removing photographs

You do not need to touch any code. The site has an editor built into it,
which only ever appears on your own computer — visitors never see it.

---

## First: open the site locally

The editor only works on the LOCAL copy, never the live one. That is
deliberate: it is how visitors are prevented from seeing your tools.

**Double-click `START-PORTFOLIO.bat`** in the CLOUDE folder.

That opens the site in your browser with the editor available. You will
see two buttons appear when you open a category: **+ Add photos** and
**Arrange**.

---

## To ADD photographs

1. Open the site locally (above)
2. Click into the category you want — PORTRAIT, NATURE, and so on
3. Click **+ Add photos** (top left)
4. Choose the files. You can pick several at once.
   *Or just drag the photographs onto the page — that works too.*
5. They appear straight away

## To REMOVE a photograph

1. Open the category
2. **Right-click** the photograph you want gone
3. Choose **Remove**

## To REARRANGE

1. Click **Arrange**
2. Drag photographs between columns and reorder them
3. Drag the dividers between columns to change their widths
4. Click **Arrange** again to finish

---

## THE IMPORTANT STEP — making it permanent

Everything above lives only in your browser until you export it. Do not
skip this.

1. Press **Ctrl + Shift + E** to open the layout editor bar
2. Click **Export**
3. It saves your photographs and layout to your **Downloads** folder

Then:

4. Move the exported photographs into the `images` folder
5. Open the export's text file and follow what it says — it tells you
   which lines to paste into `V2-PORTFOLIO.html`

If that last step looks daunting, this is exactly the kind of thing to
hand to an AI assistant. Paste it the export file and say:

> This is an export from my single-file HTML portfolio. Tell me exactly
> where in V2-PORTFOLIO.html to paste each part, and what to search for
> to find the right place.

---

## Then publish it

Open PowerShell (Windows key, type `powershell`, Enter):

```
cd "C:\Users\Sai veekshith\OneDrive\Desktop\CLOUDE"
.\deploy.ps1 "added four new portraits"
```

Live in about a minute.

---

## After changing the photographs

**Rebuild the hero's pixel grid.** The opening screen is built from a
sprite sheet of every photograph. New pictures will not appear in it, and
removed ones will leave gaps, until that sheet is rebuilt.

Ask an assistant to rebuild `images/_sprite.jpg`, telling it:

- it is an 11x11 grid, 1584x1584px, each tile 144x144px
- filled left to right, top to bottom, in the order the page lists them
- it must NOT be re-encoded afterwards or the tiles shift

---

## Things worth knowing

**Photograph sizes.** Drop in whatever comes off the camera. `publish.ps1`
shrinks everything to 1800px for the web automatically — your originals
are never touched.

**Naming.** Use lowercase with hyphens: `portrait-07.jpg`, not
`IMG_2931 (1).JPG`. Spaces and capitals cause problems on the web.

**The editor is invisible to visitors.** `window.READONLY` hides it on any
address that is not your own computer. This was checked; the buttons do
not appear on the live site.

**If you break something**, you can always go back:

```
git checkout -- V2-PORTFOLIO.html
```

That restores the last saved version, whatever you did to it.
