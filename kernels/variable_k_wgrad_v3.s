.amdgcn_target "amdgcn-amd-amdhsa--gfx950"

.text
.globl _grouped_variable_k_gemm_kernel
.p2align 8
.type _grouped_variable_k_gemm_kernel,@function
_grouped_variable_k_gemm_kernel:
	s_load_dwordx2 s[2:3], s[0:1], 0x0
	s_load_dwordx8 s[4:11], s[0:1], 0x8
	s_load_dwordx4 s[12:15], s[0:1], 0x28
	s_waitcnt lgkmcnt(0)
	s_branch .L0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
.L0:
	s_mov_b64 s[28:29], s[2:3]
	s_load_dword s2, s[0:1], 0x38
	s_mov_b64 s[24:25], s[6:7]
	s_cmpk_gt_i32 s16, 0x100
	s_cbranch_scc1 .L1
	s_ashr_i32 s3, s16, 31
	s_lshr_b32 s6, s3, 29
	s_add_i32 s6, s16, s6
	s_ashr_i32 s17, s6, 31
	s_ashr_i32 s7, s6, 3
	s_lshr_b32 s3, s3, 24
	s_lshr_b32 s17, s17, 27
	s_and_b32 s6, s6, 0x7fffff8
	s_add_i32 s3, s16, s3
	s_add_i32 s17, s7, s17
	s_sub_i32 s6, s16, s6
	s_andn2_b32 s17, s17, 31
	s_and_b32 s3, s3, 0xffffff00
	s_lshl_b32 s6, s6, 5
	s_sub_i32 s7, s7, s17
	s_add_i32 s3, s3, s6
	s_add_i32 s16, s3, s7
.L1:
	s_add_i32 s3, s15, 0xff
	s_ashr_i32 s6, s3, 31
	s_lshr_b32 s6, s6, 24
	s_add_i32 s3, s3, s6
	s_ashr_i32 s17, s3, 8
	s_waitcnt lgkmcnt(0)
	s_add_i32 s3, s2, 0xff
	s_ashr_i32 s6, s3, 31
	s_lshr_b32 s6, s6, 24
	s_add_i32 s3, s3, s6
	s_ashr_i32 s3, s3, 8
	s_mul_i32 s33, s3, s17
	s_mul_i32 s14, s33, s14
	s_cmp_ge_i32 s16, s14
	s_cbranch_scc1 .L6
	s_load_dword s6, s[10:11], 0x0
	s_load_dword s7, s[8:9], 0x0
	s_load_dwordx4 s[36:39], s[0:1], 0x3c
	v_lshrrev_b32_e32 v161, 4, v0
	s_lshl_b32 s34, s3, 2
	s_waitcnt lgkmcnt(0)
	v_mov_b32_e32 v2, s6
	v_and_b32_e32 v1, 15, v0
	v_mul_f32_e32 v136, s7, v2
	v_and_b32_e32 v2, 16, v161
	s_lshl_b32 s35, s36, 6
	s_lshl_b32 s44, s37, 6
	s_and_b32 s29, s29, 0xffff
	s_and_b32 s5, s5, 0xffff
	v_lshlrev_b32_e32 v6, 3, v0
	v_lshlrev_b32_e32 v160, 4, v1
	v_or_b32_e32 v162, v2, v1
	v_and_b32_e32 v1, 0xf0, v0
	v_lshlrev_b32_e32 v3, 4, v0
	v_lshlrev_b32_e32 v4, 7, v0
	v_lshlrev_b32_e32 v5, 2, v0
	v_and_b32_e32 v6, 8, v6
	v_lshrrev_b32_e32 v0, 2, v0
	s_cmp_gt_i32 s2, -1
	v_and_b32_e32 v4, 0x1f00, v4
	v_and_b32_e32 v5, 0x78, v5
	v_and_or_b32 v0, v0, 48, v6
	s_cselect_b64 s[22:23], -1, 0
	s_abs_i32 s45, s33
	v_bitop3_b32 v180, v4, v0, v5 bitop3:0x36
	v_cvt_f32_u32_e32 v0, s45
	v_or_b32_e32 v2, v6, v2
	s_abs_i32 s47, s34
	v_bitop3_b32 v176, v4, v2, v5 bitop3:0x36
	v_rcp_iflag_f32_e32 v0, v0
	v_cvt_f32_u32_e32 v2, s47
	v_mul_lo_u32 v182, s39, v162
	s_lshl_b32 s0, s39, 5
	v_mul_f32_e32 v0, 0x4f7ffffe, v0
	v_cvt_u32_f32_e32 v0, v0
	v_add_u32_e32 v183, s0, v182
	v_add_u32_e32 v184, s0, v183
	v_add_u32_e32 v185, s0, v184
	v_readfirstlane_b32 s1, v0
	v_rcp_iflag_f32_e32 v0, v2
	v_add_u32_e32 v186, s0, v185
	v_add_u32_e32 v187, s0, v186
	s_abs_i32 s50, s15
	v_mul_f32_e32 v0, 0x4f7ffffe, v0
	v_add_u32_e32 v188, s0, v187
	v_cvt_u32_f32_e32 v0, v0
	v_cvt_f32_u32_e32 v2, s50
	v_add_u32_e32 v189, s0, v188
	s_sub_i32 s0, 0, s45
	s_mul_i32 s0, s0, s1
	s_mul_hi_u32 s0, s1, s0
	s_abs_i32 s51, s2
	s_add_i32 s48, s1, s0
	v_readfirstlane_b32 s1, v0
	v_rcp_iflag_f32_e32 v0, v2
	v_cvt_f32_u32_e32 v2, s51
	s_sub_i32 s0, 0, s47
	s_mul_i32 s0, s0, s1
	v_mul_f32_e32 v0, 0x4f7ffffe, v0
	v_rcp_iflag_f32_e32 v2, v2
	v_cvt_u32_f32_e32 v0, v0
	s_mul_hi_u32 s0, s1, s0
	s_add_i32 s52, s1, s0
	v_mul_f32_e32 v2, 0x4f7ffffe, v2
	v_cvt_u32_f32_e32 v2, v2
	s_sub_i32 s0, 0, s50
	v_mul_lo_u32 v4, s0, v0
	v_lshrrev_b32_e32 v170, 2, v1
	v_lshrrev_b32_e32 v1, 1, v1
	v_mul_hi_u32 v4, v0, v4
	s_sub_i32 s0, 0, s51
	v_xor_b32_e32 v1, v3, v1
	v_add_u32_e32 v190, v0, v4
	v_mul_lo_u32 v0, s0, v2
	v_or_b32_e32 v171, 32, v161
	s_mov_b32 s31, 0x27000
	s_mov_b32 s30, 0x7ffffffe
	v_xor_b32_e32 v3, 8, v1
	v_mul_hi_u32 v0, v2, v0
	v_or_b32_e32 v163, 32, v162
	v_or_b32_e32 v164, 64, v162
	v_or_b32_e32 v165, 0x60, v162
	v_or_b32_e32 v166, 0x80, v162
	v_or_b32_e32 v167, 0xa0, v162
	v_or_b32_e32 v168, 0xc0, v162
	v_or_b32_e32 v169, 0xe0, v162
	v_mul_lo_u32 v172, s36, v161
	v_mul_lo_u32 v173, s36, v171
	v_mul_lo_u32 v174, s37, v161
	v_mul_lo_u32 v175, s37, v171
	v_xor_b32_e32 v177, 32, v176
	v_xor_b32_e32 v178, 64, v176
	v_xor_b32_e32 v179, 0x60, v176
	v_xor_b32_e32 v181, 64, v180
	s_and_b32 s25, s25, 0xffff
	v_mov_b32_e32 v138, v136
	v_mov_b32_e32 v139, v136
	s_ashr_i32 s46, s33, 31
	s_bfe_i32 s49, s3, 0x1001d
	v_mov_b32_e32 v191, 0
	v_add_u32_e32 v192, v2, v0
	v_or_b32_e32 v193, 0x60, v161
	v_or_b32_e32 v194, 64, v161
	v_bfrev_b32_e32 v195, 1
	v_add_u32_e32 v196, 0, v1
	v_add_u32_e32 v197, 0, v3
	s_mov_b32 s40, s4
	s_mov_b32 s41, s5
	s_mov_b32 s42, s30
	s_mov_b32 s43, s31
	s_branch .L3
