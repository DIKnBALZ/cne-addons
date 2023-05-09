function onSongStart() {
	healthBar.parentVariable = null;
	healthBar.parent = null;
}
function postUpdate(elapsed:Float) healthBar.value = healthBar.value+0.06*(health-healthBar.value);