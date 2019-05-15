/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Input Cycle Audit Reports')                  */
/*********************************************************************/
/*                                                                   */
/*         Midas - Securities Trading Module                         */
/*                                                                   */
/*         SEC0301 - AUDIT REPORTS - INPUT CYCLE                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSE108             Date 06Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE017             Date 20Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU011             Date 16Mar98              */
/*                      S01401             Date 16Jun93              */
/*                      E38656             DATE 23Apr92             */
/*                      E32615             DATE 29NOV91             */
/*                      S01117                  DATE  10DEC90       */
/*                      E22956                  DATE  30JUL90       */
/*                      E15601                  DATE  31/01/89      */
/*                      S01179                  DATE  19/12/88      */
/*                      S01176                  DATE  16/08/88      */
/*                      S01169                  DATE  10/06/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/**/                                                               /**/
/*       MD046248 - Finastra Rebranding                              */
/*       CSE108 - Yearly Profitability Report and Enquiry            */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
/*       CEU011 - Position/Risk Report                             */
/*       S01401 - SWIFT Messages MT5xxs : call new report pgms :   */
/*                  SE1865 - Trade Trans Extended Settlements      */
/*                  SE1866 - Depot Movements Extended Settlements  */
/*                  SE1867 - Pos Settlements Extended Settlements  */
/*                  SE1861 - SWIFT Certificate Units List          */
/*       E38656 - Add new program SE0344 - Market Prices Report    */
/*       E32615 - FOR RPG SE0330 OVERRIDING TO WRONG RECORD FORMAT */
/*       S01117 - MULTIBRANCHING                                   */
/*       E22956 - MESSAGE TEXT CHANGED FOR SE0381                  */
/*       E15601 - CALL SE0390 WITH A PARAMETER                     */ /*S01179*/
/*       S01179 -  INCORPORATION.                               */ /*S01179*/
/*       S01176 - SECURITIES TRADING 3.1  (AUSTRALIA)              */ /*S01176*/
/*       S01169 - SECURITIES TRADING 3.1                           */ /*S01169*/
/*                 (BAER INCORPORATION)                            */ /*S01169*/
/**/
/*********************************************************************/
/************PGM        PARM(&PRM01)                                 * *S01117*/
             PGM        PARM(&PRM01 &RSEQ &RLEV &RENT)                /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**/                                                                  /*S01117*/
             DCL        &PRM01        TYPE(*CHAR)  LEN(8)
             DCL        VAR(&LDA)   TYPE(*CHAR)  LEN(256)
/**/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(60)
             DCL        VAR(&FKEY) TYPE(*CHAR) LEN(4)                 /*S01117*/
/*/COPY WNCPYSRC,SEC0301006                                          */
/**/                                                                  /*S01117*/
/* SET UP LDA IN QTEMP */                                             /*S01117*/
/**/                                                                  /*S01117*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*S01117*/
             MONMSG     MSGID(CPF1023)
/*/COPY WNCPYSRC,SEC0301007                                          */
/**/                                                                  /*S01117*/
/* CREATE KEY TO POSITION FILES                                       /*S01117*/
/**/                                                                  /*S01117*/
             CHGVAR  VAR(&FKEY) VALUE(&RLEV *CAT &RENT)               /*S01117*/
