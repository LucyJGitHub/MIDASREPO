/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas IBLC 2002 Copy reversed DEALS/LOANS')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0620 - IBLC 2002 Copy Reversed Deals/Loans               */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/*                      ULX043             Date 28Jun01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7) VALUE('*FIRST ')
 
/***  Retrieve ILSTAT data area to check if module is selected.  ***/
/***  Pos  1 : COB Run Flag.  ***/
/***  Pos 14 : Dealing Module is installed and IBLC Component must Run.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') +
                        THEN(GOTO CMDLBL(ENDPGM))
 
             IF         COND((%SST(&ILSTAT 14 1)) *EQ 'Y') THEN(DO)
 
/***  Send message to program message queue.  ***/
 
             CHGVAR     VAR(&MSG) VALUE('ILC0620 - IBLC 2002 - +
                          DEALING - Reversed deals copy')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
 
             CLRPFM     FILE(ILDLSDB)
             CLRPFM     FILE(ILDLSDC)
             CLRPFM     FILE(ILDLSDD)
             CLRPFM     FILE(ILDLSDE)
             CLRPFM     FILE(ILDLSDG)
 
             CPYF       FROMFILE(DEALSDB) TOFILE(ILDLSDB) +
                          MBROPT(*REPLACE) INCCHAR(*RCD 1 *EQ 'R') +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2869 CPF2817)
 
             CPYF       FROMFILE(DEALSDC) TOFILE(ILDLSDC) +
                          MBROPT(*REPLACE) INCCHAR(*RCD 1 *EQ 'R') +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2869 CPF2817)
 
             CPYF       FROMFILE(DEALSDD) TOFILE(ILDLSDD) +
                          MBROPT(*REPLACE) INCCHAR(*RCD 1 *EQ 'R') +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2869 CPF2817)
 
             CPYF       FROMFILE(DEALSDE) TOFILE(ILDLSDE) +
                          MBROPT(*REPLACE) INCCHAR(*RCD 1 *EQ 'R') +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2869 CPF2817)
 
             CPYF       FROMFILE(DEALSDG) TOFILE(ILDLSDG) +
                          MBROPT(*REPLACE) INCCHAR(*RCD 1 *EQ 'R') +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2869 CPF2817)
             ENDDO
 
/***  Pos 15 : Lending Module is installed and IBLC Component must Run.  ***/
 
             IF         COND((%SST(&ILSTAT 15 1)) *EQ 'Y') THEN(DO)
 
/***  Send message to program message queue.  ***/
 
             CHGVAR     VAR(&MSG) VALUE('ILC0620 - IBLC 2002 - +
                          LENDING - Reversed Loans copy')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
 
             CLRPFM     FILE(ILCLNCL)
 
             CPYF       FROMFILE(CLOANCL) TOFILE(ILCLNCL) +
                          MBROPT(*REPLACE) INCREL((*IF RECI *EQ +
                          'R')) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
