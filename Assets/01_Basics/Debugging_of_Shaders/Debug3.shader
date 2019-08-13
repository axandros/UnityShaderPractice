Shader "Basic/Debugging/Debug3"
{
	SubShader{
		Pass {
		CGPROGRAM
			#pragma vertex vert  
			#pragma fragment frag 
			#include "UnityCG.cginc"

			struct vertexOutput {
			float4 pos : SV_POSITION;
			float4 col : TEXCOORD0;
			};

			vertexOutput vert(appdata_full input)
			{
				vertexOutput output;

				output.pos = UnityObjectToClipPos(input.vertex);
				output.col = input.texcoord / tan(0.0);
				//Tan( 0 ) is 0
				// divide by 0 = 0, otherwise is undefined and would crash?

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				return input.col;
			}

		ENDCG
		}
	}
}