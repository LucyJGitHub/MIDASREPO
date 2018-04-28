/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Cust. Serv. Fees - Fixed Fees Accruals')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1954 - Fixed Fees Accruals Generation                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CSD008  *CREATE    Date 05Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ )
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Accruals Required indicator(s)  */
 
             DCL        VAR(&F0FIAC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/* check whether Accruals processing have to run today */
 
             RTVDTAARA  DTAARA(GLCSFSTAT (9 1)) RTNVAR(&F0FIAC)
 
             IF         COND(&F0FIAC *EQ 'N') THEN(GOTO CMDLBL(END))
 
/* Send start component message */
 
             SNDPGMMSG  MSG('GLC1954 - Customer Service Fees/Fixed +
                          Fees accruals Generation') TOMSGQ(MRUNQ +
                          MOPERQ) MSGTYPE(*INFO)
 
/* Reset job switches */
 
             CHGJOB SWS(00000000)
 
/* Create LDA if not there */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' '))
 
/* Retrieve SDSTAT details */
 
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 
/* Check component status */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)
 
 
/* If restrat of component, then copy back working file */
 
             IF         COND(&STATUS = 'Y') THEN(DO)
 
/* Use backup files when rerun : Fees Posting for Accruals */
 
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
 
/*       : Fees Accrued To date File */
 
                  CPYF       FROMFILE(XGLFEACPD) TOFILE(GLFEACPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GLFEACPD))
 
/*       : Today Accruals on Holding Items File */
 
                  CPYF       FROMFILE(XGLTAHIPD) TOFILE(GLTAHIPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GLTAHIPD))
 
/* Set Status component to 'N' */
 
                  CHGVAR     VAR(&STATUS) VALUE('N')
                  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
             ENDDO
 
             ELSE       CMD(DO)
 
/* Else backup files : Fee accrued To-Date File */
 
                  CPYF       FROMFILE(GLFEACPD) TOFILE(&TOLIB/XGLFEACPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGLFEACPD))
 
/*       : Today Accruals on Holdings Items File */
 
                  CPYF       FROMFILE(GLTAHIPD) TOFILE(&TOLIB/XGLTAHIPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGLTAHIPD))
 
/*        : Fees posting for accruals */
 
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
             ENDDO
 
/* Change Component Status to started */
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Override Files */
 
             IF         COND(&CSEQ *NE 1) THEN(DO)
             OVRDBF     FILE(GEFEPD) TOFILE(GEFE2PD)
             OVRDBF     FILE(GEFEZZ) TOFILE(GEFE2ZZ)
             ENDDO
 
/* Call program */
 
            CALL       PGM(GL1954)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/* Send Abnormal end component message */
 
               SNDPGMMSG  MSG('GLC1954 - Customer Service Fees/Fixed +
                          Fees Accruals Generation abnormally +
                          terminated') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
              GOTO       CMDLBL(END)
             ENDDO
 
/* If No database error, Component is terminated */
 
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Send normal end component message */
 
             SNDPGMMSG  MSG('GLC1954 - Customer Service Fees/Fixed +
                          Fees Accruals Generation successfully +
                          terminated') TOMSGQ(MRUNQ MOPERQ) +
                          MSGTYPE(*INFO)
 
/* Delete files image */
 
             DLTF       FILE(XGLFEACPD)
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
 
             GOTO       CMDLBL(END)
 
/* Abnormal end of GLC1954 */
 
 ABNORM:
             CHGJOB     SWS(XXXXXX11)
 
/* Send Abnormal end component message */
 
             SNDPGMMSG  MSG('GLC1954 - Customer Service Fees/Fixed +
                          Fees Accruals Generation abnormal end. +
                          (PGM error).') TOPGMQ(*EXT) TOMSGQ(MRUNQ +
                          MOPERQ) MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
