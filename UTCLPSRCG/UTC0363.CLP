/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Check name for asterisks')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0363 - Check name for asterisks                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUT001  *CREATE    Date 19Oct98              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUT001 - Bring CHGOWNAUT command and associated programs    */
/*                into core midas                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&NAME &AST)
 
/*/COPY WNCPYSRC,UTC0363INT                                          */
 
             DCL        VAR(&AST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NAMEP1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAMEP2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAMEP3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAMEP4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAMEP5) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAMEP6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAMEP7) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAMEP8) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAMEP9) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAMEP10) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
/*/COPY WNCPYSRC,UTC0363MPS                                          */
 
             CHGVAR     VAR(&NAMEP1) VALUE(%SST(&NAME 1 1))
             CHGVAR     VAR(&NAMEP2) VALUE(%SST(&NAME 2 1))
             CHGVAR     VAR(&NAMEP3) VALUE(%SST(&NAME 3 1))
             CHGVAR     VAR(&NAMEP4) VALUE(%SST(&NAME 4 1))
             CHGVAR     VAR(&NAMEP5) VALUE(%SST(&NAME 5 1))
             CHGVAR     VAR(&NAMEP6) VALUE(%SST(&NAME 6 1))
             CHGVAR     VAR(&NAMEP7) VALUE(%SST(&NAME 7 1))
             CHGVAR     VAR(&NAMEP8) VALUE(%SST(&NAME 8 1))
             CHGVAR     VAR(&NAMEP9) VALUE(%SST(&NAME 9 1))
             CHGVAR     VAR(&NAMEP10) VALUE(%SST(&NAME 10 1))
 
 
             IF         COND(&NAMEP1 *EQ '*') THEN(CHGVAR +
                          VAR(&AST) VALUE('Y'))
             IF         COND(&NAMEP2 *EQ '*') THEN(CHGVAR +
                          VAR(&AST) VALUE('Y'))
             IF         COND(&NAMEP3 *EQ '*') THEN(CHGVAR +
                          VAR(&AST) VALUE('Y'))
             IF         COND(&NAMEP4 *EQ '*') THEN(CHGVAR +
                          VAR(&AST) VALUE('Y'))
             IF         COND(&NAMEP5 *EQ '*') THEN(CHGVAR +
                          VAR(&AST) VALUE('Y'))
             IF         COND(&NAMEP6 *EQ '*') THEN(CHGVAR +
                          VAR(&AST) VALUE('Y'))
             IF         COND(&NAMEP7 *EQ '*') THEN(CHGVAR +
                          VAR(&AST) VALUE('Y'))
             IF         COND(&NAMEP8 *EQ '*') THEN(CHGVAR +
                          VAR(&AST) VALUE('Y'))
             IF         COND(&NAMEP9 *EQ '*') THEN(CHGVAR +
                          VAR(&AST) VALUE('Y'))
             IF         COND(&NAMEP10 *EQ '*') THEN(CHGVAR +
                          VAR(&AST) VALUE('Y'))
 
/*/COPY WNCPYSRC,UTC0363MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,UTC0363ERR                                          */
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,UTC0363END                                          */
 
             ENDPGM
