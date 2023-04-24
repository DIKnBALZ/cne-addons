import funkin.backend.utils.NativeAPI;

function update() {
    if (FlxG.keys.justPressed.F8)
        NativeAPI.allocConsole();
}