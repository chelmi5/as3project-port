package shmup;

import flambe.Component;
import flambe.Entity;
import flambe.SpeedAdjuster;
import flambe.System;
import flambe.animation.Ease;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.PatternSprite;
import flambe.display.Sprite;
import flambe.math.FMath;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.util.Value;

import shmup.ai.MoveStraight;

class JellyLevelModel extends Component
{
	public static inline var PLAYER_SPEED = 1000;
    public static inline var ENEMY_SPEED = 500;
    public static inline var COIN_SPEED = 700;

	public var player (default, null) :Entity;

	public var score (default, null) :Value<Int>;

	private var _ctx :GameContext;

    private var _worldLayer :Entity;
    private var _coralLayer :Entity;
    private var _characterLayer :Entity;
    private var _bulletLayer :Entity;
    private var _explosionLayer :Entity;

    private var _enemies :Array<Entity>;
    private var _friendlies :Array<Entity>;

	public function new (ctx :GameContext)
	{
		_ctx = ctx;
		_enemies = [];
		score = new Value<Int>(0);
	}

	override public function onAdded ()
	{
		_worldLayer = new Entity();
		owner.addChild(_worldLayer);

		//add scrolling water background
		var background = new FillSprite(0x03A3B3, System.stage.width + 32, System.stage.height);
        _worldLayer.addChild(new Entity().add(background));

		//add everything to world layer
		_worldLayer.addChild(_coralLayer = new Entity());
        _worldLayer.addChild(_characterLayer = new Entity());
        _worldLayer.addChild(_bulletLayer = new Entity());
        _worldLayer.addChild(_explosionLayer = new Entity());

        var worldScript = new Script();
        _worldLayer.add(worldScript);

		//add scrolling coral bg
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

        //add player character

        // Create the player
        var jelly = new Character(_ctx, "playerjelly", 5, 3);
        jelly.destroyed.connect(function () {
            // When the player dies, show an explosion
            //var sprite = player.get(Sprite);
            //explode(sprite.x._, sprite.y._);

            // Adjust the speed of the world for a dramatic slow motion effect
            var worldSpeed = new SpeedAdjuster(0.5);
            _worldLayer.add(worldSpeed);

            // Then show the game over prompt after a moment
            var script = new Script();
            script.run(new Sequence([
                new AnimateTo(worldSpeed.scale, 0, 1.5),
                new CallFunction(function () {
                    _ctx.showPrompt(_ctx.messages.get("game_over", [score._]), [
                        "Replay", function () {
                            _ctx.enterPlayingScene(false);
                        },
                        "Home", function () {
                            _ctx.director.popScene();
                            _ctx.enterHomeScene();
                        },
                    ]);
                }),
            ]));
            owner.add(script);
        });

        player = new Entity().add(jelly);
        _characterLayer.addChild(player);
        _friendlies = [player];

        // Start the player near the bottom of the screen
        player.get(Sprite).setXY(System.stage.width/2, 0.8*System.stage.height);

        //Attempt at coin generation
        var worldScript = new Script();
        _worldLayer.add(worldScript);

        // Repeatedly spawn more coins
        worldScript.run(new Repeat(new Sequence([
            new Delay(0.8),
            new CallFunction(function () {
                var coin = new Entity().add(new Character(_ctx, "coin", 30, 2));

                var points = 0;
                var rand = Math.random(); //save to set point worth. if (rand < 0.3) etc

                    var left = Math.random() < 0.5;
                    var speed = Math.random()*100 + 150;
                    coin
                        //add behaviors
                        .add(new MoveStraight(_ctx, left ? -speed : speed, 0))
                        .add(new Character(_ctx, "coin", 30, 1));
                    var sprite = coin.get(Sprite);
                    sprite.setXY(left ? System.stage.width : 0, Math.random()*200+100);
                    points = 10;
                

                var sprite = coin.get(Sprite);
                coin.get(Character).destroyed.connect(function () {
                    //explode(sprite.x._, sprite.y._);
                    score._ += points;
                });

                _characterLayer.addChild(coin);
                _friendlies.push(coin);
            }),
        ])));

	}

	override public function onUpdate (dt :Float)
    {
        var pointerX = System.pointer.x;
        var pointerY = System.pointer.y;

        // If the player is using a touch screen, offset a bit so that the jellyfish isn't obscurred by
        // their finger
        if (System.touch.supported) {
            pointerY -= 50;
        }

        // Move towards the pointer position at a fixed speed
        var sprite = player.get(Sprite);
        if (sprite != null) {
            var dx = pointerX - sprite.x._;
            var dy = pointerY - sprite.y._;
            var distance = Math.sqrt(dx*dx + dy*dy);

            var travel = PLAYER_SPEED * dt;
            if (travel < distance) {
                sprite.x._ += travel * dx/distance;
                sprite.y._ += travel * dy/distance;
            } else {
                sprite.x._ = pointerX;
                sprite.y._ = pointerY;
            }
        }

        // Remove offscreen enemies
        /*
        var ii = 0;
        while (ii < _enemies.length) {
            var enemy = _enemies[ii];
            var sprite = enemy.get(Sprite);
            var radius = enemy.get(Character).radius;

            if (sprite.x._ < -radius || sprite.x._ > System.stage.width+radius ||
                sprite.y._ < -radius || sprite.y._ > System.stage.height+radius) {

                _enemies.splice(ii, 1);
                enemy.dispose();
            } else {
                ++ii;
            }
        }
        */
    }
}