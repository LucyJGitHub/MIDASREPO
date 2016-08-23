/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas IBLC 2002 ICD maintenance control program')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0200 - IBLC ICD MAINTENANCE CONTROL PROGRAM.             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX043             Date 23Jul01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WRTNCODE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SSF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MIDAS) TYPE(*CHAR) LEN(05)
             DCL        VAR(&RMV) TYPE(*LGL) LEN(1) VALUE('0')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('SDC90002 - Job cannot be run at +
                          this time.Other job(s) are active')
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                                 */ /*CCB020*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO (ERROR))
 
       CHGVAR &BISCPY '(c) Misys International Banking Systems Ltd.+
                 2005'
             CHGJOB     SWS(10000000)
 
/* Main processing */
 
/**Job*can*run*only*if*system*is*in*input*cycle*or*next*day*set-up**/                     /*CCB020*/
 
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
 
/**If*this*program*is*being*called*in*next*day*set-up*then**/                             /*CCB020*/
/**the*only*valid*parameter*is*'**'***                     */                             /*CCB020*/
 
/**********  IF         COND(&MPHAS *EQ 'D') THEN(DO)                                  */ /*CCB020*/
/**********    GOTO       CMDLBL(MAINT)                                                */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
 
/**Otherwise*this*program*can*only*be*called*in*input*cycle**/                            /*CCB020*/
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
/**********    SNDPGMMSG  MSG('ILC0200 - Job cannot be run at this +                   */ /*CCB020*/
/**********                 time. Phase of Day must be A.') +                          */ /*CCB020*/
/**********                 TOMSGQ(MOPERQ)                                             */ /*CCB020*/
/**********    CALL       PGM(SDC0700) PARM('ILC0200' 'CANTRUNA' ' ')                  */ /*CCB020*/
/**********    GOTO       CMDLBL(ERROR)                                                */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
 
/**If*I/C*but*not*Maintenance,*Enquiry*mode.***/                                          /*CCB020*/
 
/**********  IF         COND(&MPHAS *EQ 'A' *AND &MODE *NE 'M') +                      */ /*CCB020*/
/**********               THEN(GOTO CMDLBL(ENQ))                                       */ /*CCB020*/
 
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)                                  */ /*CCB020*/
 
/**Send*message*'ICDR'*to*MSGQ/MSPECIAL*to*prevent*other*jobs*******/                     /*CCB020*/
/**initiating*whilst*I.C.D.*maintenance*is*active.***/                                    /*CCB020*/
/**Check*if*other*job(s)*are*currently*active*by*receiving*messages*/                     /*CCB020*/
/**from*MSGQ/MSTATUS.****/                                                                /*CCB020*/
 
/**********    SNDPGMMSG  MSG('ICDR') TOMSGQ(MSPECIAL)                                 */ /*CCB020*/
/**********    CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                                    */ /*CCB020*/
/**********    RCVMSG     MSGQ(MSTATUS) RMV(*YES)                                      */ /*CCB020*/
/**********    CHGVAR     VAR(&RMV) VALUE('1')                                         */ /*CCB020*/
 
/**********    RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&MIDAS)                           */ /*CCB020*/
 
/**********    IF         COND(&MIDAS *NE '     ') THEN(DO)                            */ /*CCB020*/
/**********      SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)                                   */ /*CCB020*/
/**********      CALL       PGM(SDC0700) PARM('ILC0200' 'CANTRUNNOW' +                 */ /*CCB020*/
/**********                   ' ')                                                     */ /*CCB020*/
/**********      GOTO       CMDLBL(ERROR)                                              */ /*CCB020*/
/**********    ENDDO                                                                   */ /*CCB020*/
/**********    ENDDO                                                                   */ /*CCB020*/
 
/**********    ELSE       CMD(DO)                                                      */ /*CCB020*/
 
/**MAINT:****/                                                                            /*CCB020*/
 
/**If*system*set-up*is*complete,*send*message*to*user**/                                  /*CCB020*/
 
/**********      RTVDTAARA  DTAARA(RUNDAT (11 1)) RTNVAR(&SSF)                         */ /*CCB020*/
/**********      IF         COND(&SSF *EQ 'Y') THEN(DO)                                */ /*CCB020*/
/**********        SNDPGMMSG  MSG('ILC0200 - Job cannot be +                           */ /*CCB020*/
/**********                     run at this time. The System Set-up +                  */ /*CCB020*/
/**********                     flag is on.') TOMSGQ(MOPERQ)                           */ /*CCB020*/
/**********        CALL       PGM(SDC0700) PARM('ILC0200' +                            */ /*CCB020*/
/**********                     'CANTRUNSSF' ' ')                                      */ /*CCB020*/
/**********        GOTO       CMDLBL(ERROR)                                            */ /*CCB020*/
/**********      ENDDO                                                                 */ /*CCB020*/
 
/**********    ENDDO                                                                   */ /*CCB020*/
 
/* Otherwise call maintenance programs */
 
/* Retrieve string of Midas modules present in the system */
 
/**ENQ:***/                                                                               /*CCB020*/
 
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
 
/* If module code is BL (NEW IBLC 95) */
 
                 IF         COND(%SST(&FMT 96 1) *EQ 'Y') THEN(DO)
                   OVRDBF     FILE(ILICDRPD) SHARE(*NO)
                 IF         COND(&MODE *EQ 'M') THEN(DO)
                   CHGJOB     SWS(00000000)
                 ENDDO
                   CALL       PGM(IL0200) PARM(&RTNCODE 'IBLC' +
                                &WRTNCODE ' ')
                   DLTOVR     FILE(ILICDRPD)
                   IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
                 ENDDO
 
ERROR:
 
             RTVJOBA    JOB(&JOB)
             DLTOVR     FILE(*ALL)
 
/* If database error occurs information message is sent to user */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
               ROLLBACK
                 RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                 CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(&JOB)
             ENDDO
 
/* Send 'MIDAS' message to MSGQ/MSTATUS that was removed at top of  */
/* this program. Remove message 'ICDR' from MSGQ/MSPECIAL and reset */
/* MSGQ/MSTATUS.                                                    */
 
END:         IF         COND(&RMV) THEN(SNDPGMMSG MSG('MIDAS') +
                          TOMSGQ(MSTATUS))
 
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             MONMSG     MSGID(CPF0000)
 
/* Remove 'ICDR' message sent to MSPECIAL at top of program */
/* for modules other than Microfiche and Optical Disk.      */
 
             RCVMSG     MSGQ(MSPECIAL) RMV(*YES)
             MONMSG     MSGID(CPF0000)
 
             CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
             MONMSG     MSGID(CPF0000)
 
             RETURN
 
             ENDPGM
