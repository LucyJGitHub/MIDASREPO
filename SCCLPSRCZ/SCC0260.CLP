/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Check Object')                               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control module                       */
/*                                                                   */
/*       SCC0260 -  Check Object                                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CRT003             DATE 23SEP96              */
/*       PREV AMEND NO.                    DATE                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      CRT003 - Cashier Interface.                                  */
/*               Written for field validation in CI ICD.             */
/*                                                                   */
/*********************************************************************/
             PGM    PARM(&OBFN &OBJ  &OBJT &MBR &AUT)                 /*083253*/
 
/*/COPY WNCPYSRC,SCC0260INT                                          */
 
             DCL        VAR(&OBFN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OBJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AUT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC0260MPS                                          */
 
             CHGVAR     VAR(&OBFN) VALUE(N)
             CHKOBJ     OBJ(&OBJ) OBJTYPE(&OBJT) MBR(&MBR) AUT(&AUT)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(ENDPGM))
 
             CHGVAR     VAR(&OBFN) VALUE(Y)
 
/*/COPY WNCPYSRC,SCC0260MPE                                          */
 
 ABNOR:
/*/COPY WNCPYSRC,SCC0260ERR                                          */
 
 ENDPGM:
/*/COPY WNCPYSRC,SCC0260END                                          */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
