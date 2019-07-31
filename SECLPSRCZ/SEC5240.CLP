/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Pool Settlement Position Update')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC5540 - POOL POSITION SETTLEMENT UPDATE                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      119446             Date 18Jun97              */
/*                      S01486     RS      Date 08NOV94              */
/*                      058886             DATE 20JUL93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       119446 - SEC5240 - Parameter mismatched in calling SE5240   */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*                Copyright Statement and Standard Header Box.       */
/*                Creation Parameters. Message Files.                */
/*       058886 - OBJECT PMC5140 RENAMED TO SEC5240                  */
/*     WRITTEN FOR SAR 91/08 - POOL SECURITIES TRANSACTIONS          */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&USRID &BLK)                             /*S01486*/
/*********** PGM        PARM(&USRID &BLK &RSEQ &RLVL &RENT) */ /*S01486 199446*/
             PGM        PARM(&USRID &BLK)                             /*119446*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1) /* RCF level +
                          flag (S/C/B)                                /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity +
                          code (all/comp/bch)                         /*S01486*/
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BLK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
 
             CHGJOB     SWS(00000000)
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/************STRCMTCTL  LCKLVL(*CHG)                                    CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
 
/*           CALL       PGM(PM5140) PARM(&USRID &BLK)          58886 */
/*********** CALL       PGM(SE5240) PARM(&USRID &BLK)          58886  /*S01486*/
/*********** CALL       PGM(SE5240) PARM(&USRID &BLK &RSEQ &RLVL +
/***********              &RENT)                        */ /*S01486*/ /*119446*/
             CALL       PGM(SE5240) PARM(&USRID &BLK)                 /*119446*/
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/*           SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)        */ /*S01486*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
             ENDDO
 
/* ENDPGM:      ENDPGM                                             */ /*S01486*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
