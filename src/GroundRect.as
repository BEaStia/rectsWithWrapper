/**
 * Created by Igor on 10.01.2016.
 */
package {
import flash.events.MouseEvent;
import flash.utils.Timer;
import flash.utils.setTimeout;

import starling.core.Starling;

import starling.display.Image;
import starling.display.MovieClip;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class GroundRect extends GameObject {

    public var background:Image;
    private var _image:Image = null;
    private var _item:GameObject = null;
    private var movie:MovieClip = null;
    public var Destroyed:Boolean = false;

    public function get item():GameObject {
        return _item;
    }

    public function get image():Image {
        return _image;
    }

    public function set image(value:Image):void {
        if (_image != null)
            _image.removeFromParent(true);
        _image = value;
    }

    public function set item(value:GameObject):void {
        _item = value;
        if (shown && value != null) {
            setTimeout(function():void {
                ShowImage();
            }, 10);
        } else {
            setTimeout(function():void {
                HideImage();
            }, 10);
        }
    }

    //called on timer imitating bounding frustrum
    private function ShowImage():void {
        background.removeFromParent(true);
        image = new Image(EmbeddedAssets.BuildRect);
        image.y = background.height - image.height;
        addChildAt(image, 0);
    }

    //called on timer imitating bounding frustrum
    private function HideImage():void {
        background = new Image(texture);
        addChildAt(background, 0);
        if (image != null && !Destroyed) {
            image.removeFromParent(true);
        }
    }

    private function ShowGarbage(_texture:Texture):void {
        background = new Image(texture);
        addChildAt(background, 0);
        image = new Image(_texture);
        image.scaleX = background.width / image.width;
        image.scaleY = background.height / image.height;
        addChild(image);
    }

    private function HideGarbage():void {
        background = new Image(texture);
        addChildAt(background, 0);
        image = null;
    }

    public function GroundRect() {
        super();
    }

    public static function get texture():Texture {
        return EmbeddedAssets.GroundRect;
    }

    override public function Show():void {
        if (!shown) {
            super.Show();
            setTimeout(function():void {
                if (item) {
                    ShowImage();
                } else {
                    HideImage();
                }
            }, 10);

        }
    }

    override public function Hide():void {
        super.Hide();
        if (background != null)
            background.removeFromParent(true);
        if (image != null)
            image.removeFromParent(true);
    }

    override public function OnClick():void {
        if (item != null) {
            (item as ContainerObject).Destroy(this);
        }
    }

    public function Destroy():void {
        Destroyed = true;
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
            image = null;
            if (Math.random() * 10 > 9)
                ShowGarbage(EmbeddedAssets.Garbage);
            else
                HideGarbage();
        }
        if(movie.currentFrame == movie.numFrames-1){
            movie.pause();
            Starling.juggler.remove(movie);
            movie.removeEventListener(EnterFrameEvent.ENTER_FRAME, checkForLastFrame);
            movie.removeFromParent(true);
            (item as ContainerObject).ClearCell(this.fieldX - item.fieldX, this.fieldY - item.fieldY);
            item = null;
        }
    }
}
}
