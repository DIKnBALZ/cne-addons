// worlds longest lines :(

import sys.Http;
import sys.io.File;
import funkin.backend.system.Main;
import haxe.Json;
import Std;

var oCheck = Json.parse(File.getContent("addons/options.json"));
if (oCheck.webhook.toggle != true) return;

var webhook = oCheck.webhook.url;
var imageUrl = "iVBORw0KGgoAAAANSUhEUgAAAcIAAACWCAYAAABNcIgQAAAACXBIWXMAADXUAAA11AFeZeUIAAACa0lEQVR4nO3VMQ3CABQAUcAjChirh7EKcFIFHeukNUHyk957Cm6757Yf5wP+7Ld+pxO4ofdnmU7ghl7TAQAwyQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQgzQgBSDNCANKMEIA0IwQg7QLNjQetpPY3DwAAAABJRU5ErkJggg==";

var currentID = "";

function postCreate() {
	Main.execAsync(()->{
		var http = new Http(webhook + "?wait=true");
		http.setParameter('content', '# ' + oCheck.webhook.name + ' started **' + formatText(PlayState.SONG.meta.displayName) + '**');
		http.setParameter('flags', 4096);
		http.onData = function(data) {
			var json = Json.parse(data);
			currentID = json.id;
		};
		http.request(true);
	});
}

function beatHit() {
    Main.execAsync(()->{
        var http = new Http(webhook + "/messages/" + currentID);
        http.setParameter('content', '## [' + oCheck.webhook.name + '] ' + formatText(PlayState.SONG.meta.displayName) + ' - (' + CoolUtil.timeToStr(Conductor.songPosition)+ ' / ' + CoolUtil.timeToStr(FlxG.sound.music.length) + ')\nAccuracy: `' + ((FlxMath.roundDecimal(accuracy * 100, 2) == -100) ? "N/A" : FlxMath.roundDecimal(accuracy * 100, 2) + '% (' + curRating.rating + ')') + '` // Misses: `' + misses + '` // Score: `' + songScore + '`');
        http.customRequest(true, null, null, "PATCH");
    });
}

function onSongEnd() {
	Main.execAsync(()->{
		var http = new Http(webhook + "/messages/" + currentID);
		http.setParameter('content', '# ' + formatText(PlayState.SONG.meta.displayName) + '** - Final Results\nAccuracy: `' + FlxMath.roundDecimal(accuracy * 100, 2) + '% ('+ curRating.rating +')` // Misses: `' + misses + '` // Score: `' + songScore + '`');
		http.customRequest(true, null, null, "PATCH");
	});
}

function formatText(str:String) {
    var string = str;
    string = StringTools.replace(string, "-", " ");
    
    var newString = "";

    for (charI in 0...string.length) {
        var char = string.charAt(charI);
        newString += (charI == 0 || string.charAt(charI - 1) == " ") ? char.toUpperCase() : char;
    }

    return newString;
}