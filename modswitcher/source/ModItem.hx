import funkin.assets.Paths;
import funkin.assets.ModsFolder;
import sys.FileSystem;
import sys.io.File;
import openfl.display.BitmapData;
import haxe.Json;

class ModItem extends flixel.FlxSprite {
	public var list:Array<String> = [];
	public var listID:Int = 0;
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
	}
}