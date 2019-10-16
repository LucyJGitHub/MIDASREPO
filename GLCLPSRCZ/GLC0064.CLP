/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Statement of Account Extract Control Pgm')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0064 - Statement of Account Extract Control Program      */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. 261705             Date 08Oct19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      AR1049762          Date 29Oct12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG4844            Date 01Nov04              */
/*                      BUG2387            Date 06May04              */
/*                      BUG1989            Date 28Apr04              */
/*                      CGL025  *CREATE    Date 18Aug03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       261705 - Add extracts for Start and End dates. Apply 258051.*/
/*              - Applied for MD054159.                              */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1049762 - Avoid I/O operation was applied to closed file. */
/*                   (Child:AR1049763)                               */
/*       BUG4844 - Errors in on-line statements                      */
/*       BUG2387 - Override GLAPSGL0 for GL0065.                     */
/*       BUG1989 - Change account code fields to 10-digits           */
/*       CGL025 - Statement of Account for a Specific Period.        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ACCKEY &SDAT &EDAT)
 
/*           DCL        VAR(&ACCKEY) TYPE(*CHAR) LEN(18)                                 /*BUG1989*/
             DCL        VAR(&ACCKEY) TYPE(*CHAR) LEN(24)                                 /*BUG1989*/
             DCL        VAR(&SDAT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&EDAT) TYPE(*DEC) LEN(5 0)
 
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
/*/COPY WNCPYSRC,GLH00345                                            */
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Reset LDA & Job switches */
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             MONMSG     MSGID(CPF1015) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' '))
 
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
                STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                             CMTSCOPE(*JOB)
                CLRPFM     FILE(CGSTMTPD)
/* Override the Reference File for Non-Comit Control                 */
                OVRDBF     FILE(EXUDCRPD) TOFILE(CGUDCRPD) SECURE(*YES) +
                             SHARE(*NO)
             ENDDO
 
/* Clear extract file       */
             CLRPFM     FILE(STMTAH)
             CLRPFM     FILE(STMTHH)
             CLRPFM     FILE(STMTZX)
 
/* Call extract program     */
             CALL       PGM(GL0064) PARM(&ACCKEY &SDAT &EDAT)
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
                                                                                         /*BUG4844*/
             CLRPFM GLWKPSPD                                                             /*BUG4844*/
                                                                                         /*BUG4844*/
             CALL GL00645                                                                /*BUG4844*/
                                                                                         /*BUG2387*/
/* Override the A/c Posting Ext. for group accounts file.                                /*BUG2387*/
             OVRDBF FILE(GLAPSGL0) TOFILE(GLAPSGAL0)                                     /*BUG2387*/
             OVRDBF FILE(APOST) TOFILE(GLWKPSPD)                                         /*BUG4844*/
 
/* Call report program      */
             CALL       PGM(GL0065)
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* If Correspondence Manager is installed */
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)
/*/COPY WNCPYSRC,GLH00346                                            */
/** Call Extract File Instance Management */
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')
             CALL       PGM(CGC3605) PARM(&ACTION)
 
/** Call Extract Program                  */
             RCLRSC     LVL(*CALLER)                                                   /*AR1049762*/
/**********  CALL       PGM(CG4520) PARM(&W0RTN &W0CMT) */                               /*261705*/
             CALL       PGM(CG4520) PARM(&W0RTN &W0CMT &SDAT &EDAT)                      /*261705*/
 
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
                          GLC0064 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
