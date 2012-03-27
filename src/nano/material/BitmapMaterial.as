package nano.material {
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	public class BitmapMaterial extends Material {
		
		protected var transformedTexture:BitmapData;
		protected var _ct:ColorTransform;
		protected var isDirty:Boolean;
		
		public function BitmapMaterial(texture:BitmapData = null, smoothed:Boolean = false, doubleSided:Boolean = false) {
			super(0xffffff, 1, doubleSided);
			this.texture = texture;
			this.smoothed = smoothed;
		}
		public function update():void {
			if (!_texture) return;
			isDirty = false;
			if (_alpha == 1 && _color == 0xffffff && _ct == null){
				if (transformedTexture && transformedTexture != _texture) transformedTexture.dispose();
				transformedTexture = _texture;
				return;
			}
			if (!transformedTexture || transformedTexture == _texture){
				transformedTexture = new BitmapData(_texture.width, _texture.height, true, 0);
			}else{
				transformedTexture.fillRect(transformedTexture.rect, 0);
			}
			transformedTexture.draw(_texture, new Matrix());
		}
		override public function get texture():BitmapData {
			if (isDirty) update();
			return transformedTexture; 
		}
		override public function set texture(value:BitmapData):void {
			if (_texture == value) return;
			super.texture = value;
			isDirty = true;
		}
	}
}