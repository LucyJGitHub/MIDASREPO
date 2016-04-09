/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Audit list')                                 */
/*********************************************************************/
/*                                                                   */
/*  Midas - Standing Data Module                             */
/*                                                                   */
/*  SCRUNQP - STANDING DATA AUDIT LIST                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*  Last Amend No. BG18886           Date 23May08                    */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  Prev Amend No. S01343            Date 15Aug91                    */
/*                 RT0159            Date 25Jun91                    */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  BG18886 - Amend non-standard codes.                              */
/*  S01343 - SC/RR/SD MODULE RENAME PROJECT.                         */
/*           - SCRUNQP RENAMED FROM MRUNQP.                          */
/*           - SCRUNQR RENAMED FROM MRUNQR.                          */
/*                                                                   */
/*  RT0159 - Messages should be sent via new Midas Info Screen.      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/********************************************************************/
     PGM PARM(&IND)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
     DCL VAR(&IND) TYPE(*CHAR) LEN(1)
     DCL VAR(&MSG) TYPE(*CHAR) LEN(132)
     DCL VAR(&SENDER) TYPE(*CHAR) LEN(80)
     DCL VAR(&MTIME) TYPE(*CHAR) LEN(6)
     SNDMSG MSG('Audit list being processed') TOMSGQ(MRUNQ)
     IF COND(&IND = 'P' *OR &IND = 'N') THEN(DO)
     CHGMSGQ MSGQ(MRUNQ) RESET(*YES)
     CHGJOB SWS(XXXXXXX0)
     OVRDBF FILE(TABLE) TOFILE(TABICD)
LOOP: +
     RCVMSG MSGQ(MRUNQ) RMV(*NO) MSG(&MSG) SENDER(&SENDER)
/****IF COND(&MSG**= ' ') THEN(DO)                                    /*BG18886*/
     IF COND(&MSG *NE ' ') THEN(DO)                                   /*BG18886*/
     CHGVAR VAR(&MTIME) VALUE(%SUBSTRING(&SENDER 50 6))
     CALL PGM(SCRUNQR) PARM(&MSG &MTIME)
     IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
/****SNDPGMMSG MSG('Database in error in MRUNQR, File TABLE, Key ''01-/*RT0159*/
/****   10''') TOPGMQ(*EXT)                                           /*RT0159*/
        CALL PGM(SDC0700) PARM('SCRUNQP' 'MRUNQRDBER' ' ')            /*RT0159*/
       DLTOVR FILE(TABLE)
       RETURN
     ENDDO
     GOTO CMDLBL(LOOP)
     ENDDO
     ELSE CMD(CALL PGM(SCRUNQR) PARM('*END*' ' '))
     DLTOVR FILE(TABLE)
     ENDDO
     IF COND(&IND = 'P' *OR &IND = 'R') THEN(RMVMSG MSGQ(MRUNQ) -
CLEAR(*ALL))
     IF COND(&IND = 'D') THEN(DSPMSG MSGQ(MRUNQ))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
     ENDPGM
