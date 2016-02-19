//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup;

import flambe.Entity;
import flambe.System;
import flambe.animation.Ease;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.util.Promise;

class HomeScene
{
    /** Creates the main menu scene. */
    public static function create (ctx :GameContext) :Entity
    {
        var scene = new Entity();

        var background = new FillSprite(0x03A3B3, System.stage.width, System.stage.height);
        scene.addChild(new Entity().add(background));

        //Loading images for title screen... var names are pretty self-exaplanatory
        var title = new ImageSprite(ctx.pack.getTexture("jelly/title"));
        title.x._ = System.stage.width/18;
        title.y._ = System.stage.height/15;
        scene.addChild(new Entity().add(title));

        var info = new ImageSprite(ctx.pack.getTexture("jelly/info"));
        info.x._ = System.stage.width/3.5;
        info.y._ = System.stage.height/2.7;
        //scene.addChild(new Entity().add(info));
        //add back in if I can get the keyboard input working...

        var titlejelly = new ImageSprite(ctx.pack.getTexture("jelly/titlejelly"));
        titlejelly.x._ = System.stage.width/11;
        titlejelly.y._ = System.stage.height/2.4;
        titlejelly.scaleX.animate(0.25, 1, 0.5, Ease.backOut);
        titlejelly.scaleY.animate(0.25, 1, 0.5, Ease.backOut);

        //try looping with a script?
        //titlejelly.y.animate(System.stage.height/2.4, System.stage.height/2.6, 1, Ease.sineInOut);
        /*
        worldScript.run(new Repeat(new Sequence([
            new Delay(1.5),
            new CallFunction(function () {
                var coral = new ImageSprite(_ctx.pack.getTexture("jelly/coraltwo"))
                    .centerAnchor().setAlpha(0.9);
                coral.setXY(Math.random() * System.stage.width, -coral.getNaturalHeight()/2);
                worldScript.run(new Sequence([
                    new AnimateTo(coral.y, System.stage.height+coral.getNaturalHeight()/2, 10+8*Math.random()),
                    new CallFunction(coral.dispose),
                ]));
                _coralLayer.addChild(new Entity().add(coral));
            }),
        ])));
        */

        scene.addChild(new Entity().add(titlejelly));

        var playbutton = new ImageSprite(ctx.pack.getTexture("jelly/playbutton"));
        playbutton.centerAnchor().setXY(System.stage.width/1.35, System.stage.height/1.3);
        playbutton.scaleX.animate(0.25, 1, 0.5, Ease.backOut);
        playbutton.scaleY.animate(0.25, 1, 0.5, Ease.backOut);

        //if pressed, plays noise and starts level
        playbutton.pointerDown.connect(function (_) {
            ctx.pack.getSound("sounds/Coin").play();
            ctx.enterPlayingScene();
        });
        scene.addChild(new Entity().add(playbutton));

        return scene;
    }
}
