/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Create XLIB objects for Support System')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC1625 - Create XLIB objects for Support System            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP016 *CREATE     Date 26Aug02              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LIBGRP &SBSID)
 
             DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
/* Parameters for QCLSCAN. */
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(2) VALUE('@@')
             DCL        VAR(&PATTERN2) TYPE(*CHAR) LEN(2) VALUE('**')
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(2) VALUE(2)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRIM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3)
 
/* Declare driving file keyed on XLIB library. */
             DCLF       FILE(SMSETULD)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&XLIB) VALUE(&LIBGRP *TCAT 'XLIB')
 
READNEXT:
/* File is keyed on sequence so objects should be created in order. */
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(CHGJOBD)
             ENDDO
 
/* Scan object name to replace '@@' with system ID. */
             CHGVAR     VAR(&RESULT) VALUE('0')
             CHGVAR     VAR(&STRLEN) VALUE(10)
             CALL       PGM(QCLSCAN) PARM(&DFNAME &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFNAME &RESULT 2 )) VALUE(&LIBGRP)
             ENDDO
 
/* Scan command to replace '@@' with system ID. */
SCAN:
             CHGVAR     VAR(&RESULT) VALUE('0')
             CHGVAR     VAR(&STRLEN) VALUE(300)
             CALL       PGM(QCLSCAN) PARM(&DFCMD &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFCMD &RESULT 2 )) VALUE(&LIBGRP)
                GOTO       CMDLBL(SCAN)
             ENDDO
 
/* Scan command to replace '**' with system ID. */
SCAN2:
             CHGVAR     VAR(&RESULT) VALUE('0')
             CALL       PGM(QCLSCAN) PARM(&DFCMD &STRLEN &STRPOS +
                          &PATTERN2 &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFCMD &RESULT 2 )) VALUE(&SBSID)
                GOTO       CMDLBL(SCAN2)
             ENDDO
 
/* Special processing for certain object types. */
             IF         COND(%SST(&DFTYPE 1 1) *EQ '*') THEN(DO)
                CHKOBJ     OBJ(&XLIB/&DFNAME) OBJTYPE(&DFTYPE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   CALL       PGM(QCMDEXC) PARM(&DFCMD 300)
                ENDDO
             ENDDO
 
/* For non-objects attempt to remove them first.  This is why the call to */
/*  QCMDEXEC has monitor messages.                                        */
/* Non-objects are part of the subsystem and include: Autostart job entry */
/*                                                    Workstation entry   */
/*                                                    Routing entries     */
/*                                                    Job queue entries   */
             IF         COND(%SST(&DFTYPE 1 1) *NE '*') THEN(DO)
                CALL       PGM(QCMDEXC) PARM(&DFCMD 300)
/* Subsystem not changed. */
                MONMSG     MSGID(CPF1697)
/* Active subsystem mayor may not have changed. */
                MONMSG     MSGID(CPF1691)
             ENDDO
 
/* Job descriptions require special processing. */
             IF         COND(&DFTYPE *EQ '*JOBD') THEN(DO)
                CALL       PGM(UPC1616) PARM(&DFNAME &LIBGRP &SBSID)
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
CHGJOBD:
/* Prompt the command to allow the user to change the job description library lists. */
             CHGJOBDLBL SYSPREFIX(&LIBGRP)
             MONMSG     MSGID(CPF6801)
 
             GOTO       CMDLBL(END)
ABNOR:
             CHGJOB     SWS(XXXXXX11)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
