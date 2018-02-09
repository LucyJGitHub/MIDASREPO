/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FD Fwd rates exceeding rate tolerance rept')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - FD Module                                           */
/*                                                                   */
/*       FDC0580 - Forward Rates Exceeding Rate Tolerance            */
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
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CSD006  *CREATE    Date 05Jan01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD006 - Market Data Feeds                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
/* Declare variables                                               */
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message                                          */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send program message                                            */
 
             SNDPGMMSG  MSG('FD0580 - Forward Rates Exceeding +
                          Rate Tolerance') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             RTVJOBA    TYPE(&JOBTYPE)
 
             IF         COND(&RPARM *NE 'ALL') THEN(DO)
             OVRDBF     FILE(SDMDFFWR) TOFILE(SDMDFHL3)
             ENDDO
 
             IF         COND(&RPARM *EQ 'ALL') THEN(DO)
             OVRDBF     FILE(SDMDFFWR) TOFILE(SDMDFHL2)
             ENDDO
 
/* Call program                                                    */
 
             CALL       PGM(FD0580) PARM(&RSEQ &RPARM)
 
             DLTOVR     FILE(SDMDFFWR)
 
/* Database error processing                                       */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination - batch job                                */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            FD0580 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
