package urgame;

import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.scene.Director;
import flambe.scene.SlideTransition;

//Contains game state info to pass around
class GameContext
{
	public var pack (default, null) : AssetPack;
	public var director (default, null) :Director;

	//currently active level
	//public var level :LevelModel;

	public function new(mainpack :AssetPack, mdirector :Director)
	{
		this.pack = mainpack;
		this.director = mdirector;

		//if messages are needed, load them here
	}

	public function startHomeScene(animate :Bool = true)
	{
		director.unwindToScene(MainMenuScene.create(this),
            animate ? new SlideTransition(0.75, Ease.quintOut) : null);
            
	}

	public function startPlayingScene(animate :Bool = true)
	{
		/*
		director.unwindToScene(PlayingScene.create(this),
            animate ? new SlideTransition(0.75, Ease.quintOut) : null);
            */
	}

	public function showPrompt(text :String, buttons :Array<Dynamic>)
	{
		/*
		director.pushScene(PromptScene.create(this, text, buttons));
		*/
	}
}