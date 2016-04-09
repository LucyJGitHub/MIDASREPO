/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Clear output queue MPRINT')                  */
/*OVR  : OVRDBF FILE(OUTQ) TOFILE(FCOUTQPD)                         :*/
/*********************************************************************/
/*                                                                   */
/* Midas - Report Control Facility Module                    */
/*                                                                   */
/* FCC0255 - CLEAR OUTPUT QUEUE MPRINT                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*        LAST AMEND NO. LN0848           DATE 10OCT90               */
/*        PREV AMEND NO. LN0736           DATE 12SEP90               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*        LN0848 - HOLD THE SPOOL FILE PRODUCED BY WRKOUTQ.          */
/*        LN0736 - CHANGES TO ERROR FLAGS AND MONITOR MESSAGES       */
/*                 RE SPOOL FILE HANDLING                            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* NOTE: TO CREATE THIS PROGRAM, A FILE OUTQ WITH 132-BYTE RECORD    */
/*       LENGTH IS REQUIRED                                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&IDATE)
             DCL        VAR(&IDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILENO) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FILENB) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)                /*LN0736*/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)                /*LN0736*/
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)             /*LN0736*/
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)                /*LN0736*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       FILE(QTEMP/OUTQ)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*LN0736*/
/* */
/* CHANGE DATE FORMAT TO THAT OF JOB WITH JOB SEPARATOR VALUE */
/* */
/************CHGJOB     DATFMT(*YMD)                                 * *LN0736*/
             CHGJOB     DATFMT(*YMD) DATSEP(/)                        /*LN0736*/
             CVTDAT     DATE(&IDATE) TOVAR(&DATE) FROMFMT(*YMD) +
                          TOFMT(*JOB)
/* */
/* CREATE FILE OF OUTPUT QUEUE */
/* */
             CRTPF      FILE(QTEMP/OUTQ1) RCDLEN(132) LVLCHK(*NO)
             OVRPRTF    FILE(QPRTSPLQ) HOLD(*YES)                     /*LN0848*/
             WRKOUTQ    OUTQ(MPRINT) OUTPUT(*PRINT)
             CPYSPLF    FILE(QPRTSPLQ) TOFILE(QTEMP/OUTQ1) +
                          SPLNBR(*LAST)
/* */
/* COPY ONLY REQUIRED RECORDS */
/* */
             CPYF       FROMFILE(QTEMP/OUTQ1) TOFILE(QTEMP/OUTQ2) +
                          CRTFILE(*YES) INCCHAR(*RCD 100 *LE &DATE)
/* */
/* ADD IN RECORDS FOR PREVIOUS CENTURY IF APPLICABLE */
/* */
             IF         COND(%SST(&DATE 1 2) *EQ '00') THEN(DO)
                  CHGVAR     VAR(&IDATE) VALUE('990101')
                  CVTDAT     DATE(&IDATE) TOVAR(&DATE) FROMFMT(*YMD) +
                               TOFMT(*JOB)
                  CPYF       FROMFILE(QTEMP/OUTQ1) TOFILE(QTEMP/OUTQ2) +
                               MBROPT(*ADD) INCCHAR(*RCD 100 *GE &DATE)
             ENDDO
/* */
/**SKIP*PAGE*HEADINGS**                                              * *LN0736*/
/* */
/************CPYF       FROMFILE(QTEMP/OUTQ2) TOFILE(QTEMP/OUTQ3) +  * *LN0736*/
/************             CRTFILE(*YES) INCCHAR(*RCD 119 *NE 'Page') * *LN0736*/
/* */
/**SKIP*TITLES**                                                     * *LN0736*/
/* */
/************CPYF       FROMFILE(QTEMP/OUTQ3) TOFILE(QTEMP/OUTQ4) +  * *LN0736*/
/************             CRTFILE(*YES) INCCHAR(*RCD 100 *NE 'Date') * *LN0736*/
/* */
/**SKIP*LINE*SAYING*'* * * END OF LISTING * * *' *                   * *LN0736*/
/* */
/************CPYF       FROMFILE(QTEMP/OUTQ4) TOFILE(QTEMP/OUTQ) +   * *LN0736*/
/************             CRTFILE(*YES) INCCHAR(*RCD 10 *NE '*')     * *LN0736*/
/**/                                                                  /*LN0736*/
/** EXCLUDE UNWANTED LINES **/                                        /*LN0736*/
/**/                                                                  /*LN0736*/
             CPYF       FROMFILE(QTEMP/OUTQ2) TOFILE(QTEMP/OUTQ) +
                          CRTFILE(*YES) INCCHAR(*RCD 105 *EQ '/')     /*LN0736*/
/* */
/* DELETE SPOOL FILE FOR PRINT CREATED IN THIS JOB */
/* */
             DLTSPLF    FILE(QPRTSPLQ) SPLNBR(*LAST)
/************MONMSG     MSGID(CPF3344 CPF3342)                       * *LN0736*/
 START:
/* */
/* RECEIVE ALL RECORDS COLLATED ABOVE */
/* */
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
/* */
/* ASSEMBLE JOB/FILE/SPOOL NUMBER FOR DLTSPLF COMMAND */
/* */
             CHGVAR     VAR(&JOB) VALUE(%SST(&OUTQ 82 10))
             CHGVAR     VAR(&JOBNO) VALUE(%SST(&OUTQ 93 6))
             CHGVAR     VAR(&FILE) VALUE(%SST(&OUTQ 2 10))
             CHGVAR     VAR(&USER) VALUE(%SST(&OUTQ 13 10))
             CHGVAR     VAR(&FILENO) VALUE(%SST(&OUTQ 73 4))
             CHGVAR     VAR(&FILENB) VALUE(&FILENO)
/* */
/* DELETE SPOOL FILE REFERENCED BY THIS RECORD */
/* */
             DLTSPLF    FILE(&FILE) JOB(&JOBNO/&USER/&JOB) +
                          SPLNBR(&FILENB)
/************MONMSG     MSGID(CPF3344 CPF3342)                       * *LN0736*/
             GOTO       CMDLBL(START)
/**/                                                                  /*LN0736*/
 ABNOR:      RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)               /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             SNDPGMMSG  MSG('FCC0255 Clear Output Queue MPRINT +
                          terminated abnormally.  See previous +
                          messages for further information.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