.L2:
	v_or_b32_e32 v137, s8, v170
	s_ashr_i32 s0, s8, 31
	v_add_u32_e32 v137, s0, v137
	v_xor_b32_e32 v140, s0, v137
	v_mul_hi_u32 v141, v140, v192
	v_mul_lo_u32 v141, v141, s51
	v_sub_u32_e32 v140, v140, v141
	v_subrev_u32_e32 v141, s51, v140
	v_cmp_le_u32_e32 vcc, s51, v140
	v_or_b32_e32 v128, s27, v162
	v_or_b32_e32 v129, s27, v163
	v_cndmask_b32_e32 v140, v140, v141, vcc
	v_subrev_u32_e32 v141, s51, v140
	v_cmp_le_u32_e32 vcc, s51, v140
	v_or_b32_e32 v130, s27, v164
	v_or_b32_e32 v131, s27, v165
	v_cndmask_b32_e32 v140, v140, v141, vcc
	v_add_u32_e32 v141, 64, v137
	v_xor_b32_e32 v141, s0, v141
	v_mul_hi_u32 v142, v141, v192
	v_mul_lo_u32 v142, v142, s51
	v_sub_u32_e32 v141, v141, v142
	v_subrev_u32_e32 v142, s51, v141
	v_cmp_le_u32_e32 vcc, s51, v141
	v_or_b32_e32 v132, s27, v166
	v_or_b32_e32 v133, s27, v167
	v_cndmask_b32_e32 v141, v141, v142, vcc
	v_subrev_u32_e32 v142, s51, v141
	v_cmp_le_u32_e32 vcc, s51, v141
	v_or_b32_e32 v134, s27, v168
	v_or_b32_e32 v135, s27, v169
	v_cndmask_b32_e32 v141, v141, v142, vcc
	v_add_u32_e32 v142, 0x80, v137
	v_xor_b32_e32 v142, s0, v142
	v_mul_hi_u32 v143, v142, v192
	v_mul_lo_u32 v143, v143, s51
	v_sub_u32_e32 v142, v142, v143
	v_subrev_u32_e32 v143, s51, v142
	v_cmp_le_u32_e32 vcc, s51, v142
	v_add_u32_e32 v137, 0xc0, v137
	v_xor_b32_e32 v137, s0, v137
	v_cndmask_b32_e32 v142, v142, v143, vcc
	v_subrev_u32_e32 v143, s51, v142
	v_cmp_le_u32_e32 vcc, s51, v142
	s_mul_i32 s26, s26, s38
	s_mul_i32 s27, s27, s39
	v_cndmask_b32_e32 v142, v142, v143, vcc
	v_mul_hi_u32 v143, v137, v192
	v_mul_lo_u32 v143, v143, s51
	v_sub_u32_e32 v137, v137, v143
	v_subrev_u32_e32 v143, s51, v137
	v_cmp_le_u32_e32 vcc, s51, v137
	v_xor_b32_e32 v140, s0, v140
	v_xor_b32_e32 v141, s0, v141
	v_cndmask_b32_e32 v137, v137, v143, vcc
	v_subrev_u32_e32 v143, s51, v137
	v_cmp_le_u32_e32 vcc, s51, v137
	v_xor_b32_e32 v142, s0, v142
	s_add_i32 s27, s27, s26
	v_cndmask_b32_e32 v137, v137, v143, vcc
	v_xor_b32_e32 v137, s0, v137
	v_subrev_u32_e32 v143, s0, v137
	v_mov_b32_e32 v137, v136
	v_subrev_u32_e32 v140, s0, v140
	v_subrev_u32_e32 v141, s0, v141
	v_subrev_u32_e32 v142, s0, v142
	v_cmp_gt_i32_e64 s[18:19], s15, v128
	v_add_u32_e32 v128, s27, v182
	v_pk_mul_f32 v[122:123], v[136:137], v[122:123]
	v_pk_mul_f32 v[120:121], v[138:139], v[120:121]
	v_pk_mul_f32 v[110:111], v[136:137], v[110:111]
	v_pk_mul_f32 v[108:109], v[138:139], v[108:109]
	v_pk_mul_f32 v[102:103], v[136:137], v[102:103]
	v_pk_mul_f32 v[100:101], v[138:139], v[100:101]
	v_pk_mul_f32 v[94:95], v[136:137], v[94:95]
	v_pk_mul_f32 v[92:93], v[138:139], v[92:93]
	v_cmp_gt_i32_e64 s[20:21], s15, v129
	v_add_u32_e32 v129, s27, v183
	v_cvt_pk_bf16_f32 v120, v120, v121
	v_cvt_pk_bf16_f32 v121, v122, v123
	v_add_lshl_u32 v122, v128, v140, 1
	s_and_b64 s[18:19], s[22:23], s[18:19]
	v_cvt_pk_bf16_f32 v108, v108, v109
	v_cvt_pk_bf16_f32 v109, v110, v111
	v_add_lshl_u32 v110, v128, v141, 1
	v_cvt_pk_bf16_f32 v100, v100, v101
	v_cvt_pk_bf16_f32 v101, v102, v103
	v_add_lshl_u32 v102, v128, v142, 1
	v_cvt_pk_bf16_f32 v92, v92, v93
	v_cvt_pk_bf16_f32 v93, v94, v95
	v_add_lshl_u32 v94, v128, v143, 1
	v_pk_mul_f32 v[86:87], v[136:137], v[86:87]
	v_pk_mul_f32 v[84:85], v[138:139], v[84:85]
	v_cndmask_b32_e64 v122, v195, v122, s[18:19]
	v_cndmask_b32_e64 v110, v195, v110, s[18:19]
	v_cndmask_b32_e64 v102, v195, v102, s[18:19]
	v_cndmask_b32_e64 v94, v195, v94, s[18:19]
	v_cvt_pk_bf16_f32 v84, v84, v85
	v_cvt_pk_bf16_f32 v85, v86, v87
	v_add_lshl_u32 v86, v129, v140, 1
	s_and_b64 s[18:19], s[22:23], s[20:21]
	v_cmp_gt_i32_e64 s[10:11], s15, v130
	v_cmp_gt_i32_e64 s[8:9], s15, v131
	v_cmp_gt_i32_e64 s[6:7], s15, v132
	v_cmp_gt_i32_e64 s[2:3], s15, v133
	v_cmp_gt_i32_e64 s[0:1], s15, v134
	v_cmp_gt_i32_e32 vcc, s15, v135
	v_add_u32_e32 v130, s27, v184
	v_add_u32_e32 v131, s27, v185
	v_add_u32_e32 v132, s27, v186
	v_add_u32_e32 v133, s27, v187
	v_add_u32_e32 v134, s27, v188
	v_add_u32_e32 v135, s27, v189
	s_mov_b32 s26, s30
	s_mov_b32 s27, s31
	v_cndmask_b32_e64 v86, v195, v86, s[18:19]
	buffer_store_dwordx2 v[120:121], v122, s[24:27], 0 offen
	buffer_store_dwordx2 v[108:109], v110, s[24:27], 0 offen
	buffer_store_dwordx2 v[100:101], v102, s[24:27], 0 offen
	buffer_store_dwordx2 v[92:93], v94, s[24:27], 0 offen
	buffer_store_dwordx2 v[84:85], v86, s[24:27], 0 offen
	v_pk_mul_f32 v[84:85], v[136:137], v[126:127]
	v_pk_mul_f32 v[86:87], v[138:139], v[124:125]
	s_and_b64 s[10:11], s[22:23], s[10:11]
	v_cvt_pk_bf16_f32 v86, v86, v87
	v_cvt_pk_bf16_f32 v87, v84, v85
	v_add_lshl_u32 v84, v129, v141, 1
	v_cndmask_b32_e64 v84, v195, v84, s[18:19]
	buffer_store_dwordx2 v[86:87], v84, s[24:27], 0 offen
	v_pk_mul_f32 v[84:85], v[136:137], v[118:119]
	v_pk_mul_f32 v[86:87], v[138:139], v[116:117]
	v_pk_mul_f32 v[82:83], v[136:137], v[82:83]
	v_cvt_pk_bf16_f32 v86, v86, v87
	v_cvt_pk_bf16_f32 v87, v84, v85
	v_add_lshl_u32 v84, v129, v142, 1
	v_cndmask_b32_e64 v84, v195, v84, s[18:19]
	buffer_store_dwordx2 v[86:87], v84, s[24:27], 0 offen
	v_pk_mul_f32 v[84:85], v[136:137], v[114:115]
	v_pk_mul_f32 v[86:87], v[138:139], v[112:113]
	v_pk_mul_f32 v[80:81], v[138:139], v[80:81]
	v_cvt_pk_bf16_f32 v86, v86, v87
	v_cvt_pk_bf16_f32 v87, v84, v85
	v_add_lshl_u32 v84, v129, v143, 1
	v_cndmask_b32_e64 v84, v195, v84, s[18:19]
	buffer_store_dwordx2 v[86:87], v84, s[24:27], 0 offen
	v_pk_mul_f32 v[84:85], v[136:137], v[106:107]
	v_pk_mul_f32 v[86:87], v[138:139], v[104:105]
	v_pk_mul_f32 v[78:79], v[136:137], v[78:79]
	v_cvt_pk_bf16_f32 v86, v86, v87
	v_cvt_pk_bf16_f32 v87, v84, v85
	v_add_lshl_u32 v84, v130, v140, 1
	v_cndmask_b32_e64 v84, v195, v84, s[10:11]
	buffer_store_dwordx2 v[86:87], v84, s[24:27], 0 offen
	v_pk_mul_f32 v[84:85], v[136:137], v[98:99]
	v_pk_mul_f32 v[86:87], v[138:139], v[96:97]
	v_pk_mul_f32 v[76:77], v[138:139], v[76:77]
	v_cvt_pk_bf16_f32 v86, v86, v87
	v_cvt_pk_bf16_f32 v87, v84, v85
	v_add_lshl_u32 v84, v130, v141, 1
	v_cndmask_b32_e64 v84, v195, v84, s[10:11]
	buffer_store_dwordx2 v[86:87], v84, s[24:27], 0 offen
	v_pk_mul_f32 v[84:85], v[136:137], v[90:91]
	v_pk_mul_f32 v[86:87], v[138:139], v[88:89]
	v_pk_mul_f32 v[74:75], v[136:137], v[74:75]
	v_pk_mul_f32 v[72:73], v[138:139], v[72:73]
	v_pk_mul_f32 v[70:71], v[136:137], v[70:71]
	v_pk_mul_f32 v[68:69], v[138:139], v[68:69]
	v_pk_mul_f32 v[66:67], v[136:137], v[66:67]
	v_pk_mul_f32 v[64:65], v[138:139], v[64:65]
	v_pk_mul_f32 v[62:63], v[136:137], v[62:63]
	v_pk_mul_f32 v[60:61], v[138:139], v[60:61]
	v_pk_mul_f32 v[58:59], v[136:137], v[58:59]
	v_pk_mul_f32 v[56:57], v[138:139], v[56:57]
	v_pk_mul_f32 v[54:55], v[136:137], v[54:55]
	v_pk_mul_f32 v[52:53], v[138:139], v[52:53]
	v_pk_mul_f32 v[50:51], v[136:137], v[50:51]
	v_pk_mul_f32 v[48:49], v[138:139], v[48:49]
	v_pk_mul_f32 v[46:47], v[136:137], v[46:47]
	v_pk_mul_f32 v[44:45], v[138:139], v[44:45]
	v_pk_mul_f32 v[42:43], v[136:137], v[42:43]
	v_pk_mul_f32 v[40:41], v[138:139], v[40:41]
	v_pk_mul_f32 v[38:39], v[136:137], v[38:39]
	v_pk_mul_f32 v[36:37], v[138:139], v[36:37]
	v_pk_mul_f32 v[34:35], v[136:137], v[34:35]
	v_pk_mul_f32 v[32:33], v[138:139], v[32:33]
	v_pk_mul_f32 v[30:31], v[136:137], v[30:31]
	v_pk_mul_f32 v[28:29], v[138:139], v[28:29]
	v_pk_mul_f32 v[26:27], v[136:137], v[26:27]
	v_pk_mul_f32 v[24:25], v[138:139], v[24:25]
	v_pk_mul_f32 v[18:19], v[136:137], v[18:19]
	v_pk_mul_f32 v[16:17], v[138:139], v[16:17]
	v_pk_mul_f32 v[10:11], v[136:137], v[10:11]
	v_pk_mul_f32 v[8:9], v[138:139], v[8:9]
	v_pk_mul_f32 v[2:3], v[136:137], v[2:3]
	v_pk_mul_f32 v[0:1], v[138:139], v[0:1]
	v_cvt_pk_bf16_f32 v86, v86, v87
	v_cvt_pk_bf16_f32 v87, v84, v85
	v_add_lshl_u32 v84, v130, v142, 1
	v_cvt_pk_bf16_f32 v80, v80, v81
	v_cvt_pk_bf16_f32 v81, v82, v83
	v_add_lshl_u32 v82, v130, v143, 1
	v_cvt_pk_bf16_f32 v76, v76, v77
	v_cvt_pk_bf16_f32 v77, v78, v79
	v_add_lshl_u32 v78, v131, v140, 1
	s_and_b64 s[8:9], s[22:23], s[8:9]
	v_cvt_pk_bf16_f32 v72, v72, v73
	v_cvt_pk_bf16_f32 v73, v74, v75
	v_add_lshl_u32 v74, v131, v141, 1
	v_cvt_pk_bf16_f32 v68, v68, v69
	v_cvt_pk_bf16_f32 v69, v70, v71
	v_add_lshl_u32 v70, v131, v142, 1
	v_cvt_pk_bf16_f32 v64, v64, v65
	v_cvt_pk_bf16_f32 v65, v66, v67
	v_add_lshl_u32 v66, v131, v143, 1
	v_cvt_pk_bf16_f32 v60, v60, v61
	v_cvt_pk_bf16_f32 v61, v62, v63
	v_add_lshl_u32 v62, v132, v140, 1
	s_and_b64 s[6:7], s[22:23], s[6:7]
	v_cvt_pk_bf16_f32 v56, v56, v57
	v_cvt_pk_bf16_f32 v57, v58, v59
	v_add_lshl_u32 v58, v132, v141, 1
	v_cvt_pk_bf16_f32 v52, v52, v53
	v_cvt_pk_bf16_f32 v53, v54, v55
	v_add_lshl_u32 v54, v132, v142, 1
	v_cvt_pk_bf16_f32 v48, v48, v49
	v_cvt_pk_bf16_f32 v49, v50, v51
	v_add_lshl_u32 v50, v132, v143, 1
	v_cvt_pk_bf16_f32 v44, v44, v45
	v_cvt_pk_bf16_f32 v45, v46, v47
	v_add_lshl_u32 v46, v133, v140, 1
	s_and_b64 s[2:3], s[22:23], s[2:3]
	v_cvt_pk_bf16_f32 v40, v40, v41
	v_cvt_pk_bf16_f32 v41, v42, v43
	v_add_lshl_u32 v42, v133, v141, 1
	v_cvt_pk_bf16_f32 v36, v36, v37
	v_cvt_pk_bf16_f32 v37, v38, v39
	v_add_lshl_u32 v38, v133, v142, 1
	v_cvt_pk_bf16_f32 v32, v32, v33
	v_cvt_pk_bf16_f32 v33, v34, v35
	v_add_lshl_u32 v34, v133, v143, 1
	v_cvt_pk_bf16_f32 v28, v28, v29
	v_cvt_pk_bf16_f32 v29, v30, v31
	v_add_lshl_u32 v30, v134, v140, 1
	s_and_b64 s[0:1], s[22:23], s[0:1]
	v_cvt_pk_bf16_f32 v24, v24, v25
	v_cvt_pk_bf16_f32 v25, v26, v27
	v_add_lshl_u32 v26, v134, v141, 1
	v_cvt_pk_bf16_f32 v16, v16, v17
	v_cvt_pk_bf16_f32 v17, v18, v19
	v_add_lshl_u32 v18, v134, v142, 1
	v_cvt_pk_bf16_f32 v8, v8, v9
	v_cvt_pk_bf16_f32 v9, v10, v11
	v_add_lshl_u32 v10, v134, v143, 1
	v_cvt_pk_bf16_f32 v0, v0, v1
	v_cvt_pk_bf16_f32 v1, v2, v3
	v_add_lshl_u32 v2, v135, v140, 1
	s_and_b64 vcc, s[22:23], vcc
	v_cndmask_b32_e64 v84, v195, v84, s[10:11]
	v_cndmask_b32_e64 v82, v195, v82, s[10:11]
	v_cndmask_b32_e64 v78, v195, v78, s[8:9]
	v_cndmask_b32_e64 v74, v195, v74, s[8:9]
	v_cndmask_b32_e64 v70, v195, v70, s[8:9]
	v_cndmask_b32_e64 v66, v195, v66, s[8:9]
	v_cndmask_b32_e64 v62, v195, v62, s[6:7]
	v_cndmask_b32_e64 v58, v195, v58, s[6:7]
	v_cndmask_b32_e64 v54, v195, v54, s[6:7]
	v_cndmask_b32_e64 v50, v195, v50, s[6:7]
	v_cndmask_b32_e64 v46, v195, v46, s[2:3]
	v_cndmask_b32_e64 v42, v195, v42, s[2:3]
	v_cndmask_b32_e64 v38, v195, v38, s[2:3]
	v_cndmask_b32_e64 v34, v195, v34, s[2:3]
	v_cndmask_b32_e64 v30, v195, v30, s[0:1]
	v_cndmask_b32_e64 v26, v195, v26, s[0:1]
	v_cndmask_b32_e64 v18, v195, v18, s[0:1]
	v_cndmask_b32_e64 v10, v195, v10, s[0:1]
	v_cndmask_b32_e32 v2, v195, v2, vcc
	buffer_store_dwordx2 v[86:87], v84, s[24:27], 0 offen
	buffer_store_dwordx2 v[80:81], v82, s[24:27], 0 offen
	buffer_store_dwordx2 v[76:77], v78, s[24:27], 0 offen
	buffer_store_dwordx2 v[72:73], v74, s[24:27], 0 offen
	buffer_store_dwordx2 v[68:69], v70, s[24:27], 0 offen
	buffer_store_dwordx2 v[64:65], v66, s[24:27], 0 offen
	buffer_store_dwordx2 v[60:61], v62, s[24:27], 0 offen
	buffer_store_dwordx2 v[56:57], v58, s[24:27], 0 offen
	buffer_store_dwordx2 v[52:53], v54, s[24:27], 0 offen
	buffer_store_dwordx2 v[48:49], v50, s[24:27], 0 offen
	buffer_store_dwordx2 v[44:45], v46, s[24:27], 0 offen
	buffer_store_dwordx2 v[40:41], v42, s[24:27], 0 offen
	buffer_store_dwordx2 v[36:37], v38, s[24:27], 0 offen
	buffer_store_dwordx2 v[32:33], v34, s[24:27], 0 offen
	buffer_store_dwordx2 v[28:29], v30, s[24:27], 0 offen
	buffer_store_dwordx2 v[24:25], v26, s[24:27], 0 offen
	buffer_store_dwordx2 v[16:17], v18, s[24:27], 0 offen
	buffer_store_dwordx2 v[8:9], v10, s[24:27], 0 offen
	buffer_store_dwordx2 v[0:1], v2, s[24:27], 0 offen
	v_pk_mul_f32 v[0:1], v[136:137], v[22:23]
	v_pk_mul_f32 v[2:3], v[138:139], v[20:21]
	s_addk_i32 s16, 0x100
	v_cvt_pk_bf16_f32 v2, v2, v3
	v_cvt_pk_bf16_f32 v3, v0, v1
	v_add_lshl_u32 v0, v135, v141, 1
	v_cndmask_b32_e32 v0, v195, v0, vcc
	buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen
	v_pk_mul_f32 v[0:1], v[136:137], v[14:15]
	v_pk_mul_f32 v[2:3], v[138:139], v[12:13]
	s_cmp_lt_i32 s16, s14
	v_cvt_pk_bf16_f32 v2, v2, v3
	v_cvt_pk_bf16_f32 v3, v0, v1
	v_add_lshl_u32 v0, v135, v142, 1
	v_cndmask_b32_e32 v0, v195, v0, vcc
	buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen
	v_pk_mul_f32 v[0:1], v[136:137], v[6:7]
	v_pk_mul_f32 v[2:3], v[138:139], v[4:5]
	s_nop 0
	v_cvt_pk_bf16_f32 v2, v2, v3
	v_cvt_pk_bf16_f32 v3, v0, v1
	v_add_lshl_u32 v0, v135, v143, 1
	v_cndmask_b32_e32 v0, v195, v0, vcc
	buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen
	s_cbranch_scc0 .L6
