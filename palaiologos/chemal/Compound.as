package palaiologos.chemal {
	public class Compound implements Unit {

		private var coefficent:int = 1;
		private var subUnits:Array = new Array();

		public function addSubUnit(subUnit:Unit):void {
			this.subUnits.push(subUnit);
		}
		
		public function getHtml():String {
			var s:String = "";
			
			if(this.getCoefficient() > 1) {
				s += "(";
			}
			
			for each(var unit:Unit in this.subUnits) {
				s += unit.getHtml();
			}
			
			if(this.getCoefficient() > 1) {
				s += ")<sub>" + this.getCoefficient() + "</sub>";
			}
			
			return s;
		}
		
		public function setCoefficient(coefficent:int):void {
			this.coefficent = coefficent;
		}
		
		public function getCoefficient():int {
			return this.coefficent;
		}
		
		public function getElementCount(symbol:String):int {
			var count:int = 0;
			for each(var unit:Unit in this.subUnits) {
				count += unit.getElementCount(symbol);
			}
			count *= this.getCoefficient();
			return count;
		}

		public function Compound() {
			super();
		}

	}
	
}
