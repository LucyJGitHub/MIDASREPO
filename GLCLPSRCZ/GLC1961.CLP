/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Generate Fee Postings Control')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1961 - Customer Service Fees -                           */
/*                 Generate Fee Postings Control                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CSD008  *CREATE    Date 05Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ )
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Accruals Required INDICATOR(S)                                  */
 
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
 
/* Global monitor message                                          */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send start component message.                                   */
 
             SNDPGMMSG  MSG('GLC1961 - Customer Service Fees/Posting +
                          Generation of authorised settlements') +
                          TOMSGQ(MRUNQ MOPERQ) MSGTYPE(*INFO)
 
/* Reset job switches.                                             */
 
             CHGJOB SWS(00000000)
 
/* Create LDA if not there.                                        */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' '))
 
/* Retrieve SDSTAT details.                                        */
 
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 
/* Check component status.                                         */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)
 
 
/* IF restrat of component, then copy back working file.           */
 
             IF         COND(&STATUS = 'Y') THEN(DO)
 
/* Use backup files when rerun : Fees Posting for Accruals.        */
 
                  CPYF       FROMFILE(XGEFEPD) TOFILE(GEFEPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GEFEPD))
                  CPYF       FROMFILE(XGEFEZZ) TOFILE(GEFEZZ) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GEFEZZ))
                  CPYF       FROMFILE(XGEFE2PD) TOFILE(GEFE2PD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GEFE2PD))
                  CPYF       FROMFILE(XGEFE2ZZ) TOFILE(GEFE2ZZ) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GEFE2ZZ))
 
/* Outstanding Fees Settlements.                                   */
 
                  CPYF       FROMFILE(XGLOTSTPD) TOFILE(GLOTSTPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GLOTSTPD))
 
/* Today Accruals on Holding Items File.                           */
 
                  CPYF       FROMFILE(XGLTAHIPD) TOFILE(GLTAHIPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GLTAHIPD))
 
/* Customer Fee Charges                                            */
 
                  CPYF       FROMFILE(XGLCHRGPD) TOFILE(GLCHRGPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GLCHRGPD))
 
/* Set Status component to 'N'.                                    */
 
                  CHGVAR     VAR(&STATUS) VALUE('N')
                  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
             ENDDO
 
             ELSE       CMD(DO)
 
/* Else backup files : Outstanding Fees Settlements.               */
 
                  CPYF       FROMFILE(GLOTSTPD) TOFILE(&TOLIB/XGLOTSTPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGLOTSTPD))
 
/* Today Accruals on Holdings Items File.                          */
 
                  CPYF       FROMFILE(GLTAHIPD) TOFILE(&TOLIB/XGLTAHIPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGLTAHIPD))
 
/* Fees posting for accruals.                                      */
 
                  CPYF       FROMFILE(GEFEPD) TOFILE(&TOLIB/XGEFEPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGEFEPD))
                  CPYF       FROMFILE(GEFEZZ) TOFILE(&TOLIB/XGEFEZZ) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGEFEZZ))
                  CPYF       FROMFILE(GEFE2PD) TOFILE(&TOLIB/XGEFE2PD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGEFE2PD))
                  CPYF       FROMFILE(GEFE2ZZ) TOFILE(&TOLIB/XGEFE2ZZ) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGEFE2ZZ))
 
/* Customer Fee Charges                                            */
 
                  CPYF       FROMFILE(GLCHRGPD) TOFILE(&TOLIB/XGLCHRGPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGLCHRGPD))
             ENDDO
 
/* Change Component Status to "started".                           */
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Override Files.                                                 */
 
             IF         COND(&CSEQ *NE 1) THEN(DO)
             OVRDBF     FILE(GEFEPD) TOFILE(GEFE2PD)
             OVRDBF     FILE(GEFEZZ) TOFILE(GEFE2ZZ)
             ENDDO
 
/* Call program.                                                   */
 
            CALL       PGM(GL1961)
 
/* If No database error, Component is terminated.                  */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
                CHGVAR     VAR(&STATUS) VALUE('N')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Send normal end component message.                              */
 
                SNDPGMMSG  MSG('GLC1961 - Customer Service +
                           Fees/Postings Generation of authorised +
                           Settlements successfully terminated') +
                           TOMSGQ(MRUNQ MOPERQ) MSGTYPE(*INFO)
 
/* Delete files image.                                             */
 
                DLTF       FILE(XGLOTSTPD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGLTAHIPD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGEFEPD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGEFEZZ)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGEFE2PD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGEFE2ZZ)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGLCHRGPD)
                MONMSG     MSGID(CPF0000)
 
             ENDDO
 
/* Database error processing                                       */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/* Send Abnormal end component message.                            */
 
                SNDPGMMSG  MSG('GLC1961 - Customer Service +
                           Fees/Postings Generation of authorised +
                           Settlements abnormally terminated') +
                           TOMSGQ(MRUNQ)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC1961 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