.L3:
	s_abs_i32 s1, s16
	s_mul_hi_u32 s2, s1, s48
	s_mul_i32 s3, s2, s45
	s_ashr_i32 s0, s16, 31
	s_sub_i32 s1, s1, s3
	s_xor_b32 s0, s0, s46
	s_add_i32 s3, s2, 1
	s_sub_i32 s6, s1, s45
	s_cmp_ge_u32 s1, s45
	s_cselect_b32 s2, s3, s2
	s_cselect_b32 s1, s6, s1
	s_add_i32 s3, s2, 1
	s_cmp_ge_u32 s1, s45
	s_cselect_b32 s1, s3, s2
	s_xor_b32 s1, s1, s0
	s_sub_i32 s26, s1, s0
	s_mul_i32 s0, s26, s33
	s_sub_i32 s0, s16, s0
	s_abs_i32 s2, s0
	s_mul_hi_u32 s3, s2, s52
	s_mul_i32 s6, s3, s47
	s_ashr_i32 s1, s0, 31
	s_sub_i32 s2, s2, s6
	s_xor_b32 s1, s1, s49
	s_add_i32 s6, s3, 1
	s_sub_i32 s7, s2, s47
	s_cmp_ge_u32 s2, s47
	s_cselect_b32 s3, s6, s3
	s_cselect_b32 s2, s7, s2
	s_add_i32 s6, s3, 1
	s_cmp_ge_u32 s2, s47
	s_cselect_b32 s2, s6, s3
	s_xor_b32 s2, s2, s1
	s_sub_i32 s1, s2, s1
	s_lshl_b32 s2, s1, 2
	s_sub_i32 s3, s17, s2
	s_min_i32 s3, s3, 4
	s_abs_i32 s6, s3
	v_cvt_f32_u32_e32 v0, s6
	s_sub_i32 s8, 0, s6
	s_mul_i32 s1, s1, s34
	s_sub_i32 s0, s0, s1
	v_rcp_iflag_f32_e32 v0, v0
	s_abs_i32 s7, s0
	s_xor_b32 s1, s0, s3
	s_ashr_i32 s1, s1, 31
	v_mul_f32_e32 v0, 0x4f7ffffe, v0
	v_cvt_u32_f32_e32 v0, v0
	v_mov_b32_e32 v121, 0
	v_mov_b32_e32 v120, 0
	v_mov_b32_e32 v123, 0
	v_readfirstlane_b32 s9, v0
	s_mul_i32 s8, s8, s9
	s_mul_hi_u32 s8, s9, s8
	s_add_i32 s9, s9, s8
	s_mul_hi_u32 s8, s7, s9
	s_mul_i32 s9, s8, s6
	s_sub_i32 s7, s7, s9
	s_add_i32 s9, s8, 1
	s_sub_i32 s10, s7, s6
	s_cmp_ge_u32 s7, s6
	s_cselect_b32 s8, s9, s8
	s_cselect_b32 s7, s10, s7
	s_add_i32 s9, s8, 1
	s_cmp_ge_u32 s7, s6
	s_cselect_b32 s6, s9, s8
	s_xor_b32 s6, s6, s1
	s_sub_i32 s6, s6, s1
	s_mul_i32 s1, s6, s3
	s_sub_i32 s0, s0, s1
	s_ashr_i32 s27, s26, 31
	s_add_i32 s2, s0, s2
	s_lshl_b64 s[0:1], s[26:27], 3
	s_add_u32 s0, s12, s0
	s_addc_u32 s1, s13, s1
	global_load_dword v128, v191, s[0:1]
	s_add_i32 s0, s26, 1
	s_ashr_i32 s1, s0, 31
	s_lshl_b64 s[0:1], s[0:1], 3
	s_add_u32 s0, s12, s0
	s_addc_u32 s1, s13, s1
	global_load_dword v0, v191, s[0:1]
	s_lshl_b32 s27, s2, 8
	s_bfe_i32 s0, s2, 0x10017
	s_lshl_b32 s8, s6, 8
	v_or_b32_e32 v1, s27, v160
	s_bfe_i32 s1, s6, 0x10017
	v_or_b32_e32 v2, s8, v160
	v_add_u32_e32 v1, s0, v1
	v_add_u32_e32 v2, s1, v2
	v_xor_b32_e32 v1, s0, v1
	v_xor_b32_e32 v2, s1, v2
	v_mul_hi_u32 v3, v1, v190
	v_mul_hi_u32 v4, v2, v192
	v_mul_lo_u32 v3, v3, s50
	v_mul_lo_u32 v4, v4, s51
	v_sub_u32_e32 v1, v1, v3
	v_sub_u32_e32 v2, v2, v4
	v_subrev_u32_e32 v3, s50, v1
	v_cmp_le_u32_e32 vcc, s50, v1
	v_subrev_u32_e32 v4, s51, v2
	v_mov_b32_e32 v122, 0
	v_cndmask_b32_e32 v1, v1, v3, vcc
	v_cmp_le_u32_e32 vcc, s51, v2
	v_subrev_u32_e32 v3, s50, v1
	v_mov_b32_e32 v109, 0
	v_cndmask_b32_e32 v2, v2, v4, vcc
	v_cmp_le_u32_e32 vcc, s50, v1
	v_subrev_u32_e32 v4, s51, v2
	v_mov_b32_e32 v108, 0
	v_cndmask_b32_e32 v1, v1, v3, vcc
	v_cmp_le_u32_e32 vcc, s51, v2
	v_xor_b32_e32 v1, s0, v1
	v_subrev_u32_e32 v137, s0, v1
	v_cndmask_b32_e32 v2, v2, v4, vcc
	v_xor_b32_e32 v2, s1, v2
	v_subrev_u32_e32 v198, s1, v2
	v_mov_b32_e32 v111, 0
	v_mov_b32_e32 v110, 0
	v_mov_b32_e32 v101, 0
	v_mov_b32_e32 v100, 0
	v_mov_b32_e32 v103, 0
	v_mov_b32_e32 v102, 0
	v_mov_b32_e32 v93, 0
	v_mov_b32_e32 v92, 0
	v_mov_b32_e32 v95, 0
	v_mov_b32_e32 v94, 0
	v_mov_b32_e32 v85, 0
	v_mov_b32_e32 v84, 0
	v_mov_b32_e32 v87, 0
	v_mov_b32_e32 v86, 0
	v_mov_b32_e32 v125, 0
	v_mov_b32_e32 v124, 0
	v_mov_b32_e32 v127, 0
	v_mov_b32_e32 v126, 0
	v_mov_b32_e32 v117, 0
	v_mov_b32_e32 v116, 0
	v_mov_b32_e32 v119, 0
	v_mov_b32_e32 v118, 0
	v_mov_b32_e32 v113, 0
	v_mov_b32_e32 v112, 0
	v_mov_b32_e32 v115, 0
	v_mov_b32_e32 v114, 0
	v_mov_b32_e32 v105, 0
	v_mov_b32_e32 v104, 0
	v_mov_b32_e32 v107, 0
	v_mov_b32_e32 v106, 0
	v_mov_b32_e32 v97, 0
	v_mov_b32_e32 v96, 0
	v_mov_b32_e32 v99, 0
	v_mov_b32_e32 v98, 0
	v_mov_b32_e32 v89, 0
	v_mov_b32_e32 v88, 0
	v_mov_b32_e32 v91, 0
	v_mov_b32_e32 v90, 0
	s_waitcnt vmcnt(1)
	v_readfirstlane_b32 s0, v128
	v_mul_lo_u32 v1, s36, v128
	v_mul_lo_u32 v2, s37, v128
	v_add_u32_e32 v1, v1, v137
	v_add_u32_e32 v2, v2, v198
	v_add_u32_e32 v3, v1, v172
	s_waitcnt vmcnt(0)
	v_readfirstlane_b32 s1, v0
	s_sub_i32 s9, s1, s0
	s_add_i32 s6, s9, 63
	s_cmp_gt_i32 s6, 63
	v_cmp_gt_i32_e32 vcc, s9, v161
	s_cselect_b64 s[2:3], -1, 0
	v_cmp_gt_i32_e64 s[0:1], s9, v171
	s_and_b64 vcc, vcc, s[2:3]
	v_add_u32_e32 v1, v1, v173
	v_add_u32_e32 v4, v2, v174
	v_add_u32_e32 v2, v2, v175
	v_cndmask_b32_e32 v16, v195, v3, vcc
	s_and_b64 s[0:1], s[0:1], s[2:3]
	v_cndmask_b32_e64 v17, v195, v1, s[0:1]
	v_cndmask_b32_e32 v18, v195, v4, vcc
	v_cndmask_b32_e64 v19, v195, v2, s[0:1]
	buffer_load_dwordx4 v[0:3], v16, s[28:31], 0 offen
	buffer_load_dwordx4 v[4:7], v17, s[28:31], 0 offen
	buffer_load_dwordx4 v[8:11], v18, s[40:43], 0 offen
	buffer_load_dwordx4 v[12:15], v19, s[40:43], 0 offen
	v_mov_b32_e32 v81, 0
	v_mov_b32_e32 v80, 0
	v_mov_b32_e32 v83, 0
	v_mov_b32_e32 v82, 0
	v_mov_b32_e32 v77, 0
	v_mov_b32_e32 v76, 0
	v_mov_b32_e32 v79, 0
	v_mov_b32_e32 v78, 0
	v_mov_b32_e32 v73, 0
	v_mov_b32_e32 v72, 0
	v_mov_b32_e32 v75, 0
	v_mov_b32_e32 v74, 0
	v_mov_b32_e32 v69, 0
	v_mov_b32_e32 v68, 0
	v_mov_b32_e32 v71, 0
	v_mov_b32_e32 v70, 0
	v_mov_b32_e32 v65, 0
	v_mov_b32_e32 v64, 0
	v_mov_b32_e32 v67, 0
	v_mov_b32_e32 v66, 0
	v_mov_b32_e32 v61, 0
	v_mov_b32_e32 v60, 0
	v_mov_b32_e32 v63, 0
	v_mov_b32_e32 v62, 0
	v_mov_b32_e32 v57, 0
	v_mov_b32_e32 v56, 0
	v_mov_b32_e32 v59, 0
	v_mov_b32_e32 v58, 0
	v_mov_b32_e32 v53, 0
	v_mov_b32_e32 v52, 0
	v_mov_b32_e32 v55, 0
	v_mov_b32_e32 v54, 0
	v_mov_b32_e32 v49, 0
	v_mov_b32_e32 v48, 0
	v_mov_b32_e32 v51, 0
	v_mov_b32_e32 v50, 0
	v_mov_b32_e32 v45, 0
	v_mov_b32_e32 v44, 0
	v_mov_b32_e32 v47, 0
	v_mov_b32_e32 v46, 0
	v_mov_b32_e32 v41, 0
	v_mov_b32_e32 v40, 0
	v_mov_b32_e32 v43, 0
	v_mov_b32_e32 v42, 0
	v_mov_b32_e32 v37, 0
	v_mov_b32_e32 v36, 0
	v_mov_b32_e32 v39, 0
	s_cmpk_lt_i32 s6, 0x80
	s_waitcnt lgkmcnt(0)
	s_barrier
	v_mov_b32_e32 v38, 0
	v_mov_b32_e32 v33, 0
	v_mov_b32_e32 v32, 0
	v_mov_b32_e32 v35, 0
	v_mov_b32_e32 v34, 0
	v_mov_b32_e32 v29, 0
	v_mov_b32_e32 v28, 0
	s_waitcnt vmcnt(2)
	ds_write2st64_b64 v196, v[0:1], v[4:5] offset1:16
	ds_write2st64_b64 v197, v[2:3], v[6:7] offset1:16
	s_waitcnt vmcnt(0)
	ds_write2st64_b64 v196, v[8:9], v[12:13] offset0:32 offset1:48
	ds_write2st64_b64 v197, v[10:11], v[14:15] offset0:32 offset1:48
	v_mov_b32_e32 v31, 0
	v_mov_b32_e32 v30, 0
	v_mov_b32_e32 v25, 0
	v_mov_b32_e32 v24, 0
	v_mov_b32_e32 v27, 0
	v_mov_b32_e32 v26, 0
	v_mov_b32_e32 v17, 0
	v_mov_b32_e32 v16, 0
	v_mov_b32_e32 v19, 0
	v_mov_b32_e32 v18, 0
	v_mov_b32_e32 v9, 0
	v_mov_b32_e32 v8, 0
	v_mov_b32_e32 v11, 0
	v_mov_b32_e32 v10, 0
	v_mov_b32_e32 v1, 0
	v_mov_b32_e32 v0, 0
	v_mov_b32_e32 v3, 0
	v_mov_b32_e32 v2, 0
	v_mov_b32_e32 v21, 0
	v_mov_b32_e32 v20, 0
	v_mov_b32_e32 v23, 0
	v_mov_b32_e32 v22, 0
	v_mov_b32_e32 v13, 0
	v_mov_b32_e32 v12, 0
	v_mov_b32_e32 v15, 0
	v_mov_b32_e32 v14, 0
	v_mov_b32_e32 v5, 0
	v_mov_b32_e32 v4, 0
	v_mov_b32_e32 v7, 0
	v_mov_b32_e32 v6, 0
	s_cbranch_scc1 .L5
	s_lshr_b32 s0, s6, 6
	v_add_u32_e32 v0, v193, v128
	v_add_u32_e32 v1, v194, v128
	v_mov_b32_e32 v120, 0
	v_mul_lo_u32 v199, s37, v0
	v_mul_lo_u32 v200, s37, v1
	v_mul_lo_u32 v201, s36, v0
	v_mul_lo_u32 v202, s36, v1
	s_add_i32 s10, s0, -1
	v_mov_b32_e32 v203, v194
	v_mov_b32_e32 v204, v193
	v_mov_b32_e32 v121, v120
	v_mov_b32_e32 v122, v120
	v_mov_b32_e32 v123, v120
	v_mov_b32_e32 v108, v120
	v_mov_b32_e32 v109, v120
	v_mov_b32_e32 v110, v120
	v_mov_b32_e32 v111, v120
	v_mov_b32_e32 v100, v120
	v_mov_b32_e32 v101, v120
	v_mov_b32_e32 v102, v120
	v_mov_b32_e32 v103, v120
	v_mov_b32_e32 v92, v120
	v_mov_b32_e32 v93, v120
	v_mov_b32_e32 v94, v120
	v_mov_b32_e32 v95, v120
	v_mov_b32_e32 v84, v120
	v_mov_b32_e32 v85, v120
	v_mov_b32_e32 v86, v120
	v_mov_b32_e32 v87, v120
	v_mov_b32_e32 v124, v120
	v_mov_b32_e32 v125, v120
	v_mov_b32_e32 v126, v120
	v_mov_b32_e32 v127, v120
	v_mov_b32_e32 v116, v120
	v_mov_b32_e32 v117, v120
	v_mov_b32_e32 v118, v120
	v_mov_b32_e32 v119, v120
	v_mov_b32_e32 v112, v120
	v_mov_b32_e32 v113, v120
	v_mov_b32_e32 v114, v120
	v_mov_b32_e32 v115, v120
	v_mov_b32_e32 v104, v120
	v_mov_b32_e32 v105, v120
	v_mov_b32_e32 v106, v120
	v_mov_b32_e32 v107, v120
	v_mov_b32_e32 v96, v120
	v_mov_b32_e32 v97, v120
	v_mov_b32_e32 v98, v120
	v_mov_b32_e32 v99, v120
	v_mov_b32_e32 v88, v120
	v_mov_b32_e32 v89, v120
	v_mov_b32_e32 v90, v120
	v_mov_b32_e32 v91, v120
	v_mov_b32_e32 v80, v120
	v_mov_b32_e32 v81, v120
	v_mov_b32_e32 v82, v120
	v_mov_b32_e32 v83, v120
	v_mov_b32_e32 v76, v120
	v_mov_b32_e32 v77, v120
	v_mov_b32_e32 v78, v120
	v_mov_b32_e32 v79, v120
	v_mov_b32_e32 v72, v120
	v_mov_b32_e32 v73, v120
	v_mov_b32_e32 v74, v120
	v_mov_b32_e32 v75, v120
	v_mov_b32_e32 v68, v120
	v_mov_b32_e32 v69, v120
	v_mov_b32_e32 v70, v120
	v_mov_b32_e32 v71, v120
	v_mov_b32_e32 v64, v120
	v_mov_b32_e32 v65, v120
	v_mov_b32_e32 v66, v120
	v_mov_b32_e32 v67, v120
	v_mov_b32_e32 v60, v120
	v_mov_b32_e32 v61, v120
	v_mov_b32_e32 v62, v120
	v_mov_b32_e32 v63, v120
	v_mov_b32_e32 v56, v120
	v_mov_b32_e32 v57, v120
	v_mov_b32_e32 v58, v120
	v_mov_b32_e32 v59, v120
	v_mov_b32_e32 v52, v120
	v_mov_b32_e32 v53, v120
	v_mov_b32_e32 v54, v120
	v_mov_b32_e32 v55, v120
	v_mov_b32_e32 v48, v120
	v_mov_b32_e32 v49, v120
	v_mov_b32_e32 v50, v120
	v_mov_b32_e32 v51, v120
	v_mov_b32_e32 v44, v120
	v_mov_b32_e32 v45, v120
	v_mov_b32_e32 v46, v120
	v_mov_b32_e32 v47, v120
	v_mov_b32_e32 v40, v120
	v_mov_b32_e32 v41, v120
	v_mov_b32_e32 v42, v120
	v_mov_b32_e32 v43, v120
	v_mov_b32_e32 v36, v120
	v_mov_b32_e32 v37, v120
	v_mov_b32_e32 v38, v120
	v_mov_b32_e32 v39, v120
	v_mov_b32_e32 v32, v120
	v_mov_b32_e32 v33, v120
	v_mov_b32_e32 v34, v120
	v_mov_b32_e32 v35, v120
	v_mov_b32_e32 v28, v120
	v_mov_b32_e32 v29, v120
	v_mov_b32_e32 v30, v120
	v_mov_b32_e32 v31, v120
	v_mov_b32_e32 v24, v120
	v_mov_b32_e32 v25, v120
	v_mov_b32_e32 v26, v120
	v_mov_b32_e32 v27, v120
	v_mov_b32_e32 v16, v120
	v_mov_b32_e32 v17, v120
	v_mov_b32_e32 v18, v120
	v_mov_b32_e32 v19, v120
	v_mov_b32_e32 v8, v120
	v_mov_b32_e32 v9, v120
	v_mov_b32_e32 v10, v120
	v_mov_b32_e32 v11, v120
	v_mov_b32_e32 v0, v120
	v_mov_b32_e32 v1, v120
	v_mov_b32_e32 v2, v120
	v_mov_b32_e32 v3, v120
	v_mov_b32_e32 v20, v120
	v_mov_b32_e32 v21, v120
	v_mov_b32_e32 v22, v120
	v_mov_b32_e32 v23, v120
	v_mov_b32_e32 v12, v120
	v_mov_b32_e32 v13, v120
	v_mov_b32_e32 v14, v120
	v_mov_b32_e32 v15, v120
	v_mov_b32_e32 v4, v120
	v_mov_b32_e32 v5, v120
	v_mov_b32_e32 v6, v120
	v_mov_b32_e32 v7, v120
