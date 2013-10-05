package worlds 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameplay_objects.ActionMenu;
	import gameplay_objects.Ball;
	import gameplay_objects.BallEnemy;
	import gameplay_objects.Bomb;
	import gameplay_objects.bricks.Brick;
	import gameplay_objects.Bullet;
	import gameplay_objects.FieldBar;
	import gameplay_objects.Pad;
	import gameplay_objects.particles.BackgroundStar;
	import gameplay_objects.PointBar;
	import gameplay_objects.ScoreShow;
	import gameplay_objects.SideBar;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.utils.Data;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;

	/**
	 * ...
	 * @author Zeeshan
	 */
	public class GameWorld extends World 
	{
		[Embed(source = "../../lib/actions_tiles/invoke_button.png")]
		private static const ACTION_INVOKE:Class;
		public static var actionInvoker:Image;
		
		[Embed(source = "../../lib/bg/planet1.png")]
		public static const PLANET_1:Class;
		
		[Embed(source = "../../lib/sounds/start.mp3")]
		private static const START_SND:Class;
		private static var startSnd:Sfx = new Sfx(START_SND);
		
		[Embed(source = "../../lib/sounds/slomo_off.mp3")]
		private static const SLOMO_OFF_SND:Class;
		private static var slomoOffSnd:Sfx = new Sfx(SLOMO_OFF_SND);
		
		[Embed(source = "../../lib/sounds/slomo_on.mp3")]
		private static const SLOMO_ON_SND:Class;
		private static var slomoOnSnd:Sfx = new Sfx(SLOMO_ON_SND);
		
		[Embed(source = "../../lib/sounds/bomb_assign.mp3")]
		private static const BOMB_ASS_SND:Class;
		private static var bombAssignSnd:Sfx = new Sfx(BOMB_ASS_SND);
		
		/*[Embed(source = "../../lib/music/game.mp3")]
		private static const MUSIC:Class;
		public static var music:Sfx = new Sfx(MUSIC);*/
		
		public static var i:GameWorld;
		
		public static var firstBallSpeed:Number = 10;
		public static var fieldLeft:Number;
		public static const FIELD_TOTAL:Number = 60;
		
		public static var wave:uint;
		
		public static var sideBar:SideBar;
		public static var pad:Pad;
		public static var pointBar:PointBar;
		public static var actionMenu:ActionMenu;
		public static var fieldBar:FieldBar;
		
		//layers
		public static var pointLayer:Sprite;
		public static var ballGuideLayer:Sprite;
		public static var ballPathLayer:Sprite;
		
		public static var timeFactor:Number = 1;
		public static var move:int = 1;
		public static var paused:Boolean;
		
		public static var scoreTextLabel:Text;
		public static var scoreText:Text;
		public static var score:uint;
		
		public static var soundOn:Boolean = true;
		
		
		public function GameWorld() 
		{
			i = this;
			
			//FP.console.enable();
			
			sideBar = new SideBar();
			pointBar = new PointBar();
			pad = new Pad();
			actionMenu = new ActionMenu();
			fieldBar = new FieldBar();
			
			scoreTextLabel = new Text("Score: ");
			scoreTextLabel.color = 0xDDDDDD;
			scoreTextLabel.smooth = true;
			scoreTextLabel.size = 24;
			scoreTextLabel.x = 5 + SideBar.W;
			
			scoreText = new Text("0");
			scoreText.color = 0xffffff;
			scoreText.smooth = true;
			scoreText.size = 24;
			scoreText.x = scoreTextLabel.x + scoreTextLabel.width;
			
			Main.CURRENT_WORLD = "gameWorld";
		}
		
		public static function addScore(d:int):void
		{
			score = Math.max(0, score + d);
			scoreText.text = String(score);
			scoreText.x = scoreTextLabel.x + scoreTextLabel.width;
		}
		
		public static function getHighScores():Array
		{
			var ar:Array = new Array();
			Data.load("brickadersHighScores");
			for (var i:uint = 0; i < 5; i++)
			{
				ar.push(Data.readUint("score"+int(i+1), 0));
			}
			
			ar = ar.sort(Array.DESCENDING|Array.NUMERIC);
			
			return ar;
		}
		
		public static function submitScore(s:uint):Boolean
		{
			var ar:Array = getHighScores();
			
			var high:Boolean = false;
			
			
			for (var i:uint = 0; i < ar.length; i++)
			{
				if (s > ar[i])
				{
					high = true;
					break;
				}
			}
			
			
			ar.push(s);
			ar = ar.sort(Array.DESCENDING|Array.NUMERIC);
			ar.pop();
			
			
			Data.load("brickadersHighScores");
			for (var j:uint = 0; j < 5; j++)
			{
				Data.writeUint("score" + String(j + 1), ar[j]);
			}
			
			Data.save("brickadersHighScores");
			
			GameOver.gameScore = s;
			
			return high;
		}
		
		override public function begin():void 
		{
			if (GameWorld.soundOn) startSnd.play();
			
			add(sideBar);
			add(pointBar);
			add(pad);
			add(fieldBar);
			
			addGraphic(scoreTextLabel);
			addGraphic(scoreText);
			
			
			score = 0;
			move = 1;
			wave = 1;
			timeFactor = 1;
			paused = false;
			fieldLeft = FIELD_TOTAL;
			
			sideBar.x = -100;
			var sidebarT:MultiVarTween = new MultiVarTween();
			sidebarT.tween(sideBar, { x: 0 }, 0.4, Ease.quintOut);
			
			
			pointBar.y = FP.height;
			var pointbarT:MultiVarTween = new MultiVarTween();
			pointbarT.tween(pointBar, { y: pointBar.nY }, 0.4, Ease.quintOut);
			
			pad.y = FP.height;
			var padT:MultiVarTween = new MultiVarTween();
			padT.tween(pad, { y : pointBar.nY - pad.height }, 0.5, Ease.backOut);
			
			addTween(sidebarT, true);
			sidebarT.complete = function():void { addTween(pointbarT, true); }
			pointbarT.complete = function():void { addTween(padT, true); }
			padT.complete = newGameAnimationComplete;
			
			var bg1:Image = new Image(PLANET_1);
			var randX:Number = FP.rand(FP.width - bg1.width - SideBar.W) + SideBar.W;
			
			addGraphic(bg1, 0, FP.rand(FP.width - bg1.width-SideBar.W)+SideBar.W, -bg1.height);
			var bg1Tween:MultiVarTween = new MultiVarTween();
			bg1Tween.tween(bg1, { x:randX, y: FP.height }, 60*40, null, 10);
			addTween(bg1Tween, true);
			
			fieldBar.y = 10;
			fieldBar.x = FP.halfWidth - fieldBar.img.width / 2 + SideBar.W/2;
			fieldBar.transparency = 0.2;
			
			actionInvoker = new Image(ACTION_INVOKE);
			actionInvoker.x = (FP.width - SideBar.W - actionInvoker.width) / 2 + SideBar.W;
			actionInvoker.y = (PointBar.Y - actionInvoker.height) / 2;
			addGraphic(actionInvoker);
			
			//music.loop();
			
			super.begin();
		}
		
		override public function end():void 
		{
			//music.stop();
			super.end();
		}
		
		
		
		public function newGameAnimationComplete():void
		{
			PointBar.pointLimit = 1;
			PointBar.pointCount = 0;
			
						var ball:Ball = new Ball();
			add(ball); ball.moveTo(200, 200);
			ball.setRadialSpd(10, -Math.PI / 4);
		}
		
		override public function update():void 
		{
			if (!paused)
			{
				spawnBricks();
				spawnBalls();
				if (FP.rand(2000) < 2 && typeCount("ballenemy") < 2 && wave > 9) add(new BallEnemy());
			}
			
			//background stars
			if ( typeCount("bgStar") < 20 && FP.rand(100) < 10 ) create(BackgroundStar, true);
			
			if (Input.mousePressed && !paused)
			{
				if (mouseCollideRect(new Rectangle(actionInvoker.x, actionInvoker.y, actionInvoker.width, actionInvoker.height)))
				{
					actionMenu.show();
				}
			}
			
			//fieldbar
			if (Input.mousePressed && Ball.fieldCheck)
			{
				if (Ball.mouseOnRight || Ball.mouseOnLeft)
				{
					fieldBar.transparency = 1;
				}
			}
			else if (Input.mouseReleased)
			{
				fieldBar.transparency = 0.2;
				fieldBar.fillUp();
			}
			
			if (Ball.fieldCheck)
			{
				if (Ball.mouseOnRight || Ball.mouseOnLeft)
				{
					fieldLeft--;
					fieldBar.inner.scaleX = fieldLeft / FIELD_TOTAL;
				}
			}
			
			if (bombOn)
			{
				if (Input.mousePressed && Input.mouseY < PointBar.Y && Input.mouseX > SideBar.W)
				{
					bombOn = false;
					add(new Bomb(Input.mouseX, -20, Input.mouseX, Input.mouseY));
					if (GameWorld.soundOn) bombAssignSnd.play();
				}
			}
			
			super.update();
		}
		
		public function spawnBalls():void
		{
			if (FP.rand(3000) < 2) if (typeCount("ball") != 0 && typeCount("ball") < 4)
			{
				FP.randomizeSeed();
				var b:Ball = new Ball();
				b.x = FP.rand(FP.width - SideBar.W) + SideBar.W;
				b.y = 0;
				add(b);
				b.setCartesianSpd(0, 9);
				if (soundOn) Brick.getOrbiterSnd.play();
			}
		}
		
		public function spawnBricks():void
		{
			if (typeCount("brick") == 0)
			{
				var b:Brick;
				for (var i:uint = 0; i < Math.ceil(Math.min(20, 0.5*wave+1)); i++)
				{
					b = new Brick();
					add(b).y = -b.height-i * (FP.rand(40) + b.height);
				}
				wave++;
				SideBar.waveText.text = "Wave " + String(wave-1);
				Brick.speedY = 0.4 + (wave * 0.05);
			}
		}
		
		/*private static var prevBrickSpeed:Number;
		public static function doRewind():void
		{
			prevBrickSpeed = Brick.speedY.valueOf();
			Brick.speedY = -4*Math.abs(Brick.speedY);
			var t:MultiVarTween = new MultiVarTween(function():void { Brick.speedY = GameWorld.prevBrickSpeed.valueOf(); } );
			t.tween(GameWorld, { }, 1.2);
			FP.world.addTween(t, true);
			
		}*/
		
		public static function doBulletsFromPad():void
		{
			if (pad != null) for (var i:uint = 0; i < 3; i++)
			{
				FP.world.add(new Bullet(new Point(pad.centerX, pad.y - 5), -(i+1)*Math.PI/4, 8, 3, FP.world));
			}
			if (soundOn) Brick.shootSnd.play();
		}
		
		public static function doUnlockPad():Boolean
		{
			var unlocked:Boolean = false;
			if (pad != null)
			{ 
				if (pad.fixed)
				{
					pad.showFixed = false;
					pointBar.clear();
					if (soundOn) Pad.padUnclockSnd.play();
					unlocked = true;
				}
				else {
					FP.world.add(new ScoreShow(0, FP.halfWidth-30, FP.halfHeight, "Pad already unlocked!"));
				}
			}
			return unlocked;
		}
		
		public static var slomoOnT:MultiVarTween;
		public static var slomoOffT:MultiVarTween;
		public static var slomoOn:Boolean = false;
		
		public static function doSlomo():void
		{
			if (!slomoOn)
			{
				slomoOn = true;
				slomoOnT = new MultiVarTween();
				slomoOnT.tween(GameWorld, { timeFactor:0.2 }, 0.8, Ease.quadOut);
				i.addTween(slomoOnT, true);
				
				slomoOffT = new MultiVarTween(function():void { slomoOn = false;  } );
				slomoOffT.tween(GameWorld, { timeFactor:1 }, 0.8, Ease.quadOut, 5);
				i.addTween(slomoOffT, true);
				
				var offT:MultiVarTween = new MultiVarTween(function():void { if (GameWorld.soundOn) slomoOffSnd.play(); } );
				offT.tween(GameWorld, { }, 5);
				i.addTween(offT, true);
				
				if (soundOn) slomoOnSnd.play();
			}
		}
		
		public static var bombOn:Boolean = false;
		
		public static function doBomb():void
		{
			if (!bombOn)
			{
				bombOn = true;
			}
		}
		
		public static function mouseCollideRect(r:Rectangle):Boolean
		{
			return (Input.mouseX >= r.x && Input.mouseX <= r.x + r.width && Input.mouseY >= r.y && Input.mouseY <= r.y + r.height);
		}
		
		public static function entitiesByType(typ:String, wrld:World):Array
		{
			var arr:Array = new Array();
			wrld.getType(typ, arr);
			return arr;
		}
		
		/*public static function explosion(obj:DisplayObject):Boolean
		{
			var gotBrickOnExplosion:Boolean = false;
			
			new ExplosionParticles(obj.x, obj.y, [0xF3B90A, 0xC71C03], [4, 5]);
			
			return gotBrickOnExplosion;
		}*/
		
		
		public static function pythagoras(x1:Number, y1:Number, x2:Number = 0, y2:Number = 0):Number
		{
			return Math.sqrt( Math.abs(Math.pow(x1-x2, 2)) + Math.abs(Math.pow(y1-y2, 2)) );
		}
		
		public static function pythagorasObj(object1:DisplayObject, object2:DisplayObject):Number
		{
			return pythagoras(object1.x, object1.y, object2.x, object2.y);
		}
		
		public static function del(e:Entity):void
		{
			if (e.world != null) e.world.remove(e);
		}
		
		public static function doGameOver():void
		{
			if (FP.world.typeCount("ball") == 0 && FP.world.typeCount("powerball") == 0)
			{
				var overTween:MultiVarTween = new MultiVarTween(function():void{
				
				submitScore(score);
				FP.world = new GameOver;
				});
				overTween.tween(GameWorld, { }, 1);
				FP.world.addTween(overTween, true);
			}
		}
		
	}

}