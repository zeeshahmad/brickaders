package gameplay_objects.particles
{
	
	import com.greensock.TimelineLite;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	internal class Particle extends Sprite 
	{
		
		public var particle:Sprite;
		public var tweenVars:Object = new Object();
		internal var timeline:TimelineLite = new TimelineLite( { onComplete:removeThis } );
		
		public function Particle() 
		{
			Main.getStage().addChild(this);
		}
		
		
		private function removeThis():void
		{
			
			if (this.parent != null)
			{
				this.parent.removeChild(this);
			}
		}
		
	}

}