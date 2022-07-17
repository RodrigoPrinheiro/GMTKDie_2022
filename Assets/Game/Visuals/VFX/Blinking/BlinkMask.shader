Shader "Hidden/BlinkMask"
{
    Properties
    {
        _MainTex("Alpha Texture", 2D) = "white" {}
        [MainColor]_Color ("Main Color", Color) = (0, 0, 0, 0)
        _VignettePower ("Power", Float) = 1
        _VignetteSize ("Size", Float) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float _VignettePower;
            float _VignetteSize;
            fixed4 _Color;
            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 polarUV = i.uv + float2(0.5, 0.5);
                float d = sqrt(pow(i.uv.x - 0.5, 2.0) + pow(i.uv.y - 0.5, 2.0) * 2);
                d *= _VignetteSize * d;
                d = pow(d, _VignettePower);

                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                col.a *= d;
                return col;
            }
            ENDCG
        }
    }
}
