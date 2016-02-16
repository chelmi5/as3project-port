package urgame;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.util.Promise;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.Font;
import flambe.display.TextSprite;

class PreloaderScene
{
	public static function create(pack :AssetPack, promise :Promise<Dynamic>) :Entity
	{
		var scene = new Entity();

        // Add a solid dark background
        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        scene.addChild(new Entity().add(background));

        //add text that just says "Loading"
        var font = new Font(pack, "Arial");
		var myTextSprite:TextSprite = new TextSprite(font, "Hello world!");
		myTextSprite.align = TextAlign.Left;
		scene.addChild(new Entity().add(myTextSprite));

		// change the text using .text property:
		myTextSprite.text = "Loading...";

        return scene;
	}
}