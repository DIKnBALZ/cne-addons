import sys.FileSystem;
import sys.io.File;
import funkin.backend.utils.CoolUtil;

/*
v1: 
    - idk its kinda finished? im writing these patch notes long after i finished this i might have forgotten a few stuff lol


v1.1: 
    - made sure stage images were forced into a single directory (idk how to explain it)
    - bandade fix for making sure meta.json can be created
*/

//before you look at this code, yes, it is incredibly messy lol. im sorry

// i didnt have a plan going into this, it was ment as just a character converter but turned it into a mod converter. so things might be all over the place.

// Change these paths if you need to
var modInputPath:String = "assets/data/states/ModInput"; 
var modOutputPath:String = "assets/data/states/ModOutput"; 



var charJsonsPath:String = ""; 
var charOutputPath:String = "";

var txt:FlxText;

var curMod = '';

function create()
{
    txt = new FlxText(0,0,900,"Done!",42); // it finished before the transition finishes
    txt.alignment = "center";
    txt.screenCenter();
    add(txt);

    var modDirectories = Paths.getFolderContent('data/states/ModInput/');
    //trace(modDirectories);

    for(i in modDirectories)
    {
        curMod = i;
        charJsonsPath = modInputPath+'/'+i+'/characters';
        //trace(charJsonsPath);
        convertChars();
        convertSongs();
        convertCharts();
        convertStages();
    }

    
    
    FlxG.switchState(new MainMenuState());
}

function convertSongs()
{
    var songdirectories = FileSystem.readDirectory(modInputPath+'/'+curMod+'/songs');

    for(songFolder in songdirectories)
    {
        var songFiles = [];
        if(FileSystem.isDirectory(modInputPath+'/'+curMod+'/songs/'+songFolder))
        {
            FileSystem.createDirectory(modOutputPath+'/'+curMod+'/songs/'+songFolder);
            songFiles = FileSystem.readDirectory(modInputPath+'/'+curMod+'/songs/'+songFolder);
        }
        for(song in songFiles)
        {
            var path = modOutputPath+'/'+curMod+'/songs/'+songFolder+'/song/';
            switch(song)
            {
                case 'Inst.ogg':
                    FileSystem.createDirectory(modOutputPath+'/'+curMod+'/songs/'+songFolder+'/song');
                    File.copy(modInputPath+'/'+curMod+'/songs/'+songFolder+'/Inst.ogg',path+'Inst.ogg');

                case 'Voices.ogg':
                    FileSystem.createDirectory(modOutputPath+'/'+curMod+'/songs/'+songFolder+'/song');
                    File.copy(modInputPath+'/'+curMod+'/songs/'+songFolder+'/Voices.ogg',path+'Voices.ogg');
            }
        }
    }
}

function convertCharts()
{
    var chartdirectories = FileSystem.readDirectory(modInputPath+'/'+curMod+'/data');

    var chartFiles = [];

    var inputSongListRaw = '';
    var inputSongList = {};

    for(chartFolder in chartdirectories)
    {
        if(chartFolder == 'freeplaySonglist.json')
        {
            inputSongListRaw = File.getContent(modInputPath+'/'+curMod+'/data/freeplaySonglist.json');
            inputSongList = Json.parse(inputSongListRaw);
            trace(inputSongList);
        }
    }

    for(chartFolder in chartdirectories)
    {
        if(FileSystem.isDirectory(modInputPath+'/'+curMod+'/data/'+chartFolder))
        {
            chartFiles = FileSystem.readDirectory(modInputPath+'/'+curMod+'/data/'+chartFolder);
            for(chart in chartFiles)
            {
                var path = modOutputPath+'/'+curMod+'/songs/'+chartFolder+'/charts/';

                FileSystem.createDirectory(modOutputPath+'/'+curMod+'/songs/'+chartFolder+'/charts');

                var newChartName = '';
                if(chartFolder == StringTools.replace(chart,'.json',''))
                {
                    newChartName = 'normal.json';
                } else {
                    newChartName = StringTools.replace(chart,chartFolder+'-','');
                }
                File.copy(modInputPath+'/'+curMod+'/data/'+chartFolder+'/'+chart,path+newChartName);
            }
            var metapath = modOutputPath+'/'+curMod+'/songs/'+chartFolder+'/';
            for(i in inputSongList.songs)
            {
                
                if(i.name == chartFolder)
                {
                    var metaJson = {
                        "displayName": i.name,
                        "bpm": i.bpm,
                        "icon": i.char,
                        "color": i.color,
                        "coopAllowed": true,
                        "opponentModeAllowed": true
                    }

                    var metaString = Json.stringify(metaJson);
                    trace(metaString);
                    File.saveContent(metapath+"meta.json",metaString);
                }
            }
        }
    }
}


