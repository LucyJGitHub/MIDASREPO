/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC reorganise member')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2040  - U.D.C. Reorganise Member                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 04Oct01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 21Nov94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CPK014 - Release 4 packaging:                               */
/*                - As SCJRNCG has been removed at Release 4, a new  */
/*                  CG file has been created to hold the driving     */
/*                  data for this program.                           */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
/**********  DCL        VAR(&FILE) TYPE(*CHAR) LEN(10) */                                 /*CPK014*/
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NBR_RCD) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR_DLT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR_TOT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&DLT_PCT) TYPE(*DEC) LEN(4 2)
/* */
/* File containing UDC files to be journaled */
/* */
/**********  DCLF       FILE(SCJRNCG) */                                                  /*CPK014*/
             DCLF       FILE(CGFRGZPD)                                                    /*CPK014*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2040 - U.D.C. Reorganise Member') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
/* */
/* Read records from SCJRNCG */
/* */
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
/* */
             CHGVAR     VAR(&MEMBER) VALUE('*FIRST')
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Check to see Control needs reorganising */
/* */
/**********  RTVMBRD    FILE(&FILE) MBR(&MEMBER) NBRCURRCD(&NBR_RCD) + */            /*CPK014*/
/**********               NBRDLTRCD(&NBR_DLT)                          */            /*CPK014*/
             RTVMBRD    FILE(&AAFILE) MBR(&MEMBER) NBRCURRCD(&NBR_RCD) +
                          NBRDLTRCD(&NBR_DLT)                                        /*CPK014*/
             MONMSG     MSGID(CPF3019) EXEC(DO)
             CHGVAR     VAR(&NBR_TOT) VALUE(0)
             CHGVAR     VAR(&NBR_RCD) VALUE(0)
             CHGVAR     VAR(&NBR_DLT) VALUE(0)
             ENDDO
             CHGVAR     VAR(&NBR_TOT) VALUE(&NBR_RCD + &NBR_DLT)
/* */
/* Check records exist */
/* */
             IF         COND(&NBR_TOT *GT 0) THEN(DO)
             CHGVAR     VAR(&DLT_PCT) VALUE(&NBR_DLT / &NBR_TOT)
/* */
/* If 25% is deleted - reorganise */
/* */
             IF         COND(&DLT_PCT *GT 0.25) THEN(DO)
/**********  RGZPFM     FILE(&FILE) MBR(&MEMBER) */                                       /*CPK014*/
/**********  RGZPFM     FILE(&AAFILE) MBR(&MEMBER)                             /*CPK014*/ /*228542*/
             CALL       PGM(SCC000060) PARM(&AAFILE '*FIRST    ')                         /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
             ENDDO
             ENDDO
/* */
             GOTO       CMDLBL(LOOP)
/* */
 END:
/* */
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC2040 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2040 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
