package palaiologos.chemal {
	import flash.display.MovieClip;
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import flash.text.TextFormat;

	public class Start {
		private var equationInput:TextInput;
		private var equationOutput:TextArea;
		
		public function Start(parent:MovieClip) {
			this.equationInput = parent.EquationInput;
			this.equationOutput = parent.EquationOutput;
		}
		
		public function run():void {
			var inputFormat:TextFormat = new TextFormat();

			inputFormat.font = "Arial";
			inputFormat.size = 20;
			inputFormat.color = 0x0000000;
			
			trace("Running!");
		}
	}
}
