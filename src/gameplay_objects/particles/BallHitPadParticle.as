package gameplay_objects.particles 
{
	import views.game_view.particles.Particle;
	import views.GameView;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class BallHitPadParticle extends Particle 
	{
		
		
		public function BallHitPadParticle(_x:Number, _y:Number) 
		{
			this.x = _x;
			this.y = _y;// GameView.pad.y;
			
			doAni();
			
			//if (this.parent != null) { this.parent.removeChild(this); } //removes from stage - as a Particle class object is added to stage
			//GameView.pad.addChild(this);
			
		}
		
		private function doAni():void
		{
			//this.graphics.beginFill(0x0F7325);
			//this.graphics.drawRoundRect( -2.5, 0, 5, 2.5, 2);
			//this.graphics.endFill();
			
			for (var i:uint = 0; i < 3; i++)
			{
				particle = new Sprite();
				particle.graphics.beginFill(GameView.pickRandomFromArray([0x203A03, 0x0E315C]));
				particle.graphics.drawRect( -1, -6, 2, 6);
				particle.graphics.endFill();
				particle.x = (Math.random() - 0.5) * 7;
				particle.y = -Math.random() * 3;
				
				particle.rotation = Math.min(Math.max(Math.random() * particle.x * 100, -90), 90);
				this.addChild(particle);
				
				timeline.insert(
				new TweenLite(particle, 0.3, { x: 7*Math.cos(Math.PI*(particle.rotation-90)/180), y: 7*Math.sin(Math.PI*(particle.rotation-90)/180)} )
				);
			}
			timeline.insert(new TweenLite(this, 0.35, { alpha:0 } ));
		}
		
	}

}