import flixel.text.FlxTextBorderStyle;

var coolCoin:FlxSprite;
var coolCoinCounter:FlxText;
var curCoins:Int = 0;

function postCreate() {
    coolCoin = new FlxSprite(975, healthBar.y).loadGraphic(Paths.image('coins'), true, 10, 14);
    coolCoin.animation.add("idle", [0, 1, 2, 1], 12, true);
    coolCoin.animation.play("idle", true);
    coolCoin.scale.set(4, 4);

    curCoins = Std.int(FlxG.save.data.curCoins);

    coolCoinCounter = new FlxText(coolCoin.x + 30, healthBar.y - (downscroll ? 30 : 20), 0, Std.string(curCoins), 48);
	coolCoinCounter.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 4);

    for (c in [coolCoin, coolCoinCounter]) {
        c.cameras = [camHUD];
        add(c);
    }
}

function onNoteHit(event:NoteHitEvent) {
    if (event.player && !event.note.isSustainNote)
        addCoin(1);
}

function postUpdate(elapsed:Float) {
    if (health < 0.1 && curCoins >= 100) {
        camGame.flash(0x6000ff00, 1); // oh no
        addCoin(-100);
        health = 2;
        FlxG.sound.play(Paths.sound('1-up'), 0.5);
    }

    coolCoinCounter.text = " " + Std.string(curCoins);
}

function addCoin(amount:Int) {
    curCoins += amount;
    FlxG.save.data.curCoins = curCoins;
}