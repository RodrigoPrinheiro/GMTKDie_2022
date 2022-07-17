// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Thomas/MyDefaultSplit"
{
	Properties
	{
		_Color("Color", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_Metallic("Metallic", Range( 0 , 1)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_AO("AO", Range( 0 , 1)) = 1
		_Normal_Map("Normal_Map", 2D) = "bump" {}
		_Normal_Scale("Normal_Scale", Range( -1 , 5)) = 1
		_Emission("Emission", 2D) = "white" {}
		_Emission_Power("Emission_Power", Float) = 0
		[HDR]_Emission_Color("Emission_Color", Color) = (1,1,1,0)
		_MetallicMap("MetallicMap", 2D) = "white" {}
		_SmoothnessMap("SmoothnessMap", 2D) = "white" {}
		_AOMap("AOMap", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma only_renderers d3d11 gles3 metal 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows noshadow exclude_path:deferred nometa 
		struct Input
		{
			float2 uv_texcoord;
		};

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
		uniform sampler2D _MetallicMap;
		uniform half4 _MetallicMap_ST;
		uniform half _Metallic;
		uniform sampler2D _SmoothnessMap;
		uniform half4 _SmoothnessMap_ST;
		uniform half _Smoothness;
		uniform sampler2D _AOMap;
		uniform half4 _AOMap_ST;
		uniform half _AO;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal_Map = i.uv_texcoord * _Normal_Map_ST.xy + _Normal_Map_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _Normal_Map, uv_Normal_Map ), _Normal_Scale );
			float2 uv_Color = i.uv_texcoord * _Color_ST.xy + _Color_ST.zw;
			o.Albedo = ( _Tint * tex2D( _Color, uv_Color ) ).rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			o.Emission = ( tex2D( _Emission, uv_Emission ) * _Emission_Power * _Emission_Color ).rgb;
			float2 uv_MetallicMap = i.uv_texcoord * _MetallicMap_ST.xy + _MetallicMap_ST.zw;
			o.Metallic = ( tex2D( _MetallicMap, uv_MetallicMap ) * _Metallic ).r;
			float2 uv_SmoothnessMap = i.uv_texcoord * _SmoothnessMap_ST.xy + _SmoothnessMap_ST.zw;
			o.Smoothness = ( tex2D( _SmoothnessMap, uv_SmoothnessMap ) * _Smoothness ).r;
			float2 uv_AOMap = i.uv_texcoord * _AOMap_ST.xy + _AOMap_ST.zw;
			o.Occlusion = ( tex2D( _AOMap, uv_AOMap ) * _AO ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
837;449;1610;833;867.9868;-103.0911;1;True;True
Node;AmplifyShaderEditor.SamplerNode;1;-243,46;Inherit;True;Property;_Color;Color;0;0;Create;True;0;0;0;False;0;False;-1;None;6f648cce8d3419d498b8f6a5f4c9757a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-362.8303,933.4554;Inherit;False;Property;_Normal_Scale;Normal_Scale;6;0;Create;True;0;0;0;False;0;False;1;5;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-483.9868,257.0911;Inherit;True;Property;_MetallicMap;MetallicMap;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-486.9868,457.0911;Inherit;True;Property;_SmoothnessMap;SmoothnessMap;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-51,573;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-71,487;Inherit;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-489.9868,658.0911;Inherit;True;Property;_AOMap;AOMap;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;211,1219;Inherit;False;Property;_Emission_Power;Emission_Power;8;0;Create;True;0;0;0;False;0;False;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;87,959;Inherit;True;Property;_Emission;Emission;7;0;Create;True;0;0;0;False;0;False;-1;None;c73f3d975b840434d80cb483993b2eec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;399.1203,1229.487;Inherit;False;Property;_Emission_Color;Emission_Color;9;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;2,0.8313726,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-33,666;Inherit;False;Property;_AO;AO;4;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-197,-148;Inherit;False;Property;_Tint;Tint;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;302,391;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;11;78,741;Inherit;True;Property;_Normal_Map;Normal_Map;5;0;Create;True;0;0;0;False;0;False;-1;None;2fa0c73ffe298824db95e43c4ab7294a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;289,237;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;531,1016;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;362,526;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;205,46;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;784.2,157.4;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Thomas/MyDefaultSplit;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;3;d3d11;gles3;metal;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;18;0
WireConnection;6;1;9;0
WireConnection;11;5;16;0
WireConnection;5;0;17;0
WireConnection;5;1;8;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;13;2;15;0
WireConnection;7;0;19;0
WireConnection;7;1;10;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;0;0;3;0
WireConnection;0;1;11;0
WireConnection;0;2;13;0
WireConnection;0;3;5;0
WireConnection;0;4;6;0
WireConnection;0;5;7;0
ASEEND*/
//CHKSM=EE1A12DCF0AFAD199B41A3490E036E0DA32FB8FB