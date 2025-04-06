Shader "Unlit/ThermalVisionHotspots"
{
    Properties
    {
        _MainTex("Video Texture", 2D) = "white" {}
        _NoiseScale("Noise Scale", Float) = 15
        _HotspotStrength("Hotspot Strength", Range(0, 1)) = 0.3
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

            float _Time; // auto-populated Unity built-in
            float _NoiseScale;
            float _HotspotStrength;

            float rand(float2 co)
            {
                return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
            }

            float hotspotNoise(float2 uv)
            {
                return rand(floor(uv * _NoiseScale + _Time * 10));
            }

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                return OUT;
            }

            float4 ThermalColor(float luminance)
            {
                float4 color;

                if (luminance < 0.25)
                    color = lerp(float4(0, 0, 1, 1), float4(0, 1, 1, 1), luminance * 4); // Blue → Cyan
                else if (luminance < 0.5)
                    color = lerp(float4(0, 1, 1, 1), float4(0, 1, 0, 1), (luminance - 0.25) * 4); // Cyan → Green
                else if (luminance < 0.75)
                    color = lerp(float4(0, 1, 0, 1), float4(1, 1, 0, 1), (luminance - 0.5) * 4); // Green → Yellow
                else
                    color = lerp(float4(1, 1, 0, 1), float4(1, 0, 0, 1), (luminance - 0.75) * 4); // Yellow → Red

                return color;
            }

            float4 frag(Varyings IN) : SV_Target
            {
                float4 texColor = tex2D(_MainTex, IN.uv);

                // Basic grayscale (brightness)
                float luminance = dot(texColor.rgb, float3(0.299, 0.587, 0.114));

                // Add noise-based flickering only to bright areas
                float noise = hotspotNoise(IN.uv);
                float flicker = saturate(noise * step(0.7, luminance)); // only apply flicker if bright

                // Boost luminance with flicker
                luminance = saturate(luminance + flicker * _HotspotStrength);

                return ThermalColor(luminance);
            }
            ENDHLSL
        }
    }
}

