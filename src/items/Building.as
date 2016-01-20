/**
 * Created by Igor on 19.01.2016.
 */
package items {
import flash.utils.setTimeout;

public class Building extends ContainerObject implements IDestroyable{
    public function Building(_sizeX:int, _sizeY:int, _x:int, _y:int) {
        super(_sizeX, _sizeY, _x, _y);
    }

    public override function Destroy(obj:GroundRect):void {
        if (!isDestroying) {
            isDestroying = true;
            //destroy items
            DestroyFromRect(obj.fieldX - fieldX, obj.fieldY - fieldY);
        }
    }

    private function DestroyFromRect(_x:int, _y:int):void {
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
}
}
