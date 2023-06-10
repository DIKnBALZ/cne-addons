// this will def not work but fuck it we ball

import haxe.Json;
import sys.io.File;
var oCheck = Json.parse(File.getContent("addons/options.json"));

var isStreamsOnly:Bool = true;
var noteCount:Int = 1000;
var noteInterval:Int = 4;
scrollSpeed = 3;

var prevNote:Int = FlxG.random.int(0, 3);

function create() {
    trace(oCheck.toggle_autochart);
    // if (oCheck.toggle_autochart != true) return;

    var noteBG = new FlxSprite(FlxG.width / 2, 0).makeGraphic(1, 1, 0x8D000000);
    noteBG.setGraphicSize(FlxG.width, FlxG.height);
    noteBG.updateHitbox();
    noteBG.cameras = [camHUD];
    insert(members.indexOf(strumLines), noteBG);

    PlayState.SONG.strumLines[1].notes = [];
    for (i in 0...noteCount) {
        if (i % noteInterval != 0) continue;
        var newAutoNote = FlxG.random.int(0, 3, isStreamsOnly ? [prevNote] : []);
        PlayState.SONG.strumLines[1].notes.push({
            time: Conductor.stepCrochet * i,
            id: newAutoNote,
            type: 0,
            sLen: 0
        });
        prevNote = newAutoNote;
    }
}

function beatHit() {
    FlxG.sound.play(Paths.sound("editors/charter/metronome"), 1);
}