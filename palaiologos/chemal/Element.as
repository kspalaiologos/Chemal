package palaiologos.chemal {
	
	public class Element implements Unit {

		protected var coefficent:int;
		private var symbol:String;

		public function Element(symbol:String, coefficent:int=1) {
			super();
			
			this.symbol = symbol;
			this.coefficent = coefficent;
		}
		
		public function getSymbol():String {
			return this.symbol;
		}
		
		public function toString():String {
			return this.symbol + this.coefficent;
		}
		
		public function setCoefficient(coefficent:int):void {
			this.coefficent = coefficent;
		}
		
		public function getCoefficient():int {
			return this.coefficent;
		}
		
		public function getHtml():String {
			if(this.coefficent > 1) {
				return "<b>" + this.symbol + "</b>" + "<font size=\"16\">" + this.getCoefficient() + "</font>";
			}
			
			return "<b>" + this.symbol + "</b>";
		}
		
		public function getElementCount(symbol:String):int {
			if(this.symbol == symbol)
				return this.getCoefficient();
			return 0;
		}

	}
	
}