/**/                                                                  /*S01117*/
/**/
/* SET UP PGM MESSAGE */
/**/
             IF         COND(&PRM01 *EQ 'SE0305  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - INVESTMENT TYPES +
                          AUDIT LIST-INTERIM'))
/************IF         COND(&PRM01 *EQ 'SE0310  ') THEN(CHGVAR +       S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - STD SETTLEMENT +   S01117*/
/************             INSTRUCTIONS AUDIT LIST-INTERIM'))            S01117*/
             IF         COND(&PRM01 *EQ 'SE0310  ') THEN(DO)          /*S01117*/
                 CHGVAR   VAR(&MSG) VALUE('SEC0301 - STD SETTLEMENT +
                          INSTRUCTIONS AUDIT LIST-INTERIM')           /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
          OVRDBF     FILE(STDSELCD) POSITION(*KEY 1 STDSEDF &RENT)    /*S01117*/
             OPNDBF     FILE(STDSELCD) OPTION(*ALL)                   /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(STDSELCD)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(TRDIP)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/*/COPY WNCPYSRC,SEC0301005                                          */
             IF         COND(&PRM01 *EQ 'SE0315  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - SECURITIES AUDIT +
                          LIST-INTERIM'))
             IF         COND(&PRM01 *EQ 'SE0320  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - SECURITY DIARY +
                          AUDIT LIST-INTERIM'))
/************IF         COND(&PRM01 *EQ 'SE0325  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - TRANSACTIONS +  * *S01117*/
/************             AUDIT LIST-INTERIM'))                      * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0325  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0301 - TRANSACTIONS +
                          AUDIT LIST-INTERIM')                        /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(TRDIP) POSITION(*KEY 1 TRADSDF &RENT)    /*S01117*/
             OPNDBF     FILE(TRDIP) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(TRDIP)                                   /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(TRDIP)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/*/COPY WNCPYSRC,SEC0301001                                          */
                                                                      /*S01401*/
             IF (&PRM01 *EQ 'SE1865  ') +
             THEN(CHGVAR (&MSG) VALUE('SEC0301 - TRANSACTIONS +
                  EXTENDED SETTLEMENTS AUDIT LIST-INTERIM'))          /*S01401*/
                                                                      /*S01401*/
/************IF         COND(&PRM01 *EQ 'SE0330  ') THEN(CHGVAR +       S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - TRADE +            S01117*/
/************             SETTLEMENTS AUDIT LIST-INTERIM'))             S01117*/
             IF         COND(&PRM01 *EQ 'SE0330  ') THEN(DO)          /*S01117*/
               CHGVAR     VAR(&MSG) VALUE('SEC0301 - TRADE +
                          SETTLEMENTS AUDIT LIST-INTERIM')            /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
/************OVRDBF FILE(SETLE) POSITION(*KEY 1 SETLEF  &RENT)*S01117* *E32615*/
             OVRDBF     FILE(SETLE) POSITION(*KEY 1 SETLEDF  &RENT)   /*E32615*/
             OPNDBF     FILE(SETLE) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SETLE)                                   /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SETLE)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/************IF         COND(&PRM01 *EQ 'SE0335  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - POSITION +      * *S01117*/
/************             SETTLEMENTS AUDIT LIST-INTERIM'))          * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0335  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0301 - POSITION +
                          SETTLEMENTS AUDIT LIST-INTERIM')            /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(POSET) POSITION(*KEY 1 POSETDF &RENT)    /*S01117*/
             OPNDBF     FILE(POSET) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(POSET)                                   /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(POSET)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
                                                                      /*S01401*/
             IF (&PRM01 *EQ 'SE1867  ') +
             THEN(CHGVAR (&MSG) VALUE('SEC0301 - POS SETTLEMENTS +
                  EXT SETTLEMENTS AUDIT LIST-INTERIM'))               /*S01401*/
                                                                      /*S01401*/
/************IF         COND(&PRM01 *EQ 'SE0340  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - DEPOT MOVEMENTS +**S01117*/
/************             AUDIT LIST-INTERIM'))                      * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0340  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0301 - DEPOT MOVEMENTS +
                          AUDIT LIST-INTERIM')                        /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(DPTMB) POSITION(*KEY 1 DPTMVDF &RENT)    /*S01117*/
             OPNDBF     FILE(DPTMB) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(DPTMB)                                   /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(DPTMB)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
                                                                      /*S01401*/
             IF (&PRM01 *EQ 'SE1866  ') +
             THEN(CHGVAR (&MSG) VALUE('SEC0301 - DEPOT MOVEMENTS +
                  EXTENDED SETTLEMENTS AUDIT LIST-INTERIM'))          /*S01401*/
                                                                      /*S01401*/
             IF         COND(&PRM01 *EQ 'SE0344  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - MARKET PRICES +
                          AUDIT LIST-INTERIM'))                       /*E38656*/
/************IF         COND(&PRM01 *EQ 'SE0345  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - PRICES AUDIT +  * *S01117*/
/************             LIST-INTERIM'))                            * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0345  ') THEN(DO)          /*S01117*/
/************CHGVAR     VAR(&MSG) VALUE('SEC0301 - PRICES AUDIT +    * *E38656*/
/************             LIST-INTERIM')                      *S01117* *E38656*/
             CHGVAR     VAR(&MSG) VALUE('SEC0301 - AVERAGE PRICES +
                          AUDIT LIST-INTERIM')                        /*E38656*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(PRICBLCD) POSITION(*KEY 1 PRICEDF &RENT) /*S01117*/
             OPNDBF     FILE(PRICBLCD) OPTION(*ALL)                   /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(PRICBLCD)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(PRICBLCD)                               /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/************IF         COND(&PRM01 *EQ 'SE0351  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - COUNTRY LIMITS +* *S01117*/
/************             AUDIT LIST-INTERIM'))                      * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0351  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0301 - COUNTRY LIMITS +
                          AUDIT LIST-INTERIM')                        /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(SLIMELLC) POSITION(*KEY 2 SLIMEF &FKEY)  /*S01117*/
             OPNDBF     FILE(SLIMELLC) OPTION(*ALL)                   /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMELLC)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMELLC)                               /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE   IF  COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
             OVRDBF     FILE(SLIMELLC) POSITION(*KEY 1 SLIMEF &RLEV)  /*S01117*/
             OPNDBF     FILE(SLIMELLC) OPTION(*ALL)                   /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMELLC)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMELLC)                               /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/************IF         COND(&PRM01 *EQ 'SE0352  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - CURRENCY LIMITS +**S01117*/
/************             AUDIT LIST-INTERIM'))                      * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0352  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0301 - CURRENCY LIMITS +
                          AUDIT LIST-INTERIM')                        /*S01117*/
               OVRDBF     FILE(SESLIMPD) SHARE(*NO)                   /*CEU011*/
               MONMSG     MSGID(CPF0000)                              /*CEU011*/
               OPNQRYF    FILE((SLIMF) (SDCURRPD)) FORMAT(SESLIMPD) +
                          KEYFLD((*MAPFLD/ECSS *ASCEND) +
                          (SLIMF/CNCL)) JFLD((SLIMF/CNCL +
                          SDCURRPD/A6CYCD)) MAPFLD((ECSS A6SSNB) +
                          (INCY A6INCY))                              /*CEU011*/
               CPYFRMQRYF FROMOPNID(SLIMF) TOFILE(SESLIMPD) +
                 MBROPT(*REPLACE)                                     /*CEU011*/
               MONMSG     MSGID(CPF2909)                              /*CEU011*/
               CLOF       OPNID(SLIMF)                                /*CEU011*/
               DLTOVR     FILE(SESLIMPD)                              /*CEU011*/
               MONMSG     MSGID(CPF0000)                              /*CEU011*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
/*********** OVRDBF FILE(SLIMFLLC) POSITION(*KEY 2 SLIMFF +    /*S01117 CEU011*/
/*********** &FKEY)                                            /*S01117 CEU011*/
/*********** OPNDBF FILE(SLIMFLLC) OPTION(*ALL)                /*S01117 CEU011*/
               OVRDBF   FILE(SESLIML1) POSITION(*KEY 2 SLIMFF &FKEY)  /*CEU011*/
               OPNDBF   FILE(SESLIML1) OPTION(*ALL)                   /*CEU011*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
/*********** DLTOVR     FILE(SLIMFLLC)                         /*S01117 CEU011*/
               DLTOVR     FILE(SESLIML1)                              /*CEU011*/
             ENDDO                                                    /*S01117*/
/*********** CLOF       OPNID(SLIMFLLC)                        /*S01117 CEU011*/
               CLOF     OPNID(SESLIML1)                               /*CEU011*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE   IF  COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
/*********** OVRDBF FILE(SLIMFLLC) POSITION(*KEY 1 SLIMFF +    /*S01117 CEU011*/
/*********** &RLEV)                                            /*S01117 CEU011*/
/*********** OPNDBF FILE(SLIMFLLC) OPTION(*ALL)                /*S01117 CEU011*/
               OVRDBF   FILE(SESLIML1) POSITION(*KEY 1 SLIMFF &RLEV)  /*CEU011*/
               OPNDBF   FILE(SESLIML1) OPTION(*ALL)                   /*CEU011*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
/*********** DLTOVR     FILE(SLIMFLLC)                         /*S01117 CEU011*/
               DLTOVR   FILE(SESLIML1)                                /*CEU011*/
             ENDDO                                                    /*S01117*/
/*********** CLOF       OPNID(SLIMFLLC)                        /*S01117 CEU011*/
               CLOF     OPNID(SESLIML1)                               /*CEU011*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/************IF         COND(&PRM01 *EQ 'SE0353  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - INVESTMENT TYPES +*S01117*/
/************             LIMITS AUDIT LIST-INTERIM'))               * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0353  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0301 - INVESTMENT TYPES +
                          LIMITS AUDIT LIST-INTERIM')                 /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(SLIMGLLC) POSITION(*KEY 2 SLIMGF &FKEY)  /*S01117*/
             OPNDBF     FILE(SLIMGLLC) OPTION(*ALL)                   /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMGLLC)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMGLLC)                               /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE   IF  COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
             OVRDBF     FILE(SLIMGLLC) POSITION(*KEY 1 SLIMGF &RLEV)  /*S01117*/
             OPNDBF     FILE(SLIMGLLC) OPTION(*ALL)                   /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMGLLC)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMGLLC)                               /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/************IF         COND(&PRM01 *EQ 'SE0354  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - CUSTOMER LIMITS +**S01117*/
/************             AUDIT LIST-INTERIM'))                      * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0354  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0301 - CUSTOMER LIMITS +
                          AUDIT LIST-INTERIM')                        /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(SLIMHLLC) POSITION(*KEY 2 SLIMHF &FKEY)  /*S01117*/
             OPNDBF     FILE(SLIMHLLC) OPTION(*ALL)                   /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMHLLC)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMHLLC)                               /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE   IF  COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
             OVRDBF     FILE(SLIMHLLC) POSITION(*KEY 1 SLIMHF &RLEV)  /*S01117*/
             OPNDBF     FILE(SLIMHLLC) OPTION(*ALL)                   /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMHLLC)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMHLLC)                               /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/************IF         COND(&PRM01 *EQ 'SE0355  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - SECURITY LIMITS +**S01117*/
