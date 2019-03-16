package palaiologos.chemal.converter {
	import flash.display.MovieClip;
	import fl.controls.ComboBox;
	import fl.controls.TextInput;
	import flash.events.Event;
	
	public class Start {

		private var CategoryCombo:ComboBox;
		private var InputCombo:ComboBox;
		private var OutputCombo:ComboBox;
		
		private var InputTxt:TextInput;
		private var OutputTxt:TextInput;
		
		private var category:int;

		private function switchCategory(e:Event):void {
			switch(this.CategoryCombo.selectedIndex) {
				case Category.LENGTH:
					InputCombo.dataProvider.removeAll();
					InputCombo.dataProvider.addItem({
						label: ""
					});
			}
		}

		public function Start(parent:MovieClip) {
			this.CategoryCombo = parent.CategoryCombo;
			this.InputCombo = parent.InputCombo;
			this.OutputCombo = parent.OutputCombo;
			
			this.InputTxt = parent.InputTxt;
			this.OutputTxt = parent.OutputTxt;
		}
		
		public function run():void {
			this.CategoryCombo.addEventListener(Event.CHANGE, switchCategory);
		}

	}
	
}
