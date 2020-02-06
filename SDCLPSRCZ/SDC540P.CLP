/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Audit Print File Override')                     */
/********************************************************************/
/*                                                                  */
/*                Midas STANDING DATA MODULE                    */
/*                                                                  */
/*       SDC540P - AUDIT PRINT FILE OVERRIDE                        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. LN0220                  DATE  25MAY90       */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                             */
/*       LN0220 OVERRIDE OF PRINT FILE SHOULD BE FROM 'AU' NOT 'P$' */
/*                                                                  */
/********************************************************************/
/**/
             PGM        PARM(&PRM01 &PRM02 &PRM03 &PRM04 &PRM05 +
                          &PRM06 &PRM07 &PRM08 &PRM09)
/**/
             DCL           VAR(&PRM01) TYPE(*CHAR) LEN(10)
             DCL           VAR(&PRM02) TYPE(*CHAR) LEN(1)
             DCL           VAR(&PRM03) TYPE(*DEC) LEN(5 0)
             DCL           VAR(&PRM04) TYPE(*DEC) LEN(5 0)
             DCL           VAR(&PRM05) TYPE(*DEC) LEN(5 0)
             DCL           VAR(&PRM06) TYPE(*DEC) LEN(5 0)
             DCL           VAR(&PRM07) TYPE(*DEC) LEN(5 0)
             DCL           VAR(&PRM08) TYPE(*CHAR) LEN(53)
             DCL           VAR(&PRM09) TYPE(*CHAR) LEN(53)
             DCL           VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* OVERRIDE THE DEFAULTED AUDIT PRINTFILE TO THE CALLING PROGRAMS */
/* SPECIFIC PRINTFILE .                                           */
/**/
/************OVRPRTF    FILE(SD0540P$) TOFILE(&PRM01)                   LN0220*/
             OVRPRTF    FILE(SD0540AU) TOFILE(&PRM01)                 /*LN0220*/
/**/
             CALL      PGM(SD0540P) PARM(&RTNCDE &PRM01 &PRM02 &PRM03 +
                          &PRM04 &PRM05 &PRM06 &PRM07 &PRM08 &PRM09)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