/************             AUDIT LIST-INTERIM'))                      * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0355  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0301 - SECURITY LIMITS +
                          AUDIT LIST-INTERIM')                        /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(SLIMILLC) POSITION(*KEY 2 SLIMIF &FKEY)  /*S01117*/
             OPNDBF     FILE(SLIMILLC) OPTION(*ALL)                   /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMILLC)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMILLC)                               /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE   IF  COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
             OVRDBF     FILE(SLIMILLC) POSITION(*KEY 1 SLIMIF &RLEV)  /*S01117*/
             OPNDBF     FILE(SLIMILLC) OPTION(*ALL)                   /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMILLC)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMILLC)                               /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
             IF         COND(&PRM01 *EQ 'SE0360  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - LIMIT TYPES +
                          AUDIT LIST-INTERIM'))
             IF         COND(&PRM01 *EQ 'SE0365  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - FUNDING AUDIT +
                          LIST-INTERIM'))
             IF         COND(&PRM01 *EQ 'SE0370  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - ACCOUNT KEYS +
                          AUDIT LIST-INTERIM'))
             IF         COND(&PRM01 *EQ 'SE0375  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - TRADE NUMBER +
                          RANGES LIST-INTERIM'))
/*           IF         COND(&PRM01 *EQ 'SE0380  ') THEN(CHGVAR +  *  *S01169*/
/*                        VAR(&MSG) VALUE('SEC0301 - CHARGEABLE +  *  *S01169*/
/*                        RATES LIST-INTERIM'))                    *  *S01169*/
/************IF         COND(&PRM01 *EQ 'SE0381  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - CHARGE TYPES +
                          AUDIT LIST-INTERIM'))                  S01169E22956*/
             IF         COND(&PRM01 *EQ 'SE0381  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - CHARGE AND +
                          COMMISSION CODES - +
                          AUDIT LIST-INTERIM'))                /*S01169E22956*/
             IF         COND(&PRM01 *EQ 'SE0390  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - MARKET CENTRES +
                          LIST-INTERIM'))                            /*S01169*/
             IF         COND(&PRM01 *EQ 'SE0395  ') THEN(DO)
                  CHGVAR  VAR(&MSG) VALUE('SEC0301 - POSITION  +
                          PROFIT CENTRE AUDIT LIST - INTERIM')       /*S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(SEPPCLC) POSITION(*KEY 1 SEPCBDF &RENT)  /*S01117*/
             OPNDBF     FILE(SEPPCLC) OPTION(*ALL)                    /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SEPPCLC)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SEPPCLC)                                /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
                                                                      /*S01401*/
             IF (&PRM01 *EQ 'SE1861  ') +
             THEN(CHGVAR (&MSG) VALUE('SEC0301 - SWIFT CERTIFICATE +
                  UNITS LIST-INTERIM'))                               /*S01401*/
                                                                      /*S01401*/
/************IF         COND(&PRM01 *EQ 'SE3004  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0301 - BULK +          * *S01117*/
/************             TRANSACTIONS AUDIT LIST-INTERIM'))         * *S01117*/
             IF         COND(&PRM01 *EQ 'SE3004  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0301 - BULK +
                          TRANSACTIONS AUDIT LIST-INTERIM')           /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(TRADL) POSITION(*KEY 1 TRADSDF &RENT)    /*S01117*/
             OPNDBF     FILE(TRADL) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(TRADL)                                   /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(TRADL)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
             IF         COND(&PRM01 *EQ 'SE3150  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - CUSTOMER/BROKER +
                          DEFAULT CHARGES LIST-INTERIM'))            /*S01169*/
             IF         COND(&PRM01 *EQ 'SE5310  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - COMMERCIAL PAPER +
                          PRICE AUDIT LIST-INTERIM'))
                                                                                          /*CSE108*/
             IF         COND(&PRM01 *EQ 'SE8405  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0301 - DAILY  +
                          EXCHANGE RATE LIST'))
                                                                                          /*CSE108*/
/*/COPY WNCPYSRC,SEC0301004                                          */
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB     SWS(00000000)
/**/
/* CALL THE PROGRAM */
/**/
/*           IF         COND(&PRM01 *EQ 'SE0375  ' *OR &PRM01 *EQ +*/ /* +
S01169*/
/*                        'SE0380  ' *OR &PRM01 *EQ 'SE0390  ') +  */ /* +
S01169*/
/*                        THEN(CALL PGM(&PRM01))                   */ /* +
S01169*/
/*           IF         COND(&PRM01 *EQ 'SE0375  ' *OR &PRM01  +   */ /*E15601*/
/*                         *EQ 'SE0390  ') +                       */ /*E15601*/
/*                        THEN(CALL PGM(&PRM01))        */ /*E15601*/ /*S01169*/
                                                           /*E15601*/
/************IF         COND(&PRM01 *EQ 'SE0375  ') +                * *S01117*/
/************             THEN(CALL PGM(&PRM01))                     * *S01117*/
/************ELSE       CMD(CALL PGM(&PRM01) PARM('I'))              * *S01117*/
                                                                                          /*CSE108*/
             IF         COND(&PRM01 *EQ 'SE8405  ') THEN(DO)                              /*CSE108*/
             CALL       PGM(SE8405) PARM('I' '     ')                                     /*CSE108*/
             IF     COND(%SWITCH(XXXXXXX1)) THEN(GOTO ERROR)                              /*CSE108*/
             DLTOVR *ALL                                                                  /*CSE108*/
             GOTO ERROR                                                                   /*CSE108*/
             ENDDO                                                                        /*CSE108*/
                                                                                          /*CSE108*/
             IF         COND(&PRM01 *EQ 'SE0351' *OR +
                             &PRM01 *EQ 'SE0352' *OR +
                             &PRM01 *EQ 'SE0353' *OR +
                             &PRM01 *EQ 'SE0354' *OR +
                             &PRM01 *EQ 'SE0355') +
                          THEN(CALL PGM(&PRM01) +
                                    PARM('I' &RSEQ &RLEV &RENT))      /*S01117*/
/**/                                                                  /*S01117*/
             ELSE   IF COND(&PRM01 *EQ 'SE0375  ') +
                       THEN(CALL   PGM(&PRM01) PARM(&RSEQ))           /*S01117*/
                                                                      /*S01401*/
/************ELSE   CMD(IF COND(&PRM01 *EQ 'SE0325' *OR &PRM01 +       *S01401*/
/************       *EQ 'SE0310' *OR &PRM01 *EQ 'SE0330' *OR &PRM01 +  *S01401*/
/************             *EQ 'SE0335' *OR &PRM01 *EQ 'SE0340' *OR +   *S01401*/
/************             &PRM01 *EQ 'SE0345' *OR &PRM01 *EQ +         *S01401*/
/************             'SE0395' *OR &PRM01 *EQ +                    *S01401*/
/************             'SE3004') THEN(CALL PGM(&PRM01) +            *S01401*/
/************             PARM('I' &RSEQ &RENT)))              /*S01117*S01401*/
/************ELSE       CMD(IF COND(&PRM01 *EQ 'SE0344') THEN(CALL +   *S01401*/
/************             PGM(&PRM01) PARM('I' &RSEQ &RENT)))  /*E38656*S01401*/
/*/COPY WNCPYSRC,SEC0301002                                          */
                                                                      /*S01401*/
             ELSE (IF (&PRM01 *EQ 'SE0325' *OR +
                       &PRM01 *EQ 'SE1865' *OR +
                       &PRM01 *EQ 'SE0310' *OR +
                       &PRM01 *EQ 'SE0330' *OR +
                       &PRM01 *EQ 'SE0335' *OR +
                       &PRM01 *EQ 'SE1867' *OR +
                       &PRM01 *EQ 'SE0340' *OR +
                       &PRM01 *EQ 'SE1866' *OR +
                       &PRM01 *EQ 'SE0344' *OR +
                       &PRM01 *EQ 'SE0345' *OR +
                       &PRM01 *EQ 'SE0395' *OR +
                       &PRM01 *EQ 'SE3004') +
                   THEN(CALL (&PRM01) PARM('I' &RSEQ &RENT)))         /*S01401*/
/*/COPY WNCPYSRC,SEC0301003                                          */
                                                                      /*S01401*/
             ELSE       CMD(CALL PGM(&PRM01) PARM('I' &RSEQ))         /*S01117*/
                                                           /*E15601*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))*/ /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0301 - JOB TERMINATED, +
                          DATABASE IN ERROR')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/*ENDPGM:****ENDPGM*******                                             *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
