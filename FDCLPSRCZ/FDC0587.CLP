/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FD Valid MDF Deposit Rates received today')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - FD Module                                           */
/*                                                                   */
/*       FDC0587 - Valid MDF Deposit Rates received today            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Phase:  I/C  on request                                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. 196570  *CREATE    Date 12Nov01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       196570 - MDF Patch                                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
/* Declare variables                                               */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      (c) Misys International Banking Systems Ltd.')
 
/* RCF Sequence Number                                             */
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
/* Global monitor message                                          */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send program message                                            */
 
             SNDPGMMSG  MSG('FDC0587 - Valid MDF Deposit Rates+
                          Received Today') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             RTVJOBA    TYPE(&JOBTYPE)
 
/* Setup parameter                                                 */
 
             CHGVAR     VAR(&MODE) VALUE(%SST(&RPARM 1 3))
             OVRDBF     FILE(SDMDFHL8) TOFILE(SDMDFHLD)
/* Call program                                                    */
 
             CALL       PGM(FD0587) PARM(&RSEQ)
 
             DLTOVR     FILE(SDMDFHL8)
 
/* Database error processing                                       */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination - batch job                                */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            FDC0587 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
