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

#ifndef _KMDFIH_H
#define _KMDFIH_H

#ifdef __cplusplus
extern "C" {
#endif

#include "kmdfdh.h"

extern char process_name[25];
extern char unit_name[25];
extern int debug_level;
extern int feeder_number;
extern char stop_code[2];
extern char previous_end[SEQ_NO_LEN];
extern char last_good_record[SEQ_NO_LEN];

extern int get_next_table(char *name, PROD *prod);
extern int get_next_product(char *name, char *short_name);
extern void change_restart(char *sequence);
extern void change_end(char *sequence);
extern void change_sequence(char *sequence);
extern void get_env_values(void);

#ifdef __cplusplus
}
#endif

#endif
