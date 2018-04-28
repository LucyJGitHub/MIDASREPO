/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Full Lists - On Request')                    */
/*********************************************************************/
/*                                                                   */
/*  Midas - Securities Trading Module                                */
/*                                                                   */
/*  SEC0302 - FULL LISTS - ON REQUEST                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSE039             Date 06Mar03              */
/*       Prev Amend No. CSE041             Date 27Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CSE023             Date 12Jul00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE017             Date 20Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU011             Date 16Mar98              */
/*                      S01401             Date 16Jun93              */
/*                      E38656             Date 23Apr92            */
/*                 E32615                  DATE 29NOV91            */
/*                 E27553             DATE  20AUG91                */
/*                 S01117             DATE  10DEC90                */
/*                 E22956             DATE  30JUL90                */
/*                 E15601             DATE  31JAN89                */
/*                 S01179             DATE  20DEC88                */
/*                 S01176             DATE  16AUG88                */
/*                 S01169             DATE  10JUN88                */
/*                                                                 */
/*-----------------------------------------------------------------*/
/*                                                                 */
/*       CSE039 - Automatic Settlements of Trades                    */
/*       CSE041 - DVP/RVP Processing                                 */
/*       CSE023 - Treaty Withholding Tax                             */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
/*  CEU011 - Position/Risk Report                                  */
/*  S01401 - SWIFT Messages MT5xxs : call new report pgms :        */
/*              SE1865 - Trade Trans Extended Settlements          */
/*              SE1866 - Depot Movements Extended Settlements      */
/*              SE1867 - Pos Settlements Extended Settlements      */
/*              SE1861 - SWIFT Certificate Units List              */
/*  E38656 - Add new program SE0344 - Market Prices Report         */
/*  E32615 - For program SE0330 overriding to wrong record format  */
/*  E27553 - Both files should be positioned for settlements list  */
/*  S01117 - MULTIBRANCHING                                        */
/*  E22956 - MESSAGE TEXT CHANGED FOR SE0381                       */
/*  E15601 - CALL SE0390 WITH A PARAMETER                          */
/*  S01179 - INCORPORATION.                                    */
/*  S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)                    */
/*  S01169 - SECURITIES TRADING 3.1                                */
/*                 (BAER INCORPORATION)                            */
/*                                                                 */
/*******************************************************************/
/************PGM        PARM(&PRM01)                                 * *S01117*/
             PGM        PARM(&PRM01 &RSEQ &RLEV &RENT)                /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**/                                                                  /*S01117*/
             DCL        &PRM01        TYPE(*CHAR)  LEN(8)
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
/**/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&FKEY) TYPE(*CHAR) LEN(4)                 /*S01117*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(60)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSE023*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CSE023*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSE023*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CSE023*/
             DCL        VAR(&CSE023) TYPE(*CHAR) LEN(1)               /*CSE023*/
             DCL        VAR(&CSE041) TYPE(*CHAR) LEN(1)               /*CSE041*/
             DCL        VAR(&CSE039) TYPE(*CHAR) LEN(1)               /*CSE039*/
             DCL        VAR(&TRADE) TYPE(*CHAR) LEN(6)                /*CSE039*/
             DCL        VAR(&DEPMV) TYPE(*CHAR) LEN(6)                /*CSE039*/
             DCL        VAR(&ALL) TYPE(*CHAR) LEN(1)                  /*CSE039*/
             CHGVAR  VAR(&ALL) VALUE('X')                             /*CSE039*/
/*/COPY WNCPYSRC,SEC0302006                                          */
/**/                                                                  /*S01117*/
/* CREATE KEY TO POSITION FILES                                       /*S01117*/
/**/                                                                  /*S01117*/
             CHGVAR  VAR(&FKEY) VALUE(&RLEV *CAT &RENT)               /*S01117*/
/*/COPY WNCPYSRC,SEC0302007                                          */
/**/                                                                  /*S01117*/
/**/                                                                  /*CSE023*/
/* Check if CSE023 is installed */                                    /*CSE023*/
/**/                                                                  /*CSE023*/
             CHGVAR     VAR(&SARD) VALUE('CSE023')                    /*CSE023*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE023*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE023*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CSE023*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE023) VALUE('Y'))
/**/                                                                  /*CSE041*/
/* Check if CSE041 is installed */                                    /*CSE041*/
/**/                                                                  /*CSE041*/
             CHGVAR     VAR(&SARD) VALUE('CSE041')                    /*CSE041*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE041*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE041*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CSE041*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE041) VALUE('Y'))                    /*CSE041*/
