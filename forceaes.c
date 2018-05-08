#include <linux/bitops.h>
set_bit(153, (unsigned long *)(boot_cpu_data.x86_capability));

module_init(forceases_register);
module_exit(forceases_unregister);


MODULE_LICENSE("Dual BSD/GPL");
MODULE_DESCRIPTION("forceaes");