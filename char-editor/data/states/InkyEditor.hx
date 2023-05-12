import funkin.editors.ui.UICheckbox;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UITopMenu;
import funkin.editors.ui.UIWarningSubstate;

import haxe.ds.StringMap;

var charcam:FlxCamera;
var uicam:FlxCamera;

var character:Character;
var ghostCharacter:Character;

var startOffset:Array<Float> = [];
var startOffset2:Array<Float> = [];

var animList:Array<String> = [];

var dragging:Bool = false;

var curAnim:Int = 0;

var animXmls:StringMap<Xml>;

var infoText:FlxText;
var offsetText:FlxText;
var globalOffsetText:FlxText;
var cameraOffsetText:FlxText;

var nextButton:UIButton;
var prevButton:UIButton;

var cameraPoint:FlxSprite;

var globalCheckbox:UICheckbox;

function create() {
	FlxG.mouse.enabled = true;
	FlxG.mouse.visible = true;

	charcam = new FlxCamera(0, 0);
	charcam.bgColor = 0xFF444444;
	FlxG.cameras.remove(FlxG.camera, false);
	FlxG.cameras.add(charcam, false);
	FlxG.cameras.add(FlxG.camera, false);
	FlxG.camera.bgColor = 0x00000000;

	uicam = new FlxCamera(0, 0);
	uicam.bgColor = 0x00000000;
	FlxG.cameras.add(uicam, false);

	FlxG.mouse.enabled = true;
	FlxG.mouse.visible = true;

	infoText = new FlxText(FlxG.width-250, 25, 0, 'Editing LOCAL Offset', 25);
	infoText.cameras = [uicam];
	infoText.font = Paths.font('GOTHICB.ttf');
	infoText.x = FlxG.width-7-(infoText.width);
	add(infoText);

	offsetText = new FlxText(infoText.x, 75, 0, 'Animation Name [offsetX, offsetY]\n[null out of null]', 25);
	offsetText.cameras = [uicam];
	offsetText.font = Paths.font('GOTHIC.ttf');
	add(offsetText);

	var topmenu:UITopMenu = new UITopMenu([
		{
			label: "File",
			childs: [
				{
					label: "Open",
					onSelect: () ->
					{
						var fDial = new FileDialog();
						fDial.onSelect.add(function(file){openChar(file);});
						fDial.browse(FileDialogType.OPEN, 'xml', null, 'Open a Codename Engine Character XML.');
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
		}
	]);
	topmenu.cameras = [uicam];
	add(topmenu);

	var ref = new Character(0, 0, 'dad', false);
	ref.cameras = [charcam];
	ref.color = 0xFF000000;
	ref.alpha = 0.5;
	ref.screenCenter();
	add(ref);

	for (anim in ref.animOffsets.keys()) {
		var offsets = ref.animOffsets[anim];
		if (offsets == null || !ref.hasAnimation(anim)) continue;
		animList.push(anim);
	}

	ghostCharacter = new Character(ref.x, ref.y, 'dad', false);
	ghostCharacter.cameras = [charcam];
	ghostCharacter.alpha = 0.5;
	ghostCharacter.playAnim('idle', true);
	add(ghostCharacter);

	character = new Character(ref.x, ref.y, 'dad', false);
	character.cameras = [charcam];
	character.playAnim(animList[curAnim], true);
	add(character);

	nextButton = new UIButton(offsetText.x, offsetText.y+offsetText.height+10, "Next", function(){
		if (curAnim+1 < animList.length)
			curAnim++;character.playAnim(animList[curAnim], true);
	});
	nextButton.cameras = [uicam];
	add(nextButton);

	prevButton = new UIButton(nextButton.x, nextButton.y+40, "Previous", function(){
		if (curAnim+1 > 1)
			curAnim--;character.playAnim(animList[curAnim], true);
	});
	prevButton.cameras = [uicam];
	add(prevButton);

	globalOffsetText = new FlxText(infoText.x, prevButton.y+40, 0, 'Global Offset: 0, 0', 25);
	globalOffsetText.cameras = [uicam];
	globalOffsetText.font = Paths.font('GOTHIC.ttf');
	add(globalOffsetText);

	cameraOffsetText = new FlxText(infoText.x, globalOffsetText.y+globalOffsetText.height, 0, 'Camera Offset: 0, 0', 25);
	cameraOffsetText.cameras = [uicam];
	cameraOffsetText.font = Paths.font('GOTHIC.ttf');
	add(cameraOffsetText);

	globalCheckbox = new UICheckbox(cameraOffsetText.x, cameraOffsetText.y+cameraOffsetText.height+10, "Edit Global", false, 0);
	globalCheckbox.cameras = [uicam];
	add(globalCheckbox);

	var charCam = character.getCameraPosition();
	cameraPoint = new FlxSprite(charCam.x, charCam.y).makeGraphic(25, 25, 0xFFFFFFFF);
	cameraPoint.cameras = [charcam];
	add(cameraPoint);

	animXmls = new StringMap();
	for (anim in character.xml.elementsNamed("anim")) {
		animXmls.set(anim.get("name"), anim);
	}
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.EIGHT) FlxG.switchState(new UIState(true, 'InkyEditor'));
	if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(new MainMenuState());

	if (FlxG.mouse.justPressed && mouseOverlapsChar()) {
		dragging = true;
		startOffset = [FlxG.mouse.getWorldPosition(charcam).x, FlxG.mouse.getWorldPosition(charcam).y];
		if (globalCheckbox.checked) startOffset2 = [character.offset.x, character.offset.y];
		else startOffset2 = [character.globalOffset.x, character.globalOffset.y];
	} else if (FlxG.mouse.justPressedRight && mouseOverlapsChar()) {
		if (!globalCheckbox.checked){
			character.offset.x = 0;
			character.animOffsets[character.getAnimName()].x = character.offset.x;
			animXmls[animList[curAnim]].set("x", character.animOffsets[animList[curAnim]].x);

			character.offset.y = 0;
			character.animOffsets[character.getAnimName()].y = character.offset.y;
			animXmls[animList[curAnim]].set("y", character.animOffsets[animList[curAnim]].y);
		} else {
			character.globalOffset.x = 0;
			character.xml.set("x", character.globalOffset.x);

			character.globalOffset.y = 0;
			character.xml.set("y", character.globalOffset.y);

			character.playAnim(animList[curAnim], false);
		}
	}

	if (FlxG.mouse.justReleased) {
		dragging = false;
		startOffset = null;
		startOffset2 = null;
	}

	if (dragging & FlxG.mouse.justMoved) {
		if (!globalCheckbox.checked){
			character.offset.x = startOffset2[0] - (FlxG.mouse.getWorldPosition(charcam).x - startOffset[0]);
			character.animOffsets[character.getAnimName()].x = character.offset.x;
			animXmls[animList[curAnim]].set("x", character.animOffsets[animList[curAnim]].x);

			character.offset.y = startOffset2[1] - (FlxG.mouse.getWorldPosition(charcam).y - startOffset[1]);
			character.animOffsets[character.getAnimName()].y = character.offset.y;
			animXmls[animList[curAnim]].set("y", character.animOffsets[animList[curAnim]].y);
		} else {
			character.globalOffset.x = startOffset2[0] + (FlxG.mouse.getWorldPosition(charcam).x - startOffset[0]);
			character.xml.set("x", character.globalOffset.x);

			character.globalOffset.y = startOffset2[1] + (FlxG.mouse.getWorldPosition(charcam).y - startOffset[1]);
			character.xml.set("y", character.globalOffset.y);

			character.playAnim(animList[curAnim], false);
		}
	}

	if (FlxG.keys.pressed.A)
		charcam.scroll.x -= 500 / charcam.zoom * elapsed;
	if (FlxG.keys.pressed.S)
		charcam.scroll.y += 500 / charcam.zoom * elapsed;
	if (FlxG.keys.pressed.W)
		charcam.scroll.y -= 500 / charcam.zoom * elapsed;
	if (FlxG.keys.pressed.D)
		charcam.scroll.x += 500 / charcam.zoom * elapsed;
	if (FlxG.mouse.wheel < 0)
		charcam.zoom -= 2 * elapsed;
	if (FlxG.mouse.wheel > 0)
		charcam.zoom += 2 * elapsed;

	offsetText.text = character.getAnimName()+' ['+character.animOffsets[character.getAnimName()].x+', '+character.animOffsets[character.getAnimName()].y+']\n['+(animList.indexOf(character.getAnimName())+1)+' out of '+animList.length+']';
	offsetText.x = FlxG.width-7-(offsetText.width);
	globalOffsetText.text = 'Global Offset: '+character.globalOffset.x+', '+character.globalOffset.y;
	globalOffsetText.x = FlxG.width-7-(globalOffsetText.width);
	var camPos = character.getCameraPosition();
	cameraPoint.setPosition(camPos.x, camPos.y);
	cameraOffsetText.text = 'Camera Offset: '+character.cameraOffset.x+', '+character.cameraOffset.y;
	cameraOffsetText.x = FlxG.width-7-(cameraOffsetText.width);
}

function mouseOverlapsChar() { // i stole this code from YCE im sorry yosh
	var mousePos = FlxG.mouse.getWorldPosition(charcam);
	return (character.x - (character.offset.x) < mousePos.x
		&& character.x - (character.offset.x) + (character.frameWidth * character.scale.y) > mousePos.x
		&& character.y - (character.offset.y) < mousePos.y
		&& character.y - (character.offset.y) + (character.frameHeight * character.scale.y) > mousePos.y);
}