/**/                                                                  /*CSE039*/
/* Check if CSE039 is installed */                                    /*CSE039*/
/**/                                                                  /*CSE039*/
             CHGVAR     VAR(&SARD) VALUE('CSE039')                    /*CSE039*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE039*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE039*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CSE039*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE039) VALUE('Y'))                    /*CSE039*/
/**/
/* SET UP PGM MESSAGE */
/**/
             IF         COND(&PRM01 *EQ 'SE0305  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - INVESTMENT TYPES +
                          LIST'))
/************IF         COND(&PRM01 *EQ 'SE0310  ') THEN(CHGVAR +       S01117*/
/************             VAR(&MSG) VALUE('SEC0302 - STD SETTLEMENT +   S01117*/
/************             INSTRUCTIONS LIST'))                          S01117*/
             IF         COND(&PRM01 *EQ 'SE0310  ') THEN(DO)          /*S01117*/
                 CHGVAR   VAR(&MSG) VALUE('SEC0302 - STD SETTLEMENT +
                          INSTRUCTIONS LIST')                         /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
          OVRDBF     FILE(STDSELCD) POSITION(*KEY 1 STDSEDF &RENT)    /*S01117*/
             OPNDBF     FILE(STDSELCD) OPTION(*ALL)                   /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(STDSELCD)                                /*S01117*/
             ENDDO                                                    /*S01117*/
          OVRDBF     FILE(STDSED) POSITION(*KEY 1 STDSEDF &RENT)      /*E27553*/
             OPNDBF     FILE(STDSED) OPTION(*ALL)                     /*E27553*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*E27553*/
             DLTOVR     FILE(STDSED)                                  /*E27553*/
             ENDDO                                                    /*E27553*/
             CLOF       OPNID(TRDIP)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/*/COPY WNCPYSRC,SEC0302005                                          */
             IF         COND(&PRM01 *EQ 'SE0315  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - SECURITIES LIST'))
             IF         COND(&PRM01 *EQ 'SE0320  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - SECURITY DIARY +
                          LIST'))
/************IF         COND(&PRM01 *EQ 'SE0325  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0302 - TRANSACTIONS +  * *S01117*/
/************             LIST'))                                    * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0325  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0302 - TRANSACTIONS +
                          LIST')
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
/*/COPY WNCPYSRC,SEC0302001                                          */
                                                                      /*S01401*/
             IF (&PRM01 *EQ 'SE1865  ') +
             THEN(CHGVAR (&MSG) VALUE('SEC0302 - TRANSACTIONS +
                  EXTENDED SETTLEMENTS LIST'))                        /*S01401*/
                                                                      /*S01401*/
/************IF         COND(&PRM01 *EQ 'SE0330  ') THEN(CHGVAR +       S01117*/
/************             VAR(&MSG) VALUE('SEC0302 - TRADE +            S01117*/
/************             SETTLEMENTS LIST'))                           S01117*/
             IF         COND(&PRM01 *EQ 'SE0330  ') THEN(DO)
               CHGVAR     VAR(&MSG) VALUE('SEC0302 - TRADE +
                          SETTLEMENTS LIST')
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
/************             VAR(&MSG) VALUE('SEC0302 - POSITION +      * *S01117*/
/************             SETTLEMENTS LIST'))                        * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0335  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0302 - POSITION +
                          SETTLEMENTS LIST')                          /*S01117*/
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
             THEN(CHGVAR (&MSG) VALUE('SEC0302 - POSITION +
                  SETTLEMENTS EXTENDED SETTLEMENTS LIST'))            /*S01401*/
                                                                      /*S01401*/
/************IF         COND(&PRM01 *EQ 'SE0340  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0302 - DEPOT MOVEMENTS +**S01117*/
/************             LIST'))                                    * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0340  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0302 - DEPOT MOVEMENTS +
                          LIST')                                      /*S01117*/
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
             THEN(CHGVAR (&MSG) VALUE('SEC0302 - DEPOT MOVEMENTS +
                  EXTENDED SETTLEMENTS LIST'))                        /*S01401*/
                                                                      /*S01401*/
             IF         COND(&PRM01 *EQ 'SE0344  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - MARKET PRICES +
                          LIST'))                                     /*E38656*/
/************IF         COND(&PRM01 *EQ 'SE0345  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0302 - PRICES LIST')   * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0345  ') THEN(DO)          /*S01117*/
/************CHGVAR     VAR(&MSG) VALUE('SEC0302 - PRICES LIST')*S01117*E38656*/
             CHGVAR     VAR(&MSG) VALUE('SEC0302 - AVERAGE PRICES +
                          LIST')                                      /*E38656*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(PRICB) POSITION(*KEY 1 PRICEDF &RENT)    /*S01117*/
             OPNDBF     FILE(PRICB) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(PRICB)                                   /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(PRICB)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/************IF         COND(&PRM01 *EQ 'SE0351  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0302 - COUNTRY LIMITS +* *S01117*/
/************             LIST'))                                    * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0351  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0302 - COUNTRY LIMITS +
                          LIST')                                      /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(SLIMEL) POSITION(*KEY 2 SLIMEF &FKEY)    /*S01117*/
             OPNDBF     FILE(SLIMEL) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMEL)                                  /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMEL)                                 /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE   IF  COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
             OVRDBF     FILE(SLIMEL) POSITION(*KEY 1 SLIMEF &RLEV)    /*S01117*/
             OPNDBF     FILE(SLIMEL) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMEL)                                  /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMEL)                                 /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/************IF         COND(&PRM01 *EQ 'SE0352  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0302 - CURRENCY LIMITS +**S01117*/
/************             LIST'))                                    * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0352  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0302 - CURRENCY LIMITS +
                          LIST')                                      /*S01117*/
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
/*********** OVRDBF FILE(SLIMFL) POSITION(*KEY 2 SLIMFF &FKEY) /*S01117 CEU011*/
/*********** OPNDBF FILE(SLIMFL) OPTION(*ALL)                  /*S01117 CEU011*/
               OVRDBF   FILE(SESLIML0) POSITION(*KEY 2 SLIMFF &FKEY)  /*CEU011*/
               OPNDBF   FILE(SESLIML0) OPTION(*ALL)                   /*CEU011*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
/*********** DLTOVR     FILE(SLIMFL)                           /*S01117 CEU011*/
               DLTOVR   FILE(SESLIML0)                                /*CEU011*/
             ENDDO                                                    /*S01117*/
/*********** CLOF       OPNID(SLIMFL)                          /*S01117 CEU011*/
               CLOF     OPNID(SESLIML0)                               /*CEU011*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE   IF  COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
/*********** OVRDBF FILE(SLIMFL) POSITION(*KEY 1 SLIMFF &RLEV) /*S01117 CEU011*/
/*********** OPNDBF FILE(SLIMFL) OPTION(*ALL)                  /*S01117 CEU011*/
               OVRDBF   FILE(SESLIML0) POSITION(*KEY 1 SLIMFF &RLEV)  /*CEU011*/
               OPNDBF   FILE(SESLIML0) OPTION(*ALL)                   /*CEU011*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
/*********** DLTOVR     FILE(SLIMFL)                           /*S01117 CEU011*/
               DLTOVR   FILE(SESLIML0)                                /*CEU011*/
             ENDDO                                                    /*S01117*/
/*********** CLOF       OPNID(SLIMFL)                          /*S01117 CEU011*/
               CLOF     OPNID(SESLIML0)                               /*CEU011*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/************IF         COND(&PRM01 *EQ 'SE0353  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0302 - INVESTMENT TYPES +*S01117*/
/************             LIST'))                                    * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0353  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0302 - INVESTMENT TYPES +
                          LIST')                                      /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(SLIMGL) POSITION(*KEY 2 SLIMGF &FKEY)    /*S01117*/
             OPNDBF     FILE(SLIMGL) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMGL)                                  /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMGL)                                 /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE   IF  COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
             OVRDBF     FILE(SLIMGL) POSITION(*KEY 1 SLIMGF &RLEV)    /*S01117*/
             OPNDBF     FILE(SLIMGL) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMGL)                                  /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMGL)                                 /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/************IF         COND(&PRM01 *EQ 'SE0354  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0302 - CUSTOMER LIMITS +**S01117*/
/************             LIST'))                                    * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0354  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0302 - CUSTOMER LIMITS +
                          LIST')                                      /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(SLIMHL) POSITION(*KEY 2 SLIMHF &FKEY)    /*S01117*/
             OPNDBF     FILE(SLIMHL) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMHL)                                  /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMHL)                                 /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE   IF  COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
             OVRDBF     FILE(SLIMHL) POSITION(*KEY 1 SLIMHF &RLEV)    /*S01117*/
             OPNDBF     FILE(SLIMHL) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMHL)                                  /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMHL)                                 /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/************IF         COND(&PRM01 *EQ 'SE0355  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0302 - SECURITY LIMITS +**S01117*/
