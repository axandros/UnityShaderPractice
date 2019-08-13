Shader "Basic/Debugging/Debug2"
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

				//output.pos = UnityObjectToClipPos(input.vertex);
				//output.col = input.vertex + float4(0.5, 0.5, 0.5, 0.0);

				output.pos = UnityObjectToClipPos(input.vertex);
				output.col = input.texcoord.zzzz;
					//input.texcoord + float4(0.5,0.5,0.5,0.0);
				//Feeding Z (0) into all slots
				// Why is z 0?
				// Comes in as a value between -0.5 and 0.5.
				// TexCoord only as X andd Y values (its a 2dd texture)

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				return input.col;
					/*float4(
					 0.0//input.col.x
					,1.0//input.col.y
					,0.0//input.col.z
					,1.0//input.col.w
					);*/
			}

		ENDCG
		}
	}
}