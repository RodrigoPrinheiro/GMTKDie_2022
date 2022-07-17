// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/SpinFX"
{
	Properties
	{
		_FadeTex("Fade Tex", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.1
		_NoiseTex("Noise Tex", 2D) = "white" {}
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_SecondaryNoiseMask("Secondary Noise Mask", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 screenPos;
			float3 worldPos;
		};

		uniform float4 _EmissionColor;
		uniform sampler2D _FadeTex;
		uniform float4 _FadeTex_ST;
		uniform sampler2D _NoiseTex;
		uniform sampler2D _SecondaryNoiseMask;
		uniform float4 _SecondaryNoiseMask_ST;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;
		uniform float _Cutoff = 0.1;

		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) );
			float2 cameraRefraction = float2( refractionOffset.x, refractionOffset.y );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout half4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			float2 uv_FadeTex = i.uv_texcoord * _FadeTex_ST.xy + _FadeTex_ST.zw;
			float4 tex2DNode2 = tex2D( _FadeTex, uv_FadeTex );
			float2 panner1 = ( 1.0 * _Time.y * float2( -3,0 ) + i.uv_texcoord);
			float2 uv_SecondaryNoiseMask = i.uv_texcoord * _SecondaryNoiseMask_ST.xy + _SecondaryNoiseMask_ST.zw;
			float2 panner13 = ( 1.0 * _Time.y * float2( 0.1,0 ) + uv_SecondaryNoiseMask);
			float4 temp_output_4_0 = ( tex2DNode2 * tex2D( _NoiseTex, panner1 ) * ( float4( 0.8301887,0.8301887,0.8301887,0 ) * tex2D( _SecondaryNoiseMask, panner13 ) ) * i.vertexColor.a );
			color.rgb = color.rgb + Refraction( i, o, ( float4( 1,1,1,0 ) - ( ( temp_output_4_0 * 0.8 ) * i.vertexColor.a ) ).r, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_FadeTex = i.uv_texcoord * _FadeTex_ST.xy + _FadeTex_ST.zw;
			float4 tex2DNode2 = tex2D( _FadeTex, uv_FadeTex );
			float2 panner1 = ( 1.0 * _Time.y * float2( -3,0 ) + i.uv_texcoord);
			float2 uv_SecondaryNoiseMask = i.uv_texcoord * _SecondaryNoiseMask_ST.xy + _SecondaryNoiseMask_ST.zw;
			float2 panner13 = ( 1.0 * _Time.y * float2( 0.1,0 ) + uv_SecondaryNoiseMask);
			float4 temp_output_4_0 = ( tex2DNode2 * tex2D( _NoiseTex, panner1 ) * ( float4( 0.8301887,0.8301887,0.8301887,0 ) * tex2D( _SecondaryNoiseMask, panner13 ) ) * i.vertexColor.a );
			float4 temp_output_17_0 = ( _EmissionColor * temp_output_4_0 );
			o.Albedo = temp_output_17_0.rgb;
			o.Emission = temp_output_17_0.rgb;
			o.Alpha = temp_output_4_0.r;
			clip( tex2DNode2.r - _Cutoff );
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha finalcolor:RefractionF fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float4 tSpace0 : TEXCOORD4;
				float4 tSpace1 : TEXCOORD5;
				float4 tSpace2 : TEXCOORD6;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.screenPos = IN.screenPos;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
1612;639;1610;773;864.1644;554.2692;1.102589;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-1624.181,-1.96084;Inherit;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1328.665,-268.7164;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;13;-1349.915,5.002407;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;1;-1055.665,-268.7164;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-3,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;12;-1099.015,-28.79759;Inherit;True;Property;_SecondaryNoiseMask;Secondary Noise Mask;5;0;Create;True;0;0;0;False;0;False;12;bd46706ff72992a4c8a07db09bba3dce;75fc796687feb794b9332f84015e932a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-717.9648,-502.7164;Inherit;True;Property;_FadeTex;Fade Tex;0;0;Create;True;0;0;0;False;0;False;-1;None;e5f862bd32f0cff448d6d7fb5c2f2415;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-708.9648,-296.7164;Inherit;True;Property;_NoiseTex;Noise Tex;2;0;Create;True;0;0;0;False;0;False;-1;75fc796687feb794b9332f84015e932a;75fc796687feb794b9332f84015e932a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-735.9811,25.03915;Inherit;False;2;2;0;COLOR;0.8301887,0.8301887,0.8301887,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;18;-481.4115,-191.1362;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-295.9648,-320.7164;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-498.6866,33.13844;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-299.2867,11.33844;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-153.632,5.12612;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;16;-335.4971,-506.5324;Inherit;False;Property;_EmissionColor;Emission Color;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;2.670157,0.7360985,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;10.89936,91.04996;Inherit;False;2;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;23.1951,-295.5294;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;258,-314;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/SpinFX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.1;True;True;0;True;Custom;;Transparent;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;3;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;14;0
WireConnection;1;0;5;0
WireConnection;12;1;13;0
WireConnection;3;1;1;0
WireConnection;15;1;12;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;4;2;15;0
WireConnection;4;3;18;4
WireConnection;7;0;4;0
WireConnection;7;1;6;0
WireConnection;19;0;7;0
WireConnection;19;1;18;4
WireConnection;11;1;19;0
WireConnection;17;0;16;0
WireConnection;17;1;4;0
WireConnection;0;0;17;0
WireConnection;0;2;17;0
WireConnection;0;8;11;0
WireConnection;0;9;4;0
WireConnection;0;10;2;0
ASEEND*/
//CHKSM=7E3D59C19FA0AB17FEE3C7AFD3B47C2FA5023BB3