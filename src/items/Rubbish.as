/**
 * Created by Igor on 19.01.2016.
 */
package items {
public class    Rubbish extends ContainerObject {
    public function Rubbish(_sizeX:int, _sizeY:int, _x:int, _y:int) {
        super(_sizeX, _sizeY, _x, _y);
    }

    public override function Destroy(obj:GroundRect):void {
    }
}
}
