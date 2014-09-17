Shader "Custom/DepthVisualize" {
Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}	
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct vertOut {
				float4 pos:SV_POSITION;
				float2 depth:TEXCOORD0;
				float2 scrPos:TEXCOORD1;
				float2 rd:TEXCOORD2;
			};

			vertOut vert(appdata_base v) {
				vertOut o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				

				float4 mv = mul(UNITY_MATRIX_MV, v.vertex);
				
				o.scrPos = mv.xy;

				o.depth.x = mv.z;
				o.rd.x = (mv.z) * _ProjectionParams.w; // gives depth
				o.depth.y = mv.w;
				return o;
			}

			uniform sampler2D _MainTex;

			struct fout {
                    half4 color : COLOR;
                    float depth : DEPTH;
                };    
			
			fixed4 frag(vertOut i) : COLOR0 {

				float4 test = float4(0, 0, i.rd.x * 40.0f, 1);
				float4 clipSpace = mul(UNITY_MATRIX_P, test);
			    clipSpace.z /= clipSpace.w;
				


				float d = 1 - clipSpace.z;
				half4 depth = half4(d, d, d, 1);

			    return depth;
			} 

			

			ENDCG
		}
	}
}