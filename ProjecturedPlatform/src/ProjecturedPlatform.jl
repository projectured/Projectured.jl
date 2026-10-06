"""
    ProjecturedPlatform

The platform: the slices that the domains, the backends and the adapters are
built on. The collections, the primitive values, the projection algebra, the
style, the graphics, the layout, the screen, the text, the syntax and the
natural notation; the widgets, the panes and the window; the clipboard, the
focus and the dragging; the conversation and the assistant; the file system, the
help, the logs, the statistics and the undo; and the application that puts
them in one window. Each slice is a module of its own, in
`source/platform/<slice>/`, and the order of the includes below is an order of
`PLATFORM_SLICE_EDGES`, the table of the edges between the slices.

The loop below binds every submodule of the kernel as a `const`, so a source
file here names a module of the kernel exactly as the module names itself.
"""
module ProjecturedPlatform

using ProjecturedKernel

for _n in names(ProjecturedKernel; all = true)
    isdefined(ProjecturedKernel, _n) || continue
    _m = getfield(ProjecturedKernel, _n)
    (_m isa Module && _m !== ProjecturedKernel && parentmodule(_m) !== Main) || continue
    Core.eval(@__MODULE__, Expr(:const, Expr(:(=), _n, _m)))
end

include("platform/collection/CollectionModule.jl")
include("platform/component/ComponentModule.jl")
include("platform/domain/DomainModule.jl")
include("platform/settings/SettingsModule.jl")
include("platform/focus/FocusModule.jl")
include("platform/dragtracking/DragTrackingModule.jl")
include("platform/gesturetracking/GestureTrackingModule.jl")
include("platform/primitive/PrimitiveModule.jl")
include("platform/projection/ProjectionAlgebraModule.jl")
include("platform/dragging/DraggingModule.jl")
include("platform/serialization/SerializationModule.jl")
include("platform/style/StyleModule.jl")
include("platform/graphics/GraphicsModule.jl")
include("platform/layout/LayoutModule.jl")
include("platform/plot/PlotModule.jl")
include("platform/screen/ScreenModule.jl")
include("platform/text/TextModule.jl")
include("platform/clipboard/ClipboardModule.jl")
include("platform/tooltip/TooltipModule.jl")
include("platform/versioning/VersioningModule.jl")
include("platform/widget/WidgetModule.jl")
include("platform/natural/NaturalModule.jl")
include("platform/settingsmanaging/SettingsManagingModule.jl")
include("platform/conversation/ConversationModule.jl")
include("platform/assistant/AssistantModule.jl")
include("platform/display/DisplayModule.jl")
include("platform/essentials/EssentialsModule.jl")
include("platform/inspector/InspectorModule.jl")
include("platform/pane/PaneModule.jl")
include("platform/reflection/ReflectionModule.jl")
include("platform/syntax/SyntaxModule.jl")
include("platform/appearance/AppearanceModule.jl")
include("platform/fault/FaultViewModule.jl")
include("platform/fileformat/FileFormatModule.jl")
include("platform/filesystem/FileSystemModule.jl")
include("platform/gesturehelp/GestureHelpModule.jl")
include("platform/gesturelog/GestureLogModule.jl")
include("platform/help/HelpModule.jl")
include("platform/log/MessageLogModule.jl")
include("platform/statistics/FrameStatisticsModule.jl")
include("platform/shell/ShellModule.jl")
include("platform/mcplog/McpLogModule.jl")
include("platform/undo/UndoModule.jl")
include("platform/application/ApplicationModule.jl")
include("platform/PlatformModule.jl")

# A user who loads the package by name gets every module of it and every name that
# one of them exports.
using .PlatformModule
for _n in names(PlatformModule)
    _n === :PlatformModule || Core.eval(@__MODULE__, Expr(:export, _n))
end

# The rungs of the natural notation that the text gives, and the fallback of the
# syntax.
function __init__()
    NaturalModule.register_natural_rung!(:text, :graphics,
        (; measure, appearance) -> TextModule.TextToGraphics(;
            measure, theme = StyleModule.get_scaled_theme!(appearance, TextModule.TextTheme)))
    NaturalModule.register_natural_rung!(:text, :string,
        (; measure, appearance) -> TextModule.TextToString())
    NaturalModule.register_natural_notation!(
        TextModule.TextDocument, :text,
        (; appearance) -> ProjectionAlgebraModule.IdentityProjection())
    SyntaxModule.register_syntax_fallback!()
    nothing
end

# The display of a value beside the REPL, at the level of the package.
using .DisplayModule
export EditorDisplay, display_in_editor, close_display_editor!, refresh_display_editor!

end # module ProjecturedPlatform
