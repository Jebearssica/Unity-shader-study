Shader "Custom/Chapter8/AlphaBlendBothSide"
{
    Properties
    {
        _Color ("Main Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" { }
        _AlphaScale ("Alpha Scale", Range(0, 1)) = 1
    }
    SubShader
    {
        //RenderType常用于着色器替换, IgnoreProjector表示不会受到投影器(Projection)影响
        //标签改为Transparent, 用于实现透明度混合
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
        
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            //先渲染背面, 剔除证明
            Cull Front
            
            //需要在Pass中设置混合状态
            //关闭深度写入 源颜色混合因子设为SrcAlpha 目标颜色混合因子设为OneMinusSrcAlpha
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _AlphaScale;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                float3 worldNormal: TEXCOORD0;
                float3 worldPos: TEXCOORD1;
                float2 uv: TEXCOORD2;
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                
                output.pos = UnityObjectToClipPos(v.vertex);
                output.worldNormal = UnityObjectToWorldNormal(v.normal);
                output.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                output.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                fixed3 worldNormal = normalize(input.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(input.worldPos));
                
                fixed4 texColor = tex2D(_MainTex, input.uv);
                
                
                fixed3 albedo = texColor.rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));
                //修改混合后的透明度
                return fixed4(ambient + diffuse, texColor.a * _AlphaScale);
            }
            
            ENDCG
            
        }
        
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            Cull Back
            
            //需要在Pass中设置混合状态
            //关闭深度写入 源颜色混合因子设为SrcAlpha 目标颜色混合因子设为OneMinusSrcAlpha
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _AlphaScale;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                float3 worldNormal: TEXCOORD0;
                float3 worldPos: TEXCOORD1;
                float2 uv: TEXCOORD2;
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                
                output.pos = UnityObjectToClipPos(v.vertex);
                output.worldNormal = UnityObjectToWorldNormal(v.normal);
                output.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                output.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                fixed3 worldNormal = normalize(input.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(input.worldPos));
                
                fixed4 texColor = tex2D(_MainTex, input.uv);
                
                
                fixed3 albedo = texColor.rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));
                //修改混合后的透明度
                return fixed4(ambient + diffuse, texColor.a * _AlphaScale);
            }
            
            ENDCG
            
        }
    }
    //修改Fallback
    Fallback "Transparent/VertexLit"
}
