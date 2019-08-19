Shader "Lighting/Specular/Specular"
{
	// Built from "Attennuation" an A
	Properties{
		_Color("Diffuse Material Color",Color) = (1,1,1,1)
		_SpecColor("Specular Material Color", color) = (1,1,1,1)
		_Shininess ("Shhininess", Float) = 10
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

	//Define shader property
	uniform float4 _Color; 
	uniform float4 _SpecColor;
	uniform float _Shininess;

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
		float3 normalDirection = normalize(	mul(input.normal, modelMatrixInverse)	);	// N
		float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(modelMatrix, input.vertex).xyz);
		float3 lightDirection;
		float attenuation;
		
		// L
		if (_WorldSpaceLightPos0.w == 0.0) {
			// Directional Light
			attenuation = 0.0;
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
		float3 diffuseReflection = _LightColor0.rgb * _Color.rgb * max(0.0,dot(normalDirection, lightDirection));

		float3 specularReflection;
		if (dot(normalDirection,lightDirection) < 0.0) {
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
		output.col = float4(ambientLighting + diffuseReflection + specularReflection, 1.0);
		output.pos = UnityObjectToClipPos(input.vertex);
		return output;
	}

	float4 frag(vertexOutput input) : COLOR{
		return input.col;
	}

		ENDCG

		}
		Pass{
		// Identical to previouss pass, exccept "ForwwardAdd" and Blend
		// And Removed AmbientLighting
	Tags{ "Lightmode" = "ForwardAdd" }
	Blend One One


	CGPROGRAM
	#pragma vertex vert
	#pragma	fragment frag

	#include "UnityCG.cginc"

		//Color Light Source (From Lighting.cginc)
	uniform float4 _LightColor0;

	//Define shader property
	uniform float4 _Color;
	uniform float4 _SpecColor;
	uniform float _Shininess;

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
		float3 normalDirection = normalize(mul(input.normal, modelMatrixInverse));	// N
		float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(modelMatrix, input.vertex).xyz);
		float3 lightDirection;
		float attenuation;

		// L
		if (_WorldSpaceLightPos0.w == 0.0) {
			// Directional Light
			attenuation = 0.0;
			lightDirection = normalize(_WorldSpaceLightPos0.xyz);
		}
		else {
			// Point/Spot Light
			float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(modelMatrix, input.vertex).xyz;
			float distance = length(vertexToLightSource);
			attenuation = 1.0 / distance; // Linear Attenuation
			lightDirection = normalize(vertexToLightSource);
		}

		// I_Incoming * K_Diffuse * max(0,N*L)
		float3 diffuseReflection = _LightColor0.rgb * _Color.rgb * max(0.0,dot(normalDirection, lightDirection));

		float3 specularReflection;
		if (dot(normalDirection,lightDirection) < 0.0) {
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
		output.col = float4(diffuseReflection + specularReflection, 1.0);
		output.pos = UnityObjectToClipPos(input.vertex);
		return output;
	}

	float4 frag(vertexOutput input) : COLOR{
		return input.col;
	}

		ENDCG

	}
	}

		Fallback "Specular"
}

