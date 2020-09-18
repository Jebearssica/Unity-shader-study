Shader "Custom/BumpedDiffuse"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _BumpMap ("Normal Map", 2D) = "bump" { }
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
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            
            
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
                //切线空间转世界空间的矩阵, 本来转换矩阵是float3x3,
                //但是为了充分利用插值寄存器的空间 就改成float4
                float4 T2W0: TEXCOORD1;
                float4 T2W1: TEXCOORD2;
                float4 T2W2: TEXCOORD3;
                SHADOW_COORDS(4)
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                
                output.pos = UnityObjectToClipPos(v.vertex);
                output.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                output.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                
                //多余存储一个世界空间下的顶点坐标
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
                
                output.T2W0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                output.T2W1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                output.T2W2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
                
                TRANSFER_SHADOW(output);
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                fixed3 worldPos = float3(input.T2W0.w, input.T2W1.w, input.T2W2.w);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(worldPos));
                
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                
                //纹理类型是Normal Map的反映射过程, 只需要反映射xy方向, z方向可以推导得出
                fixed3 bump = UnpackNormal(tex2D(_BumpMap, input.uv.zw));
                bump = normalize(half3(dot(input.T2W0.xyz, bump), dot(input.T2W1.xyz, bump), dot(input.T2W2.xyz, bump)));
                
                fixed3 albedo = tex2D(_MainTex, input.uv.xy).rgb * _Color.rgb;
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(bump, worldLightDir));
                
                UNITY_LIGHT_ATTENUATION(attenuation, input, worldPos);
                
                return fixed4(ambient + diffuse * attenuation, 1.0);
            }
            ENDCG
            
        }
        
        Pass
        {
            Tags { "LightMode" = "ForwardAdd" }

            Blend One One
            CGPROGRAM
            
            #pragma multi_compile_fwdadd
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            
            
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
                //切线空间转世界空间的矩阵, 本来转换矩阵是float3x3,
                //但是为了充分利用插值寄存器的空间 就改成float4
                float4 T2W0: TEXCOORD1;
                float4 T2W1: TEXCOORD2;
                float4 T2W2: TEXCOORD3;
                SHADOW_COORDS(4)
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                
                output.pos = UnityObjectToClipPos(v.vertex);
                output.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                output.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                
                //多余存储一个世界空间下的顶点坐标
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
                
                output.T2W0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                output.T2W1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                output.T2W2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
                
                TRANSFER_SHADOW(output);
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                fixed3 worldPos = float3(input.T2W0.w, input.T2W1.w, input.T2W2.w);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(worldPos));
                
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                
                //纹理类型是Normal Map的反映射过程, 只需要反映射xy方向, z方向可以推导得出
                fixed3 bump = UnpackNormal(tex2D(_BumpMap, input.uv.zw));
                bump = normalize(half3(dot(input.T2W0.xyz, bump), dot(input.T2W1.xyz, bump), dot(input.T2W2.xyz, bump)));
                
                fixed3 albedo = tex2D(_MainTex, input.uv.xy).rgb * _Color.rgb;
                
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(bump, worldLightDir));
                
                UNITY_LIGHT_ATTENUATION(attenuation, input, worldPos);
                
                return fixed4(diffuse * attenuation, 1.0);
            }
            ENDCG
            
        }
    }
    FallBack "Diffuse"
}
