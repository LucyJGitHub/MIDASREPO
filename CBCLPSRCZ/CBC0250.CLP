/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB COB Component text summary report')          */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Close of Business Processing              */
/*                                                                   */
/*       CBC0250  CLOSE OF BUSINESS COMPONENT                        */
/*                TEXT SUMMARY REPORT                                */
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
/*       PREV AMEND NO.                    DATE 00/00/00             */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* RESET SWITCHES U7 & U8 */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
             CALL       PGM(CB0250)
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOMSGQ(MOPERQ)
/**/
ABNOR:                  SNDPGMMSG  MSG('CLOSE OF BUSINESS TEXT +
                        SUMMARY REPORT TERMINATED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
/**/
             ENDPGM
