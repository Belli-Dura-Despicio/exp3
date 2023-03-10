SPDK_ROOT_DIR := ~/spdk
include $(SPDK_ROOT_DIR)/mk/spdk.common.mk
include $(SPDK_ROOT_DIR)/mk/spdk.modules.mk
 
APP = test_bdev
 
C_SRCS := test_bdev.c
 
SPDK_LIB_LIST = $(ALL_MODULES_LIST) event event_bdev
 
include $(SPDK_ROOT_DIR)/mk/spdk.app.mk
 
run: all
    @ echo "Clearing..."
    @ rm -f test_bdev.d test_bdev.o
    @ echo "Generating bdev-config..."
    @ $(SPDK_ROOT_DIR)/scripts/gen_nvme.sh --json-with-subsystems > ./test_bdev.json
    @ echo "bdev-config Generated!"
    @ echo "Program Running..."
    @ sudo ./test_bdev -c ./test_bdev.json
    @ echo "Comparing Writing Data and Reading Data"
    @ echo "*************** Size of Data ****************"
    @ du -h data.*
    @ echo "******************** End ********************"
    @ echo "Comparing Context ... (Note: Using [diff] command, empty output means no different)"
    @ diff data.in data.out
