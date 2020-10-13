Shader "Custom/Chapter10/Mirror"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" { }
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            sampler2D _MainTex;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                float2 uv: TEXCOORD0;
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(v.vertex);
                
                output.uv = v.texcoord;
                //向上翻转x
                output.uv.x = 1 - output.uv.x;
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                //没啥要计算的 直接输出
                return tex2D(_MainTex, input.uv);
            }
            
            ENDCG
            
        }
    }
    FallBack Off
}
