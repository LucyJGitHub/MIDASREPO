/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Confirmation of balances')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC4630 - Certificate of Balances                           */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL024  *CREATE    Date 11Aug03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL024 - Certificate and Confirmation of Balances.          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ)
 
             DCL        VAR(&RSEQ)    TYPE(*CHAR) LEN(5)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Reset Local Data Area  */
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/* Reset job switches     */
             CHGJOB     SWS(XXXXXX00)
 
/* Access Midas Modules File */
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
             IF         COND(&RTCD *NE '       ') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Error +
                          on access to ICD file SDMMODPD') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If Correspondence Manager is installed */
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)
                CLRPFM     FILE(CGCONBPD)
/* Override the Reference File for Non-Comit Control                 */
                OVRDBF     FILE(EXUDCRPD) TOFILE(CGUDCRPD) SECURE(*YES) +
                             SHARE(*NO)
             ENDDO
 
/* Call report program    */
             CALL       PGM(GL4630) PARM(&RTCD &RSEQ)
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(END))
 
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             CHGVAR     VAR(&MEM) VALUE('Please wait while processing...')
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MEM)
             CALL       PGM(SCC0010) PARM('GLC4630' '     ' ' ')
 
/* If Correspondence Manager is installed */
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)
/** Call Extract File Instance Management */
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')
             CALL       PGM(CGC3605) PARM(&ACTION)
 
/** Call Extract Program                  */
             CALL       PGM(CG4560) PARM(&W0RTN &W0CMT 'CONB')
 
/** Reclaim resource                      */
             RCLRSC
 
/** Error in extract program              */
             IF         COND(&W0RTN *NE '       ') THEN(DO)
                SNDPGMMSG  MSG('User Defined Correspondence Extract +
                             failure') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                             MRUNQ) MSGTYPE(*INFO)
                ROLLBACK
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/** Call Custom Defined Data Extract pgm */
             CALL       PGM(CGC3604)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Prompt for immediate print */
             CALL       PGM(CGC5217) PARM(' ')
             MONMSG     MSGID(CPF0000)
 
             ENDDO
 
/* SKIP abnormal processing  */
             GOTO       CMDLBL(END)
 
ABNOR:
/* UDC module must be on in order to call a Correspondence Manager program */
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')
                CALL       PGM(CGC3605) PARM(&ACTION)
             ENDDO
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC4630 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
 
             DLTOVR     FILE(EXUDCRPD)
             MONMSG     MSGID(CPF9841)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
