/*********************************************************************/
/****STD    CLP                                                      */                   /*UPG404*/
/*STD    CLPBASE                                                     */                   /*UPG404*/
/*EXI *  TEXT('Midas IBLC 2002 Futures&Options Module Extraction')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0645 - IBLC 2002 Futures&Options Module Extraction       */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      UPG404             Date 17Mar05              */
/*                      202483             Date 04Feb02              */
/*                      IL0023             Date 20Dec01              */
/*                      IL0009             Date 05Dec01              */
/*                      ULX043             Date 29Sep01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       UPG404 - Change creation parameter to CLPBASE               */
/*       202483 - OPERATIONS REPORTED TWICE.                         */
/*       IL0023 - ULX043 - continue IL0009                           */
/*       IL0009 - ULX043 - Review Initial margin process Completely  */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CSEQ &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)               /*IL0009*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2) VALUE(1)
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)
             DCL        VAR(&CSEQ) TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCLF       FILE(MARKTD)                                  /*IL0009*/
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Retrieve ILSTAT data area to check if module is selected.  ***/
/***  Pos  1 : COB Run Flag.  ***/
/***  Pos 18 : Futures&Options Mod. is installed and IBLC Component must run.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT (1 256)) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
             IF         COND((%SST(&ILSTAT 18 1)) *EQ 'Y') THEN(DO)
 
/***  Reset external switches.  ***/
 
             CHGJOB     SWS(XXXXXX00)
 
