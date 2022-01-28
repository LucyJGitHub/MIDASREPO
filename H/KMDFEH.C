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

/*  Log FATAL error                                                          */
#ifndef _kmdfeh_h_
#define _kmdfeh_h_

#include "kmdlgh.h"
#include <string.h>

#pragma linkage (KMDFEC,OS)

void KMDFEC(char *);

#define FATAL(x) {LOGOUT(LOG_ERROR, strcat(x," - SEE LOG.")); KMDFEC(x);}

#endif
