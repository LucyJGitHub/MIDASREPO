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

#ifndef _kmdifh_h_
#define _kmdifh_h_

extern void BASELIB(char * cp);
extern char *base_library(void);
extern void MDBALIB(char * cp);
extern char *MDBA_library(void);
extern void SBSNAME(char *);
extern char *Subsystem(void);
extern void JOBNO(char *);
extern char *Job_number(void);
extern void JOBNAME(char *);
extern char *job_name(void);
extern void CPF_message(char *,char *);
extern int  get_level(void);
extern char *control_name(void);
extern int  submit_job(char * job_name, char *user_id, char *pgm, char *parms);
#endif