function convertChars()
{
    var directories = FileSystem.readDirectory(charJsonsPath);

    for(d in directories)
    {
        
        var path = charJsonsPath +'/'+ d;
        if(d == "README.txt") // idk what im doing, im tired and i wana just get this done lol
        {

        } else {
            FileSystem.createDirectory(modOutputPath+'/'+curMod+'/');
            var newPath = modOutputPath+'/'+curMod+'/';
            var files = FileSystem.readDirectory(path);
            for(i in files)
            {
                switch(i)
                {
                    case 'Character.json':
                        var jsonRaw = File.getContent(path+'/'+i);
                        var json:Array = Json.parse(jsonRaw);
            
                        var xml = '<!DOCTYPE codename-engine-character>\n<character isPlayer="false" flipX="'+json.flipX+'" x="'+json.globalOffset.x+'" y="'+json.globalOffset.y+'" holdTime="6.1">';
            
                        var anims = json.anims;
                        for(i in anims)
                        {
                            xml += '\n <anim name="'+i.name+'"       anim="'+i.anim+'"       fps="'+i.framerate+'"    loop="'+i.loop+'" x="'+i.x+'" y="'+i.y+'" ';
        
                            if(i.indices != null)
                            {
                                xml += 'indices="'+i.indices.join(',')+'"';
                            }
        
                            xml += ' />';
                        }
                        xml += "\n</character>";
                        //trace(xml);
                        FileSystem.createDirectory(newPath+'/data/characters');
                        File.saveContent(newPath+'/data/characters/'+d+'.xml', xml);

                    case 'spritesheet.png':
                        FileSystem.createDirectory(newPath+'/images/characters');
                        File.copy(path+'/'+i,newPath+'/images/characters/'+d+'.png');

                    case 'spritesheet.xml':
                        FileSystem.createDirectory(newPath+'/images/characters');
                        File.copy(path+'/'+i,newPath+'/images/characters/'+d+'.xml');

                    case 'icon.png':
                        FileSystem.createDirectory(newPath+'/images/icons');
                        File.copy(path+'/'+i,newPath+'/images/icons/'+d+'.png');
                }

            }
        }
        

    }

}

function convertStages()
{
    var directories = modInputPath+'/'+curMod+'/stages';

    var stageFiles = FileSystem.readDirectory(directories);
    var newPath = modOutputPath+'/'+curMod+'/';

    var xml = "<!DOCTYPE codename-engine-stage>\n";

    for(file in stageFiles)
    {
        if(StringTools.endsWith(file,'.json'))
        {
            var jsonRaw = File.getContent(directories+'/'+file);
            var jsonData = Json.parse(jsonRaw);
            var stageName = StringTools.replace(file,'.json','');

            //FileSystem.createDirectory(newPath+'/stages/');
            xml += '<stage zoom="'+jsonData.defaultCamZoom+'" name="'+stageName+'" folder="stages/'+stageName+'/">\n';


            for(sprite in jsonData.sprites)
            {

                switch(sprite.type)
                {
                    case 'Bitmap':
                        copyStageBitmap(sprite.src,stageName);
                        xml += '    <sprite name="'+sprite.name+'"               x="'+sprite.pos[0]+'" y="'+sprite.pos[1]+'"   sprite="'+sprite.src+'"       scroll="'+sprite.scrollFactor[0]+'" />\n';

                    case 'SparrowAtlas':
                        copyStageSparrow(sprite.src,stageName);
                        xml += '    <sprite name="'+sprite.name+'"               x="'+sprite.pos[0]+'" y="'+sprite.pos[1]+'"   sprite="'+sprite.src+'"       scroll="'+sprite.scrollFactor[0]+'" >\n';
                        var loop = 'false';
                        if(sprite.animation.type == 'Loop')
                        {
                            loop == 'true';
                        }
                        xml += '        <anim name="'+sprite.animation.name+'" anim="'+sprite.animation.name+'" loop="'+loop+'"/>\n'; // im not entirely sure how animations work on stages so this is just a guess :/
                        xml += '    </sprite>\n';

                    case 'GF':
                        xml += '    <girlfriend />\n';

                    case 'BF':
                        xml += '    <boyfriend />\n';

                    case 'Dad':
                        xml += '    <dad />\n';
                }
            }

            xml += '</stage>';

            FileSystem.createDirectory(newPath+'/data/stages');
            File.saveContent(newPath+'/data/stages/'+stageName+'.xml', xml);
        }
    }
}

function copyStageBitmap(src,stageName)
{
    var path = modInputPath+'/'+curMod+'/images/'+src+'.png';
    var gra = path.split('/');
    var imgname = gra[gra.length-1];
    var output = modOutputPath+'/'+curMod+'/images/stages/'+stageName;
    
    
    FileSystem.createDirectory(output);
    File.copy(path,output+'/'+imgname);
    return output+'/'+imgname;
}

function copyStageSparrow(src,stageName)
{
    var pathpng = modInputPath+'/'+curMod+'/images/'+src+'.png';
    var pathxml = modInputPath+'/'+curMod+'/images/'+src+'.xml';

    var gra = pathpng.split('/');
    var pngname = gra[gra.length-1];

    var gra = pathxml.split('/');
    var xmlname = gra[gra.length-1];

    var output = modOutputPath+'/'+curMod+'/images/stages/'+stageName;
    FileSystem.createDirectory(output);

    File.copy(pathpng,output+'/'+pngname);
    File.copy(pathxml,output+'/'+xmlname);

    var noExt = output+'/'+pngname;
    return output+'/'+pngname;
}

function update(elapsed:Float)
{
    if (FlxG.keys.justPressed.ESCAPE)
        FlxG.switchState(new MainMenuState());
}