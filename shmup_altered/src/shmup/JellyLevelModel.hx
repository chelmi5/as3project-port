package shmup;

import flambe.Component;
import flambe.Entity;
import flambe.SpeedAdjuster;
import flambe.System;
import flambe.animation.Ease;
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
    private var _planeLayer :Entity;
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

		//add everything to world layer
		_worldLayer.addChild(_coralLayer = new Entity());
        _worldLayer.addChild(_planeLayer = new Entity());
        _worldLayer.addChild(_bulletLayer = new Entity());
        _worldLayer.addChild(_explosionLayer = new Entity());

        var worldScript = new Script();
        _worldLayer.add(worldScript);

		//add scrolling coral bg
		worldScript.run(new Repeat(new Sequence([
            new Delay(1.5),
            new CallFunction(function () {
                var coral = new ImageSprite(_ctx.pack.getTexture("jelly/coral"))
                    .centerAnchor().setAlpha(0.5);
                coral.setXY(Math.random() * System.stage.width, -coral.getNaturalHeight()/2);
                worldScript.run(new Sequence([
                    new AnimateTo(coral.y, System.stage.height+coral.getNaturalHeight()/2, 10+6*Math.random()),
                    new CallFunction(coral.dispose),
                ]));
                _coralLayer.addChild(new Entity().add(coral));
            }),
        ])));

	}
}