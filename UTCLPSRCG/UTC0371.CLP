/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Delete empty file left by MOVMBR command')   */
/*XBI    OVRDBF FILE(MOVMBRDLTF) TOFILE(QAFDPHY)                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0371 - Delete empty files left by MOVMBR command         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CUP014 *C *CREATE  Date 12Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK015 - 4.01 packaging.  Only delete empty source files if */
/*                they have been processed.                          */
/*       CUP014 - New utility.                                       */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&FROMLIB)                                                 */ /*CPK015*/
             PGM        PARM(&FROMLIB &SRCFILE)                                           /*CPK015*/
 
             DCL        VAR(&FROMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCFILE) TYPE(*CHAR) LEN(10)                                 /*CPK015*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(MOVMBRDLTF)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create outfile of files (physical files only).                             */
/************DSPFD      FILE(&FROMLIB/*ALL) TYPE(*ATR) +                               */ /*CPK015*/
/************             OUTPUT(*OUTFILE) FILEATR(*PF) +                              */ /*CPK015*/
/************             OUTFILE(QTEMP/MOVMBRDLTF)                                    */ /*CPK015*/
             DSPFD      FILE(&FROMLIB/&SRCFILE) TYPE(*ATR) +
                          OUTPUT(*OUTFILE) FILEATR(*PF) +
                          OUTFILE(QTEMP/MOVMBRDLTF)                                       /*CPK015*/
 
/* Read outfile to check for files with no members.                           */
READNEXT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(&PHNOMB *EQ 0) THEN(DO)
                DLTF       FILE(&FROMLIB/&PHFILE)
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
