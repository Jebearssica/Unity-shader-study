// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SimpleShader"
{
    SubShader{
			Pass{
				CGPROGRAM
				//告知vert函数包含了vertex shader的代码
				//告知frag函数包含了fragment shader的代码
				#pragma vertex vert
				#pragma fragment frag
				
				/*
				函数输入: v 包含了这个顶点的位置, 通过POSITION语义(semantics)进行定义
				函数输出: float4类型 SV_POSITION语义为裁剪空间的坐标
				*/
				float4 vert(float4 v:POSITION):SV_POSITION{
					return UnityObjectToClipPos(v);
				}
				/*
				函数输入: 无
				函数输出: fixed4类型 SV_TARGET语义为渲染目标的颜色
				*/
				fixed4 frag():SV_TARGET{
						return fixed4(1.0,1.0,1.0,1.0);
				}

				ENDCG
			}
	}
}
