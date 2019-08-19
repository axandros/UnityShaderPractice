Shader "Lighting/SmoothSpecular"
{
	// Built from "Specular" in B
	Properties{
		_Color("Front Material Diffuse Color",Color) = (1,1,1,1)
		_SpecColor("Front Material Specular Color", Color) = (1,1,1,1)
		_Shininess("Front Material Shininess", Float) = 10
		_BackColor("Back Material Diffuse Color",Color) = (1,1,1,1)
		_BackSpecColor("Back Material Specular Color", Color) = (1,1,1,1)
		_BackShininess("Back Material Shininess", Float) = 10
	}

		Subshader{
		//-------------------
		// Render Front Faces
		Pass{
		// Make sure all uniforms are correctly set
		Tags { "Lightmode" = "ForwardBase"}
		Cull Back

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
	uniform float4 _BackColor;
	uniform float4 _BackSpecColor;
	uniform float _BackShininess;

	struct vertexInput {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 col : COLOR;
		float4 posWorld: TEXCOORD0;
		float3 normalDir: TEXCOORD1;
	};

	vertexOutput vert(vertexInput input)
	{
		vertexOutput output;

		float4x4 modelMatrix = unity_ObjectToWorld;
		float4x4 modelMatrixInverse = unity_WorldToObject;

		// output
		output.posWorld = mul(modelMatrix, input.vertex);
		output.normalDir = normalize(mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
		output.pos = UnityObjectToClipPos(input.vertex);
		return output;

	}

	float4 frag(vertexOutput input) : COLOR{


		float3 normalDirection = normalize(input.normalDir);	// N
		float3 viewDirection = normalize(_WorldSpaceCameraPos - input.posWorld.xyz);
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
			float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - input.posWorld.xyz;
			float distance = length(vertexToLightSource);
			attenuation = 1.0 / distance; // Linear Attenuation
			lightDirection = normalize(vertexToLightSource);
		}

		// Ambient Lighting
		float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;

		// I_Incoming * K_Diffuse * max(0,N*L)
		float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0,dot(normalDirection, lightDirection));

		float3 specularReflection;
		if (dot(normalDirection,lightDirection) < 0.0) {
			// The Light source is on the 'wrong side'
			specularReflection = float3(0.0, 0.0, 0.0);
		}
		else {
			// Light source is on the same side as the camera
			specularReflection = attenuation * _LightColor0.rgb * _SpecColor.rgb *
				pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);

		}
		
		return float4(ambientLighting + diffuseReflection + specularReflection,1.0);
	}
		ENDCG
	}
		Pass{
		// Make sure all uniforms are correctly set
		Tags { "Lightmode" = "ForwardAdd"}
		Cull Back
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
	uniform float4 _BackColor;
	uniform float4 _BackSpecColor;
	uniform float _BackShininess;

	struct vertexInput {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 col : COLOR;
		float4 posWorld: TEXCOORD0;
		float3 normalDir: TEXCOORD1;
	};

	vertexOutput vert(vertexInput input)
	{
		vertexOutput output;

		float4x4 modelMatrix = unity_ObjectToWorld;
		float4x4 modelMatrixInverse = unity_WorldToObject;

		// output
		output.posWorld = mul(modelMatrix, input.vertex);
		output.normalDir = normalize(mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
		output.pos = UnityObjectToClipPos(input.vertex);
		return output;

	}

	float4 frag(vertexOutput input) : COLOR{


		float3 normalDirection = normalize(input.normalDir);	// N
		float3 viewDirection = normalize(_WorldSpaceCameraPos - input.posWorld.xyz);
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
			float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - input.posWorld.xyz;
			float distance = length(vertexToLightSource);
			attenuation = 1.0 / distance; // Linear Attenuation
			lightDirection = normalize(vertexToLightSource);
		}
		
		// I_Incoming * K_Diffuse * max(0,N*L)
		float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0,dot(normalDirection, lightDirection));

		float3 specularReflection;
		if (dot(normalDirection,lightDirection) < 0.0) {
			// The Light source is on the 'wrong side'
			specularReflection = float3(0.0, 0.0, 0.0);
		}
		else {
			// Light source is on the same side as the camera
			specularReflection = attenuation * _LightColor0.rgb * _SpecColor.rgb *
				pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);

		}

		return float4(diffuseReflection + specularReflection,1.0);
	}
		ENDCG

	}

		//-------------------
		// Render Back Faces
		
		Pass{
		// Make sure all uniforms are correctly set
		Tags { "Lightmode" = "ForwardBase"}
		Cull Front

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
	uniform float4 _BackColor;
	uniform float4 _BackSpecColor;
	uniform float _BackShininess;

	struct vertexInput {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 col : COLOR;
		float4 posWorld: TEXCOORD0;
		float3 normalDir: TEXCOORD1;
	};

	vertexOutput vert(vertexInput input)
	{
		vertexOutput output;

		float4x4 modelMatrix = unity_ObjectToWorld;
		float4x4 modelMatrixInverse = unity_WorldToObject;

		// output
		output.posWorld = mul(modelMatrix, input.vertex);
		output.normalDir = normalize(mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
		output.pos = UnityObjectToClipPos(input.vertex);
		return output;

	}

	float4 frag(vertexOutput input) : COLOR{


		float3 normalDirection =- normalize(input.normalDir);	// N
		float3 viewDirection = normalize(_WorldSpaceCameraPos - input.posWorld.xyz);
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
			float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - input.posWorld.xyz;
			float distance = length(vertexToLightSource);
			attenuation = 1.0 / distance; // Linear Attenuation
			lightDirection = normalize(vertexToLightSource);
		}

		// Ambient Lighting
		float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _BackColor.rgb;

		// I_Incoming * K_Diffuse * max(0,N*L)
		float3 diffuseReflection = attenuation * _LightColor0.rgb * _BackColor.rgb * max(0.0,dot(normalDirection, lightDirection));

		float3 specularReflection;
		if (dot(normalDirection,lightDirection) < 0.0) {
			// The Light source is on the 'wrong side'
			specularReflection = float3(0.0, 0.0, 0.0);
		}
		else {
			// Light source is on the same side as the camera
			specularReflection = attenuation * _LightColor0.rgb * _BackSpecColor.rgb *
				pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _BackShininess);

		}

		return float4(ambientLighting + diffuseReflection + specularReflection,1.0);
	}
		ENDCG
	}
		Pass{
		// Make sure all uniforms are correctly set
		Tags { "Lightmode" = "ForwardAdd"}
		Cull Front
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
	uniform float4 _BackColor;
	uniform float4 _BackSpecColor;
	uniform float _BackShininess;

	struct vertexInput {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 col : COLOR;
		float4 posWorld: TEXCOORD0;
		float3 normalDir: TEXCOORD1;
	};

	vertexOutput vert(vertexInput input)
	{
		vertexOutput output;

		float4x4 modelMatrix = unity_ObjectToWorld;
		float4x4 modelMatrixInverse = unity_WorldToObject;

		// output
		output.posWorld = mul(modelMatrix, input.vertex);
		output.normalDir = normalize(mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
		output.pos = UnityObjectToClipPos(input.vertex);
		return output;

	}

	float4 frag(vertexOutput input) : COLOR{


		float3 normalDirection = -normalize(input.normalDir);	// N
		float3 viewDirection = normalize(_WorldSpaceCameraPos - input.posWorld.xyz);
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
			float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - input.posWorld.xyz;
			float distance = length(vertexToLightSource);
			attenuation = 1.0 / distance; // Linear Attenuation
			lightDirection = normalize(vertexToLightSource);
		}

		// I_Incoming * K_Diffuse * max(0,N*L)
		float3 diffuseReflection = attenuation * _LightColor0.rgb * _BackColor.rgb * max(0.0,dot(normalDirection, lightDirection));

		float3 specularReflection;
		if (dot(normalDirection,lightDirection) < 0.0) {
			// The Light source is on the 'wrong side'
			specularReflection = float3(0.0, 0.0, 0.0);
		}
		else {
			// Light source is on the same side as the camera
			specularReflection = attenuation * _LightColor0.rgb * _BackSpecColor.rgb *
				pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _BackShininess);

		}

		return float4(diffuseReflection + specularReflection,1.0);
	}
		ENDCG
	} 
	}
		Fallback "Specular"
}

