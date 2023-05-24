import funkin.editors.ui.UIState;
function update(elapsed:Float) {
	if (FlxG.keys.justPressed.TWO) FlxG.switchState(new UIState(true, 'InkyEditor'));
	if (FlxG.keys.justPressed.THREE) FlxG.switchState(new UIState(true, 'editors/UICharacterEditor'));
	if (FlxG.keys.justPressed.FOUR) FlxG.switchState(new UIState(true, 'editors/UIStagePosEditor'));
}