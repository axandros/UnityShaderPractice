﻿Shader "Basic/Debugging/Debug7"
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
				output.col = float4(cross(input.normal, input.vertex.xyz), 1.0);

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