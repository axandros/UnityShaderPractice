Shader "Basic/Debugging/Debug1"
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
				output.col = input.texcoord -float4(1.5, 2.3, 1.1, 0.0);
					// drops values below 0
					// Does this clamp to 0? No

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				return //input.col;
					float4(
					 input.col.x + 1.5
					,input.col.y + 2.3
					,input.col.z + 1.1
					,input.col.w + 0.0
					);
			}

		ENDCG
		}
	}
}