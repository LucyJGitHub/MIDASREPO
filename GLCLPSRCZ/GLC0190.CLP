/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Transfer Ext GL Postings to Interface Fil')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0190 - Transfer External GL Postings to Interface File   */
/*                                                                   */
/*       (C) Copyright Misys International Banking Systems 2003      */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL028  *CREATE   Date  22Sep03              */
/*                                                                   */
/*------------------------------------------------------------------ */
/*                                                                   */
/*       CGL028 - GL Postings Interface                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL       VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                         MISYS INTERNATIONAL BANKING SYSTEMS LTD. +
                         2003')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DOC) TYPE(*CHAR) LEN(10) VALUE('GLPOST.DAT')
             DCL        VAR(&RUND) TYPE(*CHAR) LEN(7)
 
/* Global monitor */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Reset Job Switches */
             CHGJOB     SWS(00000000)
 
/* Create LDA if it's not yet existing */
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas Local Data Area'))
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/* Setup library name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
/* Retrieve the current system date */
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RUND)
 
/* Ensure that nobody else is using this function   */
             ALCOBJ     OBJ((GLTEXTPD *FILE *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
                 RCVMSG     RMV(*YES) MSGID(&MSGID)
                 IF         COND(&MSGID = 'CPF1002') THEN(DO)
                   CHGVAR     VAR(&MEM) VALUE('Job cannot be run now.')
                   CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MEM)
                   CHGVAR     VAR(&MEM) VALUE('This option is being +
                                used by another user.')
                   CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MEM)
                   CALL       PGM(SCC0010) PARM('GLC0190' 'ENTER' ' ')
                   GOTO       CMDLBL(ENDPGM)
                 ENDDO
             ENDDO
 
/* Send a message for the user to confirm that he wish to transfer  */
/* external GL postings to interface file                           */
             CHGVAR     VAR(&MEM) VALUE('Please confirm that you wish to')
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MEM)
             CHGVAR     VAR(&MEM) VALUE('transfer external GL postings to +
                           interface file')
             CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MEM)
             CHGVAR     VAR(&REPLY) VALUE(N)
             CALL       PGM(SCC0010) PARM('GLC0190' 'OPTION' &REPLY)
             IF         COND(&REPLY = 'N') THEN(GOTO CMDLBL(ENDPGM))
 
