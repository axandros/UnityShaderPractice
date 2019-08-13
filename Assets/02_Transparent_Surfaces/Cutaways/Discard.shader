// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Transparent_Surfaces/Cutawaays/Discard" {
	Properties{
		_Distance("Treshold", Float) = 0.0
		_Color("Color", Color) = (0.0, 1.0, 0.0, 1.0)
		_WorldSpace("WorldSpace", Range (0,1)) = 0
	}
		SubShader{
			Pass {
			  Cull Off // turn off triangle culling, alternatives are:
			  // Cull Back (or nothing): cull only back faces 
			  // Cull Front : cull only front faces

			  CGPROGRAM

				uniform float _Distance;
				uniform float4 _Color;
				uniform int _WorldSpace;

				#pragma vertex vert  
				#pragma fragment frag 
		
				struct vertexInput {
					float4 vertex : POSITION;
				};

				struct vertexOutput {
					float4 pos : SV_POSITION;
					float4 posInObjectCoords : TEXCOORD0;
					float4 position_in_world_space : TEXCOORD1;
				};

			vertexOutput vert(vertexInput input)
			{
				 vertexOutput output;
				 output.pos = UnityObjectToClipPos(input.vertex);
				 output.posInObjectCoords = input.vertex;
				 output.position_in_world_space = mul(unity_ObjectToWorld, input.vertex);

				 return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				if (_WorldSpace == 1)
				{
					//unity_ObjectToWorld
					if (input.position_in_world_space.y < _Distance)
					{
						discard; // drop the fragment if y coordinate > 0
					}
				}
				// Object Space - Tis will rotate with te object
				else if (input.posInObjectCoords.y > _Distance)
				{
					discard; // drop the fragment if y coordinate > 0
				}
			
				 return _Color; // green
			}
			ENDCG
		}
	}
}