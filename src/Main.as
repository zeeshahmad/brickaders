package 
{
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class Main extends Engine 
	{
		
		public static var _instance:Main;
		
		public function Main():void 
		{
			_instance = this;
			
			
			/*stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			ViewTemplate.initViews();
			ViewTemplate.changeView(ViewTemplate.GAME_VIEW);*/
			
			super(800, 480);
			
			FP.screen.color = 0x333333;
			FP.world = new GameWorld;
			
			
		}
		
		override public function setStageProperties():void 
		{
			
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			//super.setStageProperties();
		}
		
		override public function init():void 
		{
			
			super.init();
		}
		
		
		private function deactivate(e:Event):void 
		{
			// auto-close
			NativeApplication.nativeApplication.exit();
		}
		
		
		
		
		
		
		
		
		
		
		//UNIVERSAL FUNCTIONS
		public static function pickRandomFromArray(array:Array):*
		{
			return array[Math.floor(Math.random() * array.length)];
		}
		
		public static function getStage():Stage
		{
			return _instance.stage;
		}
		
		public static function getInstance():Main
		{
			return _instance;
		}
		
		public static function remove(obj:DisplayObject):void
		{
			if (obj.parent != null) obj.parent.removeChild(obj);
		}
		
		public static function removeObjFromArr(obj:DisplayObject, arr:Array):void
		{
			if (arr.indexOf(obj) != -1) arr.splice(arr.indexOf(obj), 1);
		}
		
		public static function unit(val:Number):int
		{
			return Math.round(val / Math.abs(val));
		}
		
		
	}
	
}