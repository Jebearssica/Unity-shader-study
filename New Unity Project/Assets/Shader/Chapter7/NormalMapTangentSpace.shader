Shader "Custom/Chapter7/NormalMapTangentSpace"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" { }
        //bump是Unity内置纹理
        _BumpMap ("Normal Map", 2D) = "bump" { }
        //控制凹凸程度
        _BumpScale ("Bump Scale", Float) = 1.0
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8.0, 256)) = 20
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            fixed4 _Specular;
            float _Gloss;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 tangent: TANGENT;
                float4 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                float4 uv: TEXCOORD0;
                float3 lightDir: TEXCOORD1;
                float3 viewDir: TEXCOORD2;
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(v.vertex);
                
                //使用了两个纹理就用一个float4存储两个uv坐标, 为了减少寄存器使用数量, 通常使用同一组纹理坐标
                output.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                output.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
                
                float3x3 worldToTangent = float3x3(worldTangent, worldBinormal, worldNormal);
                
                output.lightDir = mul(worldToTangent, ObjSpaceLightDir(v.vertex));
                output.viewDir = mul(worldToTangent, ObjSpaceViewDir(v.vertex));
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                fixed3 tangentLightDir = normalize(input.lightDir);
                fixed3 tangentViewDir = normalize(input.viewDir);
                
                fixed4 packedNormal = tex2D(_BumpMap, input.uv.zw);
                fixed3 tangentNormal;
                
                //纹理类型是Normal Map的反映射过程, 只需要反映射xy方向, z方向可以推导得出
                tangentNormal = UnpackNormal(packedNormal);
                tangentNormal.xy *= _BumpScale;
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));
                
                fixed3 albedo = tex2D(_MainTex, input.uv.xy).rgb * _Color.rgb;
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));
                
                fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
                
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(tangentNormal, halfDir)), _Gloss);
                
                return fixed4(ambient + diffuse + specular, 1.0);
            }
            
            ENDCG
            
        }
    }
    FallBack "Specular"
}
