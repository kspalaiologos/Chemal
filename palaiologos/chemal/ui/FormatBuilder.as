package palaiologos.chemal.ui {
	import flash.text.TextFormat;

	public class FormatBuilder {
		protected var font:String;
		protected var size:int;
		protected var color:int;
		
		public function FormatBuilder(font:String, size:int, color:int) {
			this.font = font;
			this.size = size;
			this.color = color;
		}
		
		public function nextFormat():TextFormat {
			var format:TextFormat = new TextFormat();

			format.font = this.font;
			format.size = this.size;
			format.color = this.color;
			
			return format;
		}
	}
}
