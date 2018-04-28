/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Leo Program Location Program')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Standing Data Module                            */
/*                                                                   */
/*       SCC1110 - Midas Leo Program Location Program                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  091885           DATE 19FEB96               */
/*       PREV AMEND NO.  S01473           DATE 23SEP94               */
/*                       S01467           DATE 00XXX00               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       091885 - If library does not exist, treat the same as tho'  */
/*                object not found.                                  */
/*       S01473 - Midas/Leo Integration (Phase 1) - Lending Interface*/
/*                Must be able to find DSPF/CLCD42FM too.            */
/*                And be able to find DSPF/CSTD10FM too.             */
/*                And be able to find DSPF/CSTDHELP too.             */
/*       S01467 - Midas/Leo Integration (Phase 1) - Standing Data    */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGM &LIBL)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&LEOL) TYPE(*CHAR) LEN(275)
             DCL        VAR(&X) TYPE(*DEC) LEN(3)
             DCL        VAR(&Y) TYPE(*DEC) LEN(2)
             DCL        VAR(&TEST) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WRK) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(5)                 /*S01473*/
 
 
/* &X is the start position of the library name in &LEOL  +
/* &Y is the number of repetitions through the code   */
             CHGVAR     VAR(&X) VALUE(1)
             CHGVAR     VAR(&Y) VALUE(1)
 
/* Retrieve the data area containing the Midas library list into a  +
   variable. (Hence &LEOL = Library list) The LEOLIBL variable was  +
   set up in Midas Input Cycle initiation program SCC01.  */
             RTVDTAARA  DTAARA(LEOLIBL *ALL) RTNVAR(&LEOL)
 
/* Decide whether we want to search for programs or files */          /*S01473*/
             IF         COND((&PGM *EQ 'CLCD42FM') *OR (&PGM *EQ +
                          'CSTD10FM') *OR (&PGM *EQ 'CSTDHELP')) +
                          THEN(DO) /*S01473*/
             CHGVAR     VAR(&TYPE) VALUE('*FILE')                     /*S01473*/
             ENDDO                                                    /*S01473*/
             ELSE       CMD(DO)                                       /*S01473*/
             CHGVAR     VAR(&TYPE) VALUE('*PGM')                      /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
/* The maximum number of libraries in the list is 25, hence do this +
   processing until Y is 26 */
LOOP:        IF         COND(&Y *LT 26) THEN(DO)
 
/* Move the next library to be searched into the variable &TEST     +
   (Hence &TEST = library name).   */
             CHGVAR     VAR(&TEST) VALUE(%SUBSTRING(&LEOL &X 10))
 
/* If the library name is blank, we have reached the end of the +
   list.  */
             IF         COND(&TEST *EQ ' ') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 
/* If the library name is not one we would find programs in, +
   ignore it. Remove the two character client prefix to test this */
             CHGVAR     VAR(&WRK) VALUE(%SUBSTRING(&TEST 3 7))
             IF       COND((&WRK *EQ 'DMLIB') *OR (&WRK *EQ 'LDLIB') +
                      *OR (&WRK *EQ 'DTALIB') *OR (&WRK *EQ 'DILIB') +
                      *OR (&WRK *EQ 'XLIB')) THEN(DO)
             GOTO       CMDLBL(NEXT)
             ENDDO
 
/* Check if the object is in the library */
/************CHKOBJ     OBJ(&TEST/&PGM) OBJTYPE(*PGM)***************/ /*S01473*/
             CHKOBJ     OBJ(&TEST/&PGM) OBJTYPE(&TYPE)
 
/* Monitor for the message to say the object is not found  */
/************MONMSG     MSGID(CPF9801) EXEC(DO)****/                  /*091885*/
             MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)               /*091885*/
 
/* Set up the variables for the next read, return to the top of +
   the loop */
NEXT:        CHGVAR     VAR(&Y) VALUE(&Y + 1)
             CHGVAR     VAR(&X) VALUE(&X + 11)
             GOTO       CMDLBL(LOOP)
 
             ENDDO
 
/* The library has been found, place this name in the &LIBL +
   Parameter, and end the program */
END:         CHGVAR     VAR(&LIBL) VALUE(&TEST)
 
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
