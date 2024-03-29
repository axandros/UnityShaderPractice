﻿Shader "Basic/Debugging/Debu4"
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
				output.col =
					///input.texcoord;
					//float4(input.tangent.x, input.tangent.y, input.tangent.z, 0.0);
					//float4(input.normal.x, input.normal.y, input.normal.z,1.0);
					
					dot(input.normal, input.tangent.xyz) * input.texcoord;
					//the dot product is 0?

					//5 * input.texcoord;

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