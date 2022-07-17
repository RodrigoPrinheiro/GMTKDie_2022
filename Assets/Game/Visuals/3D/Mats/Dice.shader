// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Thomas/Dice"
{
	Properties
	{
		_Color("Color", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_MSAO("MSAO", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_AO("AO", Range( 0 , 1)) = 1
		_Normal_Map("Normal_Map", 2D) = "bump" {}
		_Normal_Scale("Normal_Scale", Range( -1 , 1)) = 1
		_Emission("Emission", 2D) = "white" {}
		_Emission_Power("Emission_Power", Float) = 0
		[HDR]_Emission_Color("Emission_Color", Color) = (1,1,1,0)
		_InnerMetalMask("Inner Metal Mask", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
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
		#pragma only_renderers d3d11 gles3 metal 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred nometa vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Noise;
		uniform sampler2D _InnerMetalMask;
		uniform half4 _InnerMetalMask_ST;
		uniform sampler2D _Normal_Map;
		uniform half4 _Normal_Map_ST;
		uniform half _Normal_Scale;
		uniform half4 _Tint;
		uniform sampler2D _Color;
		uniform half4 _Color_ST;
		uniform sampler2D _Emission;
		uniform half4 _Emission_ST;
		uniform half _Emission_Power;
		uniform half4 _Emission_Color;
		uniform sampler2D _MSAO;
		uniform half4 _MSAO_ST;
		uniform half _Metallic;
		uniform half _Smoothness;
		uniform half _AO;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			half2 panner19 = ( 1.0 * _Time.y * float2( 0.05,0.1 ) + v.texcoord.xy);
			half3 ase_vertexNormal = v.normal.xyz;
			float2 uv_InnerMetalMask = v.texcoord * _InnerMetalMask_ST.xy + _InnerMetalMask_ST.zw;
			v.vertex.xyz += ( tex2Dlod( _Noise, float4( panner19, 0, 0.0) ) * half4( ase_vertexNormal , 0.0 ) * 0.005 * tex2Dlod( _InnerMetalMask, float4( uv_InnerMetalMask, 0, 0.0) ) ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal_Map = i.uv_texcoord * _Normal_Map_ST.xy + _Normal_Map_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _Normal_Map, uv_Normal_Map ), _Normal_Scale );
			float2 uv_Color = i.uv_texcoord * _Color_ST.xy + _Color_ST.zw;
			o.Albedo = ( _Tint * tex2D( _Color, uv_Color ) ).rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			o.Emission = ( tex2D( _Emission, uv_Emission ) * _Emission_Power * _Emission_Color ).rgb;
			float2 uv_MSAO = i.uv_texcoord * _MSAO_ST.xy + _MSAO_ST.zw;
			half4 tex2DNode4 = tex2D( _MSAO, uv_MSAO );
			o.Metallic = ( tex2DNode4.r * _Metallic );
			o.Smoothness = ( tex2DNode4.g * _Smoothness );
			o.Occlusion = ( tex2DNode4.b * _AO );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
837;449;1610;833;703.3838;-1099.302;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-486.8439,1658.921;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;19;-224.8439,1664.921;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;395.9884,1867.743;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;0.005;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;399.1203,1229.487;Inherit;False;Property;_Emission_Color;Emission_Color;10;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;6.062866,1.98095,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-243,46;Inherit;True;Property;_Color;Color;0;0;Create;True;0;0;0;False;0;False;-1;None;e6dc6add8bc871649a5e77e9307e2115;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-51,573;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-234.8303,790.4554;Inherit;False;Property;_Normal_Scale;Normal_Scale;7;0;Create;True;0;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-227,279;Inherit;True;Property;_MSAO;MSAO;2;0;Create;True;0;0;0;False;0;False;-1;None;e2d04d99acc0bdd4a93f90bddcade34c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-71,487;Inherit;False;Property;_Metallic;Metallic;3;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;15.18434,1431.722;Inherit;True;Property;_InnerMetalMask;Inner Metal Mask;11;0;Create;True;0;0;0;False;0;False;-1;None;471c6289f01cf314692d47d885966b36;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;211,1219;Inherit;False;Property;_Emission_Power;Emission_Power;9;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;21;120.3884,1820.943;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-197,-148;Inherit;False;Property;_Tint;Tint;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;87,959;Inherit;True;Property;_Emission;Emission;8;0;Create;True;0;0;0;False;0;False;-1;None;b90cfe474b8cbd8488135d7de681e344;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-33,666;Inherit;False;Property;_AO;AO;5;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;9.156067,1623.921;Inherit;True;Property;_Noise;Noise;12;0;Create;True;0;0;0;False;0;False;-1;bd46706ff72992a4c8a07db09bba3dce;bd46706ff72992a4c8a07db09bba3dce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;503.8884,1674.043;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;289,237;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;531,1016;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;362,526;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;302,391;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;78,741;Inherit;True;Property;_Normal_Map;Normal_Map;6;0;Create;True;0;0;0;False;0;False;-1;None;888ea3e0ed4f34e4c895f22ccde64d75;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;205,46;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;784.2,157.4;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Thomas/Dice;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;3;d3d11;gles3;metal;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;20;0
WireConnection;18;1;19;0
WireConnection;22;0;18;0
WireConnection;22;1;21;0
WireConnection;22;2;23;0
WireConnection;22;3;17;0
WireConnection;5;0;4;1
WireConnection;5;1;8;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;13;2;15;0
WireConnection;7;0;4;3
WireConnection;7;1;10;0
WireConnection;6;0;4;2
WireConnection;6;1;9;0
WireConnection;11;5;16;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;0;0;3;0
WireConnection;0;1;11;0
WireConnection;0;2;13;0
WireConnection;0;3;5;0
WireConnection;0;4;6;0
WireConnection;0;5;7;0
WireConnection;0;11;22;0
ASEEND*/
//CHKSM=E6A3CB3876052D50C7A1AE4CFA15093B61BC77B4