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

#ifndef _kmdboh_h_
#define _kmdboh_h_

/* *The*module*has*the*source*level*on*-*this*needs to be updated */
/* *when*KMDBOR*is*changed*if*the*name*changes */
/* #define KMDBOR KMDBORE3A **********/

#include "kmdmph.h"

extern char *program_library(char *);
extern void PGMLIB(char *,char *);

extern char *file_library(char *);
extern void FILLIB(char *,char *);

extern char *input_library(char *);
extern void INPLIB(char *,char *);

extern char *work_library(char *);
extern void WRKLIB(char *,char *);

extern void initialise_unit(char *);
extern void INITUNIT(char *);

extern char *unit_mnemonic(void);
extern void GETUNIT(char *);

extern char *unit_owner(char *);

extern int get_ext_data(char * , char *);
extern int get_ext_data_type(char * , short *,
                             short * , short *);

extern convert_user_type_t convert_user_type_if;
extern set_default_t set_default_if;

extern int is_EQUATION(void);
extern char *PRODUCT(void);
extern void status_message(char * unit,char * message);
extern void Init_BO(char *);
#endif
