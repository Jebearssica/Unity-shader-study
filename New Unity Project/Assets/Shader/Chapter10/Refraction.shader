Shader "Custom/Chapter10/Refraction"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _RefractionColor ("Refraction Color", Color) = (1, 1, 1, 1)
        _RefractionAmout ("Refraction Amout", Range(0, 1)) = 1
        _RefractionRatio ("Refraction Ratio", Range(0.1, 1)) = 0.5
        _Cubemap ("Refraction Cubemap", Cube) = "_Skybox" { }
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            
            #pragma multi_compile_fwdbase
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            fixed4 _Color;
            fixed4 _RefractionColor;
            fixed _RefractionAmout;
            fixed _RefractionRatio;
            samplerCUBE _Cubemap;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                float3 worldPos: TEXCOORD0;
                fixed3 worldNormal: TEXCOORD1;
                fixed3 worldViewDir: TEXCOORD2;
                //计算世界空间中光线折射方向
                fixed3 worldRefraction: TEXCOORD3;
                SHADOW_COORDS(4)
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(v.vertex);
                output.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                output.worldNormal = UnityObjectToWorldNormal(v.normal);
                output.worldViewDir = UnityWorldSpaceViewDir(output.worldPos);
                
                output.worldRefraction = refract(-normalize(output.worldViewDir), normalize(output.worldNormal), _RefractionRatio);
                
                TRANSFER_SHADOW(output);
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                fixed3 worldNormal = normalize(input.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(input.worldPos));
                fixed3 worldViewDir = normalize(input.worldViewDir);
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                fixed3 diffuse = _LightColor0.rgb * _Color.rgb * saturate(dot(worldNormal, worldLightDir));
                
                fixed3 refraction = texCUBE(_Cubemap, input.worldRefraction).rgb * _RefractionColor.rgb;
                
                UNITY_LIGHT_ATTENUATION(attenuation, input, input.worldPos);
                
                fixed3 color = ambient + lerp(diffuse, refraction, _RefractionAmout) * attenuation;
                
                return fixed4(color, 1.0);
            }
            
            ENDCG
            
        }
    }
    Fallback "Reflective/VertexLit"
}
