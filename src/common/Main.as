package common {

import flash.display.Sprite;
import starling.core.Starling;

[SWF(frameRate="60", width="800", height="600", backgroundColor="#ffffff")]
public class Main extends Sprite {
    public function Main() {
        var _starling:Starling = new Starling(Game, stage);
        _starling.start();
    }
}

}
