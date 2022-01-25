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

#ifndef _KMDDIH_H
#define _KMDDIH_H

#ifdef __cplusplus
extern "C" {
#endif

#include "kmddmh.h"

extern long num_tables;

extern char *load_table_list(char *types, char *list);

#ifdef __cplusplus
}
#endif

#endif
