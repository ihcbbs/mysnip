#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/bitops.h>

MODULE_LICENSE(“GPL”);
MODULE_AUTHOR(“Robert W. Oliver II”);
MODULE_DESCRIPTION(“A simple example Linux module.”);
MODULE_VERSION(“0.01”);
set_bit(153, (unsigned long *)(boot_cpu_data.x86_capability));
static int __init lkm_example_init(void) {
 printk(KERN_INFO “Hello, World!\n”);
 return 0;
}
static void __exit lkm_example_exit(void) {
 printk(KERN_INFO “Goodbye, World!\n”);
}
module_init(lkm_example_init);
module_exit(lkm_example_exit);