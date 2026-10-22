# The suite of `ProjecturedAnthropicTest`, which the release holds in `test/` and the
# registry serves. SDL draws into memory when no display is named: in the
# offscreen driver, and on macOS in the dummy driver, because there the
# offscreen driver loads OpenGL through EGL, which macOS does not have.
haskey(ENV, "SDL_VIDEODRIVER") ||
    (ENV["SDL_VIDEODRIVER"] = Sys.isapple() ? "dummy" : "offscreen")
using ProjecturedAnthropic
using ProjecturedAnthropicTest
test_anthropic()
