#!/bin/sh
echo "Applying BLE patches to Beken SDK for OpenBK7252N..."

# Patch sys_config_bk7252n.h to enable BLE 5.1
sed -i 's/#define CFG_SUPPORT_BLE                            0/#define CFG_SUPPORT_BLE                            1/' sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h
sed -i 's/#define CFG_BLE_VERSION                            BLE_VERSION_4_2/#define CFG_BLE_VERSION                            BLE_VERSION_5_1/' sdk/beken_freertos_sdk/beken378/app/config/sys_config_bk7252n.h

# Patch ble_main.c to wrap FIQ_BTDM with #ifdef
sed -i 's/intc_enable(FIQ_BTDM);/#ifdef FIQ_BTDM\n\t\tintc_enable(FIQ_BTDM);\n#endif/' sdk/beken_freertos_sdk/beken378/driver/ble/ble_5_1/platform/7231n/entry/ble_main.c
sed -i 's/intc_disable(FIQ_BTDM);/#ifdef FIQ_BTDM\n\t\tintc_disable(FIQ_BTDM);\n#endif/' sdk/beken_freertos_sdk/beken378/driver/ble/ble_5_1/platform/7231n/entry/ble_main.c
sed -i 's/intc_service_register( FIQ_BTDM, PRI_FIQ_BTDM, ble_btdm_isr );/#ifdef FIQ_BTDM\n\tintc_service_register( FIQ_BTDM, PRI_FIQ_BTDM, ble_btdm_isr );\n#endif/' sdk/beken_freertos_sdk/beken378/driver/ble/ble_5_1/platform/7231n/entry/ble_main.c

# Patch wlan_cli.c to allow BLE 5.1 compilation
sed -i 's/#if (CFG_SOC_NAME == SOC_BK7231N)/#if (CFG_BLE_VERSION == BLE_VERSION_5_1)/g' sdk/beken_freertos_sdk/beken378/func/wlan_ui/wlan_cli.c

echo "Patches applied successfully."
