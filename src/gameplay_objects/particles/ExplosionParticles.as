package gameplay_objects.particles
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import worlds.GameWorld;
	
	public class ExplosionParticles extends Particle 
	{
		
		public function ExplosionParticles(x:Number, y:Number,  colorArray:Array, sizeArray:Array, particleAmount:uint = 20, explodeRange:Number = 280, duration:Number = 0.7) 
		{
			this.x = x;
			this.y = y;
			
			timeline.autoRemoveChildren = true;
			
			
			for (var i:uint = 0; i < particleAmount; i++)
			{
				
				particle = new Sprite();
				
				particle.graphics.beginFill(Main.pickRandomFromArray(colorArray));
				particle.graphics.drawCircle(0, 0, Main.pickRandomFromArray(sizeArray));
				particle.graphics.endFill();
				
				this.addChild(particle);
				
				tweenVars = new Object();
				tweenVars["scaleX"] = 0;
				tweenVars["scaleY"] = 0;
				tweenVars["ease"] = Quad.easeOut;
				tweenVars["x"] = (Math.random() - 0.5) * explodeRange;
				tweenVars["y"] = (Math.random() - 0.5) * explodeRange;
				
				timeline.insert(TweenLite.to(particle, duration, tweenVars));
				
			}
		}
		
	}

}