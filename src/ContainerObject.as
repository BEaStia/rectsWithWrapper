/**
 * Created by Igor on 11.01.2016.
 */
package {
import flash.geom.Rectangle;
import flash.utils.setTimeout;

public class ContainerObject extends GameObject {

    public var cells:Array = [];
    public var sizeX:int = 0;
    public var sizeY:int = 0;
    public var isDestroying:Boolean = false;

    public function ContainerObject(_sizeX:int, _sizeY:int, _x:int, _y:int) {
        sizeX = _sizeX;
        sizeY = _sizeY;
        fieldX = _x;
        fieldY = _y;
        trace("New ContainerObject!!!");
        trace(new flash.geom.Rectangle(fieldX, fieldY, sizeX, sizeY));
        super();
    }

    public function Destroy(obj:GroundRect):void {
        if (!isDestroying) {
            isDestroying = true;
            //destroy items
            DestroyFromRect(obj.fieldX - fieldX, obj.fieldY - fieldY);
        }
    }

    public function DestroyFromRect(_x:int, _y:int):void {
        if (_y >= 0 && _y < sizeY && _x >= 0 && _x < sizeX && cells[_y][_x] != null && !(cells[_y][_x] as GroundRect).Destroyed) {
            (cells[_y][_x] as GroundRect).Destroy();
            setTimeout(function():void {
                DestroyFromRect(_x - 1, _y);
                DestroyFromRect(_x + 1, _y);
                DestroyFromRect(_x, _y - 1);
                DestroyFromRect(_x, _y + 1);
            }, 100);
        }
    }

    public function ClearCell(_x:int, _y:int):void {
        cells[_y][_x] = null;
        var empty:Boolean = cells.some(function(arr:Array, id:int, rest:Array):Boolean {
           return arr.some(function(element:GroundRect, _id:int, _rest:Array):Boolean {
               return element != null;
           })
        });
        if (empty) {
            Game.Instance.field.objects.slice(Game.Instance.field.objects.indexOf(this), 1);
            this.removeFromParent(true);
        }
    }
}
}
