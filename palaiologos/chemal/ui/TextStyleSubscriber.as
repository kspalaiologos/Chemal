package palaiologos.chemal.ui {
	import flash.text.TextFormat;
	import fl.core.UIComponent;
	
	public class TextStyleSubscriber {

		private var format:FormatFactory;

		public function TextStyleSubscriber(f:FormatFactory) {
			this.format = f;
		}
		
		public function apply(a:UIComponent) {
			a.setStyle("textFormat", this.format.nextFormat());
		}

	}
	
}
