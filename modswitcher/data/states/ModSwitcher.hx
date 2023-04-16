import haxe.io.Path;
import funkin.assets.ModsFolder;
import sys.FileSystem;

var mods:Array<String> = [];
function create() {
	for(modFolder in FileSystem.readDirectory(ModsFolder.modsPath)) {
		if (FileSystem.isDirectory(ModsFolder.modsPath+modFolder)) {
			mods.push(modFolder);
		}
	}
	trace(mods);

	for (i in mods) {
		
	}
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.NUMPADMULTIPLY) FlxG.switchState(new ModState('ModSwitcher'));
}