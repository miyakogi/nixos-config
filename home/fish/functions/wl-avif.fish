function wl-avif
  wl-paste | magick - -quality 30 avif:- | wl-copy --type image/avif
end
