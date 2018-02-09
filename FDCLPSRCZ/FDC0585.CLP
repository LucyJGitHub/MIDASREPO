/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FD MM IR exceedingrRate tolerance report')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - FD Module                                           */
/*                                                                   */
/*       FDC0585 - Interest Rates Exceeding Rate Tolerance           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Phase:  I/C  on request                                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 196570             Date 13Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CSD006  *CREATE    Date 13Jul00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       196570 - Market Data Feeds Patch                            */
/*       CSD006 - Market Data Feeds                                  */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&RPARM &RSEQ &RLEV &RENT)                                     196570*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                                   /*196570*/
 
/* Declare variables                                               */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* RCF Sequence Number                                             */
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
 
/* RCF Level Flag                                                  */
 
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
 
/* RCF Entity Code (ALL/COMP/BCH)                                  */
 
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
/* Global monitor message                                          */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send program message                                            */
 
/************SNDPGMMSG  MSG('DLC0585 - Interest Rates Exceeding +
                          Rate Tolerance') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)                                                    196570*/
             SNDPGMMSG  MSG('FDC0585 - Interest Rates Exceeding +
                          Rate Tolerance') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)                                                  /*196570*/
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             RTVJOBA    TYPE(&JOBTYPE)
 
/* Setup parameter                                                 */
 
             CHGVAR     VAR(&MODE) VALUE(%SST(&RPARM 1 3))
 
             IF         COND(&MODE *NE 'ALL') THEN(DO)
             OVRDBF     FILE(SDMDFHL8) TOFILE(SDMDFHL9)
             ENDDO
             IF         COND(&MODE *EQ 'ALL') THEN(DO)                                    /*196570*/
             OVRDBF     FILE(SDMDFHL8) TOFILE(SDMDFHL8)                                   /*196570*/
             ENDDO                                                                        /*196570*/
 
/* Call program                                                    */
             CALL       PGM(FD0585) PARM(&RSEQ)
 
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
/**************SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DLC2103 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)                                                  196570*/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            FDC0585 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)                                                /*196570*/
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
