package palaiologos.chemal.ui {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.filters.DropShadowFilter;

	public class ToolTip extends Sprite {
		private static var instance:ToolTip;
		private static var allowInstantiation:Boolean = false;
		private static var delayTimer:Timer;
		private var options:Object;
		private var defOptions:Object;
		private var globalOptions:Object;		
		private var keys:Dictionary;
		private var currentProps:Object;
		private var background:Sprite;
		private var tipText:TextField;		
		private var tipWidth:Number;
		private var tipHeight:Number;
		private var chunk:Number;
		
		public function ToolTip() {	
			if (!allowInstantiation) {
				throw(new Error("palaiologos.chemal.ui.TollTip: Class is a singleton."));
				return;
			}
			keys = new Dictionary(true);
			
			defOptions = { 
				delay:2,
				width:200,
				alpha:.8,
				corner:10,
				margin:4,
				marginLeft:ToolTipSettings.MARGIN,
				marginRight:ToolTipSettings.MARGIN,
				marginTop:ToolTipSettings.MARGIN,
				marginBottom:ToolTipSettings.MARGIN,
				color:"#8b0000",
				backgroundColor:0xFFFFDD,
				shadowColor:ToolTipSettings.COLOR_TEXT,				
				shadowType: ToolTipSettings.SHADOW_HOLLOW,				
				lineColor:ToolTipSettings.COLOR_TEXT,
				customBackground:null,
				styleSheet:null,
				fontFamily:"Verdana,Helvetica,_sans",				
				fontSize:11,
				fontWeight:"normal",
				leading:2,
				textAlign:TextFormatAlign.LEFT,
				embedFonts:true,
				followMouse:true,
				duration:0.1,
				offsetX:20,
				offsetY:25,
				fixedPosition:false,
				fixedWidth:false,
				boundingRect:ToolTipSettings.STAGE_RECT
			};
			resetDefaultOptions();
			mouseEnabled = false;
			mouseChildren = false;			
		}
		
		public static function getInstance(target:DisplayObject = null):ToolTip {
			if (ToolTip.instance == null) {
				allowInstantiation = true;
				ToolTip.instance = new ToolTip();
				allowInstantiation = false;
				delayTimer = new Timer(options.delay, 1);
				delayTimer.addEventListener(TimerEvent.TIMER, instance.doShow);
			}
			if (target != null){
				if (ToolTip.instance.stage == null) {
					if (target.stage != null) {
						target.stage.addChild(ToolTip.instance);
						target.stage.addEventListener(Event.MOUSE_LEAVE, ToolTip.instance.hideListener);
						ToolTip.instance.removeStageEvent();	
					} else {
						target.addEventListener(Event.ADDED_TO_STAGE, instance.stageListener);
					}
				}
			}
			return ToolTip.instance;
		}
		
		public static function show(tooltip:String = "", localOptions:Object = null, target:DisplayObject = null):void {
			var instance:ToolTip = ToolTip.getInstance(target);
			if (instance.stage != null && tooltip != "" && tooltip != null) {
				ToolTip.hide();
				instance.currentProps = { tooltip:tooltip, options:localOptions, target:target};
				var delay:Number = localOptions != null && localOptions.delay != undefined ? localOptions.delay  : options.delay;
				delayTimer.delay = delay * 1000;
				delayTimer.start();
			}
		}	

		public static function hide():void{
			delayTimer.stop();
			instance.doHide();
		}

		public static function get options ():Object {
			return instance.globalOptions;
		}

		public static function set options(newOptions:Object):void {
			for (var i:String in newOptions) {
				var optionValue:* = newOptions[i];
				if( optionValue !== undefined){
					instance.globalOptions[i] = optionValue;
				}
			}
		}

		public static function setOption(optionName:String, optionValue:*):void {
			instance.globalOptions[optionName] = optionValue;
		}

		public static function getOption(optionName:String):* {
			return instance.globalOptions[optionName];
		}

		public static function getDefaultOption(optionName:String):* {
			return instance.defOptions[optionName];
		}		

		public static function resetDefaults():void {
			instance.resetDefaultOptions();
		}

		public static function subscribe(target:DisplayObject, tooltip:String = "", options:Object = null):void {
			if (target == null) {
				return;
			}
			var instance:ToolTip = getInstance(target);
			if (instance.stage == null){
				target.addEventListener(Event.ADDED_TO_STAGE, instance.stageListener, false, 0, true);				
			}
			instance.addTargetProps(target, tooltip, options);	
			target.addEventListener(MouseEvent.ROLL_OVER, instance.showListener, false, 0, true);
			target.addEventListener(MouseEvent.ROLL_OUT, instance.hideListener, false, 0, true);
			target.addEventListener(MouseEvent.MOUSE_DOWN, instance.hideListener, false, 0, true);					
			target.addEventListener(MouseEvent.CLICK, instance.hideListener, false, 0, true);	
		}

		public static function unsubscribe(target:DisplayObject):void {
			if (target == null) {
				return;
			}
			var instance:ToolTip = getInstance(target);
			if (instance.getProps(target) == null) {
				return;
			}
			target.removeEventListener(MouseEvent.ROLL_OVER, instance.showListener);
			target.removeEventListener(MouseEvent.ROLL_OUT, instance.hideListener);
			target.removeEventListener(MouseEvent.MOUSE_DOWN, instance.hideListener);			
			target.removeEventListener(MouseEvent.CLICK, instance.hideListener);
			target.removeEventListener(Event.ADDED_TO_STAGE, instance.stageListener);
			target.removeEventListener(Event.MOUSE_LEAVE, instance.hideListener);	
			if (instance.getProps(target) == instance.currentProps) {
				ToolTip.hide();
			}
			instance.removeTargetProps(target);
		}

		public function getLocalOptions():Object{
			return instance.options;
		}
		
		public function getDimensions():Object{
			return {width:tipWidth, height:tipHeight};
		}

		private function showListener(e:MouseEvent):void {
			if (e.buttonDown) {
				return;
			}			
			var target:DisplayObject = e.target as DisplayObject;		
			var props:Object = ToolTip.instance.getProps(target);
			if (props != null) {
				if (props.tootlip != "") {
					ToolTip.show(props.tooltip, props.options, target);
				}
			}
		}

		private function hideListener(e:Event):void {
			ToolTip.hide();
		}
		
		private function stageListener(e:Event):void {
			ToolTip.getInstance(e.target as DisplayObject);
			removeStageEvent();
		}

		protected function doShow(e:TimerEvent):void {
			if (stage == null) {
				return;
			}
			var localOptions:Object = currentProps.options;
			
			options = new Object();
			for (var i:String in globalOptions) {
				options[i] = localOptions == null || localOptions[i] === undefined ? globalOptions[i] : localOptions[i];
			}
			
			createText();
			placeTip()	
			
			if (background != null && contains(background)) {
				removeChild(background);
			}
			if (options.customBackground == null){
				drawBackground();
			}else {
				attachBackground();
			}
			addChild(background);
			addChild(tipText);
			
			stage.setChildIndex(this, stage.numChildren - 1);
			visible = true;
			
			if (options.followMouse && !options.fixedPosition) {
				addEventListener(Event.ENTER_FRAME, placeTip);
			}			
			animate();			
		}		
		
		protected function doHide():void {			
			removeEventListener(Event.ENTER_FRAME, placeTip);	
			removeEventListener(Event.ENTER_FRAME, fadeIn);				
			if (options && options.duration) {	
				addEventListener(Event.ENTER_FRAME, fadeOut);
			}else{
				visible = false;
			}
		}
		
		protected function createText():void {
			if (currentProps != null){
				var tooltip:String = currentProps.tooltip;
				if (tooltip == null) {
					return;
				}
			}
			
			if (tipText != null) {
				removeChild(tipText);
			}

			tipText = new TextField();
			autoEmbed();
			
			if (tooltip.indexOf("<tooltip") == -1){
				tooltip = "<tooltip>" + tooltip + "</tooltip>";
			}
			setStyles();
			tipText.htmlText = tooltip;	
			
			tipText.autoSize = "left";
			tipWidth = tipText.width+1;
			tipText.wordWrap = true;
			var ar:Array = ["marginRight", "marginLeft", "marginTop", "marginBottom"];
			for each (var m:String in ar) {
				if (options[m] == ToolTipSettings.MARGIN) {
					options[m] = options.margin;
				}
			}
			var margins:Number = options.marginLeft + options.marginRight;
			var marginsV:Number = options.marginTop + options.marginBottom;
			tipText.width = options.width - margins;
			if (!options.fixedWidth) {
				tipWidth = Math.min(tipWidth, tipText.width);
				tipText.width = tipWidth;				
			}	
			tipWidth += margins;
			tipHeight =  tipText.height + marginsV;	
			tipText.x = options.marginLeft;
			tipText.y = options.marginTop;
		}

		protected function autoEmbed():void {
			if (options.embedFonts) {
				var fonts:Array = Font.enumerateFonts();
				var families:Array = options.fontFamily.split(",");
				for (var i:int = 0; i < families.length; i++){
					var family:String = families[i];
					for each (var font:Font in fonts) {
							if (font.fontName == family) {
								tipText.embedFonts = true;
								options.fontFamily = family;							
								return;
							}
					}
				}
				tipText.embedFonts = false;
			}
			tipText.embedFonts = false;
		}

		protected function setStyles():void{			
			var style:StyleSheet;
			if (options.styleSheet is StyleSheet){
				style = options.styleSheet;
			} else {
				style = new StyleSheet ();
			}		
			var styleObj:Object = style.getStyle("tooltip");
			if (styleObj == null) {
				styleObj = new Object();
			}
			if (styleObj.color == null){
				if (options.color is String){
					styleObj.color = options.color;
				} else {
					var clr:String = options.color.toString(16);
					while (clr.length < 6){
						clr = "0" + clr;
					}
					clr = "#" + clr;
					styleObj.color = clr;
				}
			}
			if (styleObj.fontFamily == null || tipText.embedFonts){
				styleObj.fontFamily = options.fontFamily;
			}
			if (styleObj.fontSize == null){
				styleObj.fontSize = options.fontSize.toString ();
			}
			if (styleObj.textAlign == null){
				styleObj.textAlign = options.textAlign;
			}
			if (styleObj.fontWeight == null) {
				styleObj.fontWeight = options.fontWeight;
			}
			if (styleObj.leading == null) {
				styleObj.leading = options.leading;
			}			
			style.setStyle ("tooltip", styleObj);	
			tipText.styleSheet = style;
		}

		protected function drawBackground():void {
			if (options.lineColor == ToolTipSettings.COLOR_TEXT) {
				options.lineColor = options.color;
			}
			
			if (options.shadowColor == ToolTipSettings.COLOR_TEXT) {
				options.shadowColor = options.color;
			}
			
			if (options.alpha){
				background = new Sprite();
				var rect:Shape = new Shape();
				rect.graphics.beginFill(options.backgroundColor, options.alpha);
				if (options.lineColor != ToolTipSettings.COLOR_NONE){
					rect.graphics.lineStyle(1, options.lineColor, options.alpha, true  );
				}
				rect.graphics.drawRoundRect(0, 0, tipWidth, tipHeight, options.corner, options.corner);
				if (options.shadowType != ToolTipSettings.SHADOW_NONE && options.shadowColor != ToolTipSettings.COLOR_NONE){
					var myFilter:DropShadowFilter = new DropShadowFilter ();
					myFilter.quality = 2;
					myFilter.alpha = options.alpha ;
					myFilter.distance = 2;
					myFilter.knockout = true;
					myFilter.color = options.shadowColor;
					if (options.shadowType == ToolTipSettings.SHADOW_HOLLOW){
						var shadow:Sprite = new Sprite();	
						shadow.graphics.beginFill(0x000000);
						shadow.graphics.drawRoundRect(0, 0, tipWidth, tipHeight, options.corner, options.corner);
						myFilter.knockout = true;
						shadow.filters = [myFilter];
						background.addChild(shadow);			
					} else if (options.shadowType == ToolTipSettings.SHADOW_FULL) {
						rect.filters = [myFilter];
					}
				}
				background.addChild(rect);

			}			
		}
		
		protected function attachBackground():void {
			background = new options.customBackground();
			background.width = tipWidth;
			background.height = tipHeight;
		}
		
		protected function placeTip(e:Event = null):void {
			var wmin:Number;
			var wmax:Number;
			var hmin:Number;
			var hmax:Number;
			
			if (options.boundingRect == ToolTipSettings.STAGE_RECT) {
				wmin = 0
				wmax = stage.stageWidth;
				hmin = 0
				hmax = stage.stageHeight;
			}else{
				wmin = options.boundingRect.x;
				wmax = options.boundingRect.x + options.boundingRect.width;
				hmin = options.boundingRect.y;
				hmax = options.boundingRect.y + options.boundingRect.height;
			}

			if (options.fixedPosition){
				x = options.offsetX;
				y = options.offsetY;
			} else {
				x = stage.mouseX + options.offsetX;
				y = stage.mouseY + options.offsetY;
				
				var r:Number = width + x;
				var l:Number = height + y;
				if (wmax < r) {
					x -= r - wmax;
					x = Math.max(wmin, x);
				}
				if (hmax < l) {
					y -= (height + options.offsetY);
					y = Math.max(hmin, y);
				}	
			}
		}
		
		protected function animate():void {
			removeEventListener(Event.ENTER_FRAME, fadeOut);
			if (options.duration){
				alpha = 0;					
				chunk = (1/stage.frameRate) / options.duration
				addEventListener(Event.ENTER_FRAME, fadeIn);
			}else{
				alpha = 1;
			}
		}
		
		private function addTargetProps(target:DisplayObject, tooltip:String = "", options:Object = null):void {			
			var props:Object = { target:target, tooltip:tooltip, options:options };
			keys[target] = props;
		}
		
		private function removeTargetProps(target:DisplayObject):void {
			delete keys[target];
		}		
		
		private function getProps(target:DisplayObject):Object {
			return keys[target];
		}
		
		private function setCurrentProps (tooltip:String = "", options:Object = null, target:DisplayObject = null):void {
				currentProps = { tooltip:tooltip, options:options, target:target};
		}
		
		private function resetDefaultOptions():void {
			globalOptions = new Object();
			for (var i:String in defOptions) {
				globalOptions[i] = defOptions[i];
			}	
		}
		
		private function removeStageEvent():void {
			for each (var props:Object in keys) {
				props.target.removeEventListener(Event.ADDED_TO_STAGE, stageListener);
			}
		}
		
		private function fadeIn(e:Event):void {			
			alpha += chunk;	
			if (alpha >= 1) {
				alpha = 1;
				removeEventListener(Event.ENTER_FRAME, fadeIn);
			}
		}
		
		private function fadeOut(e:Event):void {
			alpha -= chunk;
			if (alpha <= 0) {
				alpha = 0;
				visible = false;
				removeEventListener(Event.ENTER_FRAME, fadeOut);
			}
		}
	}
	
}