/***  Send message to program message queue.  ***/
 
             SNDPGMMSG  MSG('ILC0645 - IBLC 2002 - Futures & Options +
                          Module Extraction ') TOMSGQ(MRUNQ MOPERQ)
 
/***  Retrieve master library  ***/
 
             RTVDTAARA  DTAARA(SDSTAT (06 02)) RTNVAR(&ID)
             CHGVAR     VAR(&DMLIB) VALUE(&ID *CAT 'DMLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&ID *CAT 'DPLIB')           /*IL0009*/
 
/***  Save the account keys : Every Day.  ***/
 
/****        IF         COND(&CSEQ *EQ 1) THEN(DO) +                    IL0009*/
/****                                                                   IL0009*/
/****        CPYF       FROMFILE(FOKEYD) TOFILE(&DMLIB/FOKEYD1X) +      IL0009*/
/****                     FROMMBR(*ALL) TOMBR(*FROMMBR) +               IL0009*/
/****                     MBROPT(*REPLACE) CRTFILE(*YES)                IL0009*/
/****        MONMSG     MSGID(CPF0000)                                  IL0009*/
/****        CPYF       FROMFILE(FOKEYDXL) TOFILE(&DMLIB/FOKEYDXL1X) +  IL0009*/
/****                     FROMMBR(*ALL) TOMBR(*FROMMBR) +               IL0009*/
/****                     MBROPT(*ADD) CRTFILE(*YES)                    IL0009*/
/****        MONMSG     MSGID(CPF0000)                                  IL0009*/
/****                                                                   IL0009*/
/****        ENDDO                                                      IL0009*/
/****                                                                   IL0009*/
/****        ELSE       CMD(DO)                                         IL0009*/
/****                                                                   IL0009*/
/**** Clear FOKEYDXL members.                                           IL0009*/
/****                                                                   IL0009*/
/****        CLRPFM     FILE(FOKEYDXL) MBR(OTC)                         IL0009*/
/****                                                                   IL0009*/
/****        RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)                    IL0009*/
/****                                                                   IL0009*/
/***ROUND:   IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT + IL0009*/
/****                     61)) THEN(GOTO CMDLBL(ENDROUND))              IL0009*/
/****        CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))              IL0009*/
/****                                                                   IL0009*/
/****        CLRPFM     FILE(FOKEYDXL) MBR(&MKT)                        IL0009*/
/****        MONMSG     MSGID(CPF3141)                                  IL0009*/
/****                                                                   IL0009*/
/****        CHGVAR     VAR(&A) VALUE(&A + 2)                           IL0009*/
/****        GOTO       CMDLBL(ROUND)                                   IL0009*/
/****                                                                   IL0009*/
/****ENDROUND:    CPYF       FROMFILE(FOKEYD) TOFILE(&DMLIB/FOKEYD2X) + IL0009*/
/****                     FROMMBR(*ALL) TOMBR(*FROMMBR) +               IL0009*/
/****                     MBROPT(*ADD) CRTFILE(*YES)                    IL0009*/
/****                                                                   IL0009*/
/****        MONMSG     MSGID(CPF0000)                                  IL0009*/
/****                                                                   IL0009*/
/****        ENDDO                                                      IL0009*/
                                                                      /*IL0009*/
/***  Save the account keys : Every Day.  ***/                        /*IL0009*/
/***  Sequence 1: FOKEYD after Close out.   ***/                      /*IL0009*/
/***  Sequence 2: FOKEYDXL contains Initial Margin.  ***/             /*IL0009*/
                                                                      /*IL0009*/
             IF         COND(&CSEQ *EQ 1) THEN(DO)                    /*IL0009*/
                                                                      /*IL0009*/
/*****Remove*existing*FOKEYD1X*MEMBERS*and*Take*a*copy*of*FOKEYD******  IL0009*/
/***  Remove existing FOKEYD1XL MEMBERS and Take a copy of FOKEYD       IL0023*/
                                                                      /*IL0009*/
/************RMVM*******FILE(&DPLIB/FOKEYDX1X)*MBR(*ALL)***********     IL0009*/
             RMVM       FILE(&DPLIB/FOKEYDX1XL) MBR(*ALL)             /*IL0023*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
/************CPYF*******FROMFILE(FOKEYD)*TOFILE(&DPLIB/FOKEYD1X)*+*   +
 *************************FROMMBR(*ALL)*TOMBR(*FROMMBR)*+**********   +
 *************************MBROPT(*REPLACE)*CRTFILE(*YES)***********     IL0009*/
             CPYF       FROMFILE(FOKEYD) TOFILE(&DPLIB/FOKEYD1XL) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*IL0023*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
                                                                      /*IL0009*/
/***  Remove existing FOKEYDXL1X MEMBERS and Take a copy of FOKEYDXL    IL0009*/
                                                                      /*IL0009*/
             RMVM       FILE(&DPLIB/FOKEYDXL1X) MBR(*ALL)             /*IL0009*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
/**********  CPYF       FROMFILE(FOKEYDXL) TOFILE(&DPLIB/FOKEYDXL1X) +                    /*CER001*/
             CPYF       FROMFILE(FFAKX1PD) TOFILE(&DPLIB/FOKEYDXL1X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*ADD) CRTFILE(*YES)                  /*IL0009*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
                                                                      /*IL0009*/
             ENDDO                                                    /*IL0009*/
                                                                      /*IL0009*/
             IF         COND(&CSEQ *EQ 2) THEN(DO)                    /*IL0009*/
                                                                      /*IL0009*/
/*****Remove*existing*FOKEYD2X*MEMBERS*and*Take*a*copy*of*FOKEYD***     IL0009*/
/***  Remove existing FOKEYD2XL MEMBERS and Take a copy of FOKEYD       IL0023*/
                                                                      /*IL0009*/
/************RMVM*******FILE(&DPLIB/FOKEYD2X)*MBR(*ALL)************      L0009*/
             RMVM       FILE(&DPLIB/FOKEYD2XL) MBR(*ALL)              /*IL0023*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
/************CPYF*******FROMFILE(FOKEYD)*TOFILE(&DPLIB/FOKEYD2X)*+*   +
 *************************FROMMBR(*ALL)*TOMBR(*FROMMBR)*+**********   +
 *************************MBROPT(*REPLACE)*CRTFILE(*YES)***********     IL0009*/
             CPYF       FROMFILE(FOKEYD) TOFILE(&DPLIB/FOKEYD2XL) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*IL0023*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
                                                                      /*IL0009*/
/***  Remove existing FOKEYDXL2X MEMBERS and Take a copy of FOKEYDXL    IL0009*/
                                                                      /*IL0009*/
             RMVM       FILE(&DPLIB/FOKEYDXL2X) MBR(*ALL)             /*IL0009*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
/**********  CPYF       FROMFILE(FOKEYDXL) TOFILE(&DPLIB/FOKEYDXL2X) +                    /*CER001*/
             CPYF       FROMFILE(FFAKX1PD) TOFILE(&DPLIB/FOKEYDXL2X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*ADD) CRTFILE(*YES)                  /*IL0009*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
                                                                      /*IL0009*/
             ENDDO                                                    /*IL0009*/
                                                                      /*IL0009*/
/***  Save the account keys : in ANDW1 condition 03.   ***/           /*IL0009*/
/***  Sequence 3: FOKEYD After AWND1 Phase.   ***  /                  /*IL0009*/
                                                                      /*IL0009*/
             IF         COND(&CSEQ *EQ 3) THEN(DO)                    /*IL0009*/
                                                                      /*IL0009*/
/*****Remove*existing*FOKEYD3X*MEMBERS*and*Take*a*copy*of*FOKEYD***     IL0009*/
/***  Remove existing FOKEYD3XL MEMBERS and Take a copy of FOKEYD       IL0023*/
                                                                      /*IL0009*/
/************RMVM*******FILE(&DPLIB/FOKEYD3X)*MBR(*ALL)************     IL0009*/
             RMVM       FILE(&DPLIB/FOKEYD3XL) MBR(*ALL)              /*IL0023*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
/************CPYF*******FROMFILE(FOKEYD)*TOFILE(&DPLIB/FOKEYD3X)*+*   +
 *************************FROMMBR(*ALL)*TOMBR(*FROMMBR)*+**********   +
 *************************MBROPT(*REPLACE)*CRTFILE(*YES)***********     IL0009*/
             CPYF       FROMFILE(FOKEYD) TOFILE(&DPLIB/FOKEYD3XL) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*IL0023*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
                                                                      /*IL0009*/
/***  Remove existing FOKEYDXL3X MEMBERS and Take a copy of FOKEYDXL    IL0009*/
                                                                      /*IL0009*/
             RMVM       FILE(&DMLIB/FOKEYDXL3X) MBR(*ALL)             /*IL0009*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
/**********  CPYF       FROMFILE(FOKEYDXL) TOFILE(&DMLIB/FOKEYDXL3X) +                    /*CER001*/
             CPYF       FROMFILE(FFAKX1PD) TOFILE(&DMLIB/FOKEYDXL3X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*ADD) CRTFILE(*YES)                  /*IL0009*/
             MONMSG     MSGID(CPF0000)                                /*IL0009*/
                                                                      /*IL0009*/
             ENDDO                                                    /*IL0009*/
                                                                      /*IL0009*/
/***  When ANDW1, CLRPFM all Market Members.  ***/                    /*IL0009*/
/***  (before call of extraction program.  ***/                       /*IL0009*/
                                                                      /*IL0009*/
             IF         COND(&CSEQ *EQ 3) THEN(DO)                    /*IL0009*/
/**********  CLRPFM     FILE(FOKEYDXL) MBR(OTC)                       /*IL0023*/          /*CER001*/
             CLRPFM     FILE(FFAKX1PD) MBR(OTC)                                           /*CER001*/
             MONMSG     MSGID(CPF0000)                                /*IL0023*/
LOOP1:       RCVF                                                     /*IL0009*/
             MONMSG     MSGID(CPF0864) /* End of File? */ +
                        EXEC(GOTO CMDLBL(ENDLOOP1))                   /*IL0009*/
                                                                      /*IL0009*/
             IF         COND(&RECI *NE '*') THEN(DO)                  /*IL0009*/
                        CHGVAR     VAR(&MKT) VALUE(&MRKT)             /*IL0009*/
/**********             CLRPFM     FILE(FOKEYDXL) MBR(&MKT)           /*IL0009*/          /*CER001*/
                        CLRPFM     FILE(FFAKX1PD) MBR(&MKT)                               /*CER001*/
                        MONMSG     MSGID(CPF0000)                     /*IL0009*/
                        ENDDO                                         /*IL0009*/
                                                                      /*IL0009*/
/*** Next Market.   ***/                                              /*IL0009*/
                                                                      /*IL0009*/
             GOTO       CMDLBL(LOOP1)                                 /*IL0009*/
ENDLOOP1:                                                             /*IL0009*/
             ENDDO           /* Sequence is 3 */                      /*IL0009*/
 
/***  Clear previous records.  ***/
 
             CPYF       FROMFILE(ILDIWKPD) TOFILE(QTEMP/ILDIWKPD) +
                          MBROPT(*NONE) CRTFILE(*YES)
             OVRDBF     FILE(ILDIWKPD) TOFILE(QTEMP/ILDIWKPD)
 
/***  Cpyf FOKEYD On FOKEYDXL And Omit initial Margin Key (Pos 4 = 'J').   ***/
 
/***         CPYF       FROMFILE(FOKEYD) TOFILE(&DMLIB/FOKEYDXL) +      202483*/
/***                      FROMMBR(OTC) TOMBR(OTC) MBROPT(*ADD) +              */
/***                      CRTFILE(*NO) INCCHAR(*RCD 4 *NE 'J')                */
/**********  CPYF       FROMFILE(FOKEYD) TOFILE(&DMLIB/FOKEYDXL) +                        /*CER001*/
             CPYF       FROMFILE(FOKEYD) TOFILE(&DMLIB/FFAKX1PD) +
                          FROMMBR(OTC) TOMBR(OTC) MBROPT(*REPLACE) +
                          CRTFILE(*NO) INCCHAR(*RCD 4 *NE 'J')        /*202483*/
             MONMSG     MSGID(CPF2817 CPF2869)
 
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)
 
 ROUND1:     IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A +
                          *GT 61)) THEN(GOTO CMDLBL(ENDROUND1)) +
 
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))
/****                                                                   IL0009*/
/****        CPYF       FROMFILE(FOKEYD) TOFILE(&DMLIB/FOKEYDXL) +      IL0009*/
/****                     FROMMBR(&MKT) TOMBR(*FROMMBR) +               IL0009*/
/****                     MBROPT(*ADD) CRTFILE(*NO) INCCHAR(*RCD 4 +    IL0009*/
/****                     *NE 'J')                                      IL0009*/
/****        CPYF       FROMFILE(FOKEYD)   TOFILE(&DMLIB/FOKEYDXL) +    202483*/
/****                     FROMMBR(&MKT)    TOMBR(*FROMMBR) +                  */
/****                     MBROPT(*ADD)     CRTFILE(*NO) +                     */
/****                     INCCHAR(*RCD 4 *NE 'J')  +                          */
/****                     FMTOPT(*MAP *DROP)                                  */
/**********  CPYF       FROMFILE(FOKEYD) TOFILE(&DMLIB/FOKEYDXL) +                        /*CER001*/
             CPYF       FROMFILE(FOKEYD) TOFILE(&DMLIB/FFAKX1PD) +
                          FROMMBR(&MKT) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*NO) +
                          INCCHAR(*RCD 4 *NE 'J') FMTOPT(*MAP +
                          *DROP)                                      /*202483*/
             MONMSG     MSGID(CPF2817 CPF2869)
             CHGVAR     VAR(&A) VALUE(&A + 2)
             GOTO       CMDLBL(ROUND1)
 
