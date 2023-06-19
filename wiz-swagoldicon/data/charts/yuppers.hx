var altIcon:HealthIcon;

function postCreate() {
    altIcon = new HealthIcon('bf-thebetterversion', true);
    altIcon.cameras = iconP1.cameras;
    add(altIcon);
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.NINE) {
        FlxG.sound.play(Paths.sound('huzzah'), 1);
        iconP1.visible = !iconP1.visible;
        boyfriend.playAnim("hey", true);
        FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
    }

    // icon recreation lolol
    altIcon.visible = !iconP1.visible;
    altIcon.setPosition(iconP1.x, iconP2.y);
    altIcon.scale.set(lerp(iconP1.scale.x, 1, 0.33), lerp(altIcon.scale.y, 1, 0.33));
	altIcon.updateHitbox();
    altIcon.health = healthBar.percent / 100;
}

function beatHit(curBeat:Int) {
    altIcon.scale.set(1.2, 1.2);
    altIcon.updateHitbox();
}