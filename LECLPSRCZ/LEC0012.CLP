/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Initialisation Program Control for CLE023')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0012 - Midas Initialisation Program Control for CLE023   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CLE023  *CREATE    Date 19Nov01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CLE023  - Lending Facility History Improvements.            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCD &MODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
 
/* Get system prefix */
             CHGVAR     VAR(&PREF) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PREF *TCAT 'DPLIB')
 
             CHGJOB     SWS(XXXXXX00)
 
             IF         COND(&MODE *NE '3') THEN(DO)
                CPYF       FROMFILE(FCLTYFN) TOFILE(&TOLIB/FCLTYFNX) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                CPYF       FROMFILE(FACHISA) TOFILE(&TOLIB/FACHISAX) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                CPYF       FROMFILE(SDCLNDPD) TOFILE(&TOLIB/SDCLNDPDX) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                CPYF       FROMFILE(CLOANCK)  TOFILE(&TOLIB/CLOANCKX) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                CPYF       FROMFILE(MCLONCK)  TOFILE(&TOLIB/MCLONCKX) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
/* Call the RPG initialisation program */
             CALL       PGM(LE0012)
 
/* Check if error occured in the program */
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
             ELSE       CMD(DO)
 
/* Restore backup if an error occured  */
                CPYF       FROMFILE(FCLTYFNX) TOFILE(FCLTYFN) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   CLRPFM     FILE(FCLTYFN)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(GOTO +
                             CMDLBL(ABNOR))
 
                CPYF       FROMFILE(FACHISAX) TOFILE(FACHISA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   CLRPFM     FILE(FACHISA)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(GOTO +
                             CMDLBL(ABNOR))
 
                CPYF       FROMFILE(SDCLNDPDX) TOFILE(SDCLNDPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   CLRPFM     FILE(SDCLNDPD)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(GOTO +
                             CMDLBL(ABNOR))
 
                CPYF       FROMFILE(CLOANCKX) TOFILE(CLOANCK) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   CLRPFM     FILE(CLOANCK)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(GOTO +
                             CMDLBL(ABNOR))
 
                CPYF       FROMFILE(MCLONCKX) TOFILE(MCLONCK) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   CLRPFM     FILE(MCLONCK)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(GOTO +
                             CMDLBL(ABNOR))
 
             ENDDO
 
 
/* Abnormal Termination of the program */
ABNOR:       SNDUSRMSG  MSG('Error occurred in restoring files.  +
                          Please restore the files manually: +
                          PF/FCLTYFNX to PF/FCLTYFN; PF/FACHISAX to +
                          PF/FACHISA; PF/CLOANCKX to PF/CLOANCK +
                          PF/MCLONCKX to PF/MCLONCK and PF/SDCLNDPDX +
                          to PF/SDCLNDPD') MSGTYPE(*INFO)
 
             CHGVAR     VAR(&RTCD) VALUE('*ERROR*')
             CHGJOB     SWS(00000000)
 
ABNOR1:      SNDPGMMSG  MSG('Error occured in LEC0012 program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             IF         COND(&RTCD *NE '*ERROR*') THEN(DO)
                DLTF       FILE(FCLTYFNX)
                MONMSG     MSGID(CPF2105)
                DLTF       FILE(FACHISAX)
                MONMSG     MSGID(CPF2105)
                DLTF       FILE(SDCLNDPDX)
                MONMSG     MSGID(CPF2105)
                DLTF       FILE(CLOANCKX)
                MONMSG     MSGID(CPF2105)
                DLTF       FILE(MCLONCKX)
                MONMSG     MSGID(CPF2105)
             ENDDO
 
             ENDPGM
