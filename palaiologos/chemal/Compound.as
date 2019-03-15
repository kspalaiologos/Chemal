package palaiologos.chemal {
	public class Compound implements Unit {

		private var coefficent:int = 1;
		private var subUnits:Array = new Array();

		public function addSubUnit(subUnit:Unit):void {
			this.subUnits.push(subUnit);
		}
		
		public override function getHtml():String {
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
		
		public override function setCoefficent(coefficent:int):void {
			this.coefficent = coefficent;
		}
		
		public override function getCoefficent():int {
			return this.coefficent;
		}
		
		public override function getElementCount(symbol:String):void {
			var count:int = 0;
			for each(var unit:Unit in this.subUnits) {
				count += unit.getElementCount(symbol);
			}
			count *= this.getCoefficent();
			return count;
		}

		public function Compound() {
			super();
		}

	}
	
}
