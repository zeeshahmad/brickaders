package gameplay_objects.particles 
{
	import classes.stat.Game;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class RandomParticle extends Particle 
	{
		public var driftX:Number = 0;
		public var driftY:Number = 0;
		
		public function RandomParticle() 
		{
			this.graphics.beginFill(0x555555, 0.3);
			this.graphics.drawCircle(0, 0, GameView.pickRandomFromArray([3, 5, 6]));
			this.graphics.endFill();
			
			timeline.vars = { };
			stage.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		
		public function enterFrame(e:Event):void
		{
			driftX += 0.07*(Math.random() - 0.5);
			driftY += 0.07*(Math.random() - 0.5);
			
			
			this.x = this.x + driftX;
			this.y = this.y + driftY;
			
			if (x > 800) driftX = -Math.abs(driftX);
			else if (x < 0) driftX = Math.abs(driftX);
			if (y > 480) driftY = -Math.abs(driftY);
			else if (y < 0) driftY = Math.abs(driftY);
			
		}
		
	}

}