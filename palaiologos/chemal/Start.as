package palaiologos.chemal {
	import flash.display.MovieClip;
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import fl.controls.Button;
	import flash.text.TextFormat;
	import palaiologos.chemal.ui.ToolTip;
	import palaiologos.chemal.ui.DefaultFormatFactory;

	public class Start {
		private var equationInput:TextInput;
		private var equationOutput:TextArea;
		private var confirmButton:Button;
		
		private var textFormatFactory:DefaultFormatFactory;
		
		public function Start(parent:MovieClip) {
			this.equationInput = parent.EquationInput;
			this.equationOutput = parent.EquationOutput;
			this.confirmButton = parent.ConfirmButton;
			
			this.textFormatFactory = new DefaultFormatFactory();
		}
		
		public function run():void {
			this.equationInput.setStyle("textFormat", this.textFormatFactory.nextFormat());
			this.equationOutput.setStyle("textFormat", this.textFormatFactory.nextFormat());
			
			ToolTip.subscribe(this.equationInput, "Wpisz niewyrownana reakcje tutaj.");
			ToolTip.subscribe(this.equationOutput, "Wyrownana wersja reakcji pojawi sie tutaj.");
			ToolTip.subscribe(this.confirmButton, "Wyrownaj reakcje.");
			
			trace("Running!");
		}
	}
}
