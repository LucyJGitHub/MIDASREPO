/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 FF Initial margin processing')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0630 - IBLC 2002 Initial Margin FF Module extraction     */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 230177             Date 22Nov04              */
/*                      219626             Date 06Feb02              */
/*                      CER001             Date 25Apr05              */
/*                      202483             Date 06Feb02              */
/*                      IL0009             Date 05Dec01              */
/*                      ULX043             Date 29Sep01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       230177 - Skip processing of IL0630 if member is missing from*/
/*                TRANS or TRSET. This means that the market is      */
/*                newly inserted.                                    */
/*       219626 - Member missing if new market                       */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       202483 - OPERATIONS REPORTED TWICE.                         */
/*       IL0009 - ULX043 - Review Initial margin process             */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAME &CSEQ)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
/****        DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)            IL0009*/
/****        DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)                 IL0009*/
/****        DCL        VAR(&OLDNEW) TYPE(*CHAR) LEN(3)                 IL0009*/
             DCL        VAR(&ID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCLF       FILE(*LIBL/MARKTD)                            /*IL0009*/
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Retrieve ILSTAT data area to check if module is selected.  ***/
/***  Pos 1  : IBLC COB Componenet must run.  ***/
/***  Pos 18 : Futures&Options Mod. is installed and IBLC Component must run.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT (1 256)) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(END))
             IF         COND((%SST(&ILSTAT 18 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(END))
 
             CHGJOB     SWS(XXXXXX00)
 
/***  Send message to program message queue.  ***/
 
             SNDPGMMSG  MSG('ILC0630  - IBLC 2002 - Initial Margin +
                          processing for Futures & Options +
                          started.') TOMSGQ(MRUNQ)
 
/***  Retrieve master library  ***/
 
             RTVDTAARA  DTAARA(SDSTAT (06 02)) RTNVAR(&ID)
             CHGVAR     VAR(&DMLIB) VALUE(&ID *CAT 'DMLIB')
 
/***  Save file to allow processing in I/C  ***/
 
             CPYF       FROMFILE(ILCOLTPD) TOFILE(&DMLIB/ILCOLTPD1X) +
                          FROMMBR(*FIRST) TOMBR(*FIRST) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/***  Check if last try is completed.  ***/
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&CNAME &CSEQ &STATUS)
 
/*****in every call, Clear FOKEYDXL all members.  ***                   IL0009*/
/*****                                                                  IL0009*/
/*****       CLRPFM     FILE(FOKEYDXL) MBR(OTC)                         IL0009*/
/*****                                                                  IL0009*/
/*****Retrieve Member based on Markets defined in data area FFEOC.  *** IL0009*/
/*****                                                                  IL0009*/
/*****       RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)                    IL0009*/
/***ROUND:   IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT + IL0009*/
/*****                    61)) THEN(GOTO CMDLBL(ENDROUND))              IL0009*/
/*****       CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))              IL0009*/
/*****                                                                  IL0009*/
/*****       CLRPFM     FILE(FOKEYDXL) MBR(&MKT)                        IL0009*/
/*****       MONMSG     MSGID(CPF3141)                                  IL0009*/
/*****                                                                  IL0009*/
/*****next market center.  ***                                          IL0009*/
/*****                                                                  IL0009*/
/*****       CHGVAR     VAR(&A) VALUE(&A + 2)                           IL0009*/
/*****       GOTO       CMDLBL(ROUND)                                   IL0009*/
/***** in every Call, Remove and create members using MARKTD content    IL0009*/
                                                                      /*IL0009*/
/*           RMVM       FILE(FOKEYDXL) MBR(*ALL)            IL0009      202483*/
/*           MONMSG     MSGID(CPF0000)                      IL0009      202483*/
 
/**********  CLRPFM     FILE(FOKEYDXL) MBR(OTC)                       /*202483*/          /*CER001*/
             CLRPFM     FILE(FFAKX1PD) MBR(OTC)                                           /*CER001*/
 
/***  Save or retrieve the files  ***/
 
 ENDROUND:
             IF         COND(&STATUS *EQ 'Y') THEN(DO)     /* Restart */
 
/***  Retrieve image before previous run.  ***/
 
                          CPYF       FROMFILE(&DMLIB/ILCOLTPDXX) TOFILE(ILCOLTPD) +
                                     MBROPT(*REPLACE)
                          MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC( +
                                     CLRPFM FILE(ILCOLTPD))
 
/***  Clear transaction extended details and copy previous content.  ***/
 
/**********               RMVM       FILE(TRANSDXL) MBR(*ALL)                             /*CER001*/
                          RMVM       FILE(FFTRX1PD) MBR(*ALL)                             /*CER001*/
/**********               CPYF       FROMFILE(&DMLIB/TRANSDXLXX) TOFILE(TRANSDXL) +       /*CER001*/
                          CPYF       FROMFILE(&DMLIB/TRANSDXLXX) TOFILE(FFTRX1PD) +
                                     FROMMBR(*ALL) TOMBR(*FROMMBR) +
                                     MBROPT(*REPLACE) CRTFILE(*YES)
                          MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                          MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)
             ENDDO
             ELSE       CMD(DO)  /*** not a restar.  ***/
 
