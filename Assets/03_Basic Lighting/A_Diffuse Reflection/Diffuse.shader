Shader "Lighting/Diffuse/Diffuse"
{
	Properties{
		_Color("Diffuse Material Color",Color) = (1,1,1,1)
	}

		Subshader{
			Pass {
		// Make sure all uniforms are correctly set
		Tags { "Lightmode" = "ForwardBase"}

	CGPROGRAM
	#pragma vertex vert
	#pragma	fragment frag

	#include "UnityCG.cginc"

		//Color Light Source (From Lighting.cginc)
	uniform float4 _LightColor0;

	uniform float4 _Color; //Define shhader property

	struct vertexInput {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 col : COLOR;
	};

	vertexOutput vert(vertexInput input)
	{
		vertexOutput output;

		float4x4 modelMatrix = unity_ObjectToWorld;
		float4x4 modelMatrixInverse = unity_WorldToObject;

		// N = |a| * |b|
		float3 normalDirection = normalize(
			mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);

		// L
		float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

		// I_Incoming * K_Diffuse * max(0,N*L)
		float3 diffuseReflection = _LightColor0.rgb * _Color.rgb * max(0.0,dot(normalDirection, lightDirection));
		
		// output
		output.col = float4(diffuseReflection, 1.0);
		output.pos = UnityObjectToClipPos(input.vertex);
		return output;
	}

	float4 frag(vertexOutput input) : COLOR{
		return input.col;
	}

		ENDCG

		}
	}
	Fallback "Diffuse"
}
