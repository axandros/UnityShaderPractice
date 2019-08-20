Shader "Basic_Texturing/SingleTexture"
{
    Properties
    {
        _MainTex ("Texture Image", 2D) = "white" {}	
	}
		SubShader
	{
	 Pass{

		CGPROGRAM


#include "UnityCG.cginc"

#pragma vertex vert
#pragma fragment frag

		// Property Definitions
		uniform sampler2D _MainTex;
	uniform float4 _MainTex_ST;

	struct vertexInput {
		float4 vertex : POSITION;
		float4 texcoord : TEXCOORD0;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 tex : TEXCOORD0;
	};

	vertexOutput vert(vertexInput input) {
		vertexOutput output;

		// Unity provided lat/long 
		output.tex = input.texcoord;
		output.pos = UnityObjectToClipPos(input.vertex);
		return output;
	}
	float4 frag(vertexOutput input) : COLOR{
		// return pixel at position xy on _MainTex
		return tex2D(_MainTex
		//, _MainTex_ST.xy * input.tex.xy + _MainTex_ST.zw);
			,TRANSFORM_TEX(input.tex, _MainTex));
				// Alternative included in UnityCG.cginc
	}

		ENDCG
	}
    }
    FallBack "Unlit/Texture"
}
