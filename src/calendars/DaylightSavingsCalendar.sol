// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/// @notice Data contract encoding Daylight Savings start/end timestamps.
///         Each start/end pair is encoded as two 32-bit values, representing
///         seconds since Jan 1, 2023. Use LibDaylightSavings to decode.
contract DaylightSavingsCalendar {
    constructor() {
        bytes memory data = (
            hex"00" // STOP opcode
            hex"005c652001962a20" // 2023
            hex"023c472003760c20041c29200555ee2005fc0b200735d02007e527a0091eeca0"
            hex"09c509a00afecea00ba4eba00cdeb0a00d84cda00ebe92a00f64afa0109e74a0"
            hex"114dcc2012879120132dae2014677320150d90201647552016ed722018273720"
            hex"18cd54201a0719201aad36201be6fb201c9652a01dd017a01e7634a01faff9a0"
            hex"205616a0218fdba02235f8a0236fbda02415daa0254f9fa025f5bca0272f81a0"
            hex"27ded92029189e2029bebb202af880202b9e9d202cd862202d7e7f202eb84420"
            hex"2f5e61203098262031477da0328142a033275fa0346124a0350741a0364106a0"
            hex"36e723a03820e8a038c705a03a00caa03aa6e7a03be0aca03c9004203dc9c920"
            hex"3e6fe6203fa9ab20404fc82041898d20422faa2043696f20440f8c2045495120"
            hex"45f8a8a047326da047d88aa049124fa049b86ca04af231a04b984ea04cd213a0"
            hex"4d7830a04eb1f5a04f5812a05091d7a051412f20527af42053211120545ad620"
            hex"5500f320563ab82056e0d520581a9a2058c0b72059fa7c205aa099205bda5e20"
            hex"5c89b5a05dc37aa05e6997a05fa35ca0604979a061833ea062295ba0636320a0"
            hex"64093da0654302a065f25a20672c1f2067d23c20690c012069b21e206aebe320"
            hex"6b9200206ccbc5206d71e2206eaba7206f51c420708b8920713ae0a07274a5a0"
            hex"731ac2a0745487a074faa4a0763469a076da86a078144ba078ba68a079f42da0"
            hex"7aa385207bdd4a207c8367207dbd2c207e6349207f9d0e2080432b20817cf020"
            hex"82230d20835cd2208402ef20853cb42085ec0ba08725d0a087cbeda08905b2a0"
            hex"89abcfa08ae594a08b8bb1a08cc576a08d6b93a08ea558a08f4b75a090853aa0"
            hex"91349220926e572093147420944e392094f45620962e1b2096d43820980dfd20"
            hex"98b41a2099eddf209a93fc209bcdc1209c7d18a09db6dda09e5cfaa09f96bfa0"
            hex"a03cdca0a176a1a0a21cbea0a35683a0a3fca0a0a53665a0a5dc82a0a71647a0"
            hex"a7c59f20a8ff6420a9a58120aadf4620ab856320acbf2820ad654520ae9f0a20"
            hex"af452720b07eec20b12e43a0b26808a0b30e25a0b447eaa0b4ee07a0b627cca0"
            hex"b6cde9a0b807aea0b8adcba0b9e790a0ba8dada0bbc772a0bc76ca20bdb08f20"
        );
        assembly {
            return(add(data, 0x20), mload(data))
        }
    }
}
