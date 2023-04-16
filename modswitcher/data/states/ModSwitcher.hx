import haxe.io.Path;
import funkin.assets.ModsFolder;
import sys.FileSystem;
import flixel.FlxSprite;
import funkin.assets.Paths;
import funkin.menus.MainMenuState;

class ModSwitcher extends funkin.editors.ui.UIState {
	public var mods:Array<String> = [];
	public var sprites:Array<FlxSprite> = [];
	public function new() {
		super();

		for (modFolder in FileSystem.readDirectory(ModsFolder.modsPath)) {
			if (FileSystem.isDirectory(ModsFolder.modsPath+modFolder)) {
				mods.push(modFolder);
			}
		}
		trace(mods);

		for (i in mods) {
			var spr:FlxSprite = new FlxSprite(360*(mods.indexOf(i))+50, 25).loadGraphic(Paths.image('what'));
			spr.scale.set(0.5, 0.5);
			spr.updateHitbox();
			sprites.push(spr);
			add(spr);
		}
	}

	public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new ModSwitcher());
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new MainMenuState());
	}
}