//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup;

import flambe.Component;
import flambe.Entity;
import flambe.display.ImageSprite;
import flambe.display.Sprite; 
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.util.Signal0;

/** Base logic for characters: player, baddie, coins. */
class GameEntity extends Entity
{
    public var sprite : Sprite;
    public var radius (default, null) :Float;
    public var health (default, null) :Float;
    public var x (default, null) :Float;
    public var y (default, null) :Float;

    /** Emitted when this character is destroyed. */
    public var destroyed (default, null) :Signal0;

    private var _ctx :GameContext;
    private var _name :String;

    public function new (ctx :GameContext, name :String, radius :Float, health :Float)
    {
        _ctx = ctx;
        _name = name;
        this.radius = radius;
        this.health = health;
        destroyed = new Signal0();
    }

    override public function onAdded ()
    {
        var normal = _ctx.pack.getTexture("jelly/"+_name);
        var sprite = owner.get(ImageSprite);
        if (sprite == null) {
            owner.add(sprite = new ImageSprite(normal));
        }
        sprite.texture = normal;
        sprite.centerAnchor();
    }

    public inline function overlaps(e:GameObject)
    {
        var maxDist = this.radius + e.radius;
        // classic distance formula
        var distSqr = (e.x-x)*(e.x-x) + (e.y-y)*(e.y-y);
        if( distSqr<=maxDist*maxDist )
        {
            trace("collision ho");
            return true;
        }
        else
            return false;
    }

    /** Deal damage to this character, returns true if it was destroyed. */
    public function damage (amount :Float) :Bool
    {
        //object destroyed
        if (amount >= health) {
            health = 0;
            destroyed.emit();
            owner.dispose();
            return true;
        }
        //object damaged 
        else {

            _ctx.pack.getSound("sounds/Hurt").play();
            health -= amount;
            return false;
        }
    }

}