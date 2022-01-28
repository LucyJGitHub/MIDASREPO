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

#ifndef _KMDCFH_H_
#define _KMDCFH_H_
#include <decimal.h>

#pragma mapinc ("x1pf.h","X1PF(*ALL)","both","_P d",,"X1PF")
#pragma mapinc ("x2pf.h","X2PF(*ALL)","both","_P d",,"X2PF")
#pragma mapinc ("x3pf.h","X3PF(*ALL)","both","_P d",,"X3PF")
#pragma mapinc ("x4pf.h","X4PF(*ALL)","both","_P d",,"X4PF")
#include "x1pf.h"
#include "x2pf.h"
#include "x3pf.h"
#include "x4pf.h"
#define X1PFR_t X1PF_X1PFR_both_t
#define X2PFR_t X2PF_X2PFR_both_t
#define X3PFR_t X3PF_X3PFR_both_t
#define X4PFR_t X4PF_X4PFR_both_t

/* Read Access */

extern int retrieve_cfg_data(char *,...);
extern int next_cfg_data(void);
extern void end_cfg_access(void);

#endif
