Shader "Custom/Chapter10/GlassRefraction"
{
    Properties
    {
        _MainTex ("Main tex", 2D) = "white" { }
        _BumpMap ("Normal map", 2D) = "bump" { }
        _CubeMap ("Enviroment Cubemap", Cube) = "_Skybox" { }
        //折射图像扭曲程度
        _Distortion ("Distortion", Range(0, 100)) = 10
        //
        _RefractAmount ("Refract Amount", Range(0.0, 1.0)) = 1.0
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Opaque" }
        
        //截取
        GrabPass
        {
            "_RefractionTex"
        }
        
        pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            samplerCUBE _CubeMap;
            float _Distortion;
            fixed _RefractAmount;
            //纹理纹素大小
            sampler2D _RefractionTex;
            //用于采样坐标偏移
            float4 _RefractionTex_TextlSize;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 tangent: TANGENT;
                float2 texcoord: TEXCOORD;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                float4 srcPos: TEXCOORD0;
                float4 uv: TEXCOORD1;
                float4 T2W0: TEXCOORD2;
                float4 T2W1: TEXCOORD3;
                float4 T2W2: TEXCOORD4;
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                
                output.pos = UnityObjectToClipPos(v.vertex);
                output.srcPos = ComputeGrabScreenPos(output.pos);
                
                output.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                output.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);
                
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldTangent = UnityObjectToWorldNormal(v.tangent.xyz);
                fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
                
                output.T2W0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                output.T2W1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                output.T2W2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                float3 worldPos = float3(input.T2W0.w, input.T2W1.w, input.T2W2.w);
                fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                
                fixed3 bump = UnpackNormal(tex2D(_BumpMap, input.uv.zw));
                
                float2 offset = bump.xy * _Distortion * _RefractionTex_TextlSize.xy;
                input.srcPos.xy = offset +input.srcPos.xy;
                fixed3 refrCol = tex2D(_RefractionTex, input.srcPos.xy / input.srcPos.w).rgb;
                
                bump = normalize(half3(dot(input.T2W0.xyz, bump), dot(input.T2W1.xyz, bump), dot(input.T2W2.xyz, bump)));
                
                fixed3 reflDir = reflect(-worldViewDir, bump);
                fixed4 texColor = tex2D(_MainTex, input.uv.xy);
                fixed3 reflCol = texCUBE(_CubeMap, reflDir).rgb * texColor.rgb;
                
                fixed3 finalColor = reflCol * (1 - _RefractAmount) + reflCol * _RefractAmount;
                return fixed4(finalColor, 1);
            }
            ENDCG
            
        }
    }
    FallBack "Diffuse"
}
