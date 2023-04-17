import funkin.assets.ModsFolder;
import sys.FileSystem;
import sys.io.File;
import openfl.display.BitmapData;
import haxe.Json;
import ModItem;

var mods:Array<String> = [];
var shitmods = [];
var poster:FlxSprite;
var curSelected:Int = 0;
function create() {
	FlxG.mouse.visible = true;

	for (modFolder in FileSystem.readDirectory(ModsFolder.modsPath)) {
		if (FileSystem.isDirectory(ModsFolder.modsPath+modFolder)) {
			mods.push(modFolder);
		}
	}
	trace(mods);

	poster = new FlxSprite();
	if (FileSystem.exists(ModsFolder.modsPath+mods[curSelected]+'/poster.png')) poster.loadGraphic(BitmapData.fromFile(ModsFolder.modsPath+mods[curSelected]+'/poster.png'));
	else poster.loadGraphic(Paths.image('what'));
	add(poster);
	poster.scrollFactor.set();
	poster.color = 0xFF4A3F4C;

	for (i in mods) {
		var spr:ModItem = new ModItem(288*(mods.indexOf(i))+(25*(mods.indexOf(i)+1)), 25, mods[mods.indexOf(i)], mods);
		add(spr);

		if (!FileSystem.exists(ModsFolder.modsPath+mods[mods.indexOf(i)]+'/modconfig.json')) {
			trace('Mod "'+mods[mods.indexOf(i)]+'" does not have a modconfig.json!');

			var text:FlxText = new FlxText(spr.x, spr.y+spr.height, 0, 'No modconfig.json found!', 53);
			text.font = Paths.file('fonts/cool.ttf');
			add(text);
			text.alpha = 0;
			shitmods.push([spr, text]);
		}
		else {
			var ass = Json.parse(File.getContent(ModsFolder.modsPath+mods[mods.indexOf(i)]+'/modconfig.json'));
			var text:FlxText = new FlxText(spr.x, spr.y+spr.height, 0, ass.title, 53);
			text.font = Paths.file('fonts/cool.ttf');
			add(text);
			text.alpha = 0;
			shitmods.push([spr, text, mods[mods.indexOf(i)]]);
		}
	}
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.EIGHT)
		FlxG.switchState(new ModState('ModSwitcher'));
	if (FlxG.keys.justPressed.ESCAPE)
		FlxG.switchState(new MainMenuState());

	if (FlxG.keys.pressed.LEFT) FlxG.camera.scroll.x -= 50;
	if (FlxG.keys.pressed.RIGHT) FlxG.camera.scroll.x += 50;

	for (i in shitmods) {
		if (i[0].hovering) {
			i[1].alpha = FlxMath.lerp(i[1].alpha, 1, 0.12);
			i[1].y = FlxMath.lerp(i[1].y, i[0].y+i[0].height+10, 0.06);
		} else {
			i[1].alpha = FlxMath.lerp(i[1].alpha, 0, 0.24);
			i[1].y = FlxMath.lerp(i[1].y, i[0].y+i[0].height, 0.06);
		}
	}
}