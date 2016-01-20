/**
 * Created by Igor on 19.01.2016.
 */
package items {
import common.Game;

import flash.utils.setTimeout;

import items.ContainerObject;

import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;

import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.textures.Texture;

import utils.EmbeddedAssets;

public class Explosion extends ContainerObject {
    private var movie:MovieClip;
    public function Explosion(_sizeX:int, _sizeY:int, _x:int, _y:int) {
        super(_sizeX, _sizeY, _x, _y);
    }

    public override function Destroy(obj:GroundRect):void {
        setTimeout(function ():void {

            if (Math.random() * 10 > 5)
                movie = new MovieClip(EmbeddedAssets.Explosion1.getTextures("dust1x1_"), 10);
            else
                movie = new MovieClip(EmbeddedAssets.Explosion2.getTextures("dust2x2_"), 10);
            movie.loop = false; // default: true
            Game.Instance.field.addChild(movie);
            movie.x = (Game.Instance.field.cellWidth - movie.width) / 2 + x;
            movie.y = (Game.Instance.field.cellHeight - movie.height) + y;

            movie.play();

            Starling.juggler.add(movie);

            movie.addEventListener(EnterFrameEvent.ENTER_FRAME, checkForLastFrame);
        }, 10);
    }



    private function checkForLastFrame(e:Event):void {
        if (movie.currentFrame == 5) {
            for each(var cellRow:Array in cells) {
                for each(var cell:GroundRect in cellRow) {
                    cell.image = null;
                }
            }
//            if (Math.random() * 10 > 1)
//                ShowGarbage(EmbeddedAssets.Garbage);
        }
        if(movie.currentFrame == movie.numFrames-1){
            movie.pause();
            Starling.juggler.remove(movie);
            movie.removeEventListener(EnterFrameEvent.ENTER_FRAME, checkForLastFrame);
            movie.removeFromParent(true);
            //(item as ContainerObject).ClearCell(this.fieldX - item.fieldX, this.fieldY - item.fieldY);
            //item = null;
        }
    }



}
}
