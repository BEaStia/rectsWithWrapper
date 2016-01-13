/**
 * Created by Igor on 09.01.2016.
 */
package {
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.AssetManager;

public class Game extends Sprite {

    private static var _instance:Game;
    public static function get Instance():Game {
        return _instance;
    }

    public var field:Field;
    public var stageWidth:int = Starling.current.nativeStage.stageWidth;
    public var stageHeight:int = Starling.current.nativeStage.stageHeight;
    public var assets:AssetManager;


    private var drag:Boolean = false;
    private var startInfo:MouseInfo = null;
    private var previousInfo:MouseInfo = null;
    private var dragged:Boolean = false;


    public function Game() {
        _instance = this;
        assets = new AssetManager();
        assets.enqueue(EmbeddedAssets);

        assets.loadQueue(function(ratio:Number):void
        {
            trace("Loading assets, progress:", ratio);

            // -> When the ratio equals '1', we are finished.
            if (ratio == 1.0)
                Start();
        });
    }

    private function Start():void {

        EmbeddedAssets.BuildRect = Game.Instance.assets.getTexture("buildRect");
        EmbeddedAssets.GroundRect = Game.Instance.assets.getTexture("groundRect");
        EmbeddedAssets.Garbage = Game.Instance.assets.getTexture("garbage");

        var explosion1Texture:Texture = Texture.fromEmbeddedAsset(EmbeddedAssets.explosion1);
        var explosion1XML:XML = XML(new EmbeddedAssets.explosion1Xml());
        EmbeddedAssets.Explosion1 = new TextureAtlas(explosion1Texture, explosion1XML);

        var explosion2Texture:Texture = Texture.fromEmbeddedAsset(EmbeddedAssets.explosion2);
        var explosion2XML:XML = XML(new EmbeddedAssets.explosion2Xml());
        EmbeddedAssets.Explosion2 = new TextureAtlas(explosion2Texture, explosion2XML);

        field = new Field();
        addChild(field);


        stageWidth = Starling.current.nativeStage.stageWidth;
        stageHeight = Starling.current.nativeStage.stageHeight;
        stage.addEventListener(TouchEvent.TOUCH, onTouch);

        var timer:Timer = new Timer(10);
        timer.addEventListener(TimerEvent.TIMER, onTick);
        timer.start();
    }

    private function onTick(event:TimerEvent):void {


        var leftTop:Point = field.WorldToField(0,0);
        var rightTop:Point = field.WorldToField(Starling.current.viewPort.width, 0);
        var leftBottom:Point = field.WorldToField(0, Starling.current.viewPort.height);
        var rightBottom:Point = field.WorldToField(Starling.current.viewPort.width, Starling.current.viewPort.height);
        var viewport:Rectangle = new flash.geom.Rectangle(leftTop.x - 4 , rightTop.y - 4, rightBottom.x - leftTop.x + 5, leftBottom.y - rightTop.y + 5);
        for(var i:int = 0; i < field.fieldSize; i++) {
            for(var j:int = 0; j < field.fieldSize; j++) {
                if (field.fieldRectangles[i][j] != null) {
                    if (viewport.contains(j, i)) {
                        field.fieldRectangles[i][j].Show();
                    } else {
                        field.fieldRectangles[i][j].Hide();
                    }
                }
            }
        }
    }


    public function onTouch(event:TouchEvent):void {
        if (event.touches.length > 0) {
            if (event.touches[0].phase == TouchPhase.BEGAN) {
                drag = true;
                startInfo = new MouseInfo(event.touches[0].globalX, event.touches[0].globalY, event.touches[0].phase);
                previousInfo = startInfo;
            }

            if (event.touches[0].phase == TouchPhase.MOVED && drag) {
                dragged = true;
                var dx:Number = event.touches[0].globalX - previousInfo.x;
                var dy:Number = event.touches[0].globalY - previousInfo.y;
                previousInfo = new MouseInfo(event.touches[0].globalX, event.touches[0].globalY, event.touches[0].phase);
                field.x += dx;
                field.y += dy;
            }

            if (event.touches[0].phase == TouchPhase.ENDED) {
                if ((new Date().time - startInfo.timeStamp) < 1000 && !dragged) {
                    var pos:Point = field.WorldToField(event.touches[0].globalX, event.touches[0].globalY);
                    if (pos.x >= 0 && pos.x < field.fieldSize && pos.y >= 0 && pos.y < field.fieldSize) {
                        (field.fieldRectangles[pos.y][pos.x] as GroundRect).OnClick();
                    }
                }
                dragged = false;
                drag = false;
            }

        }

    }
}
}



