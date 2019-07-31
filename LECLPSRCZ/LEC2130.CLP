/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Transfer Principal Input')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2130 - Transfer Principal Input                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      148720             Date 15Jan99              */
/*                      CLE004 *Create     Date 02Dec96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       148720 - This program is now called from lec02 which will   */
/*                submit the confirmation job.                       */
/*       CLE004 - Customer Lending Enhancements - Syndications       */
/*                                                                   */
/********************************************************************/
/************PGM        PARM(&PMODE)                                 /*148720*/
             PGM                                                     /*148720*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/************DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)               /*148720*/
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1) VALUE(I)      /*148720*/
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Call Principal Transfer Input program */
/**/
             OVRDBF     FILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(LOAMS) SHARE(*NO)
             OVRDBF     FILE(LOAMD) TOFILE(LOAMS) SHARE(*NO)
             CHGJOB     SWS(XXXXXX00)
/**/
             CALL       PGM(LE2130) PARM(&PMODE)
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                COMMIT
                GOTO       CMDLBL(END)
             ENDDO
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/* Abnormal or database error processing */
/**/
 ABNOR:      ROLLBACK
             SNDPGMMSG  MSG('Transaction failed.  Re-input necessary.  +
                          Enter to continue.') TOPGMQ(*EXT)
/**/
/* Global monitor message */
/**/
 END:        DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
