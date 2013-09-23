package gameplay_objects.bricks 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameplay_objects.Ball;
	import gameplay_objects.Bullet;
	import gameplay_objects.Pad;
	import gameplay_objects.SideBar;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class Brick extends Entity 
	{
		public var speedX:Number = 0;
		public var speedY:Number = 0;
		public var dodgeX:Number = 0;
		public var dodgeAmount:Number = 0;
		public var enableDodge:Boolean = true;
		
		private var speedChangeType:int;
		
		public var pointsEarned:uint;
		
		
		[Embed(source = "../../../lib/bricks/invader1.png")]
		private static const INVADER_1:Class;
		
		[Embed(source = "../../../lib/bricks/invader2.png")]
		private static const INVADER_2:Class;
		
		[Embed(source = "../../../lib/bricks/invader3.png")]
		private static const INVADER_3:Class;
		
		[Embed(source = "../../../lib/bricks/invader4.png")]
		private static const INVADER_4:Class;
		
		[Embed(source = "../../../lib/bricks/invader-bonus.png")]
		private static const INVADER_BONUS:Class;
		
		[Embed(source = "../../../lib/bricks/gun.png")]
		private static const GUN_IMG:Class;
		
		[Embed(source = "../../../lib/bricks/exhaust.png")]
		private static const EXHAUST_IMG:Class;
		
		[Embed(source = "../../../lib/bricks/shield-icon.png")]
		private static const SHIELD_IMG:Class;
		
		private var gun:Image = new Image(GUN_IMG);
		private var exhaustRight:Image = new Image(EXHAUST_IMG);
		private var shieldIcon:Image = new Image(SHIELD_IMG);
		
		public var heightAngle:Number;
		
		private var img:Image;
		private var imgClass:Class;
		
		public var shield:Image;
		
		public function Brick() 
		{
			var rand:Number = Math.random();
			
			if (rand * 3 < 1) speedChangeType = -1;
			else if (rand * 3 < 2) speedChangeType = 0;
			else speedChangeType = 1;
			gun.originX = gun.width/2;
			gun.originY = 5;
			
			var rLim:Number;
			if (GameWorld.wave < 6) rLim = 39;
			else if (GameWorld.wave < 20) rLim = 69;
			else if (GameWorld.wave < 40) rLim = 74;
			else rLim = 77;
			
			var r:Number = FP.rand(rLim);
			
			if (r < 40) {
				img = new Image(INVADER_1);
				imgClass = INVADER_1;
				enableDodge = false;
			}
			else if (r < 60) {
				img = new Image(INVADER_2);
				imgClass = INVADER_2;
				dodgeAmount = 1;
			}
			else if (r < 70) {
				img = new Image(INVADER_3);
				imgClass = INVADER_3;
				dodgeAmount = 1.25;
			}
			else if (r < 75) {
				img = new Image(INVADER_4);
				imgClass = INVADER_4;
				dodgeAmount = 1.6;
			}
			else if (r < 78) {
				img = new Image(INVADER_BONUS);
				imgClass = INVADER_BONUS;
				dodgeAmount = 1.9;
			}
			
			img.smooth = true;
			//img.scale = 0.8;
			
			var shieldBD:BitmapData = new BitmapData(img.width, 2, false, 0xE2E2E2);
			shield = new Image(shieldBD);
			
			graphic = new Graphiclist(shield, gun, img);
			setHitbox(img.scaledWidth, img.scaledHeight);
			heightAngle = Math.atan2(height, width);
			
			type = "brick";
			
			x = FP.rand(FP.width - int(SideBar.W) - width) + SideBar.W;
			y = - height;
			
			addGraphic(exhaustRight).visible = false;
			exhaustRight.y = halfHeight - exhaustRight.height / 2;
			
			gun.x = halfWidth; gun.y = 0;
			gun.visible = false;
			
			shield.y = height - shield.height;
		}
		
		
		override public function added():void 
		{
			speedY = 0.5;
			super.added();
		}
		
		override public function update():void 
		{
			x += (speedX + dodgeX) * GameWorld.move * FP.rate;
			y += speedY * GameWorld.move * FP.rate;
			
			
			for each (var i:Entity in GameWorld.entitiesByType("ball", world))
			{
				if (i.distanceFrom(this, true) < 50) 
				{
					if (enableDodge) 
					{
						if (i.centerX > centerX)
						{
							dodgeX = -dodgeAmount;
							exhaustRight.x = width;
							exhaustRight.flipped = false;
							exhaustRight.visible = true;
						}
						else {
							dodgeX = +dodgeAmount;
							exhaustRight.x = -exhaustRight.width;
							exhaustRight.flipped = true;
							exhaustRight.visible = true;
						}
					}
					
					if (defending && i.collideRect(i.x, i.y, x + shield.x, y + shield.y, shield.width, shield.height))
					{
						if (centerY < i.y && (i as Ball).speedY < 0) (i as Ball).bounceDown();
					}
					else if (collide("ball", x, y)) onBallCollision(collide("ball", x, y));
				}
				else {
					dodgeX = 0;
					exhaustRight.visible = false;
				}
			}
			
			if (collide("pad", x, y))
			{
				if ((collide("pad", x, y) as Pad).moveTween.active)
				{
					destroy();
				}
				else 
				{
					trace("brick hit pad");
				}
			}
			
			if (collidable && Math.round(GameWorld.move) == 1)
			{
				if (FP.rand(6000) < 2) {
					defend();
				} else if (FP.rand(3000) < 2) {
					fireGun();
				}
			}
			
			super.update();
		}
		
		//collision test in ball class
		public function onBallCollision(ball:Entity):void
		{
			if (!(ball as Ball).reverseOn)
			{
				var angle:Number = Math.atan2(ball.y + ball.halfHeight - y - halfHeight, ball.x + ball.halfWidth - x - halfWidth);
				if (angle > -Math.PI + heightAngle && angle < - heightAngle) //top wall
				{
					(ball as Ball).bounceUp();
				}
				else if (angle < Math.PI - heightAngle && angle > heightAngle) // bottom wall
				{
					(ball as Ball).bounceDown();
				}
				else if (angle <= heightAngle && angle >= -heightAngle) //right wall
				{
					(ball as Ball).bounceRight();
				}
				else //left wall
				{
					(ball as Ball).bounceLeft();
				}
			}
			destroy();
		}
		
		private var firing:Boolean = false;
		
		public function fireGun():void
		{
			if (!firing && !defending)
			{
				trace("fire");
				firing = true;
				gun.smooth = true;
				gun.angle = 0;
				gun.y = halfHeight;
				gun.visible = true;
				var angleToPad:Number = 180 * Math.atan2(GameWorld.pad.centerX - x - halfWidth, GameWorld.pad.y - y - height) / Math.PI;
				var gunOutTween:MultiVarTween = new MultiVarTween(function():void {addTween(gunTween, true);});
				gunOutTween.tween(gun, { y: height }, 0.6, Ease.quartOut);
				addTween(gunOutTween, true);
				var gunTween:MultiVarTween = new MultiVarTween(departBullet);
				gunTween.tween(gun, { angle: angleToPad }, 0.6, null, 0.3);
				
			}
		}
		
		private function departBullet():void
		{
			
			new Bullet(new Point(centerX, bottom+10), Math.atan2(GameWorld.pad.top-bottom, GameWorld.pad.centerX-centerX), 5, 2, world);
		}
		
		public var defending:Boolean = false;
		
		public function defend():void
		{
			if (!defending && !firing) {
				defending = true;
				shield.visible = true;
				var defendTween:VarTween = new VarTween();
				defendTween.tween(shield, "y", height + 1, 0.3, Ease.backOut);
				addTween(defendTween, true);
				
				shieldIcon.x = FP.rand(width - shieldIcon.width);
				shieldIcon.y = - shieldIcon.height
				addGraphic(shieldIcon);
				var iconT:MultiVarTween = new MultiVarTween(function():void { shieldIcon.active = false; } );
				iconT.tween(shieldIcon, { y: -shieldIcon.height - 20, alpha: 0 }, 0.6);
				addTween(iconT, true);
			}
		}
		
		public function destroy():void
		{		
			collidable = false;
			type = "exploding brick";
			
			//explosion
			var l:Number = 10;
			
			var tPart:Image;
			
			img.visible = false;
			gun.visible = false;
			shield.visible = false;
			
			
			var particleTween:MultiVarTween;
			
			for (var i:uint = 0; i < Math.ceil(width / l); i++)
			{
				for (var j:uint = 0; j < Math.ceil(height / l); j++)
				{
					tPart = new Image(imgClass, new Rectangle(i * l, j * l, l, l));
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
		
		
		
	}

}