ENDROUND1:
 
/***  Rebuild LF with PF Members  ***/
 
             RMVM       FILE(ILFOKEY) MBR(*ALL)
             MONMSG     MSGID(CPF7310)
 
             ADDLFM     FILE(ILFOKEY) MBR(ILFOKEY) DTAMBRS(*ALL)
 
/***  Call Extraction Program.  ***/
 
             CALL       PGM(IL0645)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  If the 00003 SEQ and end of month, add IBLC items  ***/
/***  in the file ILDINWPD (it will use in the next C.O.B) ***/
/***  ILSTAT Pos 8 : EOM flag.  ***/
 
             IF         COND((&CSEQ *EQ 3) +
                             *AND (%SST(&ILSTAT 8 1) *EQ 'Y')) THEN(DO)
 
/*** Save Extracted details in New Working day intermediary file.  ***/
 
                        CPYF       FROMFILE(ILDIWKPD) TOFILE(ILDINWPD) +
                                   FROMMBR(*ALL) MBROPT(*ADD)
                        MONMSG     MSGID(CPF2817)
             ENDDO
             ELSE       CMD(DO)
 
/*** Save Extracted details in Today IBLC 2002 items file.  ***/
 
                        CPYF       FROMFILE(ILDIWKPD) TOFILE(ILITEMPD) +
                                   MBROPT(*ADD)
                        MONMSG     MSGID(CPF2817)
             ENDDO
 
             ENDDO   /*** ILSTAT pos 18 is 'Y'.  ***/
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Program ended abnormally.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0645 - IBLC 2002 -  Futures & +
                          Options Extraction Program Ended +
                          Abnormally - See JOBLOG for details.') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
 
