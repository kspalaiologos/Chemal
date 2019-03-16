package palaiologos.chemal {
	import flash.display.MovieClip;
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import fl.controls.Button;
	import flash.text.TextFormat;
	import palaiologos.chemal.ui.ToolTip;
	import palaiologos.chemal.ui.DefaultFormatFactory;
	import flash.events.MouseEvent;
	import palaiologos.chemal.ui.TextStyleSubscriber;
	import palaiologos.chemal.ui.FormatFactory;

	public class Start {
		private var equationInput:TextInput;
		private var equationOutput:TextArea;
		private var confirmButton:Button;
		
		private var textFormatFactory:FormatFactory;
		private var textStyleSubscriber:TextStyleSubscriber;
		
		public function Start(parent:MovieClip) {
			this.equationInput = parent.EquationInput;
			this.equationOutput = parent.EquationOutput;
			this.confirmButton = parent.ConfirmButton;
			
			this.textFormatFactory = new DefaultFormatFactory();
			this.textStyleSubscriber = new TextStyleSubscriber(this.textFormatFactory);
		}
		
		public function run():void {
			textStyleSubscriber.apply(this.equationInput);
			textStyleSubscriber.apply(this.equationOutput);
			
			ToolTip.subscribe(this.equationInput, "Wpisz niewyrownana reakcje tutaj.");
			ToolTip.subscribe(this.equationOutput, "Wyrownana wersja reakcji pojawi sie tutaj.");
			ToolTip.subscribe(this.confirmButton, "Wyrownaj reakcje.");
			
			this.confirmButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			
			new Chemal(this.equationInput, this.equationOutput, this.confirmButton);
		}
	}
}
