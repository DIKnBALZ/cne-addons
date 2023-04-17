import haxe.Json;
import lime.ui.FileDialog;
import sys.io.File;
import lime.ui.FileDialogType;
function update(elapsed:Float) {
	if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.S) {
		var fDial = new FileDialog();
		fDial.onSelect.add(function(file) {
		File.saveContent(file, Json.stringify(PlayState.instance.SONG));
		});
		fDial.browse(FileDialogType.SAVE, 'json', null, 'save the song');
	}
}