/************CPYF*******FROMFILE(FOKEYDXL1X)*TOFILE(&DMLIB/FOKEYDXL) +
 *************************FROMMBR(*ALL)*TOMBR(*FROMMBR)*+*********** +
 *************************MBROPT(*REPLACE)*CRTFILE(*NO)*************    IL0023*/
/************MONMSG*****MSGID(CPF2817*CPF2869)**********************  /*IL0023*/
                                                                      /*IL0023*/
/***  Recreate FOKEYD and FOKEYDXL based on saved details (CSEQ)        IL0023*/
                                                                      /*IL0023*/
             IF         COND(&CSEQ *EQ 1) THEN(DO)                    /*IL0023*/
/**********      RMVM       FILE(&DPLIB/FOKEYDXL) MBR(*ALL)           /*IL0023*/          /*CER001*/
                 RMVM       FILE(&DPLIB/FFAKX1PD) MBR(*ALL)                               /*CER001*/
                 MONMSG     MSGID(CPF0000)                            /*IL0023*/
/**********      CPYF       FROMFILE(FOKEYDXL1X) TOFILE(&DPLIB/FOKEYDXL) +                /*CER001*/
                 CPYF       FROMFILE(FOKEYDXL1X) TOFILE(&DPLIB/FFAKX1PD) +
                            FROMMBR(*ALL) TOMBR(*FROMMBR) +
                            MBROPT(*REPLACE) CRTFILE(*YES)            /*IL0023*/
                 MONMSG     MSGID(CPF0000)                            /*IL0023*/
                                                                      /*IL0023*/
             ENDDO                                                    /*IL0023*/
 
             IF         COND(&CSEQ *EQ 2) THEN(DO)                    /*IL0023*/
