// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Transparent_Surfaces/Transparency/Miltiplicative" {
	SubShader{
	   Tags { "Queue" = "Transparent" }
	   // draw after all opaque geometry has been drawn
	Pass {
	   Cull Off // draw front and back faces
	   ZWrite Off // don't write to depth buffer 
		  // in order not to occlude other objects
	   Blend Zero OneMinusSrcAlpha // multiplicative blending 
		  // for attenuation by the fragment's alpha

	   CGPROGRAM

	   #pragma vertex vert 
	   #pragma fragment frag

	   float4 vert(float4 vertexPos : POSITION) : SV_POSITION
	   {
		  return UnityObjectToClipPos(vertexPos);
	   }

	   float4 frag(void) : COLOR
	   {
		  return float4(1.0, 0.0, 0.0, 0.2);
	   }

	   ENDCG
	}
	}
}