/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Retail Account Extract')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas      Retail  Module                                   */
/*                                                                   */
/*       GLC3570 -  ACCOUNTS BALANCES EXTRACT                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CGL127AA           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01413 *CREATE     Date 13Apr93              */
/*                      xnnnnn             DATE nnxxxnn              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL127AA - COB Restructure - GL COB Optimisation Phase 1    */
/*       S01413 - Retail 3 incorporation                             */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FRF) TYPE(*CHAR) LEN(7) VALUE(SDBANK)
             DCL        VAR(&TOF) TYPE(*CHAR) LEN(7)
/**/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RUNDX) TYPE(*CHAR) LEN(5)
             DCLF       FILE(SDBANKPD)
             RCVF
             MONMSG     MSGID(CPF4101) EXEC(GOTO CMDLBL(EXIT1))
/**/
             CHGVAR     VAR(&RUNDX) VALUE(&BJRDNB)
/**/
             SNDPGMMSG  MSG('GLC3570 - RETAIL II ACCOUNTS BALANCES EXTRACT') +
                          TOMSGQ(MRUNQ)
/**/
             CHGVAR     VAR(&TOF) VALUE('RABEXOR')
             CLRPFM     FILE(RABEXOR)
             MONMSG     MSGID(CPF3133 CPF3141) EXEC(GOTO CMDLBL(EXIT2))
             MONMSG     MSGID(CPF3142) EXEC(GOTO CMDLBL(EXIT3))
/*           CHGVAR     VAR(&TOF) VALUE('ACDETAB')   +
             CLRPFM     FILE(ACDETAB)                +
           MONMSG     MSGID(CPF3133 CPF3141) EXEC(GOTO CMDLBL(EXIT2)) +
             MONMSG     MSGID(CPF3142) EXEC(GOTO CMDLBL(EXIT3))  +
/**/
             CHGVAR     VAR(&FRF) VALUE('ACCNTAB')
/*/COPY WNCPYSRC,GLC3570003                                          */
/**********  CPYF       FROMFILE(ACCNTAB) TOFILE(RABEXOR) +          */
/**********             MBROPT(*ADD) INCREL((*IF RECI *EQ D) (*AND + */
/**********             ATYP *EQ R)) FMTOPT(*MAP *DROP)              */                 /*CGL127AA*/
/*/COPY WNCPYSRC,GLC3570002                                          */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                        CMDLBL(EXIT1))
/*/COPY WNCPYSRC,GLC3570001                                          */
/**/
             CALL       PGM(GL3570)
/**/
             GOTO       CMDLBL(ENDCL)
/**/
EXIT1:
/**/
             CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&MEM) VALUE('File ' *CAT &FRF *TCAT ' not +
                        found - GLC3570')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ENDCL)
EXIT2:
             CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&MEM) VALUE('Member of file ' *CAT &TOF +
                        *TCAT ' not found - GLC3570')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ENDCL)
/**/
EXIT3:
/**/
             CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&MEM) VALUE('File ' *CAT &TOF *TCAT ' not +
                        found - GLC3570')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
/**/
ENDCL:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
