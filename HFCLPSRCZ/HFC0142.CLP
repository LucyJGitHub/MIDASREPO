/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Rpt Grp maint.crt HFRGRPP/JRNPBAT')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0142  - REPORTING GROUPS MAINTENANCE                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 04MAY95              */
/*       PREV AMEND NO. S01379             DATE 15SEP92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01408 - Addition of hook HFC0142MP1                        */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&POBJ &POK)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&POBJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
 
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&DMLIB) VALUE(&LID *CAT 'DMLIB')
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,HFC0142MP1                                          */
                                                                      /*S01408*/
 
/* */
/* Copy the HAF master file to the HAF file library */
/* */
             CPYF       FROMFILE(HFRGRPPD) TOFILE(&HFLIB/&POBJ) +
                          MBROPT(*ADD) CRTFILE(*YES) NBRRCDS(1)
             MONMSG     MSGID(CPF2817)
 
             RMVM       FILE(&POBJ) MBR(HFRGRPPD)
             ADDPFM     FILE(&POBJ) MBR(&POBJ)
 
             GRTOBJAUT  OBJ(&HFLIB/&POBJ) OBJTYPE(*FILE) +
                          USER(*PUBLIC) AUT(*ALL)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGVAR     VAR(&POK) VALUE('N')
             MONMSG     MSGID(CPF0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
