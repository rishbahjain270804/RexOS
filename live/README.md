# RexOS Live Wallpapers

Drop **video files** here (`.mp4`, `.webm`, `.mkv`, `.gif`) to use them as live
(animated) wallpapers. They show up automatically in the RexOS wallpaper picker
(**Super+W**) tagged `(live)`.

## Adding a live wallpaper

1. Put a video file in this folder, e.g. `~/.local/share/rexos/live/space.mp4`
2. Press **Super+W**, pick it — it plays as your animated wallpaper.

## "Albedo's Paradise" and other Wallpaper Engine scenes

These are **Wallpaper Engine** wallpapers (from Steam). Two ways to use them:

**A) If it's a video export** (many WE scenes can be exported to .mp4):
   just drop the .mp4 in this folder — done.

**B) The real Wallpaper Engine scene** (with project.json):
   put the whole scene folder in `~/.local/share/rexos/wallengine/`
   (RexOS runs it with `linux-wallpaperengine`). It shows tagged `(engine)`.
   You need to own Wallpaper Engine on Steam and copy the scene from:
   `steamapps/workshop/content/431960/<id>/`

## Where to get free live wallpapers

- **Pixabay / Pexels** — free looping nature/abstract videos (.mp4)
- **MoeWalls**, **Wallpaper Engine Workshop** (if you own WE)
- Or generate looping gradients/particles and export to video

RexOS plays any of them — just drop the file in and pick it.