.L4:
	v_add_u32_e32 v128, v202, v137
	v_add_u32_e32 v129, v201, v137
	v_cmp_gt_i32_e32 vcc, s9, v204
	v_cmp_gt_i32_e64 s[0:1], s9, v203
	v_add_u32_e32 v216, 0, v180
	v_add_u32_e32 v217, 0, v181
	v_cndmask_b32_e64 v128, v195, v128, s[0:1]
	v_cndmask_b32_e32 v132, v195, v129, vcc
	v_add_u32_e32 v205, 0, v176
	buffer_load_dwordx4 v[128:131], v128, s[28:31], 0 offen
	s_nop 0
	buffer_load_dwordx4 v[132:135], v132, s[28:31], 0 offen
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_setprio 3
	ds_read_b64_tr_b8 v[152:153], v216 offset:16384
	ds_read_b64_tr_b8 v[150:151], v205
	ds_read_b64_tr_b8 v[144:145], v205 offset:8320
	ds_read_b64_tr_b8 v[206:207], v205 offset:128
	ds_read_b64_tr_b8 v[140:141], v216 offset:24704
	ds_read_b64_tr_b8 v[146:147], v216 offset:16512
	ds_read_b64_tr_b8 v[154:155], v217 offset:16384
	ds_read_b64_tr_b8 v[142:143], v217 offset:24704
	ds_read_b64_tr_b8 v[148:149], v217 offset:16512
	v_add_u32_e32 v218, 0, v177
	s_waitcnt lgkmcnt(7)
	v_mfma_f32_16x16x32_fp8_bf8 v[120:123], v[152:153], v[150:151], v[120:123]
	v_add_u32_e32 v219, 0, v178
	v_add_u32_e32 v220, 0, v179
	s_mov_b32 s6, s30
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x32_fp8_bf8 v[108:111], v[154:155], v[150:151], v[108:111]
	s_mov_b32 s7, s31
	s_add_i32 s10, s10, -1
	v_add_u32_e32 v137, s35, v137
	v_mfma_f32_16x16x32_fp8_bf8 v[100:103], v[146:147], v[150:151], v[100:103]
	v_add_u32_e32 v204, 64, v204
	v_add_u32_e32 v203, 64, v203
	s_cmp_lg_u32 s10, 0
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_fp8_bf8 v[92:95], v[148:149], v[150:151], v[92:95]
	ds_read_b64_tr_b8 v[156:157], v218
	ds_read_b64_tr_b8 v[150:151], v218 offset:8320
	ds_read_b64_tr_b8 v[208:209], v218 offset:128
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x32_fp8_bf8 v[84:87], v[152:153], v[156:157], v[84:87]
	v_mfma_f32_16x16x32_fp8_bf8 v[124:127], v[154:155], v[156:157], v[124:127]
	v_mfma_f32_16x16x32_fp8_bf8 v[116:119], v[146:147], v[156:157], v[116:119]
	v_mfma_f32_16x16x32_fp8_bf8 v[112:115], v[148:149], v[156:157], v[112:115]
	ds_read_b64_tr_b8 v[158:159], v219
	ds_read_b64_tr_b8 v[156:157], v219 offset:8320
	ds_read_b64_tr_b8 v[210:211], v219 offset:128
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x32_fp8_bf8 v[104:107], v[152:153], v[158:159], v[104:107]
	v_mfma_f32_16x16x32_fp8_bf8 v[96:99], v[154:155], v[158:159], v[96:99]
	v_mfma_f32_16x16x32_fp8_bf8 v[88:91], v[146:147], v[158:159], v[88:91]
	v_mfma_f32_16x16x32_fp8_bf8 v[80:83], v[148:149], v[158:159], v[80:83]
	ds_read_b64_tr_b8 v[212:213], v220
	ds_read_b64_tr_b8 v[158:159], v220 offset:8320
	ds_read_b64_tr_b8 v[214:215], v220 offset:128
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x32_fp8_bf8 v[76:79], v[152:153], v[212:213], v[76:79]
	v_mfma_f32_16x16x32_fp8_bf8 v[72:75], v[154:155], v[212:213], v[72:75]
	v_mfma_f32_16x16x32_fp8_bf8 v[60:63], v[152:153], v[206:207], v[60:63]
	v_mfma_f32_16x16x32_fp8_bf8 v[56:59], v[154:155], v[206:207], v[56:59]
	v_mfma_f32_16x16x32_fp8_bf8 v[44:47], v[152:153], v[208:209], v[44:47]
	v_mfma_f32_16x16x32_fp8_bf8 v[40:43], v[154:155], v[208:209], v[40:43]
	v_mfma_f32_16x16x32_fp8_bf8 v[28:31], v[152:153], v[210:211], v[28:31]
	v_mfma_f32_16x16x32_fp8_bf8 v[24:27], v[154:155], v[210:211], v[24:27]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_fp8_bf8 v[0:3], v[152:153], v[214:215], v[0:3]
	ds_read_b64_tr_b8 v[152:153], v216 offset:24576
	v_mfma_f32_16x16x32_fp8_bf8 v[20:23], v[154:155], v[214:215], v[20:23]
	ds_read_b64_tr_b8 v[154:155], v217 offset:24576
	v_mfma_f32_16x16x32_fp8_bf8 v[68:71], v[146:147], v[212:213], v[68:71]
	ds_read_b64_tr_b8 v[160:161], v205 offset:8192
	v_mfma_f32_16x16x32_fp8_bf8 v[52:55], v[146:147], v[206:207], v[52:55]
	v_mfma_f32_16x16x32_fp8_bf8 v[36:39], v[146:147], v[208:209], v[36:39]
	v_mfma_f32_16x16x32_fp8_bf8 v[16:19], v[146:147], v[210:211], v[16:19]
	v_mfma_f32_16x16x32_fp8_bf8 v[12:15], v[146:147], v[214:215], v[12:15]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_fp8_bf8 v[120:123], v[152:153], v[160:161], v[120:123]
	ds_read_b64_tr_b8 v[146:147], v218 offset:8192
	v_mfma_f32_16x16x32_fp8_bf8 v[108:111], v[154:155], v[160:161], v[108:111]
	v_mfma_f32_16x16x32_fp8_bf8 v[100:103], v[140:141], v[160:161], v[100:103]
	v_mfma_f32_16x16x32_fp8_bf8 v[92:95], v[142:143], v[160:161], v[92:95]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_fp8_bf8 v[84:87], v[152:153], v[146:147], v[84:87]
	ds_read_b64_tr_b8 v[160:161], v219 offset:8192
	v_mfma_f32_16x16x32_fp8_bf8 v[124:127], v[154:155], v[146:147], v[124:127]
	v_mfma_f32_16x16x32_fp8_bf8 v[116:119], v[140:141], v[146:147], v[116:119]
	v_mfma_f32_16x16x32_fp8_bf8 v[112:115], v[142:143], v[146:147], v[112:115]
	v_mfma_f32_16x16x32_fp8_bf8 v[48:51], v[148:149], v[206:207], v[48:51]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_fp8_bf8 v[104:107], v[152:153], v[160:161], v[104:107]
	ds_read_b64_tr_b8 v[146:147], v220 offset:8192
	v_mfma_f32_16x16x32_fp8_bf8 v[96:99], v[154:155], v[160:161], v[96:99]
	v_mfma_f32_16x16x32_fp8_bf8 v[88:91], v[140:141], v[160:161], v[88:91]
	v_mfma_f32_16x16x32_fp8_bf8 v[80:83], v[142:143], v[160:161], v[80:83]
	v_mfma_f32_16x16x32_fp8_bf8 v[64:67], v[148:149], v[212:213], v[64:67]
	v_mfma_f32_16x16x32_fp8_bf8 v[32:35], v[148:149], v[208:209], v[32:35]
	v_mfma_f32_16x16x32_fp8_bf8 v[60:63], v[152:153], v[144:145], v[60:63]
	v_mfma_f32_16x16x32_fp8_bf8 v[56:59], v[154:155], v[144:145], v[56:59]
	v_mfma_f32_16x16x32_fp8_bf8 v[52:55], v[140:141], v[144:145], v[52:55]
	v_mfma_f32_16x16x32_fp8_bf8 v[48:51], v[142:143], v[144:145], v[48:51]
	v_add_u32_e32 v144, v200, v198
	v_add_u32_e32 v145, v199, v198
	v_cndmask_b32_e64 v144, v195, v144, s[0:1]
	v_mfma_f32_16x16x32_fp8_bf8 v[8:11], v[148:149], v[210:211], v[8:11]
	v_add_u32_e32 v198, s44, v198
	v_mfma_f32_16x16x32_fp8_bf8 v[4:7], v[148:149], v[214:215], v[4:7]
	v_cndmask_b32_e32 v148, v195, v145, vcc
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_fp8_bf8 v[76:79], v[152:153], v[146:147], v[76:79]
	v_mfma_f32_16x16x32_fp8_bf8 v[72:75], v[154:155], v[146:147], v[72:75]
	v_mfma_f32_16x16x32_fp8_bf8 v[68:71], v[140:141], v[146:147], v[68:71]
	v_mfma_f32_16x16x32_fp8_bf8 v[64:67], v[142:143], v[146:147], v[64:67]
	buffer_load_dwordx4 v[144:147], v144, s[4:7], 0 offen
	v_mfma_f32_16x16x32_fp8_bf8 v[44:47], v[152:153], v[150:151], v[44:47]
	v_mfma_f32_16x16x32_fp8_bf8 v[40:43], v[154:155], v[150:151], v[40:43]
	v_mfma_f32_16x16x32_fp8_bf8 v[36:39], v[140:141], v[150:151], v[36:39]
	v_mfma_f32_16x16x32_fp8_bf8 v[32:35], v[142:143], v[150:151], v[32:35]
	buffer_load_dwordx4 v[148:151], v148, s[4:7], 0 offen
	s_waitcnt lgkmcnt(0)
	s_barrier
	v_mfma_f32_16x16x32_fp8_bf8 v[28:31], v[152:153], v[156:157], v[28:31]
	s_waitcnt vmcnt(2)
	ds_write2st64_b64 v196, v[128:129], v[132:133] offset1:16
	ds_write2st64_b64 v197, v[130:131], v[134:135] offset1:16
	s_waitcnt vmcnt(0)
	ds_write2st64_b64 v196, v[144:145], v[148:149] offset0:32 offset1:48
	ds_write2st64_b64 v197, v[146:147], v[150:151] offset0:32 offset1:48
	v_mfma_f32_16x16x32_fp8_bf8 v[24:27], v[154:155], v[156:157], v[24:27]
	v_mfma_f32_16x16x32_fp8_bf8 v[16:19], v[140:141], v[156:157], v[16:19]
	v_mfma_f32_16x16x32_fp8_bf8 v[8:11], v[142:143], v[156:157], v[8:11]
	v_mfma_f32_16x16x32_fp8_bf8 v[0:3], v[152:153], v[158:159], v[0:3]
	v_mfma_f32_16x16x32_fp8_bf8 v[20:23], v[154:155], v[158:159], v[20:23]
	v_mfma_f32_16x16x32_fp8_bf8 v[12:15], v[140:141], v[158:159], v[12:15]
	v_mfma_f32_16x16x32_fp8_bf8 v[4:7], v[142:143], v[158:159], v[4:7]
	s_setprio 0
	s_cbranch_scc1 .L4
