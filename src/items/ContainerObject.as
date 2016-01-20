/**
 * Created by Igor on 11.01.2016.
 */
package items {
import common.Game;
import common.GameObject;

import items.ContainerObject;
import items.IDestroyable;

public class ContainerObject extends GameObject implements IDestroyable {

    public var cells:Array = [];
    public var sizeX:int = 0;
    public var sizeY:int = 0;
    public var isDestroying:Boolean = false;

    public function ContainerObject(_sizeX:int, _sizeY:int, _x:int, _y:int) {
        super();
        sizeX = _sizeX;
        sizeY = _sizeY;
        fieldX = _x;
        fieldY = _y;
    }

    private function ResetCells():void {
        cells = [];
        for(var i:int = 0; i < sizeY; i++) {
            cells[i] = [];
        }
    }

    public function ClearCell(_x:int, _y:int):void {
        cells[_y][_x] = null;
        var empty:Boolean = cells.some(function (arr:Array, id:int, rest:Array):Boolean {
            return arr.some(function (element:GroundRect, _id:int, _rest:Array):Boolean {
                return element != null;
            })
        });
        if (empty) {
            Game.Instance.field.objects.slice(Game.Instance.field.objects.indexOf(this), 1);
            this.removeFromParent(true);
        }
    }

    public function ReplaceChildren(newParent:ContainerObject, _x:int, _y:int, _xCount:int = 1, _yCount:int = 1):void {
        for (var i:int = 0; i < _yCount; i++) {
            for (var j:int = 0; j < _xCount; j++) {
                newParent.cells[i][j] = cells[_y + i][_x + j];
            }
        }
    }

    public function Destroy(obj:GroundRect):void {
    }
}
}
