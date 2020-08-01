Shader "Custom/Chapter7/SingleTexture"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" { }
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
            /*
            针对纹理的第二个变量, 纹理名字_ST
            用于控制纹理的缩放(Scale)与平移(Translation)值
            其中xy储存缩放, zw储存偏移
            */
            float4 _MainTex_ST;
            fixed4 _Specular;
            float _Gloss;
            
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
                
                //实现方法output.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                output.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return output;
            }
            
            //计算光照模型
            fixed4 frag(v2f input): SV_TARGET
            {
                //顶点法线从a2v中的模型空间转换至世界空间
                fixed3 worldNormal = normalize(input.worldNormal);
                
                //光源方向, 只适用于场景中只有一个平行光源, 6.6使用内置函数实现
                fixed3 worldLight = normalize(UnityWorldSpaceLightDir(input.worldPos));
                
                //使用tex2D进行纹理采样, 将采样结果与颜色乘积做为材质反射率
                fixed3 albedo = tex2D(_MainTex, input.uv).rgb * _Color.rgb;
                
                //环境光, 经过纹理反射
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                //漫反射光, 同样经过纹理反射
                fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(worldNormal, worldLight));
                
                //视角方向, 6.6使用内置函数实现
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(input.worldPos));
                
                //避免计算反射光线的h向量
                fixed3 halfDir = normalize(worldLight + viewDir);
                
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
                
                return fixed4(ambient + diffuse + specular, 1.0);
            }
            ENDCG
            
        }
    }
    FallBack "Specular"
}
