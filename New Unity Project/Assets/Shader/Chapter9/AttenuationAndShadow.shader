// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

Shader "Custom/Chapter9/AttenuationAndShadow"
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
        Tags { "RenderType" = "Opaque" }
        
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            
            #pragma multi_compile_fwdbase
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            //引入新的内置文件, 用于接受阴影
            #include "AutoLight.cginc"
            
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
                //新增加一个内置宏, 用于阴影纹理采样的坐标
                //参数: 可用的插值寄存器索引值(0 1已被使用)
                SHADOW_COORDS(2)
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(v.vertex);
                output.worldNormal = UnityObjectToWorldNormal(v.normal);
                output.worldPos = mul(unity_ObjectToWorld, v.vertex);
                //将shadow信息通道传递给像素着色器
                TRANSFER_SHADOW(output);
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                fixed3 worldNormal = normalize(input.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
                
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(input.worldPos));
                
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, halfDir)), _Gloss);
                
                //平行光无衰减
                //修改为使用内置函数计算衰减
                UNITY_LIGHT_ATTENUATION(attenuation, input, input.worldPos);
                
                //添加阴影信息, 用于阴影映射纹理采样
                fixed shadow = SHADOW_ATTENUATION(input);
                
                return fixed4(ambient + (diffuse + specular) * attenuation * shadow, 1.0);
            }
            
            ENDCG
            
        }
        
        Pass
        {
            Tags { "LightMode" = "ForwardAdd" }
            
            Blend One One
            
            CGPROGRAM
            
            //更换编译指令, 以添加阴影效果
            #pragma multi_compile_fwdadd_fullshadows
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
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
            
            v2f vert(a2v v)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(v.vertex);
                output.worldNormal = UnityObjectToWorldNormal(v.normal);
                output.worldPos = mul(unity_ObjectToWorld, v.vertex);
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                fixed3 worldNormal = normalize(input.worldNormal);
                
                //根据不同类型的光源, 计算不同的光线方向
                #ifdef USING_DIRECTIONAL_LIGHT
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                #else
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - input.worldPos.xyz);
                #endif
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
                
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(input.worldPos));
                
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, halfDir)), _Gloss);
                
                //根据不同类型的光源, 计算不同的光线衰减
                // #ifdef USING_DIRECTIONAL_LIGHT
                //     fixed attenuation = 1.0;
                //     //通过查表节约时间
                // #else
                //     //将顶点坐标从世界空间转换到光源空间
                //     float3 lightCoord = mul(unity_WorldToLight, float4(input.worldPos, 1)).xyz;
                //     //使用模的平方进行采样, 避免了开方这种大消耗量的计算
                //     fixed attenuation = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
                // #endif
                //修改成内置函数计算衰减, 变量会在函数中自动被声明
                UNITY_LIGHT_ATTENUATION(attenuation, input, input.worldPos);
                
                //环境光只需要计算一次就行, 否则第二次环境光会进行一次覆盖影响效果
                return fixed4((diffuse + specular) * attenuation, 1.0);
            }
            
            ENDCG
            
        }
    }
    //指定回调内置的Specular, 会继续回调至VertexLit, 其中就有我们没有写的ShadowCaster的Pass, 因此阴影会正常产生
    Fallback "Specular"
}
