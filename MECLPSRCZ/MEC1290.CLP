/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas I.M.M. Reorganise Member')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                       */
/*                                                                   */
/*       MEC1270  - I.M.M. Reorganise Member                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01435             Date 19Aug93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILE &MEMBER)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NBR_RCD) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR_DLT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR_TOT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&DLT_PCT) TYPE(*DEC) LEN(4 2)
             DCL        VAR(&CHKPOSN) TYPE(*DEC) LEN(2 0) VALUE(10)                       /*228542*/
             DCL        VAR(&LAST) TYPE(*CHAR) LEN(1)                                     /*228542*/
             DCL        VAR(&NAMECHK) TYPE(*CHAR) LEN(10)                                 /*228542*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('MEC1290 - I.M.M. Reorganise Member') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
                                                                                          /*228542*/
/* Pad variable with blanks */                                                            /*228542*/
                                                                                          /*228542*/
             CHGVAR     VAR(&NAMECHK) VALUE(&MEMBER)                                      /*228542*/
                                                                                          /*228542*/
 BLANKCHK:                                                                                /*228542*/
             CHGVAR     VAR(&LAST) VALUE(%SST(&NAMECHK &CHKPOSN 1))                       /*228542*/
                                                                                          /*228542*/
             IF         COND(&LAST *EQ ' ') THEN(DO)                                      /*228542*/
                CHGVAR     VAR(%SST(&NAMECHK &CHKPOSN 1)) +
                             VALUE('*')                                                   /*228542*/
                CHGVAR     VAR(&CHKPOSN) VALUE(&CHKPOSN - 1)                              /*228542*/
                GOTO       CMDLBL(BLANKCHK)                                               /*228542*/
             ENDDO                                                                        /*228542*/
                                                                                          /*228542*/
/* */
/* Check to see Control needs reorganising */
/* */
             RTVMBRD    FILE(&FILE) MBR(&MEMBER) NBRCURRCD(&NBR_RCD) +
                          NBRDLTRCD(&NBR_DLT)
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
/**********  RGZPFM     FILE(&FILE) MBR(&MEMBER)                                          /*228542*/
             CALL       PGM(SCC000060) PARM(&FILE &NAMECHK)                               /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
             ENDDO
             ENDDO
/**/
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
             SNDPGMMSG  MSG('Program MEC1290 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1290 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
