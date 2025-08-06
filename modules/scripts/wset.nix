{ pkgs, ... }:

pkgs.writeScriptBin "wset" ''
#!/usr/bin/env nu

# Function to set the wallpaper with swww
def set_theme [file: path] {
  let fps = 60
  let type = if ((random int) mod 5) != 0 { "any" } else { "fade" }
  let duration = 1.5
  let bezier = ".43,1.19,1,.4"
  swww img $file --transition-fps $fps --transition-type $type --transition-duration $duration --transition-bezier $bezier
}

def main [file?: string, -r] {
  if $file != null and ($file | path type) == "file" {
    set_theme $file
  } else if $r {
    set_theme (ls ...(glob /home/sumit/media/wallpapers/**/*.{png,jpg,jpeg,webp,gif} --exclude [**/.mobile/**]) | shuffle | first | get name)
  } else {
    # Get current focused monitor
    let current_monitor = (hyprctl monitors | parse -r '^Monitor ([\w|-]+)[\s\S]*(focused:\syes)?' | get 0.capture0?)

    if ($current_monitor | is-not-empty) {
      # Construct the full path to the cache file
      let cache_file = $"($env.HOME)/.cache/swww/($current_monitor)"

      # Check if the cache file exists and set the wallpaper
      if ($cache_file | path exists) {
        let wallpaper_path = (open $cache_file | lines | where $it !~ 'Lanczos3' | first)
        sleep 1sec
        swww img $wallpaper_path --transition-type fade --transition-duration 2
      }
    }
  }
}
''
