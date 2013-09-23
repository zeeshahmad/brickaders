package gameplay_objects {
	
	import com.greensock.core.TweenCore;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import gameplay_objects.particles.*;
	import gameplay_objects.special.Flux;
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
		
		private static const explosive_glow_filter:GlowFilter = new GlowFilter(0xB31200, 1, 5, 5, 2, 1, true);
		private static const power_glow_filter:GlowFilter = new GlowFilter(0x15F020, 1, 5, 5, 2, 1, true);
		private static const freeze_glow_filter:GlowFilter = new GlowFilter(0x66A6C1, 1, 10, 10, 2, 1, true);
		private var magnetFlux:Flux;
		
		public static const NORMAL_TYPE:String = "Normal_TYPE";
		public static const EXPLOSION_TYPE:String = "EXPLOSION_TYPE";
		public static const FREEZE_TYPE:String = "FREEZE_TYPE";
		public static const MAGNET_TYPE:String = "MAGNET_TYPE";
		public static const POWER_TYPE:String = "POWER_TYPE";
		
		public static const PATH_PREDICT:String = "PATH_PREDICT";
		
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
		
		public var speedIndicator:Sprite;
		public var speedIndicatorTween:TweenLite;
		
		public var typeTween:TweenCore;
		public var expireTimer:TweenCore;
		
		public var pathCount:uint = 0;
		
		public function Ball() {
			// constructor code
			TweenPlugin.activate([BlurFilterPlugin, GlowFilterPlugin]);
			
			SetDIAMETER = 15;
			
			changeType(NORMAL_TYPE);
			
			
			
			setHitbox(DIAMETER, DIAMETER, 0, 0);
			
			type = "ball";
			
			
			var stealthRingBmp:BitmapData = new BitmapData(DIAMETER + 6, DIAMETER + 6, true, 0);
			Draw.setTarget(stealthRingBmp);
			Draw.circle(RADIUS+3, RADIUS+3, RADIUS + 3, 0x1D6CBC);
			stealthRing = new Image(stealthRingBmp);
			stealthRing.x = -3; stealthRing.y = -3;
			addGraphic(stealthRing);
			stealthRing.visible = false;
		}
		
		public function clone(newType:String):Ball
		{
			var cl:Ball = new Ball();
			cl.speedX = this.speedX.valueOf();
			cl.speedY = this.speedY.valueOf();
			cl.x = this.x.valueOf();
			cl.y = this.y.valueOf();
			cl.speed = this.speed.valueOf();
			cl.radians = radians.valueOf();
			cl.CURRENT_TYPE = newType;
			return cl;
		}
		
		private static var indicatorDrawFactor:uint = 4;
		public function drawSpeedIndicator():Sprite
		{
			speedIndicator = new Sprite();
			speedIndicator.graphics.beginFill(0x2F86DD);
			speedIndicator.graphics.drawCircle(speed * indicatorDrawFactor, 0, 4);
			speedIndicator.graphics.endFill();
			speedIndicator.graphics.lineStyle(3, 0x2F86DD, 1, false, "normal", CapsStyle.ROUND);
			speedIndicator.graphics.moveTo(0, 0);
			speedIndicator.graphics.lineTo(speed * indicatorDrawFactor, 0);
			speedIndicator.graphics.lineStyle();
			
			speedIndicator.scaleX = 0;
			speedIndicator.scaleY = 0;
			speedIndicator.x = x;
			speedIndicator.y = y;
			
			speedIndicator.rotation = radians * 180 / Math.PI;
			
			GameWorld.ballGuideLayer.addChild(speedIndicator);
			
			speedIndicatorTween = 
			TweenLite.to(speedIndicator, 0.4, { scaleX:1, scaleY:1, ease: Back.easeOut,
			onReverseComplete: Main.remove, onReverseCompleteParams: [speedIndicator] } );
			return speedIndicator;
		}
		
		private var img:Image;
		
		public function changeType(type:String = NORMAL_TYPE, redraw:Boolean = false):void
		{
			refreshEffects();
			var c:uint;
			
			switch (type)
			{
				case NORMAL_TYPE:
					
					c = 0xB7B7B7;
					break;
					
				case EXPLOSION_TYPE:
					
					c = 0xC11300;
					break;
					
				case FREEZE_TYPE:
					
					c = 0xB8D3D2;
					break;
					
				case MAGNET_TYPE:
					
					c = 0xBE5421;
					break;
					
				case POWER_TYPE:
					
					c = 0x21E60B;
					break;
				
			}
			
			var picture:BitmapData = new BitmapData(DIAMETER, DIAMETER, true, 0);
			Draw.setTarget(picture);
			Draw.circlePlus(RADIUS, RADIUS, RADIUS, c);
			img = new Image(picture);
			graphic = img;
			
			CURRENT_TYPE = type;
			
			if (type != NORMAL_TYPE && !redraw)
			{
				setTimerToNormal(30);
			}
		}
		
		public var CURRENT_TYPE:String = NORMAL_TYPE;
		
		private function setTimerToNormal(time:Number):void
		{
			expireTimer = TweenLite.to(Ball, time, { onComplete: changeType, onCompleteParams: [NORMAL_TYPE] } );
			//new ExplosionParticles(this.x, this.y, [0x18BFCD, 0x2C69A7], [3, 4], 30, 140);
		}
		
		private function refreshEffects():void
		{
			/*this.filters = [];
			if (typeTween != null) { typeTween.vars = { }; typeTween.kill(); }
			if (expireTimer != null) { expireTimer.vars = { }; expireTimer.kill(); }
			
			if (magnetFlux != null) { magnetFlux.remove(); magnetFlux == null; }
			
			this.graphics.clear();
			this.graphics.lineStyle();
			if (originalSpeed != 0) setRadialSpd(originalSpeed, radians);*/
		}
		
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
		
		public function bounceRight():void { setCartesianSpd( Math.abs(speedX), speedY ); explode(); }
		public function bounceLeft():void { setCartesianSpd( -Math.abs(speedX), speedY ); explode(); }
		public function bounceUp():void { setCartesianSpd(speedX, -Math.abs(speedY) ); explode(); }
		public function bounceDown():void { setCartesianSpd(speedX, Math.abs(speedY) ); explode(); 
		new CollisionAngleDisplay(x, y, 1, radians * 180 / Math.PI); }
		
		public function explode():void 
		{ 
			if (CURRENT_TYPE == EXPLOSION_TYPE) 
			{ 
				//GameWorld.explosion(this); 
			} 
		}
		
		
		public function predictCollisionCoords():void
		{
			var cl:Ball = clone(PATH_PREDICT);
			
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
		
		
		override public function update():void 
		{
			//if (FP.rand(300) < 2) doStealth();
			
			moveFunction.apply(this, [this]);
			
			if (Input.mouseDown && Input.mouseY < PointBar.Y && !ActionMenu.active)
			{
				if (Input.mouseX > SideBar.W + (FP.width - SideBar.W) * 0.75)
				{
					setCartesianSpd(Math.min(speedX + 0.4, 11), speedY);
				}
				else if (Input.mouseX > SideBar.W && Input.mouseX < (FP.width - SideBar.W) * 0.25 + SideBar.W)
				{
					setCartesianSpd(Math.max(speedX - 0.4, -11), speedY);
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
						setCartesianSpd(speedX + GameWorld.pad.dir*0.4, speedY);
					}
					
				}
				else if (this.y + this.height > 480)//lower boundry
				{
					bounceUp();
					
					//TODO reduceHealth
					onAnyCollision();
					if (CURRENT_TYPE != PATH_PREDICT) 
					new ExplosionParticles(this.x, this.y, [0xDF4402, 0xA4AC0B, 0x256696, 0x0E4F02], [3, 4, 5], 20, 200);
				}
			}
			else if (reverseTween.active)
			//if (collideRect(x, y, SideBar.W + width, height, FP.width - SideBar.W - 2*width, PointBar.Y - 2*height))
			 setRadialSpd(reverseSpd, radians);
			
			
			if (stealthOn)
			{
				if (stealthOffTween!=null)
				 stealthOffTween.active = (int(GameWorld.move) != 0);
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
		
		public var stealthOn:Boolean = false;
		public var stealthRing:Image;
		public var stealthOffTween:MultiVarTween;
		
		public function doStealth():void
		{
			if (!stealthOn)
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
		
	}
	
}
