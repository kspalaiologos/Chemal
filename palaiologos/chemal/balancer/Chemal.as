package palaiologos.chemal.balancer {
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import fl.controls.Button;
	import fl.events.ComponentEvent;
	import flash.events.Event;
	
	public class Chemal {

		private var equationInput:TextInput;
		private var equationOutput:TextArea;
		private var equationButton:Button;
		
		private var reactants:Array = new Array();
		private var products:Array = new Array();
		private var elementNames:Array = new Array();
		
		private var system:Array; /* double[][] */
		private var variables:Array; /* double[] */

		private function displayUnbalancedEquation():void {
			var equation:String = "";
			
			for(var i:Number = 0; i < reactants.length; i++) {
				equation += reactants[i].getHtml();
				
				if(i < reactants.length - 1) {
					equation += " + ";
				}
			}
			
			equation += " => ";
			
			for(var i2:Number = 0; i2 < products.length; i2++) {
				equation += products[i2].getHtml();
				
				if(i2 < products.length - 1) {
					equation += " + ";
				}
			}
			
			this.equationOutput.htmlText = equation;
		}
		
		private function displayBalancedEquation():void {
			var variableNumber:Number = 0;
            
			var equation:String = "";
			var i:Number = 0;
			
			for(; i < reactants.length; i++) {
				if(variables[variableNumber] != 1) {
					equation += variables[variableNumber];
				}
				
				variableNumber++;
				
				equation += reactants[i].getHtml();
				
				if(i < reactants.length - 1) {
					equation += " + ";
				}
			}
			
			equation += " => ";
			
			for(i = 0; i < products.length; i++) {
				if(variables[variableNumber] != 1) {
					equation += variables[variableNumber];
				}
				
				variableNumber++;
				
				equation += products[i].getHtml();
				
				if(i < products.length - 1) {
					equation += " + ";
				}
			}
			
			this.equationOutput.htmlText = equation;
		}
		
		private function parseEquationString(equationString:String):void {
			reactants = new Array();
			products = new Array();
			
			var s:String = equationString.split(" ").join(""); /* TODO: Better way to do this. */
			var halves:Array = s.split("=");
			
			for(var i:Number = 0; i < halves.length; i++) {
				var mols:Array = halves[i].split("+");
				
				for each(var str:String in mols) {
					if(i == 0)
						reactants.push(parseCompoundString(str));
					else
						products.push(parseCompoundString(str));
				}
			}
		}
		
		private function parseCompoundString(s:String):Compound {
			trace("Finding compound: " + s);
			var compound:Compound = new Compound();
			var i:Number = 0;
			
			while(i < s.length) {
				trace("s.charAt(i) = " + s.charAt(i));
				if(s.charCodeAt(i) >= "A".charCodeAt(0) && s.charCodeAt(i) <= "Z".charCodeAt(0)) {
					var elementName:String = s.charAt(i);
					i++;
					
					while(i < s.length && s.charCodeAt(i) >= "a".charCodeAt(0) && s.charCodeAt(i) <= "z".charCodeAt(0) && s.charAt(i) != '(' && s.charAt(i) != ')') {
						elementName += s.charAt(i);
						i++;
					}
					
					var stringCoefficent:String = "";
					
					while(i < s.length && !isNaN(new Number(s.charAt(i)))) {
						stringCoefficent += s.charAt(i);
						i++;
					}
					
					var coefficent:Number = 1;
					
					if(stringCoefficent.length > 0) {
						coefficent = new Number(stringCoefficent);
						if(isNaN(coefficent)) {
							trace("!!! coefficent=nan");
						}
					}
					
					compound.addSubUnit(new Element(elementName, coefficent));
					if(elementNames.indexOf(elementName) < 0) {
						elementNames.push(elementName);
					}
				} else if(s.charAt(i) == '(') {
					var end:Number = s.lastIndexOf(")");
					var subCompound:Compound = parseCompoundString(s.substring(i + 1, end));
					i = end + 1;
					var stringCoefficent2:String = "";
					while(i < s.length && !isNaN(new Number(s.charAt(i)))) {
						stringCoefficent2 += s.charAt(i);
						i++;
					}
					var coefficent2:Number = 1;
					if(stringCoefficent2.length > 0) {
						coefficent2 = new Number(stringCoefficent2);
						if(isNaN(coefficent2)) {
							trace("!!! coefficent=nan");
						}
					}
					subCompound.setCoefficient(coefficent2);
					compound.addSubUnit(subCompound);
				}
			}
			
			trace("Compound was found!");
			return compound;
		}
		
		private function createEquationsSystem():void {
			var i:Number = 0;
			var j:Number = 0;
			
			system = new Array(elementNames.length);
			for(; i < system.length; i++) {
				system[i] = new Array(reactants.length + products.length + 1);
			}
			
			i = 0;
			
			for(; i < system.length; i++) {
				for(j = 0; j < system[0].length - 1; j++) {
					if(j < reactants.length)
						system[i][j] = reactants[j].getElementCount(elementNames[i]);
					else
						system[i][j] = -products[j - reactants.length].getElementCount(elementNames[i]);
				}
				system[i][system[0].length - 1] = 0;
			}
		}
		
		private function solveEquations():void {
			trace("Part 1:");
			for(var i:Number = 0; i < system.length && i < system[0].length - 1; i++) {
				if(system[i][i] == 0) {
					var found:Boolean = false;
					for(var j:Number = i + 1; j < system.length; j++) {
						if(system[j][i] != 0) {
							for(var k:Number = 0; k < system[0].length; k++) {
								system[i][k] += system[j][k];
							}
							found = true;
							break;
						}
					}
					
					if(!found)
						continue;
				}
				
				for(var i2:Number = i + 1; i2 < system.length; i2++) {
					var n:Number = system[i2][i];
					if(n == 0)
						continue;
					for(var j2:Number = 0; j2 < system[i2].length; j2++) {
						system[i2][j2] *= system[i][i];
					}
					for(var j3:Number = 0; j3 < system[0].length; j3++) {
						system[i2][j3] -= system[i][j3] * n;
					}
				}
				
				printSystem();
			}
		}
		
		private function printSystem():void {
			trace(" Printing system: ");
			for each(var i:Array in system) {
				for each(var j:Number in i) {
					trace(j);
				}
			}
		}
		
		private function solveVariables():Boolean {
			variables = new Array(system[0].length - 1);
			var defaultValue:Number = 1;
			
			valueLoop: while(true) {
				for(var i:Number = variables.length - 1; i > -1; i--) {
					if(i > system.length - 1 || system[i][i] == 0)
						variables[i] = defaultValue;
					else {
						variables[i] = system[i][variables.length];
						for(var j:Number = i + 1; j < variables.length; j++) {
							variables[i] -= variables[j] * system[i][j];
						}
						variables[i] /= system[i][i];
						if(variables[i] < 0)
							return false;
						if(variables[i] % 1 != 0) {
							trace("Default value " + defaultValue + " is not an integer!");
							defaultValue++;
							continue valueLoop;
						}
					}
				}
				break;
			}
			
			return true;
		}
		
		private function balanceClick(e:ComponentEvent):void {
			parseEquationString(this.equationInput.text);
			displayUnbalancedEquation();
			
			createEquationsSystem();
			printSystem();
			
			solveEquations();
			
			if(solveVariables()){
				displayBalancedEquation();
			} else {
				trace("Invalid equation: Cannot solve with positive integers");
			}
		}

		public function Chemal(equationInput:TextInput, equationOutput:TextArea, equationButton:Button) {
			this.equationInput = equationInput;
			this.equationOutput = equationOutput;
			this.equationButton = equationButton;
			
			equationInput.text = "P2I4 + P4 + H2O + K = PH4I + K(H3PO4)2";
			
			equationButton.addEventListener(ComponentEvent.BUTTON_DOWN, balanceClick);
		}
	}
	
}
