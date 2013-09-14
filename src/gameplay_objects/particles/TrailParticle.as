package gameplay_objects.particles 
{
	/**
	 * ...
	 * @author Zeeshan
	 */
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import views.GameView;
	
	public class TrailParticle extends Particle 
	{
		
		public function TrailParticle(object:DisplayObject, colorTheme:String) 
		{
			if (colorTheme == "normal")
			{
				this.graphics.beginFill(0xD1A418);
				this.graphics.drawCircle(0, 0, GameView.pickRandomFromArray([2, 3, 4]));
				this.graphics.endFill();
			}
			else if (colorTheme == "green1")
			{
				this.graphics.beginFill(GameView.pickRandomFromArray([0x2BE362, 0x3DDA60, 0x409D35, 0x48F01E]));
				this.graphics.drawCircle(0, 0, GameView.pickRandomFromArray([6, 3, 4, 5]));
				this.graphics.endFill();
			}
			else if (colorTheme == "magnet")
			{
				this.graphics.beginFill(GameView.pickRandomFromArray([0xB89A56, 0xD9D317, 0xACB9B8]));
				this.graphics.drawCircle(0, 0, GameView.pickRandomFromArray([6, 3, 4, 5]));
				this.graphics.endFill();
			}
			else if (colorTheme == "explosive")
			{
				this.graphics.beginFill(GameView.pickRandomFromArray([0xBC0A3A, 0xFB0000, 0xFF8000, 0x8A3909]));
				this.graphics.drawCircle(0, 0, GameView.pickRandomFromArray([3, 4, 5]));
				this.graphics.endFill();
			}
			else if (colorTheme == "ice")
			{
				this.graphics.beginFill(GameView.pickRandomFromArray([0x1B87AB, 0x7AE0E0, 0x9D9DF9, 0x3ADCDC]));
				this.graphics.drawCircle(0, 0, GameView.pickRandomFromArray([6, 3, 4, 5]));
				this.graphics.endFill();
			}
			else {
				this.graphics.beginFill(0);
				this.graphics.drawCircle(0, 0, GameView.pickRandomFromArray([6, 3, 4, 5]));
				this.graphics.endFill();
			}
			
			this.x = object.x+(Math.random()-0.5)*20;
			this.y = object.y+(Math.random()-0.5)*20;
			
			timeline.insert(new TweenLite(this, 0.6, { scaleX:0.1, scaleY:0.1 } ));
			
			if (object != null && object.parent != null) 
			{
				object.parent.addChild(object);
			}
			
		}
		
	}

}