/************             LIST'))                                    * *S01117*/
             IF         COND(&PRM01 *EQ 'SE0355  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0302 - SECURITY LIMITS +
                          LIST')                                      /*S01117*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(SLIMIL) POSITION(*KEY 2 SLIMIF &FKEY)    /*S01117*/
             OPNDBF     FILE(SLIMIL) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMIL)                                  /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMIL)                                 /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE   IF  COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
             OVRDBF     FILE(SLIMIL) POSITION(*KEY 1 SLIMIF &RLEV)    /*S01117*/
             OPNDBF     FILE(SLIMIL) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SLIMIL)                                  /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SLIMIL)                                 /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
             IF         COND(&PRM01 *EQ 'SE0360  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - LIMIT TYPES +
                          LIST'))
             IF         COND(&PRM01 *EQ 'SE0365  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - FUNDING LIST'))
             IF         COND(&PRM01 *EQ 'SE0370  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - ACCOUNT KEYS +
                          LIST'))                                    /*S01169*/
             IF         COND(&PRM01 *EQ 'SE0375  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - TRADE NUMBER +
                          RANGES LIST'))                              /*S01176*/
/************IF         COND(&PRM01 *EQ 'SE0381  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - CHARGE TYPES +
                          AUDIT LIST'))                           S01176E22956*/
             IF         COND(&PRM01 *EQ 'SE0381  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - CHARGE AND +
                          COMMISSION CODES - +
                          FULL LIST'))                         /*S01176E22956*/
             IF         COND(&PRM01 *EQ 'SE0390  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - MARKET CENTRES +
                          LIST'))                                     /*S01176*/
             IF         COND(&PRM01 *EQ 'SE0395  ') THEN(DO)
                  CHGVAR  VAR(&MSG) VALUE('SEC0302 - POSITION  +
                          PROFIT CENTRE LIST')                       /*S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(SEPPC) POSITION(*KEY 1 SEPCBDF &RENT)    /*S01117*/
             OPNDBF     FILE(SEPPC) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(SEPPC)                                   /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(SEPPC)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
                                                                      /*S01401*/
             IF (&PRM01 *EQ 'SE1861  ') +
             THEN(CHGVAR (&MSG) VALUE('SEC0302 - SWIFT CERTIFICATE +
                  UNITS LIST'))                                       /*S01401*/
                                                                      /*S01401*/
/************IF         COND(&PRM01 *EQ 'SE3004  ') THEN(CHGVAR +    * *S01117*/
/************             VAR(&MSG) VALUE('SEC0302 - BULK +          * *S01117*/
/************             TRANSACTIONS LIST'))                       * *S01117*/
             IF         COND(&PRM01 *EQ 'SE3004  ') THEN(DO)          /*S01117*/
             CHGVAR     VAR(&MSG) VALUE('SEC0302 - BULK +
                          TRANSACTIONS LIST')                         /*S01117*/
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
                          VAR(&MSG) VALUE('SEC0302 - CUSTOMER/BROKER +
                          DEFAULT CHARGES LIST'))                    /*S01169*/
             IF         COND(&PRM01 *EQ 'SE5310  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - COMMERCIAL PAPER +
                          PRICES LIST'))
             IF         COND(&PRM01 *EQ 'SE7600  ' *AND +
                             &CSE023 *EQ 'Y') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - CLIENTS SUBJECT +
                          BACKUP WITHOLDING TAX REPORT'))             /*CSE023*/
             IF         COND(&PRM01 *EQ 'SE7601  ' *AND +
                             &CSE023 *EQ 'Y') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - CLIENTS W/O +
                          DOCUMENTATION FOR DIVIDEND REPORT'))        /*CSE023*/
             IF         COND(&PRM01 *EQ 'SE4710  ' *AND +
                             &CSE041 *EQ 'Y') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - CONTRACTUAL +
                          SETTLEMENT MATRIX AUDIT REPORT'))        /*CSE041*/
             IF         COND(&PRM01 *EQ 'SE4300  ' *AND +
                             &CSE039 *EQ 'Y') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0302 - MOVEMENTS +
                          STATUS AUDIT LIST'))                     /*CSE039*/
/*/COPY WNCPYSRC,SEC0302004                                          */
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
/*           IF         COND(&PRM01 *EQ 'SE0375  ' *OR &PRM01 *EQ + *  *S01169*/
/*                        'SE0380  ' *OR &PRM01 *EQ 'SE0390  ') +   *  *S01169*/
/*                        THEN(CALL PGM(&PRM01))                    *  *S01169*/
/*           IF         COND(&PRM01 *EQ 'SE0375  ' *OR &PRM01 *EQ +   /*E15601*/
/*                         'SE0390  ') +                              /*E15601*/
/*                        THEN(CALL PGM(&PRM01))           /*E15601*/ /*S01169*/
                                                           /*E15601*/
/************IF         COND(&PRM01 *EQ 'SE0375  ') +                  *S01117*/
/************             THEN(CALL PGM(&PRM01))                       *S01117*/
/************ELSE       CMD(CALL PGM(&PRM01) PARM('L'))                *S01117*/
/**/                                                                  /*S01117*/
             IF         COND(&PRM01 *EQ 'SE0351' *OR +
                             &PRM01 *EQ 'SE0352' *OR +
                             &PRM01 *EQ 'SE0353' *OR +
                             &PRM01 *EQ 'SE0354' *OR +
                             &PRM01 *EQ 'SE0355') +
                          THEN(CALL PGM(&PRM01) +
                                    PARM('L' &RSEQ &RLEV &RENT))      /*S01117*/
/**/                                                                  /*S01117*/
/*********** ELSE       CMD(IF COND(&PRM01 *EQ 'SE0375  ') +          /*CSE023*/
/***********              THEN(CALL PGM(&PRM01) PARM(&RSEQ)))  /*S01117 CSE023*/
             ELSE       CMD(IF COND(&PRM01 *EQ 'SE0375  ' *OR +
                                    &PRM01 *EQ 'SE7600  ' *AND +
                                    &CSE023 *EQ 'Y' *OR +
                                    &PRM01 *EQ 'SE7601  ' *AND +
                                    &CSE023 *EQ 'Y') +
                          THEN(CALL PGM(&PRM01) PARM(&RSEQ)))         /*CSE023*/
/**/                                                                  /*S01117*/
/************ELSE       CMD(IF COND(&PRM01 *EQ 'SE0325' *OR &PRM01 +   *S01401*/
/************       *EQ 'SE0310' *OR &PRM01 *EQ 'SE0330' *OR &PRM01 +  *S01401*/
/************             *EQ 'SE0335' *OR &PRM01 *EQ 'SE0340' *OR +   *S01401*/
/************             &PRM01 *EQ 'SE0345' *OR &PRM01 *EQ +         *S01401*/
/************             'SE0395' *OR &PRM01 *EQ +                    *S01401*/
/************             'SE3004')  +                                 *S01401*/
/************                    THEN(CALL PGM(&PRM01) +               *S01401*/
/************                           PARM('L' &RSEQ &RENT)))/*S01117*S01401*/
/************                                                  /*S01117*S01401*/
/************ELSE       CMD(IF COND(&PRM01 *EQ 'SE0344') THEN(CALL +   *S01401*/
/************             PGM(&PRM01) PARM('L' &RSEQ &RENT)))  /*E38656*S01401*/
/*/COPY WNCPYSRC,SEC0302002                                          */
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
                   THEN(CALL (&PRM01) PARM('L' &RSEQ &RENT)))         /*S01401*/
/*/COPY WNCPYSRC,SEC0302003                                          */
/**/                                                                  /*S01117*/
             ELSE       CMD(IF COND(&PRM01 *EQ 'SE4710  ' *AND +
                          &CSE041 *EQ 'Y') THEN(CALL PGM(&PRM01) +
                          PARM('L' &RSEQ &RLEV &RENT))) /*CSE041*/
 
             ELSE       IF COND(&PRM01 *EQ 'SE4300  ' *AND +
                          &CSE039 *EQ 'Y') THEN(DO)                   /*CSE039*/
             CALL       PGM(&PRM01) PARM('L' &RSEQ &RLEV &RENT +
                          &TRADE &DEPMV &ALL) /*CSE039*/
                          ENDDO                                       /*CSE039*/
 
             ELSE       CMD(CALL PGM(&PRM01) PARM('L' &RSEQ))         /*S01117*/
                                                           /*E15601*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA)  RTNVAR(&LDA)
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))*/ /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0302 - JOB TERMINATED, +
                          DATABASE IN ERROR')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) +
                           TOMSGQ(MOPERQ MRUNQ)
                GOTO ENDPGM
             ENDDO
/**/
/* CONTROL IMBALANCE */
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MEM) VALUE('SEC0302 - FILE CONTROLS OUT +
                          OF BALANCE')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/**/
/**/
/*ENDPGM:****ENDPGM*******                                             *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
