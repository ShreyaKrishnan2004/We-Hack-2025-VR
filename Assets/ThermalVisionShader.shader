Shader "Custom/ThermalVision"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                float3 col = tex2D(_MainTex, i.uv).rgb;
                float luminance = dot(col, float3(0.299, 0.587, 0.114)); // grayscale

                // Map grayscale to thermal gradient
                float3 heatColor = lerp(float3(0, 0, 1), float3(1, 0, 0), luminance); // blue to red
                return float4(heatColor, 1);
            }
            ENDCG
        }
    }
}