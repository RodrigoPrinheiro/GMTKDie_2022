// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DiceGame/DiceTree"
{
	Properties
	{
		_Color1("Color", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_MSAO("MSAO", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 1
		_Smoothness1("Smoothness", Range( 0 , 1)) = 1
		_AO("AO", Range( 0 , 1)) = 1
		_Normal_Map("Normal_Map", 2D) = "bump" {}
		_Normal_Scale("Normal_Scale", Range( -1 , 1)) = 1
		_Emission("Emission", 2D) = "white" {}
		_Emission_Power("Emission_Power", Float) = 0
		[HDR]_Emission_Color("Emission_Color", Color) = (1,1,1,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_SwayMask("SwayMask", 2D) = "white" {}
		_SwayNoise("SwayNoise", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _SwayNoise;
		uniform sampler2D _SwayMask;
		uniform float4 _SwayMask_ST;
		uniform sampler2D _Normal_Map;
		uniform float4 _Normal_Map_ST;
		uniform float _Normal_Scale;
		uniform float4 _Tint;
		uniform sampler2D _Color1;
		uniform float4 _Color1_ST;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _Emission_Power;
		uniform float4 _Emission_Color;
		uniform sampler2D _TextureSample0;
		uniform sampler2D _MSAO;
		uniform float4 _MSAO_ST;
		uniform float _Metallic;
		uniform float _Smoothness1;
		uniform float _AO;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 panner31 = ( 1.0 * _Time.y * float2( 0.05,-0.02 ) + v.texcoord.xy);
			float2 uv_SwayMask = v.texcoord * _SwayMask_ST.xy + _SwayMask_ST.zw;
			v.vertex.xyz += ( tex2Dlod( _SwayNoise, float4( panner31, 0, 0.0) ) * 0.1 * tex2Dlod( _SwayMask, float4( uv_SwayMask, 0, 0.0) ) ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal_Map = i.uv_texcoord * _Normal_Map_ST.xy + _Normal_Map_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _Normal_Map, uv_Normal_Map ), _Normal_Scale );
			float2 uv_Color1 = i.uv_texcoord * _Color1_ST.xy + _Color1_ST.zw;
			o.Albedo = ( _Tint * tex2D( _Color1, uv_Color1 ) ).rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float2 panner24 = ( 1.0 * _Time.y * float2( 0.1,0.1 ) + i.uv_texcoord);
			o.Emission = ( tex2D( _Emission, uv_Emission ) * _Emission_Power * _Emission_Color * tex2D( _TextureSample0, panner24 ) ).rgb;
			float2 uv_MSAO = i.uv_texcoord * _MSAO_ST.xy + _MSAO_ST.zw;
			float4 tex2DNode7 = tex2D( _MSAO, uv_MSAO );
			o.Metallic = ( tex2DNode7.r * _Metallic );
			o.Smoothness = ( tex2DNode7.g * _Smoothness1 );
			o.Occlusion = ( tex2DNode7.b * _AO );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
2178;73;1261;989;1055.467;-130.3014;1.3;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-1650.48,1204.113;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;24;-1321.448,1209.12;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;10;-995.0539,958.3724;Inherit;False;Property;_Emission_Color;Emission_Color;10;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1.498039,0.4010934,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-1307.174,687.8854;Inherit;True;Property;_Emission;Emission;8;0;Create;True;0;0;0;False;0;False;-1;None;2ffb968d792f0254c9eac7c29cbbb0bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;31;-291.072,708.2566;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,-0.02;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1183.174,947.8854;Inherit;False;Property;_Emission_Power;Emission_Power;9;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-1091.941,1179.429;Inherit;True;Property;_TextureSample0;Texture Sample 0;11;0;Create;True;0;0;0;False;0;False;-1;None;bd46706ff72992a4c8a07db09bba3dce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-596.386,889.2405;Inherit;True;Property;_SwayMask;SwayMask;12;0;Create;True;0;0;0;False;0;False;-1;None;3b325b054b66dd44e98e9caa6ea88fea;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-740.7998,298.9228;Inherit;False;Property;_AO;AO;5;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-58.10564,657.0253;Inherit;True;Property;_SwayNoise;SwayNoise;13;0;Create;True;0;0;0;False;0;False;-1;None;bd46706ff72992a4c8a07db09bba3dce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-950.7998,-321.0771;Inherit;True;Property;_Color1;Color;0;0;Create;True;0;0;0;False;0;False;-1;None;163dffcc2675e734f8a9d33b3166893a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-934.7998,-88.07712;Inherit;True;Property;_MSAO;MSAO;2;0;Create;True;0;0;0;False;0;False;-1;None;746b6a7720a69a9429ef3be14b356aa2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-778.7998,119.9229;Inherit;False;Property;_Metallic;Metallic;3;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-904.7998,-515.0772;Inherit;False;Property;_Tint;Tint;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-758.7998,205.9228;Inherit;False;Property;_Smoothness1;Smoothness;4;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-739.1741,723.8854;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-122.0218,612.1862;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-942.6301,423.3781;Inherit;False;Property;_Normal_Scale;Normal_Scale;7;0;Create;True;0;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;27;-158.9757,538.7825;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-27.10748,500.8338;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;30;-215.4078,931.8135;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-345.7999,158.9229;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-418.7999,-130.0771;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-502.7999,-321.0771;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-405.7999,23.92288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-629.7999,373.9228;Inherit;True;Property;_Normal_Map;Normal_Map;6;0;Create;True;0;0;0;False;0;False;-1;None;dde75fff2c133f44db391fee0a44abfc;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;DiceGame/DiceTree;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;25;0
WireConnection;31;0;25;0
WireConnection;23;1;24;0
WireConnection;29;1;31;0
WireConnection;19;0;8;0
WireConnection;19;1;16;0
WireConnection;19;2;10;0
WireConnection;19;3;23;0
WireConnection;27;0;19;0
WireConnection;32;0;29;0
WireConnection;32;1;33;0
WireConnection;32;2;26;0
WireConnection;22;0;7;3
WireConnection;22;1;11;0
WireConnection;20;0;7;1
WireConnection;20;1;13;0
WireConnection;21;0;12;0
WireConnection;21;1;14;0
WireConnection;17;0;7;2
WireConnection;17;1;15;0
WireConnection;18;5;9;0
WireConnection;0;0;21;0
WireConnection;0;1;18;0
WireConnection;0;2;27;0
WireConnection;0;3;20;0
WireConnection;0;4;17;0
WireConnection;0;5;22;0
WireConnection;0;11;32;0
ASEEND*/
//CHKSM=4599BB4046F9C9E522EED49A653F94F463F3700F