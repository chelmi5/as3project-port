//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup;

import flambe.Component;
import flambe.Entity;
import flambe.display.ImageSprite;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.util.Signal0;
import flambe.animation.AnimatedFloat;

/** Base logic for characters: player, baddie, coins. */
class GameObject extends Component
{
    public var radius (default, null) :Float;
    public var health (default, null) :Float;
    public var points (default, null) :Float;

    /** Emitted when this character is destroyed. */
    public var destroyed (default, null) :Signal0;

    private var _ctx :GameContext;
    private var _name :String;

    public function new (ctx :GameContext, name :String, radius :Float, health :Float, points :Float)
    {
        _ctx = ctx;
        _name = name;
        this.radius = radius;
        this.health = health;
        destroyed = new Signal0();
        this.points = points;
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

    /** Deal damage to this character, returns true if it was destroyed. */
    public function damage (amount :Float) :Bool
    {
        _ctx.pack.getSound("sounds/Hurt").play();
        //object destroyed
        if (amount >= health) {
            points = 0;
            health = 0;
            return true;
        }
        //object damaged 
        else {
            health -= amount;
            return false;
        }
    }

}
