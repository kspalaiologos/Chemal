package palaiologos.chemal {
	import flash.display.MovieClip;

	public class Start {
		private var parent:MovieClip;
		
		public function Start(parent:MovieClip) {
			this.parent = parent;
			
			trace("Test!");
		}
		
		public function run():void {
			trace("Running!");
		}
	}
}
