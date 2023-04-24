import funkin.backend.MusicBeatState;

function update() {
	if (FlxG.keys.justPressed.SIX) {
		var state = new MusicBeatState(true, "YCEModtoCodenameMod");
		FlxG.switchState(state);
	}
}