/***  save working files to recover situation in case of Error.  ***/
 
                        CPYF       FROMFILE(ILCOLTPD) TOFILE(&DMLIB/ILCOLTPDXX) +
                                   MBROPT(*REPLACE) CRTFILE(*YES)
                        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/**********             CPYF       FROMFILE(TRANSDXL) TOFILE(&DMLIB/TRANSDXLXX) +         /*CER001*/
                        CPYF       FROMFILE(FFTRX1PD) TOFILE(&DMLIB/TRANSDXLXX) +
                                   FROMMBR(*ALL) TOMBR(*FROMMBR) +
                                   MBROPT(*REPLACE) CRTFILE(*YES)
                        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                        MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)
             ENDDO
 
/***  Set Component flag as started. ***/
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STATUS)
 
/*** Create Members in FOKEYDXL to received Initial Margins details OTC.  ***/
 
             DLTOVR     FILE(*ALL)
/*           ADDPFM     FILE(FOKEYDXL) MBR(OTC)                           202483*/
/*           MONMSG     MSGID(CPF7306 CPF5812)                            202483*/
 
/**********  ADDPFM     FILE(TRANSDXL) MBR(OTC)                                           /*CER001*/
             ADDPFM     FILE(FFTRX1PD) MBR(OTC)                                           /*CER001*/
             MONMSG     MSGID(CPF7306 CPF5812)
 
/***  Override files, Initial Margins for OTC Contracts.  ***/
 
/**********  OVRDBF     FILE(FOKEYDXL) MBR(OTC) SEQONLY(*YES 100)                         /*CER001*/
             OVRDBF     FILE(FFAKX1PD) MBR(OTC) SEQONLY(*YES 100)                         /*CER001*/
/**********  OVRDBF     FILE(TRANSDXL) MBR(OTC)                                           /*CER001*/
             OVRDBF     FILE(FFTRX1PD) MBR(OTC)                                           /*CER001*/
             OVRDBF     FILE(TRANS)  MBR(OTC)
             OVRDBF     FILE(TRSET)  MBR(OTC)
 
             CALL       PGM(IL0630 ) PARM('  ')     /*** OTC ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOMSGQ(MOPERQ MRUNQ)
                 SNDPGMMSG  MSG('ILC0630 - IBLC 2002 - IL0630  : Program +
                            is abnormally terminated with OTC as +
                            Market') TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
 
 
/***  Create Members in FOKEYDXL to received Initial Margins details &MKT.  ***/
/*****Loop usung MArkets defined in data are FFEOC.  ***                IL0009*/
/***  Loop using Markets defined in MARKTD file.  ***/                /*IL0009*/
/*****                                                                  IL0009*/
/*****       RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)                    IL0009*/
/*****       CHGVAR     VAR(&A) VALUE(1)                                IL0009*/
/*****LOOP:  IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT + IL0009*/
/*****                    61)) THEN(GOTO CMDLBL(ENDPGM))                IL0009*/
/*****       CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))              IL0009*/
 LOOP:       RCVF                                                     /*IL0009*/
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))      /*IL0009*/
                                                                      /*IL0009*/
             IF         COND(&RECI *NE '*') THEN(DO)                  /*IL0009*/
             CHGVAR     VAR(&MKT) VALUE(&MRKT)                        /*IL0009*/
 
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/*           ADDPFM     FILE(FOKEYDXL) MBR(&MKT)                        202483*/
/*           MONMSG     MSGID(CPF7306 CPF5812)                          202483*/
/**********  CLRPFM     FILE(FOKEYDXL) MBR(&MKT)                      /*202483*/          /*CER001*/
             CLRPFM     FILE(FFAKX1PD) MBR(&MKT)                                          /*CER001*/
