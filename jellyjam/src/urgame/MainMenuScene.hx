package urgame;

import flambe.Entity;
import flambe.System;
import flambe.animation.Ease;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.util.Promise;

class MainMenuScene
{
	public static function create (ctx :GameContext) :Entity
    {
        var scene = new Entity();

        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        scene.addChild(new Entity().add(background));

        //add title jelly, text info
        var titlejelly = new ImageSprite(ctx.pack.getTexture("titlejelly"));
        titlejelly.centerAnchor().setXY(System.stage.width/4, System.stage.height/4);
        scene.addChild(new Entity().add(titlejelly));

        var play = new ImageSprite(ctx.pack.getTexture("play"));
        play.centerAnchor().setXY(System.stage.width/2, System.stage.height/2);
        play.scaleX.animate(0.5, 1, 0.5, Ease.backOut);
        play.scaleY.animate(0.5, 1, 0.5, Ease.backOut);
        play.pointerDown.connect(function (_) {
            ctx.startPlayingScene();
        });
        scene.addChild(new Entity().add(play));

        return scene;
    }
}