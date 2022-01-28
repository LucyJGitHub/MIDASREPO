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

#ifndef _kmdtrh_h_
#define _kmdtrh_h_

#define trIPMS 1
#define trMQ 2

typedef void * qhandle;

/* Queue priorities */

#define MIN_QPRI 1
#define MID_QPRI 2
#define MAX_QPRI 3

#define QUEUE_READ 1
#define QUEUE_WRITE 2
#define QUEUE_WRITE_AUTO 3
#define QUEUE_READ_AUTO 4

/* Message handling calls */
extern int attach_to_queue_manager(void);
extern int detach_from_queue_manager(void);
extern char * queue_name(char * prod,char * dept,char * env,short inv);
extern qhandle attach_to_queue(char *,int flags);
extern int detach_from_queue(qhandle);
extern int write_to_queue(qhandle,char *,int,unsigned short);
extern unsigned short get_max_msg_length(qhandle);
extern char * read_from_queue(qhandle,int *,unsigned short *, int);
extern void commit_queue_manager(void);
extern void rollback_queue_manager(void);
#endif
