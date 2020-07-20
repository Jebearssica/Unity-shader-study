Shader "Custom/Chapter6/BlinnPhong"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
        //控制高光反射颜色
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        //控制高光区域大小
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
            
            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                float3 worldNormal: TEXCOORD0;
                float3 worldPos: TEXCOORD1;
            };
            
            //只需要计算世界空间下的法线方向与顶点坐标, 并传递给片元着色器
            v2f vert(a2v v)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(v.vertex);
                //6.6 使用内置函数计算世界空间下的顶点法线
                output.worldNormal = UnityObjectToWorldNormal(v.vertex);
                output.worldPos = mul(unity_ObjectToWorld, v.vertex);
                
                return output;
            }
            
            //计算光照模型
            fixed4 frag(v2f input): SV_TARGET
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //顶点法线从a2v中的模型空间转换至世界空间
                fixed3 worldNormal = normalize(input.worldNormal);
                
                //光源方向, 只适用于场景中只有一个平行光源, 6.6使用内置函数实现
                fixed3 worldLight = normalize(UnityWorldSpaceLightDir(input.worldPos));
                //漫反射光
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
                
                //反射光线, 其中reflect函数入射方向的要求是光源指向交点
                fixed3 reflectDir = normalize(reflect(-worldLight, worldNormal));
                
                //视角方向, 6.6使用内置函数实现
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(input.worldPos));
                
                //
                fixed3 halfDir = normalize(worldLight + viewDir);
                
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
                
                return fixed4(ambient + diffuse + specular, 1.0);
            }
            
            ENDCG
            
        }
    }
    FallBack "Specular"
}
