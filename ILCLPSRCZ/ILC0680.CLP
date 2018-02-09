/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Synoptique table conversion')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0680  - IBLC 2002 SYNOPTIQUE TABLE CONVERSION            */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      200733             Date 30Nov01              */
/*                      ULX043             Date 21Aug01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       200733 - ULX043 - ILITEMPDXX not restored when Reopen       */
/*                Put and take copy in xxDPLIB instead (WORKING FILE)*/
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&CNAME &CSEQ &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)               /*200733*/
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
 
 
/***  Monitor for Error Messages from System.  ***/
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Retrieve ILSTAT data area to check if IBLC 2002 should run ***/
/***  Pos  1 : COB Run Flag.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/***  Reset Error values - switches and LDA.  ***/
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             SNDPGMMSG  MSG('ILC0680 - IBLC 2002 Synoptique    +
                         conversion.') TOMSGQ(MOPERQ MRUNQ)
 
/***  Retrieve master library  ***/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&ID)
             CHGVAR     VAR(&DMLIB) VALUE(&ID *CAT 'DMLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&ID *CAT 'DPLIB')           /*200733*/
 
 
/***  Check if last try is completed.  ***/
 
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&CNAME &CSEQ &STATUS)
 
             IF         COND(&STATUS *NE 'Y') THEN(DO)  /** not a restart **/
 
/***  Save files before working with in case of restart  ***/
 
/*****    CPYF  FROMFILE(&DMLIB/ILITEMPD) TOFILE(&DMLIB/ILITEMPDXX) +   200733*/
/*****                    MBROPT(*REPLACE) CRTFILE(*YES)              /*200733*/
             CPYF       FROMFILE(&DMLIB/ILITEMPD) TOFILE(&DPLIB/ILITEMPDXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*200733*/
                        MONMSG MSGID(CPF2817) EXEC(CLRPFM FILE(ILITEMPDXX))
                        ENDDO
 
             ELSE       CMD(DO)
 
/***  Restore files with starting value because previous try missed.  ***/
 
/****    CPYF   FROMFILE(&DMLIB/ILITEMPDXX) TOFILE(&DMLIB/ILITEMPD) +   200733*/
/****                   MBROPT(*REPLACE)                              /*200733*/
             CPYF       FROMFILE(&DPLIB/ILITEMPDXX) TOFILE(&DMLIB/ILITEMPD) +
                        MBROPT(*REPLACE)                              /*200733*/
                        MONMSG MSGID(CPF2817)
 
             ENDDO
 
/***  Set Component flag as started. ***/
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STATUS)
 
 
             CALL       PGM(IL0680) PARM(&RSEQ &RLEV &RENT)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('ILC0680 - IBLC 2002 - IL0680 : Program +
                          is abnormally terminated - see joblog') +
                          TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  Set Component flag as terminated.  ***/
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STATUS)
 
             RGZPFM     FILE(ILITEMPD)
             MONMSG     MSGID(CPF0000)
     /***    DLTF       FILE(ILITEMPDXX)  ***/
     /***    MONMSG     MSGID(CPF0000)    ***/
 
             GOTO       CMDLBL(ENDPGM)
 
 
/***  Program ended abnormally.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0680 - IBLC 2002 Synoptique Conversion +
                          endded abnormally') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             DMPCLPGM
 
/***  End program ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
