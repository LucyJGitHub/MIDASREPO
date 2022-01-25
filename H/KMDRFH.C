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

#ifndef _KCMRFH_H
#define _KCMRFH_H

#ifdef __cplusplus
extern "C" {
#endif

#define CYCLE_ID_LEN 10
#define SEQ_NO_LEN 10
#define PRODUCT_NAME_LEN 8
#define PRODUCT_SHORT_NAME_LEN 5
#define PRODUCT_DESCRIPTION_LEN 35
#define MDBA_CHANNEL_LEN 40
#define TABLE_NAME_LEN 18

typedef _Packed struct {
   long length;
   short count;
   char ds_mnemonic[2];
   char cycle[CYCLE_ID_LEN];
   char type[2];
   char table[TABLE_NAME_LEN];
   char null_flag; /* '0' - no NULLS, '1' - NULLS applicable,
                                            indicators follow, '2' - NULL indicator record */
   char data[1];
} OUTREC;


#ifdef __cplusplus
}
#endif

#endif
