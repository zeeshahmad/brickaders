package gameplay_objects.special
{
	import adobe.utils.CustomActions;
	import com.greensock.easing.Bounce;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import classes.stat.CommentEngine;
	import classes.stat.Main;
	import classes.stat.Game;
	import net.flashpunk.Entity;

	public class Beam extends Entity 
	{
		
		public function Beam() 
		{
			this.graphics.beginFill(0x0B85CE, 0.5);
			this.graphics.drawRect(0, -50, Main.getStage().stageWidth, 100);
			this.graphics.endFill();
			
			
			
			this.addEventListener(Event.ADDED, added);
			Main.getStage().addChild(this);
		}
		
		private function added(e:Event):void
		{
			this.y = Math.random() * (Main.getInstance().statusbar.y - this.height)+50;
			TweenLite.from(this, 0.5, { alpha: 0, scaleY:0.1, onComplete:onEntranceComplete } );
		}
		
		private var beamTimer:Timer = new Timer(3000, 1);
		
		private function onEntranceComplete():void
		{
			//kill bricks inside beam
			beamTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			beamTimer.start();
			
			Main.getStage().addEventListener(Event.ENTER_FRAME, checkForBricks);
			
			
		}
		
		private var oscillateTimeLine:TimelineLite;
		
		private var gotBricksInBeam:Boolean = false;
		private function checkForBricks(e:Event):void
		{
			detector: for (var i:uint = 0; i < GameView.brickArray.length; i++)
			{
				if (GameView.brickArray[i] != null)
				{
					if (GameView.brickArray[i].getBounds(Main.getStage()).bottom > this.getBounds(Main.getStage()).top 
					&& GameView.brickArray[i].getBounds(Main.getStage()).top < this.getBounds(Main.getStage()).bottom )
					{ //if the brick is entirely in the beam
						GameView.brickInBeamS.play();
						oscillateTimeLine = new TimelineLite( { onComplete: GameView.brickArray[i].doDieTween } );
						for (var j:uint = 0; j < 12; j++)
						{
							
							oscillateTimeLine.append(TweenLite.to(GameView.brickArray[i], 0.05, { rotation: Math.pow( -1, j) * 6.5 } ));
							
						}
						GameView.removeBrickFromArray(GameView.brickArray[i]);
						gotBricksInBeam = true;
						break detector;
					}
				}
				
			}
			
			
		}
		
		private function timerComplete(e:TimerEvent):void
		{
			Main.getStage().removeEventListener(Event.ENTER_FRAME, checkForBricks);
			if (gotBricksInBeam) {
				
			}else {
				CommentEngine.doComment(CommentEngine.USELESS_SPECIAL);
			}
			TweenLite.to(this, 0.5, { alpha:0, onComplete: remove } );
		}
		
		private function remove():void
		{
			if (this.parent != null)
			{
				this.parent.removeChild(this);
			}
		}
		
	}
	

}