package gameplay_objects.bricks 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameplay_objects.Ball;
	import gameplay_objects.Bullet;
	import gameplay_objects.Orbiter;
	import gameplay_objects.Pad;
	import gameplay_objects.PointBar;
	import gameplay_objects.ScoreShow;
	import gameplay_objects.SideBar;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
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
		public static var speedX:Number = 1.2;
		public static var speedY:Number = 0;
		public var dodgeX:Number = 0;
		public var dodgeAmount:Number = 0;
		public var enableDodge:Boolean = true;
		public var bonus:Boolean = false;
		
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
		
		[Embed(source = "../../../lib/sounds/brick_explode.mp3")]
		private static const EXPLODE_SND:Class;
		private static var explodeSnd:Sfx = new Sfx(EXPLODE_SND);
		
		[Embed(source = "../../../lib/sounds/shoot.mp3")]
		private static const SHOOT_SND:Class;
		public static var shootSnd:Sfx = new Sfx(SHOOT_SND);
		
		[Embed(source = "../../../lib/sounds/get_orbiter.mp3")]
		private static const GET_ORBITER:Class;
		public static var getOrbiterSnd:Sfx = new Sfx(GET_ORBITER);
		
		[Embed(source = "../../../lib/sounds/brick_dodge.mp3")]
		private static const DODGE_SND:Class;
		public var dodgeSnd:Sfx = new Sfx(DODGE_SND);
		
		[Embed(source = "../../../lib/sounds/bonus.mp3")]
		private static const BONUS_SND:Class;
		public static var bonusSnd:Sfx = new Sfx(BONUS_SND);
		
		[Embed(source = "../../../lib/sounds/bonus_ship.mp3")]
		private static const BONUS_SHIP_SND:Class;
		private static var bonusShipSnd:Sfx = new Sfx(BONUS_SHIP_SND);
		
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
			if (GameWorld.wave < 6) rLim = 29;
			else if (GameWorld.wave < 20) rLim = 59;
			else if (GameWorld.wave < 40) rLim = 65;
			else rLim = 77;
			
			var r:Number = FP.rand(rLim);
			
			if (r < 30) {
				img = new Image(INVADER_1);
				imgClass = INVADER_1;
				enableDodge = false;
				
				movementI = [0, 0];
				movementJ = [1, 0];
			}
			else if (r < 50) {
				img = new Image(INVADER_2);
				imgClass = INVADER_2;
				enableDodge = false; //dodgeAmount = 1.25;
				
				movementI = [0, 0, 1, 0, 0, -1];
				movementJ = [1, 1, 0, 1, 1, 0];
			}
			else if (r < 61) {
				img = new Image(INVADER_3);
				imgClass = INVADER_3;
				enableDodge = false; //dodgeAmount = 1.5;
				
				movementI = [0, 0, 1, 0, 0, 0, -1, 0];
				movementJ = [1, 1, 0, -1, 1, 1, 0, -1];
			}
			else if (r < 75) {
				img = new Image(INVADER_4);
				imgClass = INVADER_4;
				dodgeAmount = 1.6;
				
				movementI = [0];
				movementJ = [1];
			}
			else if (r < 78) {
				img = new Image(INVADER_BONUS);
				imgClass = INVADER_BONUS;
				dodgeAmount = 1.9;
				bonus = true;
				
				movementI = [0];
				movementJ = [1];
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
			
			super.added();
		}
		
		private var moveI:int = 0; 
		private var moveJ:int = 0;
		public var counter:Number = Math.random() * -0.8;
		private var movementIndex:uint = 0;
		private var movementI:Array;
		private var movementJ:Array;
		
		private var moveTween:MultiVarTween;
		
		private function moveFunction():void
		{
			counter += FP.elapsed;
			
			if (counter >= 1.8)
			{
				moveI = movementI[movementIndex];
				moveJ = movementJ[movementIndex];
				
				if (moveTween != null) if (moveTween.active) moveTween.cancel();
				moveTween = new MultiVarTween();
				moveTween.tween(this, { x: Main.between(SideBar.W, 800, x + 40 * moveI),
				y: Main.between(0, 480, y + 40 * moveJ) }, 1.1, Ease.quadOut);
				addTween(moveTween);
				
				if (movementIndex == movementI.length - 1) movementIndex = 0;
				else movementIndex++;
				counter -= 1.0;
			}
		}
		
		
		override public function update():void 
		{
			if (!GameWorld.paused && !GameWorld.actionMenu.active) 
			moveFunction.apply(this);
			
			//x += (speedX*moveI + dodgeX) * GameWorld.move * FP.rate * GameWorld.timeFactor;        
			//x = Math.max(Math.min(x,800 - width), SideBar.W);
			//y += speedY * GameWorld.move * FP.rate * GameWorld.timeFactor * moveJ;
			
			if (bonus && !bonusShipSnd.playing) bonusShipSnd.play();
			
			for each (var i:Entity in GameWorld.entitiesByType("ball", world))
			{
				if (i.distanceFrom(this, true) < 60) 
				{
					if (enableDodge && !endOfBrick) 
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
						if (GameWorld.soundOn && !dodgeSnd.playing) dodgeSnd.play();
					}
					
					if (defending && i.collideRect(i.x, i.y, x + shield.x, y + shield.y, shield.width, shield.height))
					{
						if (centerY < i.y && (i as Ball).speedY < 0 && !Ball.powerOn) {
							(i as Ball).bounceDown();
							GameWorld.addScore( -2);
							if (world != null) world.add(new ScoreShow(-2, x + FP.rand(width), y + height + 24));
						}
					}
					else if (collide("ball", x, y)) onBallCollision(collide("ball", x, y));
				}
				else {
					dodgeX = 0;
					exhaustRight.visible = false;
					if (dodgeSnd.playing) dodgeSnd.stop();
				}
			}
			
			if (collide("pad", x, y))
			{
				if (!(collide("pad", x, y) as Pad).moveTween.active)
				{
					GameWorld.addScore( -110);
					if (world != null) world.add(new ScoreShow( -110, FP.rand(width) + x, y - 10));
					GameWorld.reduceHealth();
				}
				destroy();
			}
			
			if (collidable && Math.round(GameWorld.move) == 1)
			{
				if (FP.rand(4500) < 2) {
					defend();
				} else if (FP.rand(4500) < 2) {
					fireGun();
				}
			}
			
			if (y + height > PointBar.Y)
			{
				if (world != null) 
				{
					/*if (world.typeCount("orbiter") > 0)
					{
						var e:Entity = world.typeFirst("orbiter");
						if (e.world != null) e.world.remove(e);
					}
					else */if (!endOfBrick)
					{
						GameWorld.addScore( -80);
						if (world != null) world.add(new ScoreShow( -80, FP.rand(width) + x, y - 10));
						GameWorld.reduceHealth();
					}
				}
				trace(endOfBrick);
				destroy();
			}
			super.update();
		}
		
		//collision test in ball class
		public function onBallCollision(ball:Entity):void
		{
			Pad.movesLeft++;
			SideBar.movesLeftText.text = "Moves: " + String(Pad.movesLeft);
			
			(ball as Ball).airComboCheck();
			
			if (/*!(ball as Ball).reverseOn && */!Ball.powerOn && !endOfBrick)
			{
				if ((ball as Ball).reverseOn) 
				{
					//cancel reverse and just bounce off like normal
					(ball as Ball).reverseTween.cancel();
					(ball as Ball).onReverseComplete();
				}
				
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
			
			if (ball.centerX > left + (1/3) * width && ball.centerX < right - (1/3) * width && !endOfBrick)
			{
				GameWorld.addScore(10);
				if (world != null) world.add(new ScoreShow(10, FP.rand(width) + x, y - height, "Center Shot!"));
				if (GameWorld.soundOn) bonusSnd.play();
			}
			
			var hitScore:uint = Math.round(Math.abs(20 * (1 - y / 480)));
			if (bonus) {
				hitScore += 150;
				if (GameWorld.soundOn) bonusSnd.play();
			}
			GameWorld.addScore(hitScore);
			if (world != null) world.add(new ScoreShow(hitScore, FP.rand(width) + x, y +2* height));
			
			FP.randomizeSeed();
			if (world != null) if (world.typeCount("orbiter") < 6) if (FP.rand(3) == 0) {
				ball.world.add(new Orbiter(ball as Ball));
				if (GameWorld.soundOn) getOrbiterSnd.play();
			}
			
			destroy();
		}
		
		private var firing:Boolean = false;
		private var fireAngle:Number;
		private var gunTween:MultiVarTween;
		private var angleToPad:Number;
		
		public function fireGun():void
		{
			if (!endOfBrick && !firing && !defending)
			{
				firing = true;
				gun.smooth = true;
				gun.angle = 0;
				gun.y = halfHeight;
				gun.visible = true;
				
				var gunOutTween:MultiVarTween = new MultiVarTween();
				gunOutTween.tween(gun, { y: height }, 0.6, Ease.quartOut);
				addTween(gunOutTween, true);
				
				pointAndShoot();
			}
		}
		
		public function pointAndShoot():void
		{
			angleToPad = 180 * Math.atan2(GameWorld.pad.centerX - x - halfWidth, GameWorld.pad.y - y - height) / Math.PI;
			fireAngle = Math.atan2(GameWorld.pad.top - bottom, GameWorld.pad.centerX - centerX);
			if (!endOfBrick && !GameWorld.paused)
			{
				gunTween = new MultiVarTween(departBullet);
				gunTween.tween(gun, { angle: angleToPad }, 0.6, null, 0.9);
				addTween(gunTween, true);
			}
		}
		
		private function departBullet():void
		{
			new Bullet(new Point(centerX, bottom + 10), fireAngle, 5, 2, world);
			if (GameWorld.soundOn) shootSnd.play();
			var t:MultiVarTween = new MultiVarTween(pointAndShoot);
			t.tween(this, { }, 2.8);
			addTween(t);
		}
		
		public var defending:Boolean = false;
		
		public function defend():void
		{
			if (!endOfBrick && !defending && !firing) {
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
		
		public var endOfBrick:Boolean = false;
		
		public function destroy():void
		{		
			collidable = false;
			
			endOfBrick = true;
			
			if (GameWorld.soundOn) explodeSnd.play(0.8);
			
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