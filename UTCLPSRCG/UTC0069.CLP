/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Embed blanks as characters into field')      */
/*********************************************************************/
/*                                                                   */
/*       Midas    - Utilities module                                 */
/*                                                                   */
/*       UTC0069   - Check whether or not an object exists           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 20May04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CUP003  *CREATE    Date 23Jul99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global.             */
/*       CUP003 - Introduction of utility                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FIELD &FLDLEN)
 
             DCL        VAR(&FIELD) TYPE(*CHAR) LEN(9999)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(4 0)
 
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Initialise fields */
             CHGVAR     VAR(&COUNT) VALUE(1)
 
LOOP:
             IF         COND(&COUNT *GT &FLDLEN) THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
             IF         COND(%SST(&FIELD &COUNT 1) *EQ ' ') THEN(DO)
                CHGVAR     VAR(%SST(&FIELD &COUNT 1)) VALUE(X'41')
             ENDDO
 
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
 
             GOTO       CMDLBL(LOOP)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
