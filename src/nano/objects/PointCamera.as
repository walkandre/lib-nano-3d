package nano.objects {
	
	import nano.objects.Object3D;
	
	public class PointCamera extends Object3D {
		public var fl:Number = 250;
		public var zOffset:Number = 100;
		public var vpX:Number;
		public var vpY:Number;
		public function PointCamera(screenW:Number, screenH:Number){
			vpX = screenW / 2;
			vpY = screenH / 2;
		}
	}
}