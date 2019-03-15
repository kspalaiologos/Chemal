package palaiologos.chemal {
	import flash.display.MovieClip;
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import fl.controls.Button;
	import flash.text.TextFormat;
	import palaiologos.chemal.ui.ToolTip;

	public class Start {
		private var equationInput:TextInput;
		private var equationOutput:TextArea;
		private var confirmButton:Button;
		
		public function Start(parent:MovieClip) {
			this.equationInput = parent.EquationInput;
			this.equationOutput = parent.EquationOutput;
			this.confirmButton = parent.ConfirmButton;
		}
		
		public function run():void {
			var inputFormat:TextFormat = new TextFormat();

			inputFormat.font = "Arial";
			inputFormat.size = 20;
			inputFormat.color = 0x0000000;
			
			this.equationInput.setStyle("textFormat", inputFormat);
			
			ToolTip.subscribe(this.equationInput, "Wpisz niewyrownana reakcje tutaj.");
			ToolTip.subscribe(this.equationOutput, "Wyrownana wersja reakcji pojawi sie tutaj.");
			ToolTip.subscribe(this.confirmButton, "Wyrownaj reakcje.");
			
			trace("Running!");
		}
	}
}
