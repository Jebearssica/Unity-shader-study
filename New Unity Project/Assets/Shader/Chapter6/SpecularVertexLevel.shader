﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Chapter6/SpecularVertexLevel"
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
                float3 color: COLOR;
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(v.vertex);
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                //顶点法线从a2v中的模型空间转换至世界空间
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                
                //光源方向, 只适用于场景中只有一个平行光源
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                //漫反射光
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
                
                //反射光线, 其中reflect函数入射方向的要求是光源指向交点
                fixed3 reflectDir = normalize(reflect(-worldLight, worldNormal));
                
                //视角方向
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
                
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(dot(reflectDir, viewDir), _Gloss);
                
                output.color = ambient + diffuse + specular;
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                return fixed4(input.color, 1.0);
            }
            
            ENDCG
            
        }
    }
    FallBack "Specular"
}
