// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Thomas/WaterGround"
{
	Properties
	{
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_BaseMap("Base Map", 2D) = "bump" {}
		_Normal_Scale("Normal_Scale", Range( -1 , 5)) = 1
		_2("2", 2D) = "bump" {}
		_Color("Color", Color) = (1,1,1,0)
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_DistortionSpeed("Distortion Speed", Vector) = (1,0,0,0)
		_BaseSpeed("Base Speed", Vector) = (1,0,0,0)
		_DistortionIntensity("Distortion Intensity", Float) = 0.01
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma only_renderers d3d11 gles3 metal 
		#pragma surface surf Standard keepalpha exclude_path:deferred nometa vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BaseMap;
		uniform half2 _BaseSpeed;
		uniform half2 _Tiling;
		uniform sampler2D _2;
		uniform half2 _DistortionSpeed;
		uniform half _DistortionIntensity;
		uniform half _Normal_Scale;
		uniform half4 _Color;
		uniform half _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_TexCoord25 = v.texcoord.xy * _Tiling;
			float2 uv_TexCoord21 = v.texcoord.xy * _Tiling;
			half2 panner19 = ( 1.0 * _Time.y * _DistortionSpeed + uv_TexCoord21);
			half2 panner30 = ( 1.0 * _Time.y * _BaseSpeed + ( half3( uv_TexCoord25 ,  0.0 ) + ( (UnpackNormal( tex2Dlod( _2, float4( panner19, 0, 0.0) ) )).xyz * _DistortionIntensity ) ).xy);
			half3 tex2DNode11 = UnpackScaleNormal( tex2Dlod( _BaseMap, float4( panner30, 0, 0.0) ), _Normal_Scale );
			half grayscale33 = Luminance(tex2DNode11);
			half3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( grayscale33 * ase_vertexNormal * 0.15 );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord25 = i.uv_texcoord * _Tiling;
			float2 uv_TexCoord21 = i.uv_texcoord * _Tiling;
			half2 panner19 = ( 1.0 * _Time.y * _DistortionSpeed + uv_TexCoord21);
			half2 panner30 = ( 1.0 * _Time.y * _BaseSpeed + ( half3( uv_TexCoord25 ,  0.0 ) + ( (UnpackNormal( tex2D( _2, panner19 ) )).xyz * _DistortionIntensity ) ).xy);
			half3 tex2DNode11 = UnpackScaleNormal( tex2D( _BaseMap, panner30 ), _Normal_Scale );
			o.Normal = tex2DNode11;
			o.Albedo = _Color.rgb;
			o.Metallic = 0.0;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
837;449;1610;833;341.6734;-209.5205;1;True;True
Node;AmplifyShaderEditor.Vector2Node;27;-1760.274,-138.4506;Inherit;False;Property;_Tiling;Tiling;5;0;Create;True;0;0;0;False;0;False;1,1;3,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1531.799,-302.6203;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;28;-1458.498,-472.8721;Inherit;False;Property;_DistortionSpeed;Distortion Speed;6;0;Create;True;0;0;0;False;0;False;1,0;0.3,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;19;-1248.699,-299.1205;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;24;-1035.199,-320.5205;Inherit;True;Property;_2;2;3;0;Create;True;0;0;0;False;0;False;-1;None;9db678e9a8b5fb74d988d36e80d6d932;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-690.7314,-418.9812;Inherit;False;Property;_DistortionIntensity;Distortion Intensity;8;0;Create;True;0;0;0;False;0;False;0.01;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;22;-712.7987,-324.7203;Inherit;True;True;True;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-404.9705,-451.6445;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-407.2989,-319.5204;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.01;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;29;-488.9596,-38.32877;Inherit;False;Property;_BaseSpeed;Base Speed;7;0;Create;True;0;0;0;False;0;False;1,0;0.08,-0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-154.9705,-362.6445;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-659.9486,232.1199;Inherit;False;Property;_Normal_Scale;Normal_Scale;2;0;Create;True;0;0;0;False;0;False;1;1;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;30;-164.6327,78.19373;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;11;-92.92673,342.6959;Inherit;True;Property;_BaseMap;Base Map;1;0;Create;True;0;0;0;False;0;False;-1;None;f7b11effc19a1f0488ca840cd28e59c3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;35;300,614;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;33;290.7472,531.9754;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;342.419,753.8307;Inherit;False;Constant;_Displacement;Displacement;9;0;Create;True;0;0;0;False;0;False;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;221.3109,443.7013;Inherit;False;Property;_Smoothness;Smoothness;0;0;Create;True;0;0;0;False;0;False;1;0.937;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;352.889,299.2359;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;394.299,24.101;Inherit;False;Property;_Color;Color;4;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.385947,0.3966601,0.4622642,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;32;573.9471,337.0754;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;583,548;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;784.2,157.4;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Thomas/WaterGround;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;3;d3d11;gles3;metal;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;27;0
WireConnection;19;0;21;0
WireConnection;19;2;28;0
WireConnection;24;1;19;0
WireConnection;22;0;24;0
WireConnection;25;0;27;0
WireConnection;23;0;22;0
WireConnection;23;1;31;0
WireConnection;26;0;25;0
WireConnection;26;1;23;0
WireConnection;30;0;26;0
WireConnection;30;2;29;0
WireConnection;11;1;30;0
WireConnection;11;5;16;0
WireConnection;33;0;11;0
WireConnection;32;0;11;0
WireConnection;37;0;33;0
WireConnection;37;1;35;0
WireConnection;37;2;38;0
WireConnection;0;0;18;0
WireConnection;0;1;11;0
WireConnection;0;3;17;0
WireConnection;0;4;9;0
WireConnection;0;11;37;0
ASEEND*/
//CHKSM=9F7A08755B31F6DC311CC422360AA9D6A5882AC3