/**********      RMVM       FILE(&DPLIB/FOKEYDXL) MBR(*ALL)           /*IL0023*/          /*CER001*/
                 RMVM       FILE(&DPLIB/FFAKX1PD) MBR(*ALL)                               /*CER001*/
                 MONMSG     MSGID(CPF0000)                            /*IL0023*/
/**********      CPYF       FROMFILE(FOKEYDXL2X) TOFILE(&DPLIB/FOKEYDXL) +                /*CER001*/
                 CPYF       FROMFILE(FOKEYDXL2X) TOFILE(&DPLIB/FFAKX1PD) +
                            FROMMBR(*ALL) TOMBR(*FROMMBR) +
                            MBROPT(*REPLACE) CRTFILE(*YES)            /*IL0023*/
                 MONMSG     MSGID(CPF0000)                            /*IL0023*/
                                                                      /*IL0023*/
             ENDDO                                                    /*IL0023*/
 
             IF         COND(&CSEQ *EQ 3) THEN(DO)                    /*IL0023*/
/**********      RMVM       FILE(&DPLIB/FOKEYDXL) MBR(*ALL)           /*IL0023*/          /*CER001*/
                 RMVM       FILE(&DPLIB/FFAKX1PD) MBR(*ALL)                               /*CER001*/
                 MONMSG     MSGID(CPF0000)                            /*IL0023*/
/**********      CPYF       FROMFILE(FOKEYDXL3X) TOFILE(&DPLIB/FOKEYDXL) +                /*CER001*/
                 CPYF       FROMFILE(FOKEYDXL3X) TOFILE(&DPLIB/FFAKX1PD) +
                            FROMMBR(*ALL) TOMBR(*FROMMBR) +
                            MBROPT(*REPLACE) CRTFILE(*YES)            /*IL0023*/
                 MONMSG     MSGID(CPF0000)                            /*IL0023*/
                                                                      /*IL0023*/
             ENDDO                                                    /*IL0023*/
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             DMPCLPGM
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(ILDIWKPD)
             MONMSG     MSGID(CPF0000)
             ENDPGM
