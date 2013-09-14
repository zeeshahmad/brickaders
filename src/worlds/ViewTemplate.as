package worlds 
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class ViewTemplate extends Sprite 
	{
		public static var CURRENT_VIEW:String;
		public static const SPLASH_VIEW:String = "SPLASH_VIEW";
		public static const MAINMENU_VIEW:String = "MAINMENU_VIEW";
		public static const GAME_VIEW:String = "GAME_VIEW";
		
		public static var viewInstances:Array = new Array();
		public static var tempInstance:ViewTemplate;
		
		public var viewName:String;
		
		public function ViewTemplate() 
		{
			tempInstance = this;
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, 800, 480);
			this.graphics.endFill();
			
			
			inAnimation = TweenMax.fromTo(this, 0.5, { alpha:0 }, { alpha:1,  onStart: function(ins:ViewTemplate):void { onView(); Main.getStage().addChild(ins); }, onStartParams: [this] } );
			outAnimation = TweenMax.fromTo(this, 0.5, { alpha:1 }, { alpha:0, onStart: onInitExit, onComplete: function(ins:ViewTemplate):void { onExit(); Main.remove(ins);}, onCompleteParams: [this] } );
			
			viewInstances.push(this);
		}
		
		public static function initViews():void
		{
			new SplashView();
			new MainMenuView();			
			new GameView();
			changeView(GAME_VIEW);
		}
		
		public static function getView(nm:String):ViewTemplate
		{
			var vw:ViewTemplate;
			for (var i:uint = 0; i < viewInstances.length; i++)
			{
				if (viewInstances[i].viewName == nm)
				{
					vw = viewInstances[i];
				}
			}
			return vw;
		}
		
		public var inAnimation:TweenMax;
		public var outAnimation:TweenMax;
		
		public static function changeView(newViewName:String):void
		{
			var totalAni:TimelineLite = new TimelineLite( { } );
			if (CURRENT_VIEW!=null) totalAni.append(getView(CURRENT_VIEW).outAnimation);
			totalAni.append(getView(newViewName).inAnimation);
			totalAni.play();
		}
		
		//To be Overridden
		public function onView():void
		{
			
		}
		public function onExit():void
		{
			
		}
		
		public function onInitExit():void
		{
			
		}
		
	}

}