.L5:
	s_andn2_b64 vcc, exec, s[2:3]
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_vccnz .L2
	v_add_u32_e32 v137, 0, v180
	ds_read_b64_tr_b8 v[128:129], v137 offset:16384
	v_add_u32_e32 v146, 0, v176
	ds_read_b64_tr_b8 v[130:131], v146
	ds_read_b64_tr_b8 v[132:133], v146 offset:8320
	ds_read_b64_tr_b8 v[134:135], v146 offset:128
	ds_read_b64_tr_b8 v[140:141], v137 offset:24576
	ds_read_b64_tr_b8 v[142:143], v137 offset:24704
	ds_read_b64_tr_b8 v[144:145], v137 offset:16512
	v_add_u32_e32 v137, 0, v181
	ds_read_b64_tr_b8 v[146:147], v146 offset:8192
	ds_read_b64_tr_b8 v[148:149], v137 offset:16384
	ds_read_b64_tr_b8 v[150:151], v137 offset:24704
	ds_read_b64_tr_b8 v[152:153], v137 offset:16512
	ds_read_b64_tr_b8 v[154:155], v137 offset:24576
	s_waitcnt lgkmcnt(3)
	v_mfma_f32_16x16x32_fp8_bf8 v[108:111], v[148:149], v[130:131], v[108:111]
	v_add_u32_e32 v137, 0, v177
	v_mfma_f32_16x16x32_fp8_bf8 v[120:123], v[128:129], v[130:131], v[120:123]
	v_mfma_f32_16x16x32_fp8_bf8 v[100:103], v[144:145], v[130:131], v[100:103]
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_fp8_bf8 v[92:95], v[152:153], v[130:131], v[92:95]
	v_mfma_f32_16x16x32_fp8_bf8 v[120:123], v[140:141], v[146:147], v[120:123]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_fp8_bf8 v[108:111], v[154:155], v[146:147], v[108:111]
	v_mfma_f32_16x16x32_fp8_bf8 v[100:103], v[142:143], v[146:147], v[100:103]
	v_mfma_f32_16x16x32_fp8_bf8 v[92:95], v[150:151], v[146:147], v[92:95]
	ds_read_b64_tr_b8 v[130:131], v137
	ds_read_b64_tr_b8 v[146:147], v137 offset:8320
	ds_read_b64_tr_b8 v[156:157], v137 offset:128
	ds_read_b64_tr_b8 v[158:159], v137 offset:8192
	v_add_u32_e32 v137, 0, v178
	s_waitcnt lgkmcnt(3)
	v_mfma_f32_16x16x32_fp8_bf8 v[84:87], v[128:129], v[130:131], v[84:87]
	v_mfma_f32_16x16x32_fp8_bf8 v[124:127], v[148:149], v[130:131], v[124:127]
	v_mfma_f32_16x16x32_fp8_bf8 v[116:119], v[144:145], v[130:131], v[116:119]
	v_mfma_f32_16x16x32_fp8_bf8 v[112:115], v[152:153], v[130:131], v[112:115]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_fp8_bf8 v[84:87], v[140:141], v[158:159], v[84:87]
	v_mfma_f32_16x16x32_fp8_bf8 v[124:127], v[154:155], v[158:159], v[124:127]
	v_mfma_f32_16x16x32_fp8_bf8 v[116:119], v[142:143], v[158:159], v[116:119]
	v_mfma_f32_16x16x32_fp8_bf8 v[112:115], v[150:151], v[158:159], v[112:115]
	ds_read_b64_tr_b8 v[130:131], v137
	ds_read_b64_tr_b8 v[158:159], v137 offset:8320
	ds_read_b64_tr_b8 v[198:199], v137 offset:128
	ds_read_b64_tr_b8 v[200:201], v137 offset:8192
	v_add_u32_e32 v137, 0, v179
	s_waitcnt lgkmcnt(3)
	v_mfma_f32_16x16x32_fp8_bf8 v[104:107], v[128:129], v[130:131], v[104:107]
	v_mfma_f32_16x16x32_fp8_bf8 v[96:99], v[148:149], v[130:131], v[96:99]
	v_mfma_f32_16x16x32_fp8_bf8 v[88:91], v[144:145], v[130:131], v[88:91]
	v_mfma_f32_16x16x32_fp8_bf8 v[80:83], v[152:153], v[130:131], v[80:83]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_fp8_bf8 v[104:107], v[140:141], v[200:201], v[104:107]
	v_mfma_f32_16x16x32_fp8_bf8 v[96:99], v[154:155], v[200:201], v[96:99]
	v_mfma_f32_16x16x32_fp8_bf8 v[88:91], v[142:143], v[200:201], v[88:91]
	v_mfma_f32_16x16x32_fp8_bf8 v[80:83], v[150:151], v[200:201], v[80:83]
	ds_read_b64_tr_b8 v[130:131], v137
	ds_read_b64_tr_b8 v[200:201], v137 offset:8320
	ds_read_b64_tr_b8 v[202:203], v137 offset:128
	ds_read_b64_tr_b8 v[204:205], v137 offset:8192
	s_waitcnt lgkmcnt(3)
	v_mfma_f32_16x16x32_fp8_bf8 v[76:79], v[128:129], v[130:131], v[76:79]
	v_mfma_f32_16x16x32_fp8_bf8 v[72:75], v[148:149], v[130:131], v[72:75]
	v_mfma_f32_16x16x32_fp8_bf8 v[68:71], v[144:145], v[130:131], v[68:71]
	v_mfma_f32_16x16x32_fp8_bf8 v[64:67], v[152:153], v[130:131], v[64:67]
	v_mfma_f32_16x16x32_fp8_bf8 v[60:63], v[128:129], v[134:135], v[60:63]
	v_mfma_f32_16x16x32_fp8_bf8 v[56:59], v[148:149], v[134:135], v[56:59]
	v_mfma_f32_16x16x32_fp8_bf8 v[52:55], v[144:145], v[134:135], v[52:55]
	v_mfma_f32_16x16x32_fp8_bf8 v[48:51], v[152:153], v[134:135], v[48:51]
	v_mfma_f32_16x16x32_fp8_bf8 v[44:47], v[128:129], v[156:157], v[44:47]
	v_mfma_f32_16x16x32_fp8_bf8 v[40:43], v[148:149], v[156:157], v[40:43]
	v_mfma_f32_16x16x32_fp8_bf8 v[36:39], v[144:145], v[156:157], v[36:39]
	v_mfma_f32_16x16x32_fp8_bf8 v[32:35], v[152:153], v[156:157], v[32:35]
	v_mfma_f32_16x16x32_fp8_bf8 v[28:31], v[128:129], v[198:199], v[28:31]
	v_mfma_f32_16x16x32_fp8_bf8 v[24:27], v[148:149], v[198:199], v[24:27]
	v_mfma_f32_16x16x32_fp8_bf8 v[16:19], v[144:145], v[198:199], v[16:19]
	v_mfma_f32_16x16x32_fp8_bf8 v[8:11], v[152:153], v[198:199], v[8:11]
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x32_fp8_bf8 v[0:3], v[128:129], v[202:203], v[0:3]
	v_mfma_f32_16x16x32_fp8_bf8 v[20:23], v[148:149], v[202:203], v[20:23]
	v_mfma_f32_16x16x32_fp8_bf8 v[12:15], v[144:145], v[202:203], v[12:15]
	v_mfma_f32_16x16x32_fp8_bf8 v[4:7], v[152:153], v[202:203], v[4:7]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x32_fp8_bf8 v[76:79], v[140:141], v[204:205], v[76:79]
	v_mfma_f32_16x16x32_fp8_bf8 v[72:75], v[154:155], v[204:205], v[72:75]
	v_mfma_f32_16x16x32_fp8_bf8 v[68:71], v[142:143], v[204:205], v[68:71]
	v_mfma_f32_16x16x32_fp8_bf8 v[64:67], v[150:151], v[204:205], v[64:67]
	v_mfma_f32_16x16x32_fp8_bf8 v[60:63], v[140:141], v[132:133], v[60:63]
	v_mfma_f32_16x16x32_fp8_bf8 v[56:59], v[154:155], v[132:133], v[56:59]
	v_mfma_f32_16x16x32_fp8_bf8 v[52:55], v[142:143], v[132:133], v[52:55]
	v_mfma_f32_16x16x32_fp8_bf8 v[48:51], v[150:151], v[132:133], v[48:51]
	v_mfma_f32_16x16x32_fp8_bf8 v[44:47], v[140:141], v[146:147], v[44:47]
	v_mfma_f32_16x16x32_fp8_bf8 v[40:43], v[154:155], v[146:147], v[40:43]
	v_mfma_f32_16x16x32_fp8_bf8 v[36:39], v[142:143], v[146:147], v[36:39]
	v_mfma_f32_16x16x32_fp8_bf8 v[32:35], v[150:151], v[146:147], v[32:35]
	v_mfma_f32_16x16x32_fp8_bf8 v[28:31], v[140:141], v[158:159], v[28:31]
	v_mfma_f32_16x16x32_fp8_bf8 v[24:27], v[154:155], v[158:159], v[24:27]
	v_mfma_f32_16x16x32_fp8_bf8 v[16:19], v[142:143], v[158:159], v[16:19]
	v_mfma_f32_16x16x32_fp8_bf8 v[8:11], v[150:151], v[158:159], v[8:11]
	v_mfma_f32_16x16x32_fp8_bf8 v[0:3], v[140:141], v[200:201], v[0:3]
	v_mfma_f32_16x16x32_fp8_bf8 v[20:23], v[154:155], v[200:201], v[20:23]
	v_mfma_f32_16x16x32_fp8_bf8 v[12:15], v[142:143], v[200:201], v[12:15]
	v_mfma_f32_16x16x32_fp8_bf8 v[4:7], v[150:151], v[200:201], v[4:7]
	s_branch .L2
