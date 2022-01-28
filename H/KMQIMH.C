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

#ifndef _kmqimh_h_
#define _kmqimh_h_
#include "kmq00h.h"
#include "kmdslh.h"
int _init_selection(char * product,  /* Product being mapped */
               char * env,           /* unit */
               char * process,
               tinit_t ptinit,       /* Target initialisation function */
               void * puser,         /* Source to target information */
               selcb * psel          /* Selection control block */
               );
#endif
