Shader "Custom/DepthWrite" {
Properties {
		_DepthTex ("Depth Texture", 2D) = "white" {}
		_RenderedTex ("Rendered Image", 2D) = "white" {}
		_Near("Near clipping plane", Float) = 1
		_Far("Far clipping plane", Float) = 40
	}	
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct vertOut {
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
			};

			vertOut vert(appdata_base v) {
				vertOut o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord.xy;
				return o;
			}

			uniform sampler2D _DepthTex;
			uniform sampler2D _RenderedTex;
			uniform float4x4 _Perspective;	// The perspective projection of the Unity camera
			uniform float _Near;
			uniform float _Far;

			struct fout {
                    half4 color : COLOR;
                    float depth : DEPTH;
                };    
			
			
			fout frag( vertOut i ) {              
                    fout fo;

					// Read the depth from the depth texture
					float4 imageDepth4 = tex2D(_DepthTex, i.uv);
					float imageDepth = -imageDepth4.x;

					// Go back to clip space by computing the depth as the depth of the pixel from the camera
					float4 temp = float4(0, 0, (imageDepth * (_Far - _Near) - _Near) , 1);
					float4 clipSpace = mul(_Perspective, temp);
					
					// Carry out the perspective division and map into screen space (DirectX)					
					// We only care about z
					clipSpace.z /= clipSpace.w;
					clipSpace.z = 0.5*(clipSpace.z+1.0);
					float z = clipSpace.z;

					// Write out the pre-computed color and the correct depth.
					fo.color = tex2D(_RenderedTex, i.uv);
					fo.depth = z;
                    return fo;
                }
			
			

			

			ENDCG
		}
	}
}