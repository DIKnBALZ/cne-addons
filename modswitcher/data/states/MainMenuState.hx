function update(elapsed:Float) {
	if (FlxG.keys.justPressed.END) {
		FlxG.switchState(new ModState('ModSwitcher'));
	}
}