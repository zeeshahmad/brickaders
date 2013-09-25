package gameplay_objects {
	
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameplay_objects.particles.*;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import worlds.GameWorld;

	
	public class Ball extends Entity {
		
		[Embed(source = "../../lib/ball/target.png")]
		private static const TARGET_PNG:Class;
		
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
		public var positionsX:Vector.<Number> = new Vector.<Number>;
		public var positionsY:Vector.<Number> = new Vector.<Number>;
		
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
			
			var stealthRingBmp:BitmapData = new BitmapData(DIAMETER + 6, DIAMETER + 6, true, 0);
			Draw.setTarget(stealthRingBmp);
			Draw.circle(RADIUS+3, RADIUS+3, RADIUS + 3, 0x1D6CBC);
			stealthRing = new Image(stealthRingBmp);
			stealthRing.x = -3; stealthRing.y = -3;
			addGraphic(stealthRing);
			stealthRing.visible = false;
			
			//for power ball
			for (var i:int = 0; i < POWER_STEPS; i++) {
                positionsX.push(x);
                positionsY.push(y);
            }
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
		public function bounceDown():void { setCartesianSpd(speedX, Math.abs(speedY) ); 
		new CollisionAngleDisplay(x, y, 1, radians * 180 / Math.PI); }
		
		
		
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
			
			//setCartesianSpd(speedX - (shotSpeed / 4) * Math.cos(shotAngle), speedY - (shotSpeed / 4) * Math.sin(shotAngle));
			setRadialSpd(speed, shotAngle + Math.PI );
			
			trace("ball speed:" + speed);
			
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
			trace(radians * 180 / Math.PI);
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
		
		override public function update():void 
		{
			//if (FP.rand(300) < 2) doStealth();
			
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
					
					clearWallTouch();
					onAnyCollision();
					
				}
				else if (this.x + this.width > FP.width)//right wall
				{
					bounceLeft();
					//GameWorld.resetCombo();
					
					clearWallTouch();
					onAnyCollision();
				}
				
				//vertical collision
				if (this.y < 0)//upper wall
				{
					bounceDown();
					
					clearWallTouch();
					onAnyCollision();
				}
				else if (this.y + this.height > GameWorld.pad.y && (collide("pad", x, y)))
				//&&this.x > GameWorld.pad.x && this.x < GameWorld.pad.x + GameWorld.pad.width)//pad
				{
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
					}
					
				}
				else if (this.y + this.height > 480)//lower boundry
				{
					bounceUp();
					
					
					var orbiters:Array = GameWorld.entitiesByType("orbiter", world);
					
					for (var or:uint = 0; or < orbiters.length; or++)
					{
						if ((orbiters[or] as Orbiter).b == this)
						{
							GameWorld.del(orbiters[or] as Orbiter);
							break;
						}
					}
					
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
					
					if (orbCount == 0) destroy();
					
					if (GameWorld.i.typeCount("ball") == 0 && GameWorld.i.typeCount("stealthball") ==0)
					trace("no ball left");//TODO loose due to no ball left
					
				}
			}
			else if (reverseTween.active)
			 setRadialSpd(reverseSpd, radians);
			
			
			if (stealthOn)
			{
				if (stealthOffTween!=null)
				 stealthOffTween.active = (int(GameWorld.move) != 0);
			}
			else if (powerOn)
			{
				positionsX.push(x);
				positionsY.push(y);
				
				if (powerTween!=null)
				 powerTween.active = (int(GameWorld.move) != 0);
			}
			
			if (targetOn)
			{
				if (Input.mousePressed && Input.mouseY < 480 - GameWorld.pointBar.height && Input.mouseX > SideBar.W)
				{
					targetEntity.x = Input.mouseX - Image(targetEntity.graphic).width / 2;
					targetEntity.y = Input.mouseY - Image(targetEntity.graphic).height / 2;
					if (world != null) world.add(targetEntity);
					targetOn = false;
					shootBullet();
					
					var targetRemoveTween:MultiVarTween = new MultiVarTween(function():void {
						if (targetEntity.world != null) targetEntity.world.remove(targetEntity);
					});
					targetRemoveTween.tween(Image(targetEntity.graphic), { alpha: 0 }, 0.4, null, 3);
					addTween(targetRemoveTween, true);
				}
			}
			
			
			super.update();
		}
		
		override public function render():void 
		{
			if (powerOn)
			{
				for (var i:int = 0; i < POWER_STEPS; i++) {
					img.alpha = i / POWER_STEPS;
					Draw.graphic(graphic, positionsX[i], positionsY[i]);
				}
				
				positionsX.shift();
				positionsY.shift();
			}
			super.render();
		}
		
		public var stealthOn:Boolean = false;
		public var stealthRing:Image;
		public var stealthOffTween:MultiVarTween;
		
		public function doStealth():void
		{
			if (!stealthOn && !powerOn)
			{
				stealthOn = true;
				stealthRing.visible = true;
				
				img.color = 0x1D6CBC;
				var stealthOnTween:MultiVarTween = new MultiVarTween();
				stealthOnTween.tween(img, { alpha: 0.2 }, 0.5);
				addTween(stealthOnTween, true);
				
				
				stealthOffTween = new MultiVarTween(onStealthComplete);
				stealthOffTween.tween(img, { alpha: 1 }, 0.5, null, 1);
				addTween(stealthOffTween, true);
				type = "stealthball";
			}
		}
		
		
		public function onStealthComplete():void
		{
			img.color = 0xffffff;
			
			stealthRing.visible = false;
			stealthOn = false;
			type = "ball";
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
		
		
		public static var targetOn:Boolean = false;
		public var targetEntity:Entity;
		
		public function doTarget():void
		{
			if (!targetOn)
			{
				targetOn = true;
				targetEntity = new Entity(0, 0, new Image(TARGET_PNG));
				targetEntity.type = "targetEntity";
				targetEntity.setHitbox(Image(targetEntity.graphic).width, Image(targetEntity.graphic).height);
				//targetEntity.setOrigin(Image(targetEntity.graphic).width / 2, Image(targetEntity.graphic).height / 2);
			}
		}
		
		public var powerOn:Boolean = false;
		public var powerTween:MultiVarTween;
		public var powerInitSpd:Number;
		
		public function doPower():void
		{
			if (!powerOn && !stealthOn)
			{
				
				powerOn = true;
				powerTween = new MultiVarTween(powerEnd);
				powerTween.tween(this, { }, 9);
				addTween(powerTween, true);
				img.color = 0x0DDD51;
				powerInitSpd = speed.valueOf();
				setRadialSpd(speed + 2, radians);
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
			collidable = false;
			type = "exploding brick";
			
			//explosion
			var l:Number = 4;
			
			var tPart:Image;
			
			img.visible = false;
			
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
					particleTween.tween(tPart, { x: tPart.x + FP.rand(100) - 50, y: tPart.y + FP.rand(100) - 50, scale:0 }, 0.8, Ease.quadOut);
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
			return Input.mouseDown && Input.mouseY < PointBar.Y && GameWorld.fieldLeft > 0 && !ActionMenu.active;
		}
		
	}
	
}
