.bob_linker : {
	setup_ints = 0x00044bd4;
	dram_init = 0x0004170e;
	s_GLITCH = 0x0004028a;
	gpio_port_read = 0x00041f0a;
	ernie_3auth_single = 0x00041a2c;
	i2c_transfer_write = 0x00042186;
	s_IRQ = 0x0004022a;
	c_OTHER_EXC = 0x00041dac;
	sm_loadstart = 0x00044508;
	alice_schedule_task = 0x0004046a;
	compat_armReBoot = 0x00040cd8;
	uart_printn = 0x00044ab0;
	c_IRQ = 0x00041c96;
	alice_get_task_status = 0x000402d0;
	debug_setGpoCode = 0x000414fe;
	spi_write_start = 0x0004456e;
	pervasive_control_clock = 0x00042804;
	uart_write = 0x00044a0e;
	alice_stopReloadAlice = 0x000403ea;
	debug_s_regdump = 0x00044c42;
	set_dbg_mode = 0x00044d8c;
	regina_sendCmd = 0x0004291c;
	s_DBG = 0x0004026a;
	g_rpc_status = 0x000459b0;
	compat_handleAllegrex = 0x00040ec4;
	memcpy = 0x0004084c;
	jig_read_shared_buffer = 0x000423e4;
	uart_print = 0x00044a7e;
	c_ARM_REQ = 0x00041cf8;
	ernie_exec = 0x000418e2;
	gpio_set_port_mode = 0x00041eec;
	ernie_exec_cmd = 0x0004197e;
	spi_init = 0x0004450c;
	PANIC = 0x00041ddc;
	pervasive_control_misc = 0x0004282e;
	readAs = 0x000424c2;
	sdif_read_sector_mmc = 0x00043ee6;
	i2c_transfer_write_read = 0x0004224c;
	alice_core_status = 0x00045750;
	keyring_slot_data = 0x0004251c;
	compat_IRQ7_handleCmd = 0x00040b3c;
	ex_save_ctx = 0x0004018c;
	debug_c_regdump = 0x00041528;
	enable_icache = 0x00044da0;
	stor_read_emmc = 0x00044844;
	debug_printFormat = 0x00041168;
	alice_vectors = 0x0004575c;
	regina_loadRegina = 0x00042854;
	sdif_init_ctx = 0x0004403e;
	uart_rxfifo_flush = 0x00044a5e;
	alice_loadAlice = 0x00040302;
	stor_write_emmc = 0x00044894;
	memset32 = 0x000407fe;
	crypto_bigmacDefaultCmd = 0x00040f6a;
	sdif_read_sector_sd = 0x00043dee;
	debug_printU32 = 0x000410f4;
	sdif_init_sd = 0x000440c8;
	memset8 = 0x000407d8;
	stor_read_sd = 0x000447a4;
	pervasive_control_reset = 0x00042774;
	alice_xcfg = 0x00045758;
	glitch_test = 0x00041ea2;
	sdif_init_mmc = 0x0004432a;
	c_OTHER_INT = 0x00041d7c;
	uart_init = 0x0004497e;
	stor_export_ctx = 0x000448e4;
	ernie_read = 0x00041868;
	test = 0x00042704;
	delay_nx = 0x00044ba0;
	pervasive_control_gate = 0x000427bc;
	i2c_transfer_read = 0x000421e2;
	gpio_enable_port = 0x00042098;
	gpio_port_set = 0x00041f20;
	gpio_query_intr = 0x00041fa8;
	spi_read = 0x000445c6;
	ernie_exec_cmd_short = 0x00041a10;
	cbus_write = 0x00044d6c;
	glitch_init = 0x000400d8;
	stor_import_ctx = 0x0004492a;
	spi_read_end = 0x000445d2;
	memcmp = 0x0004088a;
	set_exception_table = 0x00041e3a;
	stor_init_emmc = 0x00044728;
	uart_scann = 0x00044aec;
	s_RESET = 0x0004029a;
	init = 0x00042634;
	i2c_init_bus = 0x00042114;
	alice_handleCmd = 0x000405a4;
	g_uart_bus = 0x000459d4;
	crypto_waitStopBigmacOps = 0x0004102e;
	compat_pListCopy = 0x00040c8e;
	gpio_set_intr_mode = 0x00041f60;
	stor_init_sd = 0x000446aa;
	ernie_init = 0x00041b62;
	memset = 0x00040820;
	s_ARM_REQ = 0x0004024a;
	get_build_timestamp = 0x00044bca;
	gpio_acquire_intr = 0x00042014;
	writeAs = 0x000424f8;
	delay = 0x00044d44;
	rpc_loop = 0x000430fa;
	jig_update_shared_buffer = 0x000422e4;
	ce_framework = 0x000425b0;
	cbus_read = 0x00044d4c;
	uart_scanns = 0x00044b3e;
	keyring_slot_prot = 0x0004258a;
	spi_write_end = 0x0004458e;
	spi_write = 0x000445aa;
	stub = 0x00044c38;
	compat_killArm = 0x00040e26;
	ernie_write = 0x00041810;
	c_SWI = 0x00041c2c;
	debug_printRange = 0x000414d6;
	sdif_write_sector_mmc = 0x00043f92;
	uart_read = 0x00044a2a;
	alice_tasks = 0x00045754;
	spi_read_available = 0x000445b8;
	g_ernie_comms = 0x000459dc;
	gpio_port_clear = 0x00041f40;
	strlen = 0x000408ce;
	c_DBG = 0x00041e10;
	gpio_init = 0x000420b4;
	alice_schedule_bob_task = 0x00040536;
	s_SWI = 0x0004020a;
	sdif_write_sector_sd = 0x00043e6a;
	ex_restore_ctx = 0x000401cc;
	stor_write_sd = 0x000447f4;
	crypto_memset = 0x000410b8;
	c_RESET = 0x00041be4;
	compat_Cry2Arm0 = 0x000408dc;
}
