// this is peak holy shit

return;

// invalid class my ASS
import flixel.addons.ui.FlxUIInputText;

var chat = [
    "test",
    "balls",
    "balls the sequel"
];

var camMC:FlxCamera;

var typeText:FlxText;
var typeBG:FlxSprite;

var freezeGame:Bool = false;

function postCreate() {
    camMC = new FlxCamera(0, 0, FlxG.width, FlxG.height);
    camMC.bgColor = 0x00000000;
    FlxG.cameras.add(camMC, false);
    // cameras = [camMC];

    typeBG = new FlxSprite(0, FlxG.height - 36).makeGraphic(FlxG.width, 36, 0xA0000000);
    typeBG.cameras = [camMC];
    add(typeBG);

    // new(X:Float = 0, Y:Float = 0, Width:Int = 150, ?Text:String, size:Int = 8, TextColor:Int = FlxColor.BLACK, BackgroundColor:Int = FlxColor.WHITE, EmbeddedFont:Bool = true)
    typeText = new FlxUIInputText(0, FlxG.height - 34, 0, "this is a test LOLOLOL", 24);
    typeText.font = Paths.font("Minecraftia-Regular.ttf");
    typeText.cameras = [camMC];
    add(typeText);
}



function update() {
    // typeText.hasFocus = true;

    if (FlxG.keys.justPressed.T) {
        freezeGame = !freezeGame;
    }

    if (Conductor.songPosition >= 0) {
        if (freezeGame) {
            inst.pause();
            vocals.pause();
        } else {
            inst.play();
            vocals.play();
        }
    }
}