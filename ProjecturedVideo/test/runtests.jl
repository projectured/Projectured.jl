# The suite of `ProjecturedVideoTest`, which the release holds in `test/` and the
# registry serves. SDL draws into memory when no display is named.
haskey(ENV, "SDL_VIDEODRIVER") || (ENV["SDL_VIDEODRIVER"] = "offscreen")
using ProjecturedVideo
using ProjecturedVideoTest
test_video()
