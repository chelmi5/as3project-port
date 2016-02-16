package urgame;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.scene.Director;

class Main
{
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        var director = new Director();
        System.root.add(director);

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        System.loadAssetPack(manifest).get(function (bootstrapPack) {

            var promise = System.loadAssetPack(Manifest.fromAssets("main"));
                promise.get(function (mainPack) {
                    var ctx = new GameContext(mainPack, director);
                    ctx.startHomeScene(false);

                    // Free up the preloader assets to save memory
                    bootstrapPack.dispose();

                
            });

                // Show a simple preloader while the main pack is loading
                var preloader = PreloaderScene.create(bootstrapPack, promise);
                director.unwindToScene(preloader);
        });
    }

/*
    private static function onSuccess (pack :AssetPack)
    {
        // Wind up all platform-specific stuff
        System.init();

        var director = new Director();
        System.root.add(director);

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);

        // Add a solid color background
        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        //var background = new FillSprite(3399cc, System.stage.width, System.stage.height);
        System.root.addChild(new Entity().add(background));


        //Load images from assets>bootstrap

        //Show preloader while images are loading
        var preloader = PreloaderScene.create(bootstrapPack, promise);
        director.unwindToScene(preloader);
        /*
        
        //plane.y.animateTo(200, 6);

        //test to make sure things are showing up properly
        var titlejelly = new ImageSprite(pack.getTexture("titlejelly"));
        titlejelly.x._ = 30;
        titlejelly.y._ = 30;
        System.root.addChild(new Entity().add(titlejelly));
        
    }
    */
}
