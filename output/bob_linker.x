.bob_linker : {
	setup_ints = 0x000450bc;
	dram_init = 0x000419ae;
	s_GLITCH = 0x000402c2;
	gpio_port_read = 0x000421d2;
	compat_pspemuColdInit = 0x00040f3c;
	ernie_3auth_single = 0x00041ccc;
	i2c_transfer_write = 0x0004244e;
	config_set_dfl_test = 0x0004111a;
	s_IRQ = 0x00040262;
	c_OTHER_EXC = 0x000420a8;
	sm_loadstart = 0x000448e8;
	alice_schedule_task = 0x000404be;
	compat_armReBoot = 0x00040d50;
	uart_printn = 0x00044f74;
	c_IRQ = 0x00041f78;
	alice_get_task_status = 0x0004031c;
	debug_setGpoCode = 0x000417f0;
	spi_write_start = 0x0004494e;
	pervasive_control_clock = 0x00042ae2;
	uart_write = 0x00044eba;
	alice_stopReloadAlice = 0x0004043e;
	debug_s_regdump = 0x0004512a;
	set_dbg_mode = 0x00045274;
	regina_sendCmd = 0x00042c1a;
	s_DBG = 0x000402a2;
	g_rpc_status = 0x00045d24;
	compat_handleAllegrex = 0x00041074;
	memcpy = 0x000408a0;
	jig_read_shared_buffer = 0x000426be;
	uart_print = 0x00044f36;
	c_ARM_REQ = 0x00041fda;
	ernie_exec = 0x00041b82;
	gpio_set_port_mode = 0x000421b4;
	ernie_exec_cmd = 0x00041c1e;
	spi_init = 0x000448ec;
	PANIC = 0x000420da;
	pervasive_control_misc = 0x00042b0c;
	readAs = 0x0004279c;
	sdif_read_sector_mmc = 0x000442c6;
	i2c_transfer_write_read = 0x00042526;
	alice_core_status = 0x00045ac4;
	keyring_slot_data = 0x000427f6;
	compat_IRQ7_handleCmd = 0x00040b90;
	ex_save_ctx = 0x000401c4;
	debug_c_regdump = 0x0004181a;
	enable_icache = 0x00045288;
	stor_read_emmc = 0x00044c24;
	debug_printFormat = 0x0004148c;
	alice_vectors = 0x00045ad0;
	regina_loadRegina = 0x00042b32;
	sdif_init_ctx = 0x0004441e;
	uart_rxfifo_flush = 0x00044f0a;
	alice_loadAlice = 0x0004034e;
	stor_write_emmc = 0x00044c74;
	memset32 = 0x00040852;
	crypto_bigmacDefaultCmd = 0x00041294;
	sdif_read_sector_sd = 0x000441ce;
	debug_printU32 = 0x0004141e;
	dfl_test = 0x00044d5e;
	sdif_init_sd = 0x000444a8;
	memset8 = 0x0004082c;
	stor_read_sd = 0x00044b84;
	pervasive_control_reset = 0x00042a52;
	alice_xcfg = 0x00045acc;
	glitch_test = 0x00044dce;
	sdif_init_mmc = 0x0004470a;
	c_OTHER_INT = 0x00042076;
	uart_init = 0x00044e2a;
	stor_export_ctx = 0x00044cc4;
	ernie_read = 0x00041b08;
	delay_nx = 0x00045088;
	pervasive_control_gate = 0x00042a9a;
	i2c_transfer_read = 0x000424bc;
	gpio_enable_port = 0x00042360;
	gpio_port_set = 0x000421e8;
	gpio_query_intr = 0x00042270;
	spi_read = 0x000449a6;
	config_parse = 0x000411ce;
	ernie_exec_cmd_short = 0x00041cb0;
	cbus_write = 0x00045254;
	glitch_init = 0x000400e0;
	stor_import_ctx = 0x00044d0a;
	spi_read_end = 0x000449b2;
	memcmp = 0x000408de;
	set_exception_table = 0x00042154;
	stor_init_emmc = 0x00044b08;
	uart_scann = 0x00044fbc;
	s_RESET = 0x000402d2;
	init = 0x0004295a;
	i2c_init_bus = 0x000423dc;
	alice_handleCmd = 0x000405f8;
	g_uart_bus = 0x00045d48;
	crypto_waitStopBigmacOps = 0x00041358;
	compat_pListCopy = 0x00040d06;
	gpio_set_intr_mode = 0x00042228;
	stor_init_sd = 0x00044a8a;
	ernie_init = 0x00041e02;
	memset = 0x00040874;
	s_ARM_REQ = 0x00040282;
	get_build_timestamp = 0x000450b2;
	gpio_acquire_intr = 0x000422dc;
	writeAs = 0x000427d2;
	delay = 0x0004522c;
	rpc_loop = 0x000434c2;
	jig_update_shared_buffer = 0x000425be;
	ce_framework = 0x0004288a;
	cbus_read = 0x00045234;
	uart_scanns = 0x0004501a;
	keyring_slot_prot = 0x00042864;
	spi_write_end = 0x0004496e;
	spi_write = 0x0004498a;
	stub = 0x00045120;
	compat_killArm = 0x00040e9e;
	ernie_write = 0x00041ab0;
	c_SWI = 0x00041f04;
	debug_printRange = 0x000417c8;
	sdif_write_sector_mmc = 0x00044372;
	g_config = 0x000400d0;
	uart_read = 0x00044ed6;
	alice_tasks = 0x00045ac8;
	i2c_transfer_write_short = 0x000424aa;
	ex_cxctable = 0x00040306;
	spi_read_available = 0x00044998;
	g_ernie_comms = 0x00045d50;
	gpio_port_clear = 0x00042208;
	strlen = 0x00040922;
	c_DBG = 0x00042110;
	gpio_init = 0x0004237c;
	alice_schedule_bob_task = 0x0004058a;
	s_SWI = 0x00040242;
	sdif_write_sector_sd = 0x0004424a;
	ex_restore_ctx = 0x00040204;
	stor_write_sd = 0x00044bd4;
	crypto_memset = 0x000413e2;
	c_RESET = 0x00041e84;
	g_state = 0x000400cc;
	compat_Cry2Arm0 = 0x00040930;
}
