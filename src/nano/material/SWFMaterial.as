package nano.material {
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	public class SWFMaterial extends BitmapMaterial {
		
		public var swf:MovieClip;
		public var swfWidth:Number = 0;
		public var swfHeight:Number = 0;
		
		public function SWFMaterial(swf:MovieClip, smoothed:Boolean = false, doubleSided:Boolean = false) {
			this.swf = swf;
			super(null, smoothed, doubleSided);
		}
		
		override public function get texture():BitmapData {
			return _texture; 
		}
		
		override public function update():void {
			var w:Number = swfWidth > 0 ? swfWidth : swf.width;
			var h:Number = swfHeight > 0 ? swfHeight : swf.height;
			if(texture == null && w > 0 && h > 0){
				texture = new BitmapData(w, h, true, 0x00000000);
			}
			texture.fillRect(texture.rect, 0x00000000);
			texture.draw(swf, null, null, null, null, smoothed);
		}
	}
}