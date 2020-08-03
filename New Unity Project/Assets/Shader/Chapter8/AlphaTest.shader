Shader "Custom/Chapter8/AlphaTest"
{
    Properties
    {
        _Color ("Main Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" { }
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
    }
    SubShader
    {
        //RenderType常用于着色器替换, IgnoreProjector表示不会受到投影器(Projection)影响
        //这三个标签是进行透明度测试常用的三个标签
        Tags { "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }
        
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
            fixed _Cutoff;
            
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
                
                //透明度测试
                clip(texColor.a - _Cutoff);
                
                fixed3 albedo = texColor.rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));
                return fixed4(ambient + diffuse, 1.0);
            }
            
            ENDCG
            
        }
    }
    Fallback "Transparent/Cutout/VertexLit"
}
