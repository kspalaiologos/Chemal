package palaiologos.chemal {
	public interface Unit {
		public function setCoefficient(coefficient:int):void;
    	public function getCoefficient():int;
    	public function getHtml():String;
    	public function getElementCount(symbol:String):int;
	}
}
