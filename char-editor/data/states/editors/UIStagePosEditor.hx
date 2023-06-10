import funkin.editors.ui.UIButton;
import funkin.editors.ui.UITopMenu;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UIWarningSubstate;
import lime.ui.FileDialog;
import sys.io.File;
import lime.ui.FileDialogType;
import funkin.backend.utils.NativeAPI;
import StringTools;
import haxe.ds.StringMap;
import funkin.game.Stage;

var stagecam:FlxCamera;
var uicam:FlxCamera;
var stage:Stage;
var boyfriend:Character;
var dad:Character;
var gf:Character;
var curFocus;

function create() {
	stagecam = new FlxCamera(0, 0);
	stagecam.bgColor = 0xFF3C353E;
	FlxG.cameras.remove(FlxG.camera, false);
	FlxG.cameras.add(stagecam, false);
	FlxG.cameras.add(FlxG.camera, false);
	FlxG.camera.bgColor = 0x00000000;

	uicam = new FlxCamera(0, 0);
	uicam.bgColor = 0x00000000;
	FlxG.cameras.add(uicam, false);

	FlxG.mouse.enabled = true;
	FlxG.mouse.visible = true;
	
	var topmenu:UITopMenu = new UITopMenu([
		{
			label: "File",
			childs: [
				{
					label: "Open",
					onSelect: () ->
					{
						var fDial = new FileDialog();
						fDial.onSelect.add(function(file){openStage(file);});
						fDial.browse(FileDialogType.OPEN, 'xml', null, 'Open a Codename Engine Stage XML.');
					}
				},
				{
					label: "Save",
					onSelect: () ->
					{
						save();
					}
				},
				null,
				{
					label: "Exit",
					onSelect: () ->
					{
						openSubState(new UIWarningSubstate("Warning!", "You may or may not have unsaved changes. Are you sure you exit back to PlayState?", [
							{
								label: "No",
								onClick: function(t)
								{
								}
							},
							{
								label: "Yes",
								onClick: function(t)
								{
									FlxG.switchState(new PlayState());
								}
							}
						]));
					}
				}
			]
		},
		{
			label: "Edit",
			childs: [
				{
					label: "Dad",
					onSelect: () ->
					{
						curFocus = dad;
					}
				},
				{
					label: "Girlfriend",
					onSelect: () ->
					{
						curFocus = gf;
					}
				},
				{
					label: "Boyfriend",
					onSelect: () ->
					{
						curFocus = boyfriend;
					}
				}
			]
		},
		{
			label: "View",
			childs: [
				{
					label: "Show Console",
					onSelect: () ->
					{
						NativeAPI.allocConsole();
					}
				}
			]
		}
	]);
	topmenu.cameras = [uicam];
	add(topmenu);

	stage = new Stage('stage');
	for (object in stage.stageSprites) object.cameras = [stagecam];
	add(stage);

	boyfriend = new Character(0, 0, 'bf', true);
	boyfriend.cameras = [stagecam];
	stage.applyCharStuff(boyfriend, 'boyfriend', 'bf');
	add(boyfriend);

	dad = new Character(0, 0, 'dad');
	dad.cameras = [stagecam];
	stage.applyCharStuff(dad, 'dad', 'dad');
	add(dad);

	gf = new Character(0, 0, 'gf');
	gf.cameras = [stagecam];
	stage.applyCharStuff(gf, 'girlfriend', 'gf');
	add(gf);

	curFocus = boyfriend;

	posText = new FlxText(0, 25, 0, '0, 0', 50);
	posText.cameras = [uicam];
	posText.font = Paths.font('GOTHIC.ttf');
	add(posText);
}

var holding:Bool = false;
function update(elapsed:Float) {
	if (FlxG.keys.justPressed.EIGHT) FlxG.switchState(new UIState(true, 'editors/UIStagePosEditor'));

	if (FlxG.keys.pressed.A) stagecam.scroll.x -= 500 / stagecam.zoom * elapsed;
	if (FlxG.keys.pressed.S) stagecam.scroll.y += 500 / stagecam.zoom * elapsed;
	if (FlxG.keys.pressed.W) stagecam.scroll.y -= 500 / stagecam.zoom * elapsed;
	if (FlxG.keys.pressed.D) stagecam.scroll.x += 500 / stagecam.zoom * elapsed;

	if (FlxG.mouse.wheel < 0) stagecam.zoom -= 2 * elapsed;
	if (FlxG.mouse.wheel > 0) stagecam.zoom += 2 * elapsed;

	for (i in [dad, boyfriend, gf]) if (i != curFocus) i.alpha = 0.5; else i.alpha = 1;

	if (!FlxG.keys.pressed.ALT) {
		if (FlxG.keys.justPressed.LEFT) curFocus.x -= (FlxG.keys.pressed.SHIFT?50:FlxG.keys.pressed.CONTROL?5:25);
		if (FlxG.keys.justPressed.DOWN) curFocus.y += (FlxG.keys.pressed.SHIFT?50:FlxG.keys.pressed.CONTROL?5:25);
		if (FlxG.keys.justPressed.UP) curFocus.y -= (FlxG.keys.pressed.SHIFT?50:FlxG.keys.pressed.CONTROL?5:25);
		if (FlxG.keys.justPressed.RIGHT) curFocus.x += (FlxG.keys.pressed.SHIFT?50:FlxG.keys.pressed.CONTROL?5:25);
	} else {
		if (FlxG.keys.pressed.LEFT) curFocus.x -= (FlxG.keys.pressed.SHIFT?50:FlxG.keys.pressed.CONTROL?5:25)/2;
		if (FlxG.keys.pressed.DOWN) curFocus.y += (FlxG.keys.pressed.SHIFT?50:FlxG.keys.pressed.CONTROL?5:25)/2;
		if (FlxG.keys.pressed.UP) curFocus.y -= (FlxG.keys.pressed.SHIFT?50:FlxG.keys.pressed.CONTROL?5:25)/2;
		if (FlxG.keys.pressed.RIGHT) curFocus.x += (FlxG.keys.pressed.SHIFT?50:FlxG.keys.pressed.CONTROL?5:25)/2;
	}

	posText.x = FlxG.width-5-(posText.width);
	posText.text = curFocus.x+', '+curFocus.y;
}

var charName:String;
function openStage(file) {
	var fileName = file.split('\\');
	fileName = fileName[fileName.length - 1].split('.');
	fileName = fileName[fileName.length - 2];
	trace(fileName);

	for (object in stage.stageSprites) remove(object);
	stage = new Stage(fileName);
	for (object in stage.stageSprites) object.cameras = [stagecam];
	add(stage);



	charName = stage.stageXML.get("defaultBF")!=null?stage.stageXML.get("defaultBF"):'boyfriend';
	remove(boyfriend);
	boyfriend = new Character(0, 0, charName, true);
	boyfriend.cameras = [stagecam];
	stage.applyCharStuff(boyfriend, 'boyfriend', 'bf');
	add(boyfriend);

	charName = stage.stageXML.get("defaultDad")!=null?stage.stageXML.get("defaultDad"):'dad';
	remove(dad);
	dad = new Character(0, 0, charName);
	dad.cameras = [stagecam];
	stage.applyCharStuff(dad, 'dad', 'dad');
	add(dad);

	charName = stage.stageXML.get("defaultGF")!=null?stage.stageXML.get("defaultGF"):'gf';
	remove(gf);
	gf = new Character(0, 0, charName);
	gf.cameras = [stagecam];
	stage.applyCharStuff(gf, 'girlfriend', 'gf');
	add(gf);

	curFocus = boyfriend;
}