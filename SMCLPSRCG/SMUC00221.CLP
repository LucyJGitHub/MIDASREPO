/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Create GJLIB objects')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMUC00221 - Create GJLIB objects                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2010           */
/*                                                                   */
/*       Last Amend No. CSC043 *CREATE     Date 18Jun10              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&GPSBSID)
 
             DCL        VAR(&GPSBSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&GJLIB) TYPE(*CHAR) LEN(10)
 
/** Parameters for QCLSCAN. */
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(2) VALUE('**')
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(2) VALUE(2)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRIM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2010')
 
/** Declare driving file keyed on JLIB library. */
             DCLF       FILE(SMSETUL7)
 
/** Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&GJLIB) VALUE(&GPSBSID *TCAT 'GJLIB')
 
READNEXT:
/** File is keyed on sequence so objects should be created in order. */
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/** Scan object name to replace '**' with system ID. */
             CHGVAR     VAR(&RESULT) VALUE('0')
             CHGVAR     VAR(&STRLEN) VALUE(10)
             CALL       PGM(QCLSCAN) PARM(&DFNAME &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFNAME &RESULT 2 )) VALUE(&GPSBSID)
             ENDDO
 
/** Scan command to replace '**' with system ID. */
SCAN:
             CHGVAR     VAR(&RESULT) VALUE('0')
             CHGVAR     VAR(&STRLEN) VALUE(300)
             CALL       PGM(QCLSCAN) PARM(&DFCMD &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFCMD &RESULT 2 )) VALUE(&GPSBSID)
                GOTO       CMDLBL(SCAN)
             ENDDO
 
/** Special processing for certain object types. */
             IF         COND(%SST(&DFTYPE 1 1) *EQ '*') THEN(DO)
                CHKOBJ     OBJ(&GJLIB/&DFNAME) OBJTYPE(&DFTYPE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   CALL       PGM(QCMDEXC) PARM(&DFCMD 300)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
