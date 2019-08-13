Shader "Basics/RGB/CMY cube" {
	SubShader{
	   Pass {
		  CGPROGRAM

		  #pragma vertex vert // vert function is the vertex shader 
		  #pragma fragment frag // frag function is the fragment shader

		  // for multiple vertex output parameters an output structure 
		  // is defined:
		  struct vertexOutput {
			 float4 pos : SV_POSITION;
			 float4 col : TEXCOORD0;
		  };

		  vertexOutput vert(float4 vertexPos : POSITION)
			  // vertex shader 
		   {
			  vertexOutput output; // we don't need to type 'struct' here
			  output.pos = UnityObjectToClipPos(vertexPos);
			  output.col = vertexPos + float4(0.5, 0.5, 0.5, 0.0);
			  // Here the vertex shader writes output data
			  // to the output structure. We add 0.5 to the 
			  // x, y, and z coordinates, because the 
			  // coordinates of the cube are between -0.5 and
			  // 0.5 but we need them between 0.0 and 1.0. 
		   return output;
		}

		float4 frag(vertexOutput input) : COLOR // fragment shader
		{
			float R = input.col.x;
			float G = input.col.y;
			float B = input.col.z;

			float max;
			if (R >= G && R >= B) { max = R; }
			else if (G >= R && G >= B) { max = G; }
			else if (B >= G && B >= R) { max = B; }
			float K = 1.0 - max;

			float C = (1 - R); //- K) / (1 - K);
			float M = (1 - G); //- K) / (1 - K);
			float Y = (1 - B); //- K) / (1 - K);

		   return float4(C,M,Y,input.col.w);
		   // Here the fragment shader returns the "col" input 
		   // parameter with semantic TEXCOORD0 as nameless
		   // output parameter with semantic COLOR.
	 }

	 ENDCG
   }
	}
}