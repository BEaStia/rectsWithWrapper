/**
 * Created by Igor on 10.01.2016.
 */
package {
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class GameObject extends Sprite {

    public var Name:String = "";
    public var shown:Boolean = false;
    public var fieldX:int;
    public var fieldY:int;
    public function GameObject() {
        super();
    }

    public function Show():void {
        shown = true;
    }

    public function Hide():void {
        shown = false;
    }

    public function OnClick():void {

    }
}
}
