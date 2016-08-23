/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Add part sold records to facility history')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module Upgrade Utility             */
/*                                                                   */
/*       LEC0008 - LE Initialisation program to add Part Sold        */
/*                 records to Facility History file.                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. 199570 *CREATE     Date 30Oct01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       199570 - Calls RPG program LE0008 when CLE005 is switched   */
/*                on LE0008 reports facilities with missing parts    */
/*                sold events in FACHISA and generates them.         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCD &MODE)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNCHG) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                       Misys International Banking Systems Ltd. 2002')
 
             DCLF       FILE(SDBANKPD)
 
/* Global monitor message. */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
 
             RCVF       RCDFMT(SDBANKD0)
 
             CHGVAR     VAR(&RUNCHG) VALUE(&BJRDNB)
             CHGVAR     VAR(&RUNDAT) VALUE(&RUNCHG)
 
             SNDPGMMSG  MSG('Facility History Utility') TOMSGQ(MRUNQ)
 
/* Get system prefix. */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
 
             IF         COND(&MODE *NE '3') THEN(DO)
                CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')
                CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
 
/* Create backup of PF/FACHISA to PF/YFACHISA before generation. */
/*  of missing parts sold events in the file.                    */
                CPYF       FROMFILE(&DMLIB/FACHISA) +
                             TOFILE(&DPLIB/YFACHISA) MBROPT(*REPLACE) +
                             CRTFILE(*YES)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   CLRPFM     FILE(YFACHISA)
                   GOTO       CMDLBL(CONTIN1)
                ENDDO
                MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                   SNDUSRMSG  MSG('Error occurred in copying PF/FACHISA to +
                                PF/YFACHISA. Process terminated.') +
                                MSGTYPE(*INFO)
                   GOTO       CMDLBL(END)
                ENDDO
                GOTO       CMDLBL(CONTIN1)
 
/* Call PGM/LE0008. */
CONTIN1:
                CHGJOB     SWS(XXXXXX00)
                CALL       PGM(LE0008)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGVAR     VAR(&RTCD) VALUE('*ERROR*')
 /* Restore backup of files. */
             CPYF       FROMFILE(&DPLIB/YFACHISA) +
                          TOFILE(&DMLIB/FACHISA) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                CLRPFM     FILE(FACHISA)
                GOTO       CMDLBL(DSPERR1)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                GOTO       CMDLBL(DSPERR1)
             ENDDO
 
DSPERR1:
             SNDUSRMSG  MSG('Error occurred in restoring PF/FACHISA +
                          from PF/YFACHISA. Process terminated.  +
                          Please restore manually PF/FACHISA from +
                          PF/YFACHISA.') MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC0008I ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
 
ABNOR1:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC0008 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
 
 /* End program. */
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
