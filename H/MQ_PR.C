/********************************************************************
 **********************************************************************
 *
 *       Meridian Replication
 *
 *       MQ_PR - MQ processing prototypes for C
 *
 *       (c) Misys International Banking Systems Ltd. 2006
 *
 *       Last Amend No. MD058809            Date 16Dec21
 *       Prev Amend No. 128748 Supportforce
 *                             *CREATE      Date 13Sep06
 *
 ********************************************************************
 *
 *       MD058809 - After installation of MQ9 compatibility patch and
 *                  restart of the Meridian Replication subsystem
 *                  REPMIDASPT, the job MPT1PBSIN ended in MSGW.
 *       128748 - New procedure write_to_queue_with_wait() introduced
 *
 ********************************************************************
 */
#ifndef _MQ_PR_h_
#define _MQ_PR_h_

/* Procedure write_to_queue_with_wait() is a wrapper round
   write_to_queue() and uses the same parameter list */
extern int write_to_queue_with_wait(qhandle,char *,int,unsigned short);

/* Procedure RtvRmtQMaxDepth() is an RPG function, this code emulates
   that in RPCPYSRC,MQINQWRAP and make the procedure available
   to C procedures                                             */
/* NB Only the procedure(s) from MQINQWRAP that are used by
   C code are defined here                                     */
extern void RtvRmtQMaxDepth(int *, char *, char *, int *, char *);

#endif
