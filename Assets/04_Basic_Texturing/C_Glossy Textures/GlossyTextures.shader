Shader "Custom/LitTexture"
{
	Properties
	{
		_MainTex("Texture for Diffuse Material Color", 2D) = "white" {}
		_Color("Overall Diffuse Color Filter", Color) = (1,1,1,1)
		_SpecColor("Specular Material Color", Color) = (1,1,1,1)
		_Shininess("Shininess", Float) = 10
	}
		SubShader
		{
			 Pass{
				Tags { "LightMode" = "ForwardBase"}
			CGPROGRAM


	#include "UnityCG.cginc"

	#pragma vertex vert
	#pragma fragment frag

			// color of light source
				uniform float4 _LightColor0;

		// Property Definitions
		uniform sampler2D _MainTex;
		uniform float4 _Color;
		uniform float4 _SpecColor;
		uniform float _Shininess;

	struct vertexInput {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
		float4 texcoord : TEXCOORD0;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 tex : TEXCOORD0;
		float3 diffuseColor : TEXCOORD1;
		float3 specularColor : TEXCOORD2;
	};

	vertexOutput vert(vertexInput input) {
		vertexOutput output;

		float4x4 modelMatrix = unity_ObjectToWorld;
		float4x4 modelMatrixInverse = unity_WorldToObject;

		float3 normalDirection = normalize(mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);	// N
		float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(modelMatrix, input.vertex).xyz);
		float3 lightDirection;
		float attenuation;

		// L
		if (_WorldSpaceLightPos0.w == 0.0) {
			// Directional Light
			attenuation = 1.0;
			lightDirection = normalize(_WorldSpaceLightPos0.xyz);
		}
		else {
			// Point/Spot Light
			float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(modelMatrix, input.vertex).xyz;
			float distance = length(vertexToLightSource);
			attenuation = 1.0 / distance; // Linear Attenuation
			lightDirection = normalize(vertexToLightSource);
		}

		// Ambient Lighting
		float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;

		// I_Incoming * K_Diffuse * max(0,N*L)
		float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));

		float3 specularReflection;
		if (dot(normalDirection, lightDirection) < 0.0) {
			// The Light source is on the 'wrong side'
			specularReflection = float3(0.0, 0.0, 0.0);
		}
		else {
			// Light source is on the same side as the camera
			// TODO: Break down specular highlights equation to make it easier to read.
			specularReflection = attenuation * _LightColor0.rgb * _SpecColor.rgb *
				pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
		}


		// output
		output.diffuseColor = ambientLighting + diffuseReflection;
		output.specularColor = specularReflection;
		output.tex = input.texcoord;
		output.pos = UnityObjectToClipPos(input.vertex);
		return output;
	}
	float4 frag(vertexOutput input) : COLOR{
		return float4(input.specularColor + input.diffuseColor * tex2D(_MainTex, input.tex.xy),1.0);
}

	ENDCG
}
			Pass{
				Tags { "LightMode" = "ForwardAdd"}
				Blend One One // Additive Blending
			CGPROGRAM


	#include "UnityCG.cginc"

	#pragma vertex vert
	#pragma fragment frag

	// color of light source
		uniform float4 _LightColor0;

// Property Definitions
uniform sampler2D _MainTex;
uniform float4 _Color;
uniform float4 _SpecColor;
uniform float _Shininess;

struct vertexInput {
	float4 vertex : POSITION;
	float3 normal : NORMAL;
	float4 texcoord : TEXCOORD0;
};
struct vertexOutput {
	float4 pos : SV_POSITION;
	float4 tex : TEXCOORD0;
	float3 diffuseColor : TEXCOORD1;
	float3 specularColor : TEXCOORD2;
};

vertexOutput vert(vertexInput input) {
	vertexOutput output;

	float4x4 modelMatrix = unity_ObjectToWorld;
	float4x4 modelMatrixInverse = unity_WorldToObject;

	float3 normalDirection = normalize(mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);	// N
	float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(modelMatrix, input.vertex).xyz);
	float3 lightDirection;
	float attenuation;

	// L
	if (_WorldSpaceLightPos0.w == 0.0) {
		// Directional Light
		attenuation = 1.0;
		lightDirection = normalize(_WorldSpaceLightPos0.xyz);
	}
	else {
		// Point/Spot Light
		float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(modelMatrix, input.vertex).xyz;
		float distance = length(vertexToLightSource);
		attenuation = 1.0 / distance; // Linear Attenuation
		lightDirection = normalize(vertexToLightSource);
	}

	// Ambient Lighting
	float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;

	// I_Incoming * K_Diffuse * max(0,N*L)
	float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));

	float3 specularReflection;
	if (dot(normalDirection, lightDirection) < 0.0) {
		// The Light source is on the 'wrong side'
		specularReflection = float3(0.0, 0.0, 0.0);
	}
	else {
		// Light source is on the same side as the camera
		// TODO: Break down specular highlights equation to make it easier to read.
		specularReflection = attenuation * _LightColor0.rgb * _SpecColor.rgb *
			pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
	}


	// output
	output.diffuseColor = ambientLighting + diffuseReflection;
	output.specularColor = specularReflection;
	output.tex = input.texcoord;
	output.pos = UnityObjectToClipPos(input.vertex);
	return output;
}
float4 frag(vertexOutput input) : COLOR{
	return float4(input.specularColor + input.diffuseColor * tex2D(_MainTex, input.tex.xy),1.0);
}

	ENDCG
}
		}
			FallBack "Unlit/Texture"
}
