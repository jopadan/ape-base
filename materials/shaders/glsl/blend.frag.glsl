/**
 * Copyright © 2020-2024 Quartermind Games, Mark E. Sowden <hogsy@snortysoft.net>
 */

uniform sampler2D blendMap;

#include "shared.inc.glsl"
#include "lighting.inc.glsl"
#include "fog.inc.glsl"

vec4 BlendTextures( sampler2D t0, sampler2D t1 )
{
	vec4 sampleA = texture( t0, vsShared.uv.st );
	vec4 sampleB = texture( t1, vsShared.uv.st );
	return sampleA * ( 1 - vsShared.colour.g ) + sampleB * vsShared.colour.g;
}

void main()
{
	vec4 dsample = BlendTextures( blendMap, diffuseMap );
	if ( dsample.a < 0.1 )
	{
		discard;
	}

	vec3 n = normalize( texture( normalMap, vsShared.uv.st ).rgb * 2.0 - 1.0 );
	n = normalize( vsShared.tbn * n );

	vec4 lightTerm = CalculateLighting( n, normalize( vsShared.viewPos - vsShared.position ) );
	vec4 outp = CalculateFogTerm( lightTerm * dsample );
	pl_frag = outp;
}
