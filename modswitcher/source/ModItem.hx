import funkin.assets.Paths;
import funkin.assets.ModsFolder;
import sys.FileSystem;
import sys.io.File;
import openfl.display.BitmapData;
import haxe.Json;
import flixel.math.FlxMath;

class ModItem extends flixel.FlxSprite {
	public var list:Array<String> = [];
	public var listID:Int = 0;
	public var playedSound:Bool = false;
	public var hovering:Bool = false;
	public function new(xPos:Float, yPos:Float, modID:Int, modList:Array<String>) {
		super(xPos, yPos);
		x = xPos;
		y = yPos;
		list = modList;
		listID = modID;

		if (FileSystem.exists(ModsFolder.modsPath+list[list.indexOf(listID)]+'/thumbnail.png')) loadGraphic(BitmapData.fromFile(ModsFolder.modsPath+list[list.indexOf(listID)]+'/thumbnail.png'));
		else loadGraphic(Paths.image('what'));
		scale.set(0.4, 0.4);
		updateHitbox();
	}

	public function update(elapsed:Float) {
		super.update(elapsed);
		hovering = FlxG.mouse.overlaps(this);

		if (hovering) {
			if (!playedSound) {
				FlxG.sound.play(Paths.sound('menu/scroll'));
				playedSound = true;
			}
			scale.set(FlxMath.lerp(scale.x, 0.45, 0.06), FlxMath.lerp(scale.y, 0.45, 0.06));
			curSelected = list[list.indexOf(listID)];
		} else {
			scale.set(FlxMath.lerp(scale.x, 0.4, 0.06), FlxMath.lerp(scale.y, 0.4, 0.06));
			playedSound = false;
		}
	}
}