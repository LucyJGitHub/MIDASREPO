/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Reports')                                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0540 - COB PRINT REPORTS                                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1095768          Date 05Oct16              */
/*                      CCB020             Date 06Aug12              */
/*                      AR868386           Date 27Jul12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG5730            Date 21Apr05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 30Aug96              */
/*                      102495             Date 10Jul96              */
/*                      091570             DATE 08AUG95              */
/*                      S01408             DATE 07AUG95              */
/*                      S01420 *Create     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1095768 - File CBCOBRPD should be clear every day.        */
/*                 - Applied for MD041858                            */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       AR868386 - System shows an error during open of web-faced   */
/*                  screens due to a leftover EOD msg on MSPECIAL.   */
/*                  Applied fix 262364 to clear MSGQ MSPECIAL before */
/*                  I/C. (Child: AR868387)                           */
/*       BUG5730 - Remove change of MPHAS to 'A' in ICIFINISH.       */
/*       S01408 - Addition of core hook CBC0540001                   */
/*       102495 - CBSTAT must be reset for next COB. If batch monitor*/
/*                failed and was restarted by transfer of an interact*/
/*                monitor, the pos 45 remains 'Y'. At the end of COB,*/
/*                the termination message was not sent by CBC0010 to */
/*                the dtaq MONBCHQ and the monitor is not stopped.   */
/*       091570 - MSPECIAL should be reset before Input cycle.       */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0540INT                                       */
/*                - CBC0540MPS                                       */
/*                - CBC0540MPE                                       */
/*                - CBC0540ERR                                       */
/*                - CBC0540END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,CBC0540INT                                          */
 
             DCL        VAR(&MONI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SCHD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CBSTAT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRINT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&INU7) TYPE(*LGL) LEN(1)
             DCL        VAR(&INU8) TYPE(*LGL) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,CBH00013                                            */
 
/* Global error message trap */
 
             MONMSG     MSGID(CPF0000 CPI0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,CBC0540MPS                                          */
 
             RTVDTAARA  DTAARA(CBSTAT) RTNVAR(&CBSTAT)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('COB +
                          Audit Report(s) being produced') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
 
             CHGVAR     VAR(&PRINT) VALUE(%SST(&CBSTAT 44 1))
 
             CHGDTAARA  DTAARA(SDSTAT (110 5)) VALUE('PRINT')
 
             IF         COND((&PRINT *EQ 'T') *OR (&PRINT *EQ 'B')) +
                          THEN(DO)
                CALL       PGM(CBC0300) PARM('T')
                RTVJOBA    SWS(&SWS)
                IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(CHGVAR +
                             VAR(&INU7) VALUE('1'))
                IF         COND(%SST(&SWS 8 1) *EQ '1') THEN(CHGVAR +
                             VAR(&INU8) VALUE('1'))
                IF         COND((&INU7 *EQ '1') *AND (&INU8 *EQ '1')) +
                             THEN(GOTO CMDLBL(ABNOR))
             ENDDO
 
             IF         COND((&PRINT *EQ 'M') *OR (&PRINT *EQ 'B')) +
                          THEN(DO)
                CALL       PGM(CBC0300) PARM('M')
                RTVJOBA    SWS(&SWS)
                IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(CHGVAR +
                             VAR(&INU7) VALUE('1'))
                IF         COND(%SST(&SWS 8 1) *EQ '1') THEN(CHGVAR +
                             VAR(&INU8) VALUE('1'))
                IF         COND((&INU7 *EQ '1') *AND (&INU8 *EQ '1')) +
                             THEN(GOTO CMDLBL(ABNOR))
             ENDDO
 
             IF         COND(&PRINT *EQ ' ') THEN(GOTO +
                          CMDLBL(ABNOR))
                                                                                       /*AR1095768*/
/* Clear CBCOBRPD file */                                                              /*AR1095768*/
                                                                                       /*AR1095768*/
             CLRPFM     FILE(CBCOBRPD)                                                 /*AR1095768*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                 /*AR1095768*/
                                                                                       /*AR1095768*/
 
/* Set data area SDSTAT for next close of business run */
 
             CHGDTAARA  DTAARA(SDSTAT (110 5)) VALUE('BEGIN')
             CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('A')
/**********  SCWRTJREG EVENT(MPHAS) FLAG(A) TEXT('MPHAS changed from F to A')     /*BUG5730 CCB020*/
             SCWRTJREG EVENT(MPHAS) FLAG(A) TEXT('MPHAS changed from G to A')             /*CCB020*/
             CHGDTAARA  DTAARA(CBSTAT (20 1)) VALUE('N')              /*102495*/
             CHGDTAARA  DTAARA(CBSTAT (32 1)) VALUE('N')              /*102495*/
             CHGDTAARA  DTAARA(CBSTAT (45 1)) VALUE('N')              /*102495*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBC0540001                                          */
                                                                      /*S01408*/
/**********  CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES) */                            /*091570 AR868386*/
/**********  RCVMSG     MSGQ(MSPECIAL) RMV(*YES) */                              /*091570 AR868386*/
/**********  MONMSG     MSGID(CPF0000) */                                        /*091570 AR868386*/
             CLRMSGQ    MSGQ(MSPECIAL)                                                  /*AR868386*/
 
/*/COPY WNCPYSRC,CBC0540MPE                                          */
 
             GOTO       CMDLBL(ENDP)
 
ABNOR:
/*/COPY WNCPYSRC,CBC0540ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)                                                   /*AR868386*/
             SNDMSG     MSG('Abnormal End for CBC0540') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,CBC0540END                                          */
 
             ENDPGM
