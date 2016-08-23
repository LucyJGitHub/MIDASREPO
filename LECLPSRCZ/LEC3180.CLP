/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Facility history audit reports')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC3180 - Facility Audit Report LE3180 Control              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      207863             Date 19Nov02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      196768 *CREATE     Date 10May02              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       207863 - Add MONMSG to CPYF command in case file is empty.  */
/*       196768 - Calls LE3180 which performs an integrity check     */
/*                between FACHISA & FCLTY, and produces audit reports*/
/*                to warn of any possible errors in facility amount, */
/*                drawn amount, or revolving credit indicator.       */
/*                                                                   */
/*********************************************************************/
             PGM      PARM(&RSEQ &RLEV &RENT)
 
/*/COPY WNCPYSRC,LEC3180INT                                          */
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ROUND)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNCHG) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                                 */ /*CCB020*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
             DCLF FILE(SDBANKPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,LEC3180MPS                                          */
 
/* Access PF/SDMMODPD to determine whether LE module is on. */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
 
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
 
/* Database error handling. */
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
                CHGJOB     SWS('XXXXXX11')
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* Retrieve Parameters for LE3180: */
 
             RTVDTAARA  DTAARA(LE3180PARM (2 2)) RTNVAR(&ROUND) /* +
                          Allowable Rounding Error.    */
 
/* If this is called in input cycle then call LE3180 directly */
 
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)                             */ /*CCB020*/
             CALL       PGM(CBC001001) PARM(&MPHAS)                                       /*CCB020*/
 
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)                                  */ /*CCB020*/
             IF         COND(&MPHAS *EQ '*NO') THEN(DO)                                   /*CCB020*/
                CALL       PGM(LE3180) PARM(&RSEQ &RLEV &RENT &ROUND)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             RCVF       RCDFMT(SDBANKD0)
 
             CHGVAR     VAR(&RUNCHG) VALUE(&BJRDNB)
             CHGVAR     VAR(&RUNDAT) VALUE(&RUNCHG)
 
             SNDPGMMSG  MSG('Facility History Audit Report') +
                          TOMSGQ(MRUNQ)
 
/* Get system prefix */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
 
/* Call PGM/LE3180 */
 
 CONTIN:     CHGJOB     SWS(XXXXXX00)
 
             IF         COND(%SST(&FMT 28 1) *EQ 'Y') THEN(DO)
 
/* Clear files for LE3180 */
 
                CLRPFM     FILE(*LIBL/LETFHAPD)
 
                CALL       PGM(LE3180) PARM(&RSEQ &RLEV &RENT &ROUND)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CPYF       FROMFILE(*LIBL/LETFHAPD) +
                          TOFILE(*LIBL/LEPFHAPD) MBROPT(*REPLACE)
                                                                                  /* Begin 207863 */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEPFHAPD))
                                                                                    /* End 207863 */
 
/*/COPY WNCPYSRC,LEC3180MPE                                          */
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
/*/COPY WNCPYSRC,LEC3180ERR                                          */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC3180 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
 
 /* End program */
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,LEC3180END                                          */
 
             ENDPGM
