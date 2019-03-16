package palaiologos.chemal.balancer {
	public interface Unit {
		function setCoefficient(coefficient:int):void;
    	function getCoefficient():int;
    	function getHtml():String;
    	function getElementCount(symbol:String):int;
	}
}
