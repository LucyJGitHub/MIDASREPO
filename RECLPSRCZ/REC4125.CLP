/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Teller/Batch Totals Enquiry/Print')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4125 - Teller/Batch Totals Enquiry/Print                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 096490             DATE 28NOV95              */
/*       PREV AMEND NO. CRT001  *CREATE    DATE 28FEB95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       096490 - Remove creation parameters which were adopting the */
/*                owners user profile.                               */
/*                Use the standard CLP creation parameters instead.  */
/*       CRT001 - Retail Teller System                               */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&MODE)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256) VALUE(' ')
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(50)
/**/
/*  Global monitor message  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('TELLER/BATCH TOTALS QUERY/PRINT ') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/* SET SWITCHES DEPENDING ON MODE */
/**/
             IF (&MODE *EQ 'T') THEN(CHGJOB SWS(10000000))
             ELSE                   (CHGJOB SWS(01000000))
/**/
/* INITIALIZE DB AREA OF LDA AND CALL THE PROGRAM */
/**/
             CALL          PGM(RE4125)
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             GOTO ENDPGM
             ENDDO
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                          TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/* FOR FILE IMBALANCE ERROR */
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 168 8))
                SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                          TOMSGQ(MOPERQ)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4125 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
