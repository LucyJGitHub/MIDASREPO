/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Check for external file')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     Utilities Module                                  */
/*                                                                   */
/*       UTC0017 - Check for external file                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01516             Date 18Jul94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILE &ERROR)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     CPF0000
 
             CHGVAR     VAR(&ERROR) VALUE(N)
             CHKOBJ     OBJ(&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&ERROR) +
                          VALUE(Y))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
