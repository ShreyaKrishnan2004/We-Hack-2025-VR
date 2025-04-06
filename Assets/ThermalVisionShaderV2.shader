Shader "Unlit/ThermalVisionShaderV2"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                return OUT;
            }

            // Converts brightness to thermal color
            float4 ThermalColor(float luminance)
            {
                float4 color;

                if (luminance < 0.25)
                    color = lerp(float4(0, 0, 1, 1), float4(0, 1, 1, 1), luminance * 4); // Blue to Cyan
                else if (luminance < 0.5)
                    color = lerp(float4(0, 1, 1, 1), float4(0, 1, 0, 1), (luminance - 0.25) * 4); // Cyan to Green
                else if (luminance < 0.75)
                    color = lerp(float4(0, 1, 0, 1), float4(1, 1, 0, 1), (luminance - 0.5) * 4); // Green to Yellow
                else
                    color = lerp(float4(1, 1, 0, 1), float4(1, 0, 0, 1), (luminance - 0.75) * 4); // Yellow to Red

                return color;
            }

            float4 frag(Varyings IN) : SV_Target
            {
                float4 texColor = tex2D(_MainTex, IN.uv);

                // Convert to grayscale (luminance)
                float luminance = dot(texColor.rgb, float3(0.299, 0.587, 0.114));

                // Boost contrast for better thermal mapping
                luminance = saturate((luminance - 0.5) * 2 + 0.5);


                return ThermalColor(luminance);
            }
            ENDHLSL
        }
    }
}