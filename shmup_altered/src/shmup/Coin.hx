package shmup;

import flambe.Component;
import flambe.Entity;
import flambe.System;
import flambe.display.Sprite;

/** Logic for coins. */
class Coin extends Component
{
    public function new (ctx :ShmupContext, target :Entity)
    {
        _ctx = ctx;
        _target = target;
    }

    override public function onUpdate (dt :Float)
    {
        // Move the coin forward
        var coinSprite = owner.get(Sprite);
        coinSprite.x._ += dt;
        coinSprite.y._ += dt;

        if (coinSprite.x._ < 0 || coinSprite.x._ > System.stage.width ||
            coinSprite.y._ < 0 || coinSprite.y._ > System.stage.height) {
            // Bullet travelled offscreen, remove the entire entity
            owner.dispose();
            return;
        }

        var ii = 0, ll = _target.length;
        while (ii < ll) {
            var target = _target[ii];
            var targetSprite = target.get(Sprite);
            var someCharacter = target.get(Character);

            if (targetSprite != null && someCharacter != null) {
                var dx = targetSprite.x._ - coinSprite.x._;
                var dy = targetSprite.y._ - coinSprite.y._;
                if (dx*dx + dy*dy < someCharacter.radius*someCharacter.radius) {
                    
                    trace("collision detected in Coin class");
                    //owner.dispose();
                    //if (someCharacter.damage(1)) {
                      //  _targets.splice(ii, 1);
                    //}
                    return;
                }
            }

            ++ii;
        }
    }

    private var _ctx :ShmupContext;
    private var _target :Entity;
