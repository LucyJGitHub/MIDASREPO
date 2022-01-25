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

#ifndef _KMDLGH_H_
#define _KMDLGH_H_

extern void logout(int now, char *process, int level, char *cptr);
extern void *open_log(char *username, int level);
extern void close_log(void);
extern int log_level;
extern char *log_buff;

#define LOGOUT(a,b) if (a <= log_level) logout(0, NULL, a, b)

#define LOG_ERROR 1
#define LOG_ENTRY 2
#define LOG_TRACE 3
#define LOG_DEBUG 4

#define LOGERROR if (LOG_ERROR <= log_level)
#define LOGENTRY if (LOG_ENTRY <= log_level)
#define LOGTRACE if (LOG_TRACE <= log_level)
#define LOGDEBUG if (LOG_DEBUG <= log_level)

#define ERROROUT(a) logout(0, NULL, LOG_ERROR, a)
#define ENTRYOUT(a) logout(0, NULL, LOG_ENTRY, a)
#define TRACEOUT(a) logout(0, NULL, LOG_TRACE, a)
#define DEBUGOUT(a) logout(0, NULL, LOG_DEBUG, a)

#endif
