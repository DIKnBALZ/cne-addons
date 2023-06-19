import haxe.Json;
import sys.io.File;
var oCheck = Json.parse(File.getContent("addons/options.json"));
if (oCheck.toggle_hblerp != true) return;

function onSongStart() {
	healthBar.parentVariable = null;
	healthBar.parent = null;
}
function postUpdate(elapsed:Float) healthBar.value = healthBar.value+0.06*(health-healthBar.value);