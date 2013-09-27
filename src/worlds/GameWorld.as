package worlds 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import gameplay_objects.ActionMenu;
	import gameplay_objects.Ball;
	import gameplay_objects.BallEnemy;
	import gameplay_objects.bricks.Brick;
	import gameplay_objects.FieldBar;
	import gameplay_objects.Pad;
	import gameplay_objects.particles.BackgroundStar;
	import gameplay_objects.particles.ExplosionParticles;
	import gameplay_objects.PointBar;
	import gameplay_objects.SideBar;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
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
		public static var move:uint = 1;
		public static var paused:Boolean;
		
		public static var scoreTextLabel:Text;
		public static var scoreText:Text;
		public static var score:uint;
		
		
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
			ar.sort(Array.NUMERIC);
			
			return ar;
		}
		
		public static function submitScore(s:uint):Boolean
		{
			var ar:Array = getHighScores();
			
			var high:Boolean = false;
			
			var replaceInd:uint;
			
			for (var i:uint = 0; i < ar.length; i++)
			{
				if (s > ar[i])
				{
					high = true;
					replaceInd = i;
					break;
				}
			}
			
			if (high)
			{
				Data.load("brickadersHighScores");
				Data.writeUint("score" + String(replaceInd + 1), s);
				Data.save("brickadersHighScores");
			}
			
			return high;
		}
		
		override public function begin():void 
		{
			add(sideBar);
			add(pointBar);
			add(pad);
			add(fieldBar);
			
			addGraphic(scoreTextLabel);
			addGraphic(scoreText);
			
			score = 0;
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
			
			super.begin();
		}
		
		
		
		public function newGameAnimationComplete():void
		{
			PointBar.pointLimit = 1;
			PointBar.pointCount = 0;
			
			
			//PointBar.firstBall = new Ball();
			var ball:Ball = new Ball();
			add(ball); ball.moveTo(200, 200);
			ball.setRadialSpd(12, -Math.PI / 4);
			
		}
		
		override public function update():void 
		{
			spawnBricks();
			
			if (FP.rand(800) < 2 && typeCount("ballenemy") < 2 && wave > 9) add(new BallEnemy());
			
			//background stars
			if ( typeCount("bgStar") < 20 && FP.rand(100) < 10 ) create(BackgroundStar, true);
			
			if (Input.mousePressed && !Ball.targetOn)
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
			
			super.update();
		}
		
		
		public function spawnBricks():void
		{
			if (typeCount("brick") == 0)
			{
				var b:Brick;
				for (var i:uint = 0; i < Math.ceil(Math.min(20, 0.5*wave+1)); i++)
				{
					b = new Brick();
					add(b).y = -b.height-i * (FP.rand(20) + 25);
				}
				wave++;
				SideBar.waveText.text = "Wave " + String(wave-1);
				Brick.speedY = 0.5 + (wave * 0.4);
			}
		}
		
		public function stopPlayerInput():void
		{
			
			TweenLite.to(GameWorld, 0.5, { move: 1, onStart:function():void {
				//when every thing finally gets going
				for each (var b:Ball in entitiesByType("ball", this))
				{
					if (b.speedIndicatorTween != null) b.speedIndicatorTween.reverse();
				}
			}});
			
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
				slomoOnT.tween(GameWorld, { timeFactor:0.2 }, 0.7, Ease.quadOut);
				i.addTween(slomoOnT, true);
				
				slomoOffT = new MultiVarTween(function():void { slomoOn = false; } );
				slomoOffT.tween(GameWorld, {timeFactor:1},0.7, Ease.quadOut, 5);
				i.addTween(slomoOffT, true);
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
		
		public static function explosion(obj:DisplayObject):Boolean
		{
			var gotBrickOnExplosion:Boolean = false;
			
			new ExplosionParticles(obj.x, obj.y, [0xF3B90A, 0xC71C03], [4, 5]);
			
			return gotBrickOnExplosion;
		}
		
		
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
			//TODO game over screen
		}
		
	}

}