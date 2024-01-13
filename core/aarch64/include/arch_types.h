#ifndef ARCH_TYPES_H_
#define ARCH_TYPES_H_

#define true	            1
#define false	            0
#define bool	            _Bool

#ifndef NULL
#define NULL                ((void *)0)
#endif /* NULL */

#ifdef __INT8_TYPE__
typedef __INT8_TYPE__       int8_t;
#endif
#ifdef __INT16_TYPE__
typedef __INT16_TYPE__      int16_t;
#endif
#ifdef __INT32_TYPE__
typedef __INT32_TYPE__      int32_t;
#endif
#ifdef __INT64_TYPE__
typedef __INT64_TYPE__      int64_t;
#endif
#ifdef __UINT8_TYPE__
typedef __UINT8_TYPE__      uint8_t;
#endif
#ifdef __UINT16_TYPE__
typedef __UINT16_TYPE__     uint16_t;
#endif
#ifdef __UINT32_TYPE__
typedef __UINT32_TYPE__     uint32_t;
#endif
#ifdef __UINT64_TYPE__
typedef __UINT64_TYPE__     uint64_t;
#endif
#ifdef __SIZE_TYPE__
typedef __SIZE_TYPE__       size_t;
#endif

#ifndef _VA_LIST
typedef __builtin_va_list   va_list;
#define _VA_LIST
#endif
#define va_start(ap, param) __builtin_va_start(ap, param)
#define va_end(ap)          __builtin_va_end(ap)
#define va_arg(ap, type)    __builtin_va_arg(ap, type)

#ifdef  __PTRDIFF_TYPE__
typedef __PTRDIFF_TYPE__    ptrdiff_t;
#endif

typedef __INTMAX_TYPE__     intmax_t;
typedef __UINTMAX_TYPE__    uintmax_t;

#ifndef _INTPTR_T
#ifndef __intptr_t_defined
typedef __INTPTR_TYPE__     intptr_t;
#define __intptr_t_defined
#define _INTPTR_T
#endif
#endif

#ifndef _UINTPTR_T
typedef __UINTPTR_TYPE__    uintptr_t;
#define _UINTPTR_T
#endif

#endif /* ARCH_TYPES_H_ */
