package nano.objects {
	
	import nano.geom.Face;
	import nano.geom.Vertex;
	import nano.material.Material;
	
	public class Mesh extends Object3D {
		public function Mesh(){
			super();
		}
		
		public function addFace(v1:Vertex, v2:Vertex, v3:Vertex, material:Material = null, uvList:Array = null):void {
			faceList.push(new Face(this, v1, v2, v3, material, uvList));
			if(!vertexInList(v1)) vertexList.push(v1);
			if(!vertexInList(v2)) vertexList.push(v2);
			if(!vertexInList(v3)) vertexList.push(v3);
		}
		
		public function vertexInList(v:Vertex):Boolean {
			for(var i:Number = 0;i < vertexList.length; i++){
				if(vertexList[i] == v) 
				{
					return true;
				}
			}
			return false;
		}
	}
}