.L6:
	s_endpgm
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
.Lfunc_end:
.size _grouped_variable_k_gemm_kernel, .Lfunc_end-_grouped_variable_k_gemm_kernel

.rodata
.p2align 6
.amdhsa_kernel _grouped_variable_k_gemm_kernel
  .amdhsa_group_segment_fixed_size 0
  .amdhsa_private_segment_fixed_size 0
  .amdhsa_kernarg_size 96
  .amdhsa_next_free_vgpr 224
  .amdhsa_next_free_sgpr 59
  .amdhsa_accum_offset 224
  .amdhsa_float_round_mode_32 3
  .amdhsa_float_round_mode_16_64 3
  .amdhsa_float_denorm_mode_32 3
  .amdhsa_float_denorm_mode_16_64 3
  .amdhsa_ieee_mode 1
  .amdhsa_dx10_clamp 1
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_system_sgpr_workgroup_id_x 1
.end_amdhsa_kernel

.amdgpu_metadata
---
amdhsa.kernels:
  - .name: _grouped_variable_k_gemm_kernel
    .symbol: _grouped_variable_k_gemm_kernel.kd
    .kernarg_segment_size: 96
    .group_segment_fixed_size: 0
    .private_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .wavefront_size: 64
    .sgpr_count: 59
    .vgpr_count: 221
    .agpr_count: 0
    .max_flat_workgroup_size: 512
    .sgpr_spill_count: 0
    .vgpr_spill_count: 0
    .uses_dynamic_stack: false
    .uniform_work_group_size: 1
    .args:
      - .offset: 0
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 8
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 16
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 24
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 32
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 40
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 48
        .size: 4
        .value_kind: by_value
      - .offset: 52
        .size: 4
        .value_kind: by_value
      - .offset: 56
        .size: 4
        .value_kind: by_value
      - .offset: 60
        .size: 4
        .value_kind: by_value
      - .offset: 64
        .size: 4
        .value_kind: by_value
      - .offset: 68
        .size: 4
        .value_kind: by_value
      - .offset: 72
        .size: 4
        .value_kind: by_value
      - .offset: 80
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 88
        .size: 8
        .value_kind: global_buffer
        .address_space: global
amdhsa.target: amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
.end_amdgpu_metadata
