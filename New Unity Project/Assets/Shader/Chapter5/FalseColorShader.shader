Shader "Custom/Chapter5/FalseColorShader"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos:SV_POSITION;
                fixed4 color:COLOR0;
            };

            v2f vert(appdata_full v)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(v.vertex);
                // //可视化法线
                // output.color = fixed4(v.normal * 0.5 + fixed3(0.5,0.5,0.5),1.0);
                // //可视化切线
                // output.color = fixed4(v.tangent * 0.5 + fixed3(0.5,0.5,0.5),1.0);
                //可视化副切线方向
                fixed3 binormal = cross(v.normal, v.tangent.xyz)*v.tangent.w;
                output.color = fixed4(binormal*0.5+fixed3(0.5,0.5,0.5),1.0);
                // //可视化第一组纹理坐标
                // output.color = fixed4(v.texcoord.xy,0.0,1.0);
                // //可视化第二组纹理坐标
                // output.color = fixed4(v.texcoord1.xy,0.0,1.0);
                // //可视化第一组纹理坐标的小数部分
                // output.color = frac(v.texcoord);
                // if(any(saturate(v.texcoord)-v.texcoord))
                // {
                //     output.color.b = 0.5;
                // }
                // output.color.a = 1.0;
                // //可视化第二组纹理坐标的小数部分
                // output.color = frac(v.texcoord1);
                // if(any(saturate(v.texcoord1)-v.texcoord1))
                // {
                //     output.color.b = 0.5;
                // }
                // output.color.a = 1.0;
                // //可视化顶点颜色
                // output.color = v.color;

                return output;
            }

            fixed4 frag(v2f input):SV_TARGET
            {
                return input.color;
            }

            ENDCG

        }
    }
}
