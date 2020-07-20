Shader "Custom/Chapter6/HalfLambert"
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
                float3 worldNormal: TEXCOORD0;
            };
            
            //顶点着色器无需光照计算, 只需要给片元着色器顶点法线
            v2f vert(a2v v)
            {
                v2f output;
                //输出坐标世界空间坐标转到裁切空间坐标
                output.pos = UnityObjectToClipPos(v.vertex);
                
                //顶点法线从a2v中的模型空间转换至世界空间, 传递给片元着色器需要的顶点法线
                output.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                
                return output;
            }
            
            //片元着色器进行光照计算(获取信息与逐顶点光照的信息相同)
            fixed4 frag(v2f input): SV_TARGET
            {
                //得到环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //得到世界空间下顶点向量(即表面向量)
                fixed3 worldNormal = normalize(input.worldNormal);
                //得到世界空间下的光源向量
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                
                //计算漫反射, 使用半兰伯特模型
                fixed3 halfLambert = dot(worldNormal, worldLight) * 0.5 + 0.5;
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert;
                //颜色更新
                fixed3 color = ambient + diffuse;
                
                return fixed4(color, 1.0);
            }
            
            ENDCG
            
        }
    }
    //Unity Shaderh回调shader设置为diffuse
    FallBack "Diffuse"
}
