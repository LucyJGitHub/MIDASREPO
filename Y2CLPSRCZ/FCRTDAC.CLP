/*********************************************************************/
/*                                                                   */
/*       Midas - (Module Name) Module                                */
/*                                                                   */
/*       mmCnnnn - (Program Name)                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 21May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. Xnnnnn  *CREATE    Date ddmmmyy              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes                          */
/*       Xnnnnn - (fix description)                                  */
/*                                                                   */
/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Y2 R2.1.1 Retrieve a data area for a HLL pgm (CBL)')  */
/*********************************************************************/
/*T: YAPPOBJ (C-B-L) Retrieve a Data Area for a HLL Program */
/*Z: CRTCLPGM LOG(*NO) ALWRTVSRC(*NO) */
 
/*H: SYSTEM     : SYNON/2 APPLICATION GENERATOR */
/*H: PROGRAMMER : Mark Wheadon */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*H: Copy of Y2RTDAC                            */
 
/********************************************************************/
PGM (&DTAARA &RTNVAR)
/* Entry variables */
  DCL &DTAARA      *CHAR 10  /* Direct error to pgmq */
  DCL &RTNVAR      *CHAR 256  /* DATA AREA DATA */
     DCL &RTNVARWRK     *CHAR 256  /* DATA AREA DATA TEMP */
 
/* Work variables */
  DCL &MSGID       *CHAR 7   /* Message id. */
  DCL &MSGDTA      *CHAR 132 /* Message data*/
  DCL &PGMQ        *CHAR 10  /* Direct error to pgmq */
  DCL &PGMQREL     *CHAR 5   /* *PREV *SAME  */
  DCL &I           *DEC 5  /* COUNTER */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*-------------------------------------------------------------------*/
  MONMSG CPF0000  EXEC(GOTO ERROR)
/*H:  1. Retrieve data area */
            RTVDTAARA  DTAARA(&DTAARA) RTNVAR(&RTNVARWRK)
/*H:  1.1 Calculate length (so as to avoid refering to unused bytes) */
            CHGVAR &I 256
/********** WHILE:      IF (%SST(&RTNVARWRK &I 1)**= ' ') GOTO RTNDTA                */  /*BG18886*/
WHILE:      IF (%SST(&RTNVARWRK &I 1) *NE ' ') GOTO RTNDTA                               /*BG18886*/
            CHGVAR &I (&I - 1)
            IF (&I = 0 ) GOTO ENDPGM
            GOTO WHILE
 
/*H:  1.2 Move data to return     */
RTNDTA:     CHGVAR (%SST(&RTNVAR 1 &I)) (%SST(&RTNVARWRK 1 &I))
 
ENDPGM:      RCLRSC
             RMVMSG CLEAR(*ALL)
             RETURN
/*-------------------------------------------------------------------*/
ERROR:       RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID)
             SNDPGMMSG  MSGID(&MSGID) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOPGMQ(&PGMQREL &PGMQ) MSGTYPE(*DIAG)
             MONMSG CPF0000
             GOTO ENDPGM
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
