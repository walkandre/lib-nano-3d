package nano.objects {
	
	import nano.geom.Vertex;
	import flash.display.Sprite;
	
	public class Object3D {
		public var container:Sprite;
		public var faceList:Array;
		public var vertexList:Array;
		public var positionAsVertex:Vertex;
		public var direction:Vertex;
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		private var _rotationX:Number = 0;
		private var _rotationY:Number = 0;
		private var _rotationZ:Number = 0;
		public var deltaAngleX:Number = 0;
		public var deltaAngleY:Number = 0;
		public var deltaAngleZ:Number = 0;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var scaleZ:Number = 1;
		
		public function Object3D() {
			faceList = [];
			vertexList = [];
			direction = new Vertex(1, 0, 0);
			positionAsVertex = new Vertex(0, 0, 0);
			vertexList.push(positionAsVertex);
		}
		
		public function set rotationX(angle:Number):void {
			deltaAngleX = angle - _rotationX;
			_rotationX = angle;
		}
		
		public function get rotationX():Number {
			return _rotationX;
		}
		
		public function set rotationY(angle:Number):void {
			deltaAngleY = angle - _rotationY;
			_rotationY = angle;
		}
		
		public function get rotationY():Number {
			return _rotationY;
		}
		
		public function set rotationZ(angle:Number):void {
			deltaAngleZ = angle - _rotationZ;
			_rotationZ = angle;
		}
		
		public function get rotationZ():Number {
			return _rotationZ;
		}
		
		public static function rad2deg(rad:Number):Number {
			return rad * (180 / Math.PI);
		}
		
		public static function deg2rad(deg:Number):Number {
			return deg * (Math.PI / 180);
		}
	}
}
