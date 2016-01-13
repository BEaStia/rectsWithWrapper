/**
 * Created by Igor on 10.01.2016.
 */
package {
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class EmbeddedAssets {

    [Embed(source="../assets/explosion1.xml", mimeType="application/octet-stream")]
    public static const explosion1Xml:Class;

    [Embed(source="../assets/explosion1.png")]
    public static const explosion1:Class;

    public static var Explosion1:TextureAtlas;

    [Embed(source="../assets/explosion2.xml", mimeType="application/octet-stream")]
    public static const explosion2Xml:Class;

    [Embed(source="../assets/explosion2.png")]
    public static const explosion2:Class;

    public static var Explosion2:TextureAtlas;

    [Embed(source="../assets/buildRect.png")]
    public static const buildRect:Class;

    public static var BuildRect:Texture;

    [Embed(source="../assets/groundRect.png")]
    public static const groundRect:Class;

    public static var GroundRect:Texture;

    [Embed(source="../assets/musor1x1.png")]
    public static const garbage:Class;

    public static var Garbage:Texture;

}
}
