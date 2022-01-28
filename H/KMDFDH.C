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

#ifndef _KMDFDH_H
#define _KMDFDH_H

#ifdef __cplusplus
extern "C" {
#endif

#include "kmdrfh.h"

/* Data received from RCVJRNE */

typedef _Packed struct {
   char len[5];
   char sequence[10];
   char code;
   char type[2];
   char time_stamp[26];
   char job[10];
   char user[10];
   char number[6];
   char program[10];
   char object[10];
   char objlib[10];
   char member[10];
   char count[10];
   char flag;
   char cycle[10];
   char user_prof[10];
   char system[8];
   char data[1];
} INREC;

typedef struct replica {
	char *data;
	long len;
	short usage;
} REPLICA;

typedef struct replica_link {
	struct replica_link *next;
	REPLICA *replica;
} REPLICA_LINK;

typedef struct transaction {
	struct transaction *next;
	char cycle[CYCLE_ID_LEN + 1];
	REPLICA_LINK *first_replica;
	REPLICA_LINK *last_replica;
} TRANSACTION;

typedef struct product {
	struct product *next;
	char name[PRODUCT_NAME_LEN + 1];
	char short_name[PRODUCT_SHORT_NAME_LEN + 1];
	void *hQueue;
	TRANSACTION *first_transaction;
} PROD;

typedef struct product_link {
	struct product_link* next;
	PROD *prod;
} PRODUCT_LINK;

typedef struct table {
	struct table *next;
	char name[TABLE_NAME_LEN + 1];
	PRODUCT_LINK *prod_link;
} TABLE;

extern PROD *product_list_head;
extern TABLE *table_list_head;
extern TABLE *table_list_tail;
extern void initialise(void);
extern void fmain(int argc,char *argv[]);

#ifdef __cplusplus
}
#endif

#endif
