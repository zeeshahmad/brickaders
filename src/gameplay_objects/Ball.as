package gameplay_objects {
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameplay_objects.bricks.Brick;
	import gameplay_objects.particles.*;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import worlds.GameWorld;

	
	public class Ball extends Entity {
		
		[Embed(source = "../../lib/ball/target.png")]
		private static const TARGET_PNG:Class;
		
		[Embed(source = "../../lib/sounds/hit_wall.mp3")]
		private static const HIT_WALL_SND:Class;
		private var hitWallSnd:Sfx = new Sfx(HIT_WALL_SND);
		
		[Embed(source = "../../lib/sounds/hit_pad.mp3")]
		private static const HIT_PAD_SND:Class;
		private var hitPadSnd:Sfx = new Sfx(HIT_PAD_SND);
		
		[Embed(source = "../../lib/sounds/ball_destroy.mp3")]
		private static const DESTROY_SND:Class;
		private var destroySnd:Sfx = new Sfx(DESTROY_SND);
		
		[Embed(source = "../../lib/sounds/orbiter_lost.mp3")]
		private static const ORBITER_LOST_SND:Class;
		public static var orbiterLostSnd:Sfx = new Sfx(ORBITER_LOST_SND);
		
		[Embed(source = "../../lib/sounds/power_ball.mp3")]
		private static const POWER_BALL_SND:Class;
		public static var powerSnd:Sfx = new Sfx(POWER_BALL_SND);
		
		public var unstopable:Boolean = false;
		public var shotAngle:Number;
		public var shotSpeed:Number = 5;
		
		public var DIAMETER:Number = 20;
		public var RADIUS:Number = DIAMETER / 2;
		
		public function set SetDIAMETER(value:Number):void
		{
			DIAMETER = value;
			RADIUS = DIAMETER / 2;
		}
		
		private var riseTime:Number;
		
		public var wallTouch:uint = 0;
		
		public var speed:Number = 0;
		public var radians:Number = 0;
		
		public var originalSpeed:Number = 0;
		
		public var speedX:Number = 0;
		public var speedY:Number = 0;
		
		public var pathCount:uint = 0;
		
		public static const POWER_STEPS:uint = 5;
		public var positionsX:Vector.<Number>;
		public var positionsY:Vector.<Number>;
		
		public function Ball() {
			// constructor code
			
			SetDIAMETER = 15;
			
			picture = new BitmapData(DIAMETER, DIAMETER, true, 0);
			Draw.setTarget(picture);
			
			Draw.circlePlus(RADIUS, RADIUS, RADIUS, 0xE3CC2B);
			img = new Image(picture);
			graphic = img;
			
			
			setHitbox(DIAMETER, DIAMETER, 0, 0);
			
			type = "ball";
			
			
		}
		
		public function clone():Ball
		{
			var cl:Ball = new Ball();
			cl.speedX = this.speedX.valueOf();
			cl.speedY = this.speedY.valueOf();
			cl.x = this.x.valueOf();
			cl.y = this.y.valueOf();
			cl.speed = this.speed.valueOf();
			cl.radians = radians.valueOf();
			return cl;
		}
		
		private var img:Image;
		private var picture:BitmapData;
		
		
		
		public static function fixAngle(a:Number):Number
		{
			var r:Number = a;
			while (r < -Math.PI) r += 2*Math.PI;
			while (r > Math.PI) r -= 2*Math.PI;
			
			return r;
		}
		
		public function setRadialSpd(sp:Number, direct:Number):Ball
		{
			speed = sp;
			//radians = fixAngle(direct);
			radians = direct;
			
			speedX = speed * Math.cos(radians);
			speedY = speed * Math.sin(radians);
			
			return this;
		}
		
		public function setCartesianSpd(sx:Number, sy:Number):Ball
		{
			speedX = sx;
			speedY = sy;
			
			radians = Math.atan2(speedY, speedX);
			speed = Math.sqrt(speedX * speedX + speedY * speedY);
			if (reverseTween.active) reverseSpd = speed.valueOf();
			
			return this;
		}
		
		public function bounceRight():void { setCartesianSpd( Math.abs(speedX), speedY ); }
		public function bounceLeft():void { setCartesianSpd( -Math.abs(speedX), speedY );}
		public function bounceUp():void { setCartesianSpd(speedX, -Math.abs(speedY) );  }
		public function bounceDown():void { setCartesianSpd(speedX, Math.abs(speedY) ); }
		
		
		
		public function predictCollisionCoords():void
		{
			var cl:Ball = clone();
			
			cl.unstopable = true;
			cl.moveFunction = function(ins:Ball):void
			{
				this.x += (ins.speedX) * GameWorld.timeFactor;
				this.y += (ins.speedY) * GameWorld.timeFactor;
			}
			
		}
		
		public function predictLandX():Number
		{
			return ((GameWorld.pad.y - this.y) / Math.tan(radians)) + this.x;
		}
		
		public function clearWallTouch():void
		{
			wallTouch = 0;
		}
		
		public function onAnyCollision():void
		{
			
		}
		
		public var moveFunction:Function = function(ins:Ball):void
		{
			this.x += (ins.speedX) * GameWorld.timeFactor * GameWorld.move * FP.rate;
			this.y += (ins.speedY) * GameWorld.timeFactor * GameWorld.move * FP.rate;
		}
		
		public function shootBullet():void
		{
			shotAngle = Math.atan2(Input.mouseY - y - halfHeight, Input.mouseX - x - halfWidth);
			new Bullet(new Point(x+halfWidth, y+halfHeight), shotAngle, shotSpeed, 2, world);
			if (GameWorld.soundOn) Brick.shootSnd.play();
			//setCartesianSpd(speedX - (shotSpeed / 4) * Math.cos(shotAngle), speedY - (shotSpeed / 4) * Math.sin(shotAngle));
			setRadialSpd(speed, shotAngle + Math.PI );
			
			
		}
		
		public static function get mouseOnRight():Boolean
		{
			return Input.mouseX > SideBar.W + (FP.width - SideBar.W) * 0.75;
		}
		
		public static function get mouseOnLeft():Boolean
		{
			return Input.mouseX > SideBar.W && Input.mouseX < (FP.width - SideBar.W) * 0.25 + SideBar.W;
		}
		
		public function dirTendToVertical(left:Boolean):void
		{
			setRadialSpd(speed, fixAngle(radians));
			if (radians > 0)
			{
				if (left && radians < Math.PI - Math.PI/8) setRadialSpd(speed, radians + Math.PI / 60);
				else if (!left && radians > Math.PI/8) setRadialSpd(speed, radians - Math.PI / 60);
			}
			else if (radians < 0)
			{
				if (left && radians > -Math.PI + Math.PI / 8) setRadialSpd(speed, radians - Math.PI / 60);
				else if (!left && radians < -Math.PI/8) setRadialSpd(speed, radians + Math.PI / 60);
			}
		}
		
		public var collideOnce:Boolean = false;
		
		override public function update():void 
		{
			moveFunction.apply(this, [this]);
			
			if (fieldCheck)
			{
				if (mouseOnRight)
				{
					//setCartesianSpd(Math.min(speedX + 0.3, 9), speedY);
					dirTendToVertical(false);
				}
				else if (mouseOnLeft)
				{
					//setCartesianSpd(Math.max(speedX - 0.3, -9), speedY);
					dirTendToVertical(true);
				}
			}
			
			if (!reverseTween.active)
			{
				//horizontal collision
				if (collide("sidebar", x, y))//left wall
				{
					bounceRight();
					//GameWorld.resetCombo();
					if (GameWorld.soundOn) hitWallSnd.play();
					
					clearWallTouch();
					onAnyCollision();
					
				}
				else if (this.x + this.width > FP.width)//right wall
				{
					bounceLeft();
					if (GameWorld.soundOn) hitWallSnd.play();
					
					clearWallTouch();
					onAnyCollision();
				}
				
				//vertical collision
				if (this.y < 0)//upper wall
				{
					bounceDown();
					if (GameWorld.soundOn) hitWallSnd.play();
					
					clearWallTouch();
					onAnyCollision();
				}
				else if (collide("pad", x, y) && !collideOnce)
				//&&this.x > GameWorld.pad.x && this.x < GameWorld.pad.x + GameWorld.pad.width)//pad
				{
					collideOnce = true;
					if (GameWorld.soundOn) hitPadSnd.play();
					
					FP.randomizeSeed();
					
					/*if (!GameWorld.pad.fixed && FP.rand(7) == 0 && speedY > 0 && world !=null)
					{
						var newball:Ball = new Ball();
						newball.x  = x; newball.y = y;
						newball.setCartesianSpd( -speedX, -Math.abs(speedY));
						world.add(newball);
					}*/
					
					bounceUp();
					
					GameWorld.pad.showFixed = false;
					collide("pad", x, y).y = GameWorld.pointBar.nY - GameWorld.pad.height + 2;
					
					var recoilTween:MultiVarTween = new MultiVarTween();
					recoilTween.tween(GameWorld.pad, { y: GameWorld.pointBar.nY - GameWorld.pad.height }, 0.2);
					addTween(recoilTween, true);
					
					GameWorld.pointBar.clear();
					
					onAnyCollision();
					
					
					if (GameWorld.pad.moveTween != null && GameWorld.pad.moveTween.active) {
						setCartesianSpd(speedX + GameWorld.pad.dir * 0.4, speedY);
						if (GameWorld.pad.moveTween.percent > 0.75)
						{
							GameWorld.addScore(4);
							if (world != null) world.add(new ScoreShow(4, x, PointBar.Y - 40, "Last Minute Catch!"));
							if (GameWorld.soundOn) Brick.bonusSnd.play();
						}
					}
					
					
				}
				else if (bottom > FP.height && !collideBottom)//lower boundry
				{
					bounceUp();
					collideBottom = true;
					
					var orbiters:Array = new Array();
					FP.world.getType("orbiter", orbiters);
					
					
					
					var orbCount:uint = 0;
					for (var or2:uint = 0; or2 < orbiters.length; or2++)
					{
						if ((orbiters[or2] as Orbiter).b == this)
						{
							orbCount++;
							break;
						}
					}
					
					onAnyCollision();
					
					if (orbCount == 0) {
						destroy();
					} else {
						removeOrbiters();
					}
					
					if (GameWorld.i.typeCount("ball") == 0)
					{
						GameWorld.doGameOver();
					}
					
					
				}
				else if (!collide("pad", x, y)) collideOnce = false;
				if (bottom < FP.height) collideBottom = false;
			}
			else if (reverseTween.active)
			 setRadialSpd(reverseSpd, radians);
			
			
			if (powerOn)
			{
				if (positionsX != null && positionsY != null)
				{
					positionsX.push(x);
					positionsY.push(y);
				}
				
				if (powerTween!=null)
				 powerTween.active = (int(GameWorld.move) != 0);
			}
			
			
			super.update();
		}
		
		public var collideBottom:Boolean = false;
		
		public function removeOrbiters(brk:Boolean = true):void
		{
			var orbiters:Array = GameWorld.entitiesByType("orbiter", world);
			
			for (var or:uint = 0; or < orbiters.length; or++)
			{
				if ((orbiters[or] as Orbiter).b == this)
				{
					GameWorld.del(orbiters[or] as Orbiter);
					if (brk) break;
				}
			}
			
			if (brk && GameWorld.soundOn) orbiterLostSnd.play();
		}
		
		override public function render():void 
		{
			if (powerOn)
			{
				for (var i:int = 0; i < POWER_STEPS; i++) {
					img.alpha = i / POWER_STEPS;
					if (positionsX != null && positionsY != null) 
					Draw.graphic(graphic, positionsX[i], positionsY[i]);
				}
				
				positionsX.shift();
				positionsY.shift();
			}
			super.render();
		}
		
		
		
		public var reverseTween:MultiVarTween = new MultiVarTween();;
		public var reverseSpd:Number;
		public var reverseOn:Boolean = false;
		
		public function doReverse():void
		{
			reverseSpd = speed.valueOf();
			img.color = 0xC0C918;
			
			reverseTween = new MultiVarTween(onReverseComplete);
			reverseTween.tween(this, { reverseSpd: Number(-reverseSpd).valueOf() }, 0.5, Ease.cubeInOut);
			addTween(reverseTween, true);
			reverseOn = true;
			
		}
		
		public function onReverseComplete():void
		{
			reverseOn = false;
			img.color = 0xffffff;
		}
		
		
		public static var powerOn:Boolean = false;
		public var powerTween:MultiVarTween;
		public var powerInitSpd:Number;
		
		public function resetPositionsForPower():void
		{
			positionsX = new Vector.<Number>;
			positionsY = new Vector.<Number>;
			//for power ball
			for (var k:int = 0; k < POWER_STEPS; k++) {
                positionsX.push(x);
                positionsY.push(y);
            }
		}
		
		public static function doPower():void
		{
			if (!powerOn) 
			{
				var ar:Array = GameWorld.entitiesByType("ball", FP.world);
				if (GameWorld.soundOn) powerSnd.play();
				
				for (var i:uint = 0; i < ar.length; i++)
				{
					(ar[i] as Ball).resetPositionsForPower();
					ar[i].powerTween = new MultiVarTween(ar[i].powerEnd);
					ar[i].powerTween.tween(ar[i], { }, 9);
					ar[i].addTween(ar[i].powerTween, true);
					ar[i].img.color = 0x0DDD51;
					ar[i].powerInitSpd = ar[i].speed.valueOf();
					ar[i].setRadialSpd(ar[i].speed + 2, ar[i].radians);
				}
				powerOn = true;
			}
		}
		
		public function powerEnd():void
		{
			
			img.color = 0xffffff;
			setRadialSpd(powerInitSpd, radians);
			powerOn = false;
		}
		
		public function destroy():void
		{		
			setRadialSpd(0.5 * speed, radians);
			collidable = false;
			type = "exploding ball";
			if (GameWorld.soundOn) destroySnd.play();
			
			//explosion
			var l:Number = 4;
			
			var tPart:Image;
			
			img.visible = false;
			picture.colorTransform(new Rectangle(0, 0, RADIUS * 2, RADIUS * 2), new ColorTransform(1, 0, 0));
			
			var particleTween:MultiVarTween;
			
			for (var i:uint = 0; i < Math.ceil(width / l); i++)
			{
				for (var j:uint = 0; j < Math.ceil(height / l); j++)
				{
					tPart = new Image(picture, new Rectangle(i * l, j * l, l, l));
					//tPart.scale = 0.5;
					tPart.x = i * l;
					tPart.y = j * l;
					
					addGraphic(tPart);
					
					particleTween = new MultiVarTween(removeThis);
					particleTween.tween(tPart, { x: tPart.x + FP.rand(100) - 50, y: tPart.y + FP.rand(100) - 50, scale:0 }, 1, Ease.quadOut);
					addTween(particleTween);
				}
			}
			setHitbox();
		}
		
		private function removeThis():void
		{
			if (this.world != null) this.world.remove(this);
			
			
		}
		
		public static function get fieldCheck():Boolean
		{
			return Input.mouseDown && Input.mouseY < PointBar.Y && GameWorld.fieldLeft > 0 && !ActionMenu.active && !GameWorld.paused;
		}
		
	}
	
}
