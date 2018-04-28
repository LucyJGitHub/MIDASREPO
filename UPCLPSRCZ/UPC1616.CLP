/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Build up *JOBD library list - Supp. Sys.')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1533 - Build up job desription library list - Supp. Sys. */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC011 *CREATE     Date 05Aug02              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC011 - 24x7 availability.  System set up.                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&JOBD &LIBGRP &SBSID)
 
             DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
             DCL        VAR(&JOBD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
 
/* Parameters for QCLSCAN. */
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0) VALUE(10)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(2) VALUE('**')
             DCL        VAR(&PATTERN2) TYPE(*CHAR) LEN(2) VALUE('@@')
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(2) VALUE(2)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRIM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3)
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMMAND) TYPE(*CHAR) LEN(3000) +
                          VALUE('CHGJOBD JOBD(')
             DCL        VAR(&FIRST) TYPE(*CHAR) LEN(4) VALUE('*YES')
 
             DCLF       FILE(SMLIBLPD)
 
             CHGVAR     VAR(&XLIB) VALUE(&LIBGRP *TCAT 'XLIB')
 
/* Copy only library records from original driving file. */
             CPYF       FROMFILE(SMSETULA) TOFILE(SMLIBLPD) +
                          MBROPT(*REPLACE) INCCHAR(DFTYPE 1 *EQ +
                          '*LIB      ') FMTOPT(*MAP *DROP)
 
/* Build up the next step of the command to execute. */
             CHGVAR     VAR(&COMMAND) VALUE(&COMMAND *TCAT &XLIB +
                          *TCAT '/' *TCAT &JOBD *TCAT ') INLLIBL(')
READNEXT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(CHGJOBD)
             ENDDO
 
/* Change '**' on driving file to equal system prefix ID depending on */
/*  library name.                                                     */
             CALL       PGM(QCLSCAN) PARM(&DFNAME &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFNAME &RESULT 2 )) VALUE(&SBSID)
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&RESULT) VALUE(0)
                CALL       PGM(QCLSCAN) PARM(&DFNAME &STRLEN &STRPOS +
                             &PATTERN2 &PATLEN &TRANSLATE &TRIM &WILD +
                             &RESULT)
                IF         COND(&RESULT *GT 0) THEN(DO)
                   CHGVAR     VAR(%SST(&DFNAME &RESULT 2 )) VALUE(&LIBGRP)
                ENDDO
             ENDDO
 
             CHGVAR     VAR(&LIB) VALUE(&DFNAME)
             IF         COND(&FIRST *EQ '*YES') THEN(DO)
                CHGVAR     VAR(&COMMAND) VALUE(&COMMAND *TCAT &LIB)
                CHGVAR     VAR(&FIRST) VALUE('*NO ')
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&COMMAND) VALUE(&COMMAND *BCAT &LIB)
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
CHGJOBD:
/* As long as one library was found then perform CHGJOBD. */
             IF         COND(&FIRST *EQ '*NO') THEN(DO)
                CHGVAR     VAR(&COMMAND) VALUE(&COMMAND *TCAT ')')
                CALL       PGM(QCMDEXC) PARM(&COMMAND 3000)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/* Abnormal program end. */
ABNOR:
             CHGJOB     SWS(XXXXXX11)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
