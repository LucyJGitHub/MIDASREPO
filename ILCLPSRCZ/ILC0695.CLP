/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 - Routing keys Audit lists')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0607 - IBLC 2002 Routing keys Audit Lists                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. IL0023             Date 20Dec01              */
/*                      ULX043             Date 21Aug01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       IL0023 - ULX043 - Continue IL0009                           */
/*                IL0009 - Review Initial Margin Process             */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
 
/***  Start Program.  ***/
 
 START:      PGM        PARM(&CSEQ &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&EOM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EODT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)                  /*IL0023*/
                                                                      /*IL0023*/
             DCLF       MARKTD                                        /*IL0023*/
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Retrieve ILSTAT data area to check if module is selected.  ***/
/***  Pos  1 : COB Run Flag.  ***/
/***  Pos  8 : EOM flag.   ***/
 
             RTVDTAARA  DTAARA(ILSTAT) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/***  Reset external switches.  ***/
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/***  Send message to program message queue.  ***/
 
             SNDPGMMSG  MSG('ILC0695 - IBLC 2002 - Routing keys +
                          audit lists.') TOMSGQ(MOPERQ MRUNQ)
 
/***  Retrieve System information.  ***/
 
             RTVDTAARA  DTAARA(SDSTAT (06 02)) RTNVAR(&ID)
             CHGVAR     VAR(&DMLIB) VALUE(&ID *CAT 'DMLIB')
 
/***  Retrieve EOD/EOM information.  ***/
/***  ILSTAT Pos 8 : EOM flag.  ***/
/***  SDSTAT Pos 116 : Type of EOD.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT (8 1)) RTNVAR(&EOM)
             RTVDTAARA  DTAARA(SDSTAT (116 1)) RTNVAR(&EODT)
 
/***  Save Audit Fiel depending of Component sequence.  ***/
/***  CSEQ = 1 = end of month and accrual day followed by a non-working day.  ***/
/***  CSEQ = 2 = every day.   ***/
 
             IF         COND(&CSEQ *EQ 1) THEN(DO)
 
/***  save file ILRKAUPD.  ***/
 
             CPYF       FROMFILE(ILRKAUPD) TOFILE(&DMLIB/ILRKAUPD1X) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
 
             IF         COND((&EOM *EQ 'Y') *AND (&EODT *EQ '3')) +
                          THEN(DO)
 
/***  Save in Non working audit file, ONLY when EOM and Type od EOD is 3.  ***/
 
                        CPYF       FROMFILE(ILRKAUPD) TOFILE(ILNWAUPD) +
                                   MBROPT(*REPLACE)
                        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                        CLRPFM     FILE(ILRKAUPD)
                        MONMSG     MSGID(CPF0000)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO                 /*** EOM and EOD type 3.  ***/
             ENDDO                 /*** COB run Condition 14 (CSEQ = 1).  ***/
 
             IF         COND(&CSEQ *EQ 2) THEN(DO)
 
/***  save file ILRKAUPD. Every day.  ***/
 
             CPYF       FROMFILE(ILRKAUPD) TOFILE(&DMLIB/ILRKAUPD2X) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
 
             ENDDO
 
/***  Call program.  ***/
 
             CALL       PGM(IL0695) PARM(&RSEQ &RLEV &RENT)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DEB0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  Clear fiel if no,problem during print.   ***/
 
             CLRPFM     FILE(ILRKAUPD)
             MONMSG     MSGID(CPF0000)
                                                                      /*IL0023*/
/* Ensure FOKEYDXL id Cleared for all Markets */                      /*IL0023*/
                                                                      /*IL0023*/
/**********  CLRPFM     FILE(FOKEYDXL) MBR(OTC)                       /*IL0023*/          /*CER001*/
             CLRPFM     FILE(FFAKX1PD) MBR(OTC)                                           /*CER001*/
             MONMSG     MSGID(CPF2817 CPF3141)                        /*IL0023*/
                                                                      /*IL0023*/
 LOOP:       RCVF                                                     /*IL0023*/
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))      /*IL0023*/
                                                                      /*IL0023*/
             IF         COND(&RECI *NE '*') THEN(DO)                  /*IL0023*/
             CHGVAR     VAR(&MKT) VALUE(&MRKT)                        /*IL0023*/
                                                                      /*IL0023*/
/**********  CLRPFM     FILE(FOKEYDXL) MBR(&MKT)                      /*IL0023*/          /*CER001*/
             CLRPFM     FILE(FFAKX1PD) MBR(&MKT)                                          /*CER001*/
             MONMSG     MSGID(CPF2718 CPF3141)                        /*IL0023*/
                                                                      /*IL0023*/
             ENDDO                                                    /*IL0023*/
             GOTO       CMDLBL(LOOP)                                  /*IL0023*/
                                                                      /*IL0023*/
             GOTO       CMDLBL(ENDPGM)
 
/***  Send Message on error.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0695 - IBLC 2002 - Routing keys +
                          audit list ended abnormally - See joblog +
                          for details.') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
