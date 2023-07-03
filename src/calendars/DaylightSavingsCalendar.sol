// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/// @notice Data contract encoding Daylight Savings start/end timestamps.
///         Each start/end pair is encoded as two 32-bit values, representing
///         seconds since Jan 1, 2023 UTC. Use DaylightSavingsLibrary to decode.
contract DaylightSavingsCalendar {
    constructor() {
        bytes memory data = (
            hex"00" // STOP opcode
            hex"005cab7001967070023c8d7003765270041c6f700556347005fc517007361670"
            hex"07e56df0091f32f009c54ff00aff14f00ba531f00cdef6f00d8513f00ebed8f0"
            hex"0f64f5f0109ebaf0114e12701287d770132df4701467b970150dd67016479b70"
            hex"16edb87018277d7018cd9a701a075f701aad7c701be741701c9698f01dd05df0"
            hex"1e767af01fb03ff020565cf0219021f022363ef0237003f0241620f0254fe5f0"
            hex"25f602f0272fc7f027df1f702918e47029bf01702af8c6702b9ee3702cd8a870"
            hex"2d7ec5702eb88a702f5ea77030986c703147c3f0328188f03327a5f034616af0"
            hex"350787f036414cf036e769f038212ef038c74bf03a0110f03aa72df03be0f2f0"
            hex"3c904a703dca0f703e702c703fa9f17040500e704189d370422ff0704369b570"
            hex"440fd2704549977045f8eef04732b3f047d8d0f0491295f049b8b2f04af277f0"
            hex"4b9894f04cd259f04d7876f04eb23bf04f5858f050921df051417570527b3a70"
            hex"53215770545b1c7055013970563afe7056e11b70581ae07058c0fd7059fac270"
            hex"5aa0df705bdaa4705c89fbf05dc3c0f05e69ddf05fa3a2f06049bff0618384f0"
            hex"6229a1f0636366f0640983f0654348f065f2a070672c657067d28270690c4770"
            hex"69b264706aec29706b9246706ccc0b706d7228706eabed706f520a70708bcf70"
            hex"713b26f07274ebf0731b08f07454cdf074faeaf07634aff076daccf0781491f0"
            hex"78baaef079f473f07aa3cb707bdd90707c83ad707dbd72707e638f707f9d5470"
            hex"80437170817d367082235370835d187084033570853cfa7085ec51f0872616f0"
            hex"87cc33f08905f8f089ac15f08ae5daf08b8bf7f08cc5bcf08d6bd9f08ea59ef0"
            hex"8f4bbbf0908580f09134d870926e9d709314ba70944e7f7094f49c70962e6170"
            hex"96d47e70980e437098b4607099ee25709a9442709bce07709c7d5ef09db723f0"
            hex"9e5d40f09f9705f0a03d22f0a176e7f0a21d04f0a356c9f0a3fce6f0a536abf0"
            hex"a5dcc8f0a7168df0a7c5e570a8ffaa70a9a5c770aadf8c70ab85a970acbf6e70"
            hex"ad658b70ae9f5070af456d70b07f3270b12e89f0b2684ef0b30e6bf0b44830f0"
            hex"b4ee4df0b62812f0b6ce2ff0b807f4f0b8ae11f0b9e7d6f0ba8df3f0bbc7b8f0"
            hex"bc771070bdb0d570"
        );
        assembly {
            return(add(data, 0x20), mload(data))
        }
    }
}