/**********  MONMSG     MSGID(CPF3141)                                                    /*202483*/
             MONMSG     MSGID(CPF3141) EXEC(DO)                                           /*219626*/
/**********  ADDPFM     FILE(FOKEYDXL) MBR(&MKT)                               /*219626*/ /*CER001*/
             ADDPFM     FILE(FFAKX1PD) MBR(&MKT)                                          /*CER001*/
             ENDDO                                                                        /*219626*/
 
/**********  ADDPFM     FILE(TRANSDXL) MBR(&MKT)                                          /*CER001*/
             ADDPFM     FILE(FFTRX1PD) MBR(&MKT)                                          /*CER001*/
             MONMSG     MSGID(CPF7306 CPF5812)
 
/***  Override files, Initial Margins for &MKT Contracts.  ***/
 
/**********  OVRDBF     FILE(FOKEYDXL) MBR(&MKT) SEQONLY(*YES 100)                        /*CER001*/
             OVRDBF     FILE(FFAKX1PD) MBR(&MKT) SEQONLY(*YES 100)                        /*CER001*/
/**********  OVRDBF     FILE(TRANSDXL) MBR(&MKT)                                          /*CER001*/
             OVRDBF     FILE(FFTRX1PD) MBR(&MKT)                                          /*CER001*/
/*                                                                                        /*230177*/
/** Skip processing of IL0630 if memebr is not found in TRANS or                          /*230177*/
/** TRSET. This means that it is a newly inserted market and                              /*230177*/
/** FFC0110 should be the one to generate the memeber.                                    /*230177*/
/*                                                                                        /*230177*/
             CHKOBJ     OBJ(TRANS) OBJTYPE(*FILE) MBR(&MKT)                               /*230177*/
             MONMSG     MSGID(CPF9815) EXEC(GOTO CMDLBL(LOOP))                            /*230177*/
             CHKOBJ     OBJ(TRSET) OBJTYPE(*FILE) MBR(&MKT)                               /*230177*/
             MONMSG     MSGID(CPF9815) EXEC(GOTO CMDLBL(LOOP))                            /*230177*/
             OVRDBF     FILE(TRANS) MBR(&MKT)
             OVRDBF     FILE(TRSET)  MBR(&MKT)
 
             CALL       PGM(IL0630 ) PARM(&MKT)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOMSGQ(MOPERQ MRUNQ)
                 SNDPGMMSG  MSG('ILC0630  - IBLC 2002 - IL0630  : Program +
                            is abnormally terminated with ' *BCAT +
                            &MKT *BCAT ' as Market.') +
                            TOMSGQ(MOPERQ  MRUNQ)
                 GOTO END
             ENDDO
 
/*****       CHGVAR     VAR(&A) VALUE(&A + 2)                           IL0009*/
             ENDDO                                                    /*IL0009*/
             GOTO       CMDLBL(LOOP)
 
/***  Program ended abnormally.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0630  - IBLC Initial margin ended +
                          abnormally - see joblog for details.') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             DMPCLPGM
             GOTO       CMDLBL(END)
 
/***  Normal end of Program.  ***/
 
ENDPGM:
 
/***  Set Component flag as terminated.  ***/
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STATUS)
 
             DLTF       FILE(&DMLIB/ILCOLTPDXX)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DMLIB/TRANSDXLXX)
             MONMSG     MSGID(CPF0000)
END:
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
/**/
             ENDPGM
