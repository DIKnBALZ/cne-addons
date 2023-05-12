import funkin.editors.ui.UIState;
function update(elapsed:Float) {
	if (FlxG.keys.justPressed.TWO) {
		FlxG.switchState(new UIState(true, 'InkyEditor'));
	}
}