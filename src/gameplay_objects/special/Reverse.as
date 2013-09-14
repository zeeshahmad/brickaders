package gameplay_objects.special 
{
	import classes.gameObjects.ball_.Ball;
	import classes.stat.Game;
	import classes.stat.Main;
	import com.greensock.easing.*;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class Reverse extends Entity 
	{
		
		public function Reverse() 
		{
			this.graphics.beginFill(0x23A95C, 0.5);
			this.graphics.drawCircle(0, 0, 40);
			this.graphics.endFill();
			
			
			this.addEventListener(Event.ADDED, added);
			Main.getStage().addChild(this);
		}
		
		private function added(e:Event):void
		{
			this.x = Math.random() * (Main.getStage().stageWidth - this.width) + this.width / 2;
			this.y = Math.random() * (GameView.pad.y - 10 - this.height) + this.height / 2;
			
			TweenLite.from(this, 0.3, { alpha: 0.2, scaleX: 0, scaleY: 0, ease: Back.easeOut, onComplete: activate } );
			
			GameView.reverseSpecialCount = 1;
		}
		
		
		
		private function activate():void
		{
			TweenLite.to(this, 4, { onComplete: expire } );
			Main.getStage().addEventListener(Event.ENTER_FRAME, checkforballs);
		}
		
		private function expire():void
		{
			Main.getStage().removeEventListener(Event.ENTER_FRAME, checkforballs);
			TweenLite.to(this, 0.25, { alpha: 0.2, scaleX: 0.01, scaleY: 0.01,  onComplete: remove } );
		}
		
		private function checkforballs(e:Event):void
		{
			for (var i:uint = 0; i < GameView.ballArray.length; i++)
			{
				if (this.hitTestPoint(GameView.ballArray[i].x, GameView.ballArray[i].y, true))
				{
					this.graphics.beginFill(0x27A3DE, 0.7);
					this.graphics.drawCircle(0, 0, 40);
					this.graphics.endFill();
					
					deccel(GameView.ballArray[i]);
					
					GameView.ballArray[i].parent.addChild(GameView.ballArray[i]);
					GameView.removeBallFromArray(GameView.ballArray[i]);
					break;
				}
			}
		}
		
		private var startPoint:Point;
		private var endPoint:Point;
		
		public function ballInside():void
		{
			for (var j:uint = 0; j < GameView.ballArray.length; j++)
			{
				for (var k:uint = 0; k < GameView.brickArray.length; k++)
				{
					if (GameView.ballArray[j] != null) {
						if (GameView.brickArray[k] != null) {
							if (GameView.ballArray[j].hitTestObject(GameView.brickArray[k])) {
								if (GameView.ballArray[j].CURRENT_TYPE != Ball.EXPLOSION_TYPE 
								&& GameView.brickArray[k].STATE != "FROZEN") 
								{ 
									
									if (GameView.currentCombo <= 2)
									{
										GameView.doScore(5, GameView.brickArray[k].x, GameView.brickArray[k].y);
									}
									GameView.brickArray[j].hitBall(GameView.ballArray[j]);
								}
							}
						}
					}
				}
			}
		}
		
		private function deccel(ball:Ball):void 
		{ 
			startPoint = new Point(ball.x, ball.y);
			//endPoint = globalToLocal(new Point(ball.x - 2 * (ball.x - this.x), ball.y - 2 * (ball.y - this.y)));
			endPoint = new Point(globalToLocal(new Point(ball.x, 0)).x + 80 * Math.cos(ball.radians), globalToLocal(new Point(0, ball.y)).y + 80 * Math.sin(ball.radians));
			TweenLite.to(ball, Math.abs(80 / (ball.speed * GameView.STANDARD_INTERVAL)), 
			{ x: localToGlobal(endPoint).x, y: localToGlobal(endPoint).y, ease: Quad.easeOut, onUpdate:ballInside, 
			onComplete: accel, onCompleteParams: [ball] } ); 
			
			TweenLite.to(this, 0.3, { x: ball.x + 40*Math.cos(ball.radians), y: ball.y + 40*Math.sin(ball.radians) } );
			
			GameView.deccelS.play(0);
		}
		
		private function accel(ball:Ball):void 
		{ 
			
			ball.setRadialSpd(ball.speed, ball.radians + Math.PI);
			
			expire();
			TweenLite.to(ball, Math.abs(80 / (ball.speed * GameView.STANDARD_INTERVAL)), { x: startPoint.x, y: startPoint.y, ease: Quad.easeIn, 
			onUpdate:ballInside, onComplete: doneWithBall, onCompleteParams: [ball] } ); 
			
			GameView.accelS.play();
		}
		
		private function doneWithBall(ball:Ball):void
		{
			GameView.ballArray.push(ball);
		}
		
		private function remove():void
		{
			if (this.parent != null) { this.parent.removeChild(this); GameView.reverseSpecialCount = 0; }
		}
	}

}