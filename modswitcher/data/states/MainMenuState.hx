function update(elapsed:Float) {
	if (FlxG.keys.justPressed.EIGHT)
		FlxG.switchState(new ModState('ModSwitcher'));
}