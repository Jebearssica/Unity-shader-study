// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/Chapter6/DiffuseVertexLevel"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
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
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                fixed3 color: COLOR;
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                //世界空间坐标转到裁切空间坐标
                output.pos = UnityObjectToClipPos(v.vertex);
                
                //环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                //顶点法线从a2v中的模型空间转换至世界空间
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                
                //光源方向, 只适用于场景中只有一个平行光源
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                /*
                漫反射公式
                其中_LightColor0是Unity内置提供给Pass模块处理光源的颜色与强度信息
                .并且要设置合适的LightMode标签才能
                法线与光源方向的点积需要同处一个坐标系下, 因此全部转换到世界坐标空间
                
                */
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
                
                //颜色更新
                output.color = ambient + diffuse;
                
                return output;
            }
            
            //片元着色器只需要直接输出颜色
            fixed4 frag(v2f input): SV_TARGET
            {
                return fixed4(input.color, 1.0);
            }
            
            ENDCG
            
        }
    }
    //Unity Shaderh回调shader设置为diffuse
    FallBack "Diffuse"
}