/* Check if folder and document exists */
             CHGVAR     VAR(&FLR) VALUE('GLPOST' *CAT &PREFIX)
 CHECK:      RMVMSG     CLEAR(*ALL)
             CHKDLO     DLO(&DOC) FLR(&FLR)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             RCVMSG     MSGTYPE(*ANY)  RMV(*YES) MSGID(&MSGID)
                 IF         COND(&MSGID = 'CPF8A77' *OR +
                                 &MSGID = 'CPF8A82' *OR +
                                 &MSGID = 'CPF9801' *OR +
                                 &MSGID = 'CPF9006') THEN(DO)
                   IF         COND(&MSGID = 'CPF9006') THEN(CHGVAR +
                            VAR(&MEM) VALUE('User not enrolled in +
                            system distribution directory.'))
                   ELSE       CMD(CHGVAR VAR(&MEM) VALUE('The system +
                            cannot find a copy of ' *CAT &DOC *CAT ' +
                            file.'))
                   CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MEM)
                   CHGVAR     VAR(&REPLY) VALUE(N)
                   CALL       PGM(SCC0010) PARM('GLCG098' 'RETRY' &REPLY)
                   IF         COND(&REPLY = 'Y') THEN(GOTO CMDLBL(CHECK))
                   IF         COND(&REPLY = 'N') THEN(GOTO CMDLBL(ENDPGM))
                 ENDDO
             ENDDO
 
/* Clear work files */
             CLRPFM     FILE(GLTEXTPD)
             CLRPFM     FILE(GLEXTHPD)
             CLRPFM     FILE(GLEXTDPD)
 
/* Convert PC file into a physical file */
             CPYFRMPCD  FROMFLR(&FLR) TOFILE(GLTEXTPD) FROMDOC(&DOC)
 
/* Extract record to GLEXTHPD - Header File */
             CPYF       FROMFILE(GLTEXTPD) TOFILE(GLEXTHPD) +
                          MBROPT(*REPLACE) INCCHAR(*RCD 1 *EQ 'H') +
                          FMTOPT(*NOCHK)
 
/* Extract record to GLEXTDPD - Detail File */
             CPYF       FROMFILE(GLTEXTPD) TOFILE(GLEXTDPD) +
                          MBROPT(*REPLACE) INCCHAR(*RCD 1 *EQ 'D') +
                          FMTOPT(*NOCHK)
PROCESS:
/* Call GL0190 to perform transfer of postings to interface files  */
             CALL       PGM(GL0190)
 
/* Wrong copy of GLPOST.DAT */
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
                 CHGVAR     VAR(&MEM) VALUE(&DOC *CAT ' file in ' *CAT +
                        &FLR *BCAT 'folder is out of date.')
                 CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MEM)
                 CHGJOB     SWS(0XXXXX00)
                 CHGVAR     VAR(&REPLY) VALUE(N)
                 CALL       PGM(SCC0010) PARM('GLC0190' 'RETRY' &REPLY)
                 IF         COND(&REPLY = 'Y') THEN(GOTO CMDLBL(CHECK))
                 IF         COND(&REPLY = 'N') THEN(GOTO CMDLBL(ENDPGM))
             ENDDO
 
/* Incorrect hash totals  */
             IF         COND(%SWITCH(X1XXXXXX)) THEN(DO)
                 CHGVAR     VAR(&MEM) VALUE(&DOC *CAT ' file in ' *CAT +
                        &FLR *BCAT 'folder does not have')
                 CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MEM)
                 CHGVAR     VAR(&MEM) VALUE('the correct hash totals.')
                 CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MEM)
                 CHGJOB     SWS(X0XXXX00)
                 CHGVAR     VAR(&REPLY) VALUE(N)
                 CALL       PGM(SCC0010) PARM('GLC0190' 'RETRY' &REPLY)
                 IF         COND(&REPLY = 'Y') THEN(GOTO CMDLBL(CHECK))
                 IF         COND(&REPLY = 'N') THEN(GOTO CMDLBL(ENDPGM))
             ENDDO
 
/* Postings file appear to have been processed before  */
             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)
                 CHGVAR     VAR(&MEM) VALUE(&DOC *CAT ' file in ' *CAT +
                        &FLR *BCAT 'folder appears to have')
                 CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MEM)
                 CHGVAR     VAR(&MEM) VALUE('been processed before.  Do you +
                               want to continue?')
                 CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MEM)
                 CHGVAR     VAR(&REPLY) VALUE(N)
                 CALL       PGM(SCC0010) PARM('GLC0190' 'OPTION' &REPLY)
                 IF         COND(&REPLY = 'N') THEN(GOTO CMDLBL(ENDPGM))
                 IF         COND(&REPLY = 'Y') THEN(DO)
                    CHGJOB     SWS(XX01XXXX)
                    GOTO       CMDLBL(PROCESS)
                 ENDDO
             ENDDO
 
/* Rollback data changes if DBError occured */
             IF         COND(%SWITCH(XXXXXXX1) *OR +
                          %SWITCH(XXXXXX1X)) THEN(GOTO CMDLBL(DBERROR))
 
/* Commit any database changes and delete document  */
             COMMIT
             DLTDLO     DLO(&DOC) FLR(&FLR)
 
             GOTO       CMDLBL(ENDPGM)
 
 DBERROR:
             CHGVAR     VAR(&MEM) VALUE('Job Terminated - +
                            Database error')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MOPERQ MRUNQ) TOPGMQ(*EXT)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                        MSGDTA(&MEM) TOMSGQ(MRUNQ MOPERQ)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK
 
/* Abnormal termination */
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC0190 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(&MEM) VALUE('Program ended abnormally - see job log')
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MEM)
             CALL       PGM(SCC0010) PARM('GLC0190' 'ENTER' ' ')
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDPGM:
             DLCOBJ     OBJ((GLTEXTPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
