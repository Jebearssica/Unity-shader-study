Shader "Custom/Chapter10/Fresnel"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _FresnelScale ("Fresnel Scale", Range(0, 1)) = 0.5
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
            fixed _FresnelScale;
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
                fixed3 worldRefl: TEXCOORD3;
                SHADOW_COORDS(4)
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(v.vertex);
                output.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                output.worldNormal = UnityObjectToWorldNormal(v.normal);
                output.worldViewDir = UnityWorldSpaceViewDir(output.worldPos);
                
                output.worldRefl = reflect(-output.worldViewDir, output.worldNormal);
                
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
                
                UNITY_LIGHT_ATTENUATION(attenuation, input, input.worldPos);
                
                fixed3 reflection = texCUBE(_Cubemap, input.worldRefl).rgb;
                fixed fresnel = _FresnelScale + (1 - _FresnelScale) * pow((1 - dot(worldViewDir, worldNormal)), 5);
                
                fixed3 color = ambient + lerp(diffuse, reflection, saturate(fresnel)) * attenuation;
                
                return fixed4(color, 1.0);
            }
            
            ENDCG
            
        }
    }
    Fallback "Reflective/VertexLit"
}
