/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Set up system authority - Support System')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP016 *CREATE     Date 02Dec02              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SUPP_PFX &MAIN_PFX)
 
             DCL        VAR(&SUPP_PFX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MAIN_PFX) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
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
 
/* Declare driving file keyed on SETUPAUT for Support System. */
             DCLF       FILE(SMSETULE)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
READNEXT:
/* File is keyed on sequence so objects should be created in order. */
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/* Scan command to replace '@@' with system ID. */
SCAN:
             CHGVAR     VAR(&RESULT) VALUE('0')
             CHGVAR     VAR(&STRLEN) VALUE(300)
             CALL       PGM(QCLSCAN) PARM(&DFCMD &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFCMD &RESULT 2 )) VALUE(&SUPP_PFX)
                GOTO       CMDLBL(SCAN)
             ENDDO
 
/* Scan command to replace '**' with system ID. */
SCAN2:
             CHGVAR     VAR(&RESULT) VALUE('0')
             CALL       PGM(QCLSCAN) PARM(&DFCMD &STRLEN &STRPOS +
                          &PATTERN2 &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFCMD &RESULT 2 )) VALUE(&MAIN_PFX)
                GOTO       CMDLBL(SCAN2)
             ENDDO
 
             CALL       PGM(QCMDEXC) PARM(&DFCMD 300)
/* F3 taken from command prompt. */
             MONMSG     MSGID(CPF6801)
 
             GOTO       CMDLBL(READNEXT)
ABNOR:
             CHGJOB     SWS(XXXXXX11)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
