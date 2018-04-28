/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Set up files for action file BUILD')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC0892 - Set up files for Action File BUILD                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Last Amend No. CUP019 *CREATE     Date 18Sep02              */
/*       Prev Amend No. nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP019 - Changes to handle Action File BUILD.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILE &OLDLIB &NEWLIB &OLDFILE &NEWFILE)
 
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWFILE) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&TRUNC_FILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&IN01) TYPE(*LGL)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
             DCLF       FILE(UPACTFPD)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Display file field description of both files. */
             DSPFFD     FILE(&OLDLIB/&FILE) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/OLD_FFD)
             DSPFFD     FILE(&NEWLIB/&FILE) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/NEW_FFD)
 
/* Truncate file name. */
             CHGVAR     VAR(&TRUNC_FILE) VALUE(&FILE)
READNEXT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(ABNOR2)
             ENDDO
 
/* Check if Action File matches record. */
             IF         COND(&FILE *EQ &AABONF) THEN(DO)
/* Build 'old' and 'new' file names. */
                CHGVAR     VAR(&OLDFILE) VALUE(&TRUNC_FILE *TCAT '_O')
                CHGVAR     VAR(&NEWFILE) VALUE(&TRUNC_FILE *TCAT '_N')
 
/* Clear Action File. */
                CLRPFM     FILE(&AAFRMF)
 
/* Delete any existing copies of work files. */
                DLTF       FILE(QTEMP/&OLDFILE)
                MONMSG     MSGID(CPF2105)
                DLTF       FILE(QTEMP/&NEWFILE)
                MONMSG     MSGID(CPF2105)
 
/* Copy template file to QTEMP twice - once for old and once for new. */
                CPYF       FROMFILE(&AAUPPF) TOFILE(QTEMP/&OLDFILE) +
                             CRTFILE(*YES)
                CPYF       FROMFILE(&AAUPPF) TOFILE(QTEMP/&NEWFILE) +
                             CRTFILE(*YES)
 
/* Copy data from old and new libraries to the versions in QTEMP. */
                CPYF       FROMFILE(&OLDLIB/&AABONF) +
                             TOFILE(QTEMP/&OLDFILE) MBROPT(*REPLACE) +
                             FMTOPT(*MAP *DROP)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)
                CPYF       FROMFILE(&NEWLIB/&AABONF) +
                             TOFILE(QTEMP/&NEWFILE) MBROPT(*REPLACE) +
                             FMTOPT(*MAP *DROP)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)
 
                GOTO       CMDLBL(ENDPGM)
 
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
 /* Recursive error */
             IF         COND(&IN01) THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                             MSGDTA('Recursive error in pgm UPC0892') +
                             MSGTYPE(*ESCAPE)
             ENDDO
             CHGVAR     VAR(&IN01) VALUE('1')
 
ABNOR2:
/* Abnormal termination */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('UPC0892 +
                          ended abnormally - Action File data not +
                          found.') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
