/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE FACLTY AND COMMTMT RPT BY CUSTMER')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0801A - FACILITY AND COMMITMENT REPORT BY CUSTOMER      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG6168            Date 15Mar05              */
/*       Prev Amend No. CLE041             Date 11Oct04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01339             Date 09Apr92              */
/*                      BHF798             Date 09Oct90              */
/*                      S01194              DATE  07FEB90           */
/*                      S01117              DATE  07FEB90           */
/*                      S01179              DATE  14/09/88          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       BUG6168 - LEC08 10001 in MSGW                              */
/*       CLE041 - Collateralised Lending Phase 2B                    */
/*       S01339 - REMOVE SYNDICATED LOANS PROCESSING, DUE TO        */
/*                MODULE REDUNDANCY.                                */
/*       BHF798 - CLOF ALL OPNDBF AT END OF PGM                     */
/*       S01117 - REL.10 MULTIBRANCHING                             */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01179 - AS400 INCORPORATION                               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                     * *S01117*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/************DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
/************DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('FACILITY AND COMMITMENT +
                          DETAILS BY CUSTOMER/PARENT REPORT')
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CLE041*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CLE041*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CLE041*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CLE041*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)                                  /*CLE041*/
/**/
             STRCMTCTL  LCKLVL(*ALL) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                                 /*BUG6168*/
             MONMSG     MSGID(CPF8351)                                                   /*BUG6168*/
/**/                                                                                     /*BUG6168*/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/                                                                                      /*CLE041*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE041*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE041*/
             CHGVAR     VAR(&SARD) VALUE('CLE025')                                        /*CLE041*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)                      /*CLE041*/
/**/                                                                                      /*CLE041*/
             IF         COND((&RTCD *NE '       ') *AND (&RTCD *NE +
                          '*NRF   ')) THEN(DO)                                            /*CLE041*/
               SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                  TOMSGQ(MOPERQ)                                          /*CLE041*/
               CHGJOB SWS(XXXXXX11)                                                       /*CLE041*/
               GOTO       CMDLBL(ENDPGM)                                                  /*CLE041*/
             ENDDO                                                                        /*CLE041*/
/**/                                                                                      /*CLE041*/
             IF         COND(&RTCD *EQ '       ') THEN( +
                          CHGVAR VAR(&CLE025) VALUE('Y'))                                 /*CLE041*/
/**/
             ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
/**/
/* CREATE EXTRACT IF NOT ALREADY CREATED */
/**/
DO01:        IF         COND(%SUBSTRING(&LESTAT 15 1) *NE Y) +
                        THEN(DO)
/**/
                CLRPFM     FILE(FACEXHH)
                CLRPFM     FILE(FACEXFA)
                CLRPFM     FILE(FACEXFC)
                CLRPFM     FILE(FACEXT4)
/**/                                                                                      /*CLE041*/
                IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                 /*CLE041*/
                   CLRPFM     FILE(LEAGCEPD)                                              /*CLE041*/
                   CLRPFM     FILE(LEAGFEPD)                                              /*CLE041*/
                ENDDO                                                                     /*CLE041*/
/**/
/**CHECK*FOR*COMMERCIAL*LOANS*MODULE*PRESENT***********/     /*S01339*/
/**/                                                         /*S01339*/
/************RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)  ***/     /*S01339*/
/************IF      COND(%SST(&MMOD 4 1)=Y) THEN(CHGJOB **/ /*S01339*/
/************************SWS(1XXXXXXX))     *************/   /*S01339*/
/**/
/************** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)     */         /*S01194*/
                CALL       PGM(LE0700)
/***************DLTOVR     FILE(TABLE)                     */         /*S01194*/
/**/
DO02:           IF         COND(%SWITCH(XXXXXXX0))  +
                           THEN(DO)
/**/                                                                                      /*CLE041*/
                   IF         COND(&CLE025 *EQ 'Y') THEN(+
                                CALL PGM(LE000065))                                       /*CLE041*/
                   IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)                            /*CLE041*/
/**********           CPYF       FROMFILE(LEAGCEPD) TOFILE(FACEXFA)  */       /*CLE041*/ /*BUG6168*/
/**********           CPYF       FROMFILE(LEAGFEPD) TOFILE(FACEXFC)  */       /*CLE041*/ /*BUG6168*/
                      CPYF       FROMFILE(LEAGCEPD) TOFILE(FACEXFA) +
                                   MBROPT(*ADD)                                          /*BUG6168*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                          /*BUG6168*/
                      CPYF       FROMFILE(LEAGFEPD) TOFILE(FACEXFC) +
                                   MBROPT(*ADD)                                          /*BUG6168*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                          /*BUG6168*/
                   ENDDO                                                                  /*CLE041*/
/**/
/*                 CHANGE DTAARA TO 'Y' */
                   CHGVAR     VAR(%SUBSTRING(&LESTAT 15 1)) VALUE('Y')
             CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)
/**/
ENDDO02:        ENDDO
/**/
ENDDO01:     ENDDO
/**/
             DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
/**/
/* REPORT PROGRAM */
/**/
DO03:        IF         COND(%SWITCH(XXXXXXX0))  +
                           THEN(DO)
/**/
                RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
DO04:           IF         COND(%SUBSTRING(&LESTAT 15 1) *EQ Y) +
                           THEN(DO)
/**/
/***************OVRDBF     FILE(TABLE) TOFILE(TABLEEE)   */           /*S01194*/
/***************OVRDBF     FILE(TABLED) TOFILE(TABLEEE) SHARE(*NO)*/  /*S01194*/
/******************CALL       PGM(LE0710)                      */     /*S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SFCX1) POSITION(*KEY 1 FACEXFCF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SFCX1) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SFCX1)                           /*S01117*/
                 ENDDO                                                /*S01117*/
             ENDDO                                                    /*S01117*/
                   CALL       PGM(LE0710) PARM(&RSEQ &RENT)           /*S01117*/
/******************DLTOVR     FILE(*ALL)                       */     /*S01194*/
/**/
ENDDO04:        ENDDO
/**/
ENDDO03:     ENDDO
             CLOF       OPNID(SFCX1)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:                                                                                   /*CLE041*/
             ENDPGM
