/**
 * Created by Igor on 09.01.2016.
 */
package {
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.setTimeout;

import starling.display.Sprite;
import starling.text.TextField;

public class Field extends Sprite {

    public var fieldRectangles:Array = [];
    public var objects:Array = [];
    public var cellWidth:int = 0;
    public var cellHeight:int = 0;
    public var fieldSize:int = 50;

    public function Field() {
        super();
        cellWidth = EmbeddedAssets.GroundRect.width;
        cellHeight = EmbeddedAssets.GroundRect.height;
        for (var i:int = 0; i < fieldSize; i++) {
            var row:Array = [];
            for (var j:int = 0; j < fieldSize; j++) {
                var rect:GroundRect = new GroundRect();
                var pos:Point = FieldToWorld(i, j);
                rect.x = pos.x;
                rect.y = pos.y;
                rect.fieldX = j;
                rect.fieldY = i;
                rect.Name = i + " " + j;
                addChild(rect);
                row.push(rect);
            }
            fieldRectangles.push(row);
        }

        x = cellWidth * fieldSize / 2;

        setTimeout(function():void {
            GenerateAllPositions();
        }, 20);
    }

    public function WorldToField(worldX:int, worldY:int):Point {
        var dx:Number = (Number)(worldX - this.x) / cellWidth;
        var dy:Number = (Number)(worldY - this.y) / cellHeight;
        return new Point(Math.round(dx + dy) - 1, Math.round(dy - dx));
    }

    public function FieldToWorld(fieldX:int, fieldY:int):Point {
        var dx:Number = this.x + (fieldY - fieldX) * cellWidth / 2;
        var dy:Number = this.y + (fieldX + fieldY) * cellHeight / 2;
        return new Point(dx, dy);
    }

    public function GenerateAllPositions():void {
        while(objects.length < 10) {
            objects.push(GenerateOnePosition());
        }
    }

    public function GenerateOnePosition():Building {
        var places:Array = [];
        var i:int, j:int, sizeX:int, sizeY:int;

        var attemptsCount:int = 10;
        var currentAttempt:int = 0;
        while (places.length == 0 && currentAttempt < attemptsCount) {
            var maxSize:int = 7;
            while(maxSize >= 0 && places.length == 0) {
                sizeX = Math.random() * maxSize + 1;
                sizeY = Math.random() * 2 - 1 + sizeX;

                for (i = 0; i < fieldSize - sizeY; i++) {
                    for (j = 0; j < fieldSize - sizeX; j++) {
                        var items:Array = [];
                        for (var i1:int = -1; i1 < sizeY + 2 && items.length == 0; i1++) {
                            for (var j1:int= -1; j1 < sizeX + 2 && items.length == 0; j1++) {
                                if (i + i1 >= 0 && i + i1 < fieldSize &&
                                        j + j1 >= 0 && j + j1 < fieldSize &&
                                        (fieldRectangles[i + i1][j + j1] as GroundRect).item != null) {
                                    items.push((fieldRectangles[i + i1][j + j1] as GroundRect).item);
                                }
                            }
                        }
                        if (items.length == 0) {
                            places.push(new Point(j, i));
                        }
                    }
                }
                maxSize--;
            }
            currentAttempt++;
        }
        if (places.length != 0) {
            var number:int = Math.random() * places.length;
            var place:Point = places[number];
            var building:Building = new Building(sizeX, sizeY, place.x, place.y);
            for(i = 0; i < sizeY; i++) {
                building.cells[i] = [];
                for (j = 0; j < sizeX; j++) {

                    (fieldRectangles[i + place.y][j + place.x] as GroundRect).item = building;

                    building.cells[i].push((fieldRectangles[i + place.y][j + place.x] as GroundRect));
                }
            }
            return building;
        }
        return null;
    }
}
}
