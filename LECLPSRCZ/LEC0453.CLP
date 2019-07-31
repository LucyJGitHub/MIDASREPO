/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Dropped Repay/Past Due for Matured Loans')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0453 - Dropped Repay/Past Due for Matured Loans - COB    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ---------------- -----------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 236101             Date 02Nov05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE005 *C *CREATE  Date 22May97              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       236101 - Applied Fix 235249.                                */
/*                Added fix 216263 as preventive fix when file is    */
/*                empty.  Moved changed of component status to 'N'   */
/*                right after checking of U7/U8 to ensure that if    */
/*                component failed system will be able to restart.   */
/*       CLE005 - Customer Lending Enhancements - Others (T3)        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare the variables for rerun checking */
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('Midas Drop Repay/Past Due for Matured +
                          Loans') TOPGMQ(*EXT) TOMSGQ(MRUNQ)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&LIB) VALUE(&PREF *TCAT 'DPLIB')
 
/* Check the current status of this component */
/* If this is not a restart, copy master files to backup files */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
             IF         COND(&STAT *EQ 'N') THEN(DO)
 
                CPYF       FROMFILE(LOAMSDK) TOFILE(&LIB/TLOAMSDK) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                 /*236101*/
                CPYF       FROMFILE(LOAMSZ1) TOFILE(&LIB/TLOAMSZ1) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                 /*236101*/
                CPYF       FROMFILE(PDUEDU) TOFILE(&LIB/TPDUEDU) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                 /*236101*/
                CPYF       FROMFILE(PDUEZX) TOFILE(&LIB/TPDUEZX) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                 /*236101*/
 
                CHGVAR     VAR(&STAT) VALUE('Y')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
 
/* If this is a restart, restore master files */
 
             ELSE       CMD(DO)
 
                CPYF       FROMFILE(TLOAMSDK) TOFILE(LOAMSDK) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                 /*236101*/
                CPYF       FROMFILE(TLOAMSZ1) TOFILE(LOAMSZ1) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                 /*236101*/
                CPYF       FROMFILE(TPDUEDU) TOFILE(PDUEDU) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                 /*236101*/
                CPYF       FROMFILE(TPDUEZX) TOFILE(PDUEZX) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                 /*236101*/
 
             ENDDO
 
/* Call Manual Facility Utilisation Audit Report */
 
             CALL       PGM(LE0453)
 
/* No database error or not file-out-of-balance */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGVAR     VAR(&STAT) VALUE('N')                                          /*236101*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                            /*236101*/
 
                DLTF       FILE(TLOAMSDK)
                MONMSG     MSGID(CPF2105)                                                 /*236101*/
                DLTF       FILE(TLOAMSZ1)
                MONMSG     MSGID(CPF2105)                                                 /*236101*/
                DLTF       FILE(TPDUEDU)
                MONMSG     MSGID(CPF2105)                                                 /*236101*/
                DLTF       FILE(TPDUEZX)
                MONMSG     MSGID(CPF2105)                                                 /*236101*/
 
/**********     CHGVAR     VAR(&STAT) VALUE('N')                     */                   /*236101*/
/**********     CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)       */                   /*236101*/
             ENDDO
             ELSE       CMD(DO)
 
/* Database error processing */
 
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                             MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ))
                ELSE       CMD(SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) +
                             MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                             MRUNQ))
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            LEC0453 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
