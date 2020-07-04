// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SimpleShader"
{
    Properties
    {
        //声明一个Color类型的属性, 实现在材质面板上显示颜色拾取器
        _Color("Color Tint", Color)=(1.0,1.0,1.0,1.0)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            //告知vert函数包含了vertex shader的代码
            //告知frag函数包含了fragment shader的代码
            #pragma vertex vert
            #pragma fragment frag

            //在CG代码中, 需要定义一个与属性名称和类型都匹配的变量
            fixed4 _Color;

            //引入结构体来定义顶点着色器的输入 application to vertex
            struct a2v
            {
                //用顶点坐标填充vertex变量
                float4 vertex:POSITION;
                //用法线方向填充normal变量
                float3 normal:NORMAL;
                //用模型第一套纹理坐标填充texcoord变量
                float4 texcoord:TEXCOORD0;
            };

            //引入结构体定义顶点着色器的输出 vertex to fragment
            struct v2f
            {
                //pos包含裁剪空间的位置信息
                float4 pos:SV_POSITION;
                //存储颜色信息
                fixed3 color:COLOR0;
            };
            
            /*
            函数输入: v 包含了这个顶点的位置, 通过POSITION语义(semantics)进行定义
            函数输出: float4类型 SV_POSITION语义为裁剪空间的坐标
            修改: 不再进行输出 而是通过结构体进行输出 不再是SV_POSITION
            */
            v2f vert(a2v v)
            {
                v2f output;
                output.pos=UnityObjectToClipPos(v.vertex);
                //v.normal包含了法线方向,(-1,1), 将其映射到(0,1)
                output.color=v.normal*0.5+fixed3(0.5,0.5,0.5);
                return output;
            }
            /*
            函数输入: 无
            函数输出: fixed4类型 SV_TARGET语义为渲染目标的颜色
            */
            fixed4 frag(v2f i):SV_TARGET
            {
                fixed3 c = i.color;
                c *= _Color.rgb;
                return fixed4(c,1.0);
            }

            ENDCG
        }
    }
}
