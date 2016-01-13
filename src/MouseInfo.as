/**
 * Created by Igor on 11.01.2016.
 */
package {
import flash.geom.Point;

import starling.events.TouchPhase;

public class MouseInfo {

    public var position:Point;
    public var timeStamp:Number;
    public var touchPhase:String;

    public function get x():int {
        return position.x;
    }

    public function get y():int {
        return position.y;
    }

    public function MouseInfo(x:int, y:int, phase:String) {
        position = new Point(x, y);
        touchPhase = phase;
        timeStamp = new Date().time;
    }
}
}
