#!/bin/sh
echo "Applying BLE patches to Beken SDK for OpenBK7252N..."

# Patch sys_config_bk7252n.h to enable BLE 5.2 and required definitions
sed -i 's/#define CFG_SUPPORT_BLE                            0/#define CFG_SUPPORT_BLE                            1/' sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h
sed -i 's/#define CFG_BLE_VERSION                            BLE_VERSION_4_2/#define CFG_BLE_VERSION                            BLE_VERSION_5_2/' sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h

# Uncomment BLE role numbers which are commented out by default for 7252N
sed -i 's/\/\/#define CFG_BLE_ADV_NUM/#define CFG_BLE_ADV_NUM/' sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h
sed -i 's/\/\/#define CFG_BLE_SCAN_NUM/#define CFG_BLE_SCAN_NUM/' sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h
sed -i 's/\/\/#define CFG_BLE_INIT_NUM/#define CFG_BLE_INIT_NUM/' sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h
sed -i 's/\/\/#define CFG_BLE_CONN_NUM/#define CFG_BLE_CONN_NUM/' sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h
sed -i 's/\/\/#define CFG_BLE_USE_DYN_RAM/#define CFG_BLE_USE_DYN_RAM/' sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h

# Add CFG_BLE_HOST_RW which is entirely missing
echo "#ifndef CFG_BLE_HOST_RW" >> sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h
echo "#define CFG_BLE_HOST_RW                            1" >> sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h
echo "#endif" >> sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h

# Patch ble_main.c for 5.2 to wrap FIQ_BTDM with #ifdef
sed -i 's/intc_enable(FIQ_BTDM);/#ifdef FIQ_BTDM\n\t\tintc_enable(FIQ_BTDM);\n#endif/' sdk/beken_freertos_sdk/beken378/driver/ble/ble_5_2/platform/bk7252n/entry/ble_main.c
sed -i 's/intc_disable(FIQ_BTDM);/#ifdef FIQ_BTDM\n\t\tintc_disable(FIQ_BTDM);\n#endif/' sdk/beken_freertos_sdk/beken378/driver/ble/ble_5_2/platform/bk7252n/entry/ble_main.c
sed -i 's/intc_service_register( FIQ_BTDM, PRI_FIQ_BTDM, ble_btdm_isr );/#ifdef FIQ_BTDM\n\tintc_service_register( FIQ_BTDM, PRI_FIQ_BTDM, ble_btdm_isr );\n#endif/' sdk/beken_freertos_sdk/beken378/driver/ble/ble_5_2/platform/bk7252n/entry/ble_main.c

# Patch wlan_cli.c to allow BLE compilation
sed -i 's/#if (CFG_SOC_NAME == SOC_BK7231N)/#if 1/g' sdk/beken_freertos_sdk/beken378/func/wlan_ui/wlan_cli.c

echo "Patches applied successfully."
