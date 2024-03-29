package nano.geom {
	
	import nano.material.Material;
	import nano.objects.Object3D;
	
	public class Face {
		
		public var meshRef:Object3D;
		public var material:Material;
		public var v1:Vertex;
		public var v2:Vertex;
		public var v3:Vertex;
		public var vertexList:Array;
		public var uvMap:Array;
		
		public function Face(meshRef:Object3D, v1:Vertex, v2:Vertex, v3:Vertex, material:Material = null, uvMap:Array = null) {
			this.meshRef = meshRef;
			this.v1 = v1;
			this.v2 = v2;
			this.v3 = v3;
			this.material = material;
			this.uvMap = uvMap;
			vertexList = [v1, v2, v3];
		}
	}
}
