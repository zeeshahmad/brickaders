package gameplay_objects.special 
{
	import adobe.utils.CustomActions;
	import net.flashpunk.Entity;
	import gameplay_objects.Ball;
	import worlds.GameWorld;
	import com.gskinner.motion.easing.Circular;
	import com.gskinner.motion.GTween;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class Flux extends Entity 
	{
		
		private var ball:Ball;
		private var animated:Sprite;
		private var ani:GTween;
		
		public function Flux(ball_:Ball) 
		{
			
			
			/*ball = ball_;
			
			animated = new Sprite();
			animated.graphics.beginFill(0x1C788C, 0.3);
			animated.graphics.drawCircle(0, 0, 100);
			animated.graphics.endFill();
			this.addChild(animated);
			
			ani = new GTween(this, 0.8, { scaleX: 0.1, scaleY: 0.1, alpha: 0}, {onComplete: resetAni } );
			
			Main.getStage().addChild(this);*/
			
		}
		
		private const attraction:Number = 2;
		
		private function resetAni(g:GTween):void
		{
			/*if (ViewTemplate.CURRENT_VIEW == ViewTemplate.GAME_VIEW) { ani.beginning(); ani.paused = false; }
			//else if (GameView.STATE == GameView.PAUSED_STATE) ani.paused = true;
			else remove();*/
		}
		
		override public function update():void
		{
			this.x = ball.x;
			this.y = ball.y;
		}
		
		
	}

}