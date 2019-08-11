Shader "Basics/RGB/HSV Cylinder" {
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
			  output.col = vertexPos +float4(0.5, 0.5, 0.5, 0.0);
			  // Here the vertex shader writes output data to the output structure. We add 0.5 to the 
			  // x, y, and z coordinates, because the coordinates of the cube are between -0.5 and
			  // 0.5 but we need them between 0.0 and 1.0. 
		   return output;
		}

		float4 frag(vertexOutput input) : COLOR // fragment shader
		{
			// RGB between 0.0 and 0.1
			float R = input.col.x;
			float G = input.col.y;
			float B = input.col.z;

			float max;
			if (R >= G && R >= B) { max = R; }
			else if (G >= R && G >= B) { max = G; }
			else if (B >= G && B >= R) { max = B; }

			float min;
			if (R <= G && R <= B) { min = R; }
			else if (G <= R && G <= B) { min = G; }
			else if (B <= G && B <= R) { min = B; }

			float delta = max - min;
			
			float H = 0.0;
			if (delta = 0) { H = 0.0; }
			//else if (max = R) { H = 60 * (((G-B) / delta) %6); }
			//else if (max = G) { H = 60 * (((B-R) / delta) +2); }
			//else if (max = B) { H = 60 * (((R-G) / delta) +4); }

			float S = 0.0;
			if (max != 0) { S = delta / max; }
			
			float V = max;

		   return float4(H,S,V,input.col.w);
	 }

	 ENDCG
   }
	}
}