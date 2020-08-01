Shader "Custom/Chapter7/MaskTexture"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" { }
        _BumpMap ("Normal Map", 2D) = "bump" { }
        _BumpScale ("Bump Scale", Float) = 1.0
        _SpecularMask ("Specular Mask", 2D) = "white" { }
        _SpecularScale ("Specular Sclae", Float) = 1.0
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
            //MainTex BumpMap SpecularMask共用一个
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float _BumpScale;
            sampler2D _SpecularMask;
            float _SpecularScale;
            fixed4 _Specular;
            float _Gloss;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 tangent: TANGENT;
                float4 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                float4 uv: TEXCOORD0;
                float3 lightDir: TEXCOORD1;
                float3 viewDir: TEXCOORD2;
            };
            
            v2f vert(a2v v)
            {
                v2f output;
                
                output.pos = UnityObjectToClipPos(v.vertex);
                output.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                
                // Declares 3x3 matrix 'rotation', filled with tangent space basis in "UnityCG.cginc"
                TANGENT_SPACE_ROTATION;
                output.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                output.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;
                
                return output;
            }
            
            fixed4 frag(v2f input): SV_TARGET
            {
                fixed3 tangentLightDir = normalize(input.lightDir);
                fixed3 tangentViewDir = normalize(input.viewDir);
                
                fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap, input.uv));
                tangentNormal.xy *= _BumpScale;
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));
                
                fixed3 albedo = tex2D(_MainTex, input.uv).rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));
                
                fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
                //通过r通道来控制高光反射强度
                fixed specularMask = tex2D(_SpecularMask, input.uv).r * _SpecularScale;
                
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(tangentNormal, halfDir)), _Gloss) * specularMask;
                
                return fixed4(ambient + diffuse + specular, 1.0);
            }
            
            ENDCG
            
        }
    }
    FallBack "Specular"
}
