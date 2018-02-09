/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis IAT file pre-processing')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC2824 - Midas-Fontis IAT File Pre-processing              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Prev Amend No. CGL009  *CREATE    Date 18May99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL009 - Midas-Fontis Inter-Account Transfers (IAT) and     */
/*                Third Party Payments (TPP) Interface               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRTCD)
 
             DCL        VAR(&PRTCD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RECIAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Declare System outfile for DSPFD TYPE(*MBRLIST) */
 
             DCLF       FILE(QAFDMBRL)
 
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(GLFIATDA (27 1)) RTNVAR(&RECIAT)
             IF         COND(&RECIAT *EQ 'Y') THEN(DO)
             DSPFD      FILE(GLIATHPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/GLIATHPDX)
             OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/GLIATHPDX)
 
 
 RECEIVE:
             RCVF       RCDFMT(QWHFDML)
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             ALCOBJ     OBJ((&MLLIB/&MLFILE *FILE *EXCL &MLNAME)) +
                          WAIT(120)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RECEIVE))
 
             CHGVAR     VAR(&MEMBER) VALUE('GZ' *CAT +
                          %SUBSTRING(&MLNAME 3 8))
 
             IF         COND(&MLNRCD *EQ 0) THEN(DO)
             DLCOBJ     OBJ((&MLLIB/&MLFILE *FILE *EXCL &MLNAME))
             RMVM       FILE(&MLLIB/&MLFILE) MBR(&MLNAME)
             RMVM       FILE(GLIATPPD) MBR(&MEMBER)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(RECEIVE)
             ENDDO
 
             ALCOBJ     OBJ((&MLLIB/GLIATPPD *FILE *EXCL &MEMBER)) +
                          WAIT(120)
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
             DLCOBJ     OBJ((&MLLIB/&MLFILE *FILE *EXCL &MLNAME))
             GOTO       CMDLBL(RECEIVE)
             ENDDO
 
             OVRDBF     FILE(GLIATHPD) MBR(&MLNAME)
             OVRDBF     FILE(GLIATPPD) MBR(&MEMBER)
 
/* Pre-process the IAT Interface files by calling GL2824 */
 
             CALL       PGM(GL2824)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             DLCOBJ     OBJ((&MLLIB/GLIATHPD *FILE *EXCL &MLNAME))
             DLCOBJ     OBJ((&MLLIB/GLIATPPD *FILE *EXCL &MEMBER))
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             DLCOBJ     OBJ((&MLLIB/GLIATHPD *FILE *EXCL &MLNAME))
             DLCOBJ     OBJ((&MLLIB/GLIATPPD *FILE *EXCL &MEMBER))
 
             RMVM       FILE(&MLLIB/GLIATHPD) MBR(&MLNAME)
             RMVM       FILE(&MLLIB/GLIATPPD) MBR(&MEMBER)
 
             COMMIT
 
             GOTO       CMDLBL(RECEIVE)
             ENDDO
 
 
 ABNOR:
             ROLLBACK
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&PRTCD) VALUE('Y')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC2824 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
 
