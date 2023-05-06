// please let this work this will be so cool

return;

var isJumping:Bool = false;
var isYoshiWalking:Bool = false;
var isRidingYoshi:Bool = false;

var yoshi:FlxSprite;
var yoshiHitbox:FlxSprite;
var yoshiMusic:FlxSound;

function postCreate() {
    yoshi = new FlxSprite(boyfriend.x - 500, boyfriend.y + 250).makeGraphic(400, 500, 0xFF008CFF);
    yoshi.moves = true;
    yoshiHitbox = new FlxSprite(yoshi.x, yoshi.y).makeGraphic(10, yoshi.height, 0xFFFFFFFF);

    for (i in [yoshi, yoshiHitbox]) {
        insert(members.indexOf(boyfriend), i);
        yoshi.moves = true;
        // i.visible = false; // temp
    }
}

function postUpdate(elapsed:Float) {
    yoshiHitbox.setPosition(yoshi.x + (yoshi.width / 2) - (yoshiHitbox.width / 2), yoshi.y);
    yoshiHitbox.updateHitbox(); // lmao

    if (FlxG.keys.justPressed.P) {
        // spawn yoshi
        if (!isYoshiWalking) {
            yoshi.x = boyfriend.x - 1000;
            yoshi.velocity.x = 150;
        }
    }

    if (FlxG.keys.justPressed.SPACE && !isJumping) {
        isJumping = true;
        FlxTween.tween(boyfriend, {y: boyfriend.y - 200}, 0.3, {ease: FlxEase.cubeOut, onComplete: function() {
            
            trace('check here');
            if (FlxG.overlap(boyfriend, yoshiHitbox)) {
                trace('boobs');
                isRidingYoshi = true;
                yoshi.x = boyfriend.x;
                yoshi.velocity.x = 150;
                
            } else {
                trace('butts');
                FlxTween.tween(boyfriend, {y: boyfriend.y + 200}, 0.35, {ease: FlxEase.cubeIn, onComplete: function() {
                    isJumping = false;
                }});
            }
        }});

        // example anim
        // boyfriend.playAnim("jump", true, "FORCE");
    }

    if (health < 0.1 && isRidingYoshi) {
        // example anim
        // boyfriend.playAnim("fall", true, "FORCE");
        isRidingYoshi = false;
        health = 1;
    }
}

function beatHit(curBeat) {
	if (curBeat > -1 && curBeat % 8 == 0) {
		break = FlxG.sound.play(Paths.sound("break"), 1);
		break.pitch = ((Conductor.bpm / 120) * 1);
		break.volume = 0.75;
		trace("Played the break at pitch " + break.pitch + "!");
	}
}