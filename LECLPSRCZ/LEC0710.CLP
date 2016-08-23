/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE FACLTIES EXCEEDED, EXTRCT & RPT')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0710 - FACILITIES EXCEEDED, EXTRACT AND REPORT          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CLE041             Date 11Oct04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. BHF798             Date 09Oct90              */
/*                      BHF742             Date 02Oct90              */
/*                      S01194              DATE  07FEB90           */
/*                      S01117              DATE  07FEB90           */
/*                                                                  */
/********************************************************************/
/*       CLE041 - Collateralised Lending Phase 2B                    */
/*       BHF798 - CLOF ALL OPNDBF AT END OF PGM                     */
/*       BHF742 - SHOULD CLOSE FILE OPENED TO CHECK FILE POSITIONING*/
/*       S01194 - NEW STANDING DATA                                 */
/*       S01117 - REL.10 MULTIBRANCHING                             */
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
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
                                                                                          /*CLE041*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CLE041*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CLE041*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CLE041*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)                                  /*CLE041*/
                                                                                          /*CLE041*/
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('FACILITIES EXCEEDED, EXTRACT AND +
                        REPORT')
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
                                                                                          /*CLE041*/
             CHGJOB     SWS(00000000)                                                     /*CLE041*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE041*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE041*/
             CHGVAR     VAR(&SARD) VALUE('CLE025')                                        /*CLE041*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)                      /*CLE041*/
                                                                                          /*CLE041*/
             IF         COND((&RTCD *NE '       ') *AND (&RTCD *NE +
                          '*NRF   ')) THEN(DO)                                            /*CLE041*/
               SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                  TOMSGQ(MOPERQ)                                          /*CLE041*/
               CHGJOB SWS(XXXXXX11)                                                       /*CLE041*/
               GOTO       CMDLBL(ENDPGM)                                                  /*CLE041*/
             ENDDO                                                                        /*CLE041*/
                                                                                          /*CLE041*/
             IF         COND(&RTCD *EQ '       ') THEN( +
                          CHGJOB SWS(1XXXXXXX))                                           /*CLE041*/
/**/
             CLRPFM     FILE(FCLTBHH)
             CLRPFM     FILE(FCLTBFX)
             CLRPFM     FILE(FCLTBZZ)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)               */  /*S01194*/
/**/
             CALL       PGM(LE0663)
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/***************CALL       PGM(LE0670)                         */     /*S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SFCLB) POSITION(*KEY 1 FCLTBFXF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SFCLB) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SFCLB)                           /*S01117*/
                 ENDDO                                                /*S01117*/
             CLOF       OPNID(SFCLB)                                  /*BHF742*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             ENDDO                                                    /*S01117*/
                CALL       PGM(LE0670) PARM(&RSEQ &RENT)              /*S01117*/
/**/
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                   CLRPFM     FILE(FCLTBHH)
                   CLRPFM     FILE(FCLTBFX)
                   CLRPFM     FILE(FCLTBZZ)
                ENDDO
/**/
             ENDDO
             CLOF       OPNID(SFCLB)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:                                                                                   /*CLE041*/
             ENDPGM
