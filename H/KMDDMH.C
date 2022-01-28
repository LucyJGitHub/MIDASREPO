/********************************************************************
 *
 *       Meridian Replication
 *
 *       (c) Finastra International Limited 2021
 *
 *       Last Amend No. MD058809  *CREATE  Date 16Dec21
 *
 ********************************************************************
 *
 *       MD058809 - After installation of MQ9 compatibility patch and
 *                  restart of the Meridian Replication subsystem
 *                  REPMIDASPT, the job MPT1PBSIN ended in MSGW.
 *
 ********************************************************************
 */

#ifndef _KMDDMH_H
#define _KMDDMH_H

#ifdef __cplusplus
extern "C" {
#endif
#include "kmdrfh.h"

extern char product[PRODUCT_NAME_LEN + 1];
extern char short_name[PRODUCT_SHORT_NAME_LEN + 1];

#ifdef __cplusplus
}
#endif

#endif
