/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Non-authorised payments report')             */
/*********************************************************************/
/*                                                                   */
/*       Midas      FUNDS TRANSFER MODULE                            */
/*                                                                   */
/*       FTC0230    NON-AUTHORISED PAYMENTS                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. BUG25160A          Date 18Aug09              */
/*       Prev Amend No. BUG25160           Date 23Jul09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207984             Date 31Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      177984             Date 17APR00              */
/*                      CFT008             Date 04Jan00              */
/*                      CFT006            Date  10Sep99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117            Date  10Jan91              */
/*                      S01194            Date  10Jan91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG25160A - Apply fix 229526 and 229655                     */
/*       229526 - Remove call to FT0231 as it prevents AU report     */
/*                from being generated when there are no unauthorised*/
/*                records and also incorrectly calls FT0230          */
/*                which then generates db error in ZSFILE.           */
/*       229655 - Remove call to FT0571 and integrate RFT/CCT        */
/*                unauthorised details in FT0230                     */
/*       BUG25160 - Apply core fix 226942                            */
/*       226942 - Make RFT/CCT Authorised/Unauthorised reports       */
/*                available in the system.                           */
/*       207984 - Initialise &SARD before calling AOSARDR0.          */
/*       177984 - GEMS ERROR NUMBER - MONITOR FOR UNAUTHORISED 101/  */
/*                102 MESSAGES                                       */
/*       CFT008 - Funds Transfer/Swift Messages MT102                */
/*       CFT006 - Funds Transfer/Swift Messages MT101                */
/*               S01194 - NEW DATABASE HANDLING                      */
/*               S01117 - RCF PROCESSING                             */
/*                                                                   */
/*********************************************************************/
/**          PGM        PARM(&TYPE)                                  /*S01117*/
/**********  PGM        PARM(&TYPE &RSEQ &RLEV &RENT) */                           /*S01117 226942*/
/**********  PGM        PARM(&RSEQ &RLEV &RENT &PARM) */                       /*226942*/ /*229655*/
             PGM        PARM(&TYPE &RSEQ &RLEV &RENT)                                     /*229655*/
/**/
        DCL   VAR(&TYPE)  TYPE(*CHAR)   LEN(1)
        DCL   VAR(&PARM)  TYPE(*CHAR)   LEN(1)                                            /*229655*/
/**     DCL   VAR(&MEM)   TYPE(*CHAR)   LEN(44)                      /*S01194*/
        DCL   VAR(&MEM)   TYPE(*CHAR)   LEN(50)                      /*S01194*/
        DCL   VAR(&RSEQ)  TYPE(*CHAR)   LEN(5)                       /*S01117*/
        DCL   VAR(&RLEV)  TYPE(*CHAR)   LEN(1)                       /*S01117*/
        DCL   VAR(&RENT)  TYPE(*CHAR)   LEN(3)                       /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*******DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) + */                                     /*229655*/
/**********          VALUE('CFT006') */                                        /*CFT006*/ /*229655*/
/*******DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) */                            /*CFT006*/ /*229655*/
/*******DCL        VAR(&SARD1) TYPE(*CHAR) LEN(6) + */                                    /*229526*/
/**********          VALUE('CFT008') */                                        /*CFT008*/ /*229526*/
/*******DCL        VAR(&RTCD1) TYPE(*CHAR) LEN(7) */                           /*CFT008*/ /*229526*/
/*******DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) + */                                     /*229655*/
/**********               VALUE('*VERIFY') */                                  /*CFT006*/ /*229655*/
/*******DCL        VAR(&PTYP) TYPE(*CHAR) LEN(2) */                            /*226942*/ /*229655*/
/*******DCL        VAR(&STRT) TYPE(*DEC) LEN(5 0) */                           /*226942*/ /*229655*/
/*******DCL        VAR(&ENDT) TYPE(*DEC) LEN(5 0) */                           /*226942*/ /*229655*/
/*******DCL        VAR(&PMENU) TYPE(*CHAR) LEN(3) */                           /*226942*/ /*229655*/
/*******DCL        VAR(&RNTP) TYPE(*CHAR) LEN(1) */                            /*226942*/ /*229655*/
/*******DCL        VAR(&PARM) TYPE(*CHAR) LEN(100) */                          /*226942*/ /*229655*/
/**/
        SNDPGMMSG MSG('FT0230 - Non-authorised payments report') +
             TOMSGQ(MRUNQ)
/**/                                                                 /*S01194*/
/** Check if LDA Data area exists and create it if not **/           /*S01194*/
/**/                                                                 /*S01194*/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)                         /*S01194*/
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))                 /*S01194*/
/**/
        CHGJOB SWS(00000000)
/**/                                                                 /*CFT006*/
/**********/                                                                              /*229655*/
/*******CHGVAR     VAR(&RNTP) VALUE(%SST(&PARM 4 1)) */                        /*226942*/ /*229655*/
/*******CHGVAR     VAR(&PTYP) VALUE(%SST(&PARM 5 2)) */                        /*226942*/ /*229655*/
/*******CHGVAR     VAR(&STRT) VALUE(%SST(&PARM 10 5)) */                       /*226942*/ /*229655*/
/*******CHGVAR     VAR(&ENDT) VALUE(%SST(&PARM 15 5)) */                       /*226942*/ /*229655*/
/*******CHGVAR     VAR(&PMENU) VALUE(%SST(&PARM 20 3)) */                      /*226942*/ /*229655*/
/**********/                                                                              /*229655*/
/***Unauthorised Request for Transfer Transactions  */                         /*CFT006*/ /*229655*/
/**********/                                                                   /*CFT006*/ /*229655*/
/**********  CHGVAR     VAR(&SARD) VALUE('CFT006') */                          /*207984*/ /*229655*/
/*******CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD) */                        /*CFT006*/ /*229655*/
/*******IF*    COND(&RTCD *NE '       ' *AND &RTCD *NE + */                               /*229655*/
/**********               '*NRF   ') THEN(DO) */                               /*CFT006*/ /*229655*/
/**********    SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') + */                            /*229655*/
/**********                    TOMSGQ(MOPERQ) */                               /*CFT006*/ /*229655*/
/**********    CHGJOB     SWS(XXXXXX11) */                                     /*CFT006*/ /*229655*/
/**********    GOTO       CMDLBL(ENDPGM) */                                    /*CFT006*/ /*229655*/
/*******ENDDO */                                                               /*CFT006*/ /*229655*/
/**********/                                                                   /*CFT008*/ /*229655*/
/**********  CHGVAR     VAR(&SARD1) VALUE('CFT008') */                         /*207984*/ /*229655*/
/*******CALL       PGM(AOSARDR0) PARM(&RTCD1 &OPTN &SARD1) */                  /*CFT008*/ /*229526*/
/*******IF*        COND(&RTCD1 *NE '       ' *AND &RTCD1 *NE + */                         /*229526*/
/**********               '*NRF   ') THEN(DO) */                               /*CFT008*/ /*229526*/
/**********    SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') + */                            /*229526*/
/**********                    TOMSGQ(MOPERQ) */                               /*CFT008*/ /*229526*/
/**********    CHGJOB     SWS(XXXXXX11) */                                     /*CFT008*/ /*229526*/
/**********    GOTO       CMDLBL(ENDPGM) */                                    /*CFT008*/ /*229526*/
/*******ENDDO                                                                  /*CFT008*/ /*229526*/
/**     IF         COND(&RTCD *EQ '       ') THEN(DO)                  CFT008CFT006*/
/*******IF*        COND(&RTCD *EQ '       ' *OR &RTCD1 *EQ + */                           /*229526*/
/**********               '       ') THEN(DO) */                               /*CFT008*/ /*229526*/
/********          CALL   PGM(FT0231)                                /*CFT006 177984*/
/**********        CALL   PGM(FT0231) PARM(&TYPE) */                /*CFT006*/ /*177984*/ /*229526*/
/********          IF     COND(%SWITCH(XXXXXX11)) THEN(DO)           /*CFT006 177984*/
/********              SNDPGMMSG  MSG('Unauthorised Request for +
/********               Transactions/Customer Credit Transactions') +
/********               TOMSGQ(MOPERQ)                               /*CFT006 177984*/
/**********        IF     COND(&TYPE *EQ 'Y') THEN(DO) */           /*CFT006*/ /*177984*/ /*229526*/
/**********            CALL       PGM(FT0571) */                                   /*CFT006 226942*/
/**********  CALL       PGM(FT0571) PARM(&PTYP &STRT &ENDT + */                           /*229655*/
/**********               &PMENU &RNTP &RSEQ &RLEV &RENT) */                   /*226942*/ /*229655*/
/**********            GOTO       CMDLBL(ENDPGM) */                            /*CFT006*/ /*229655*/
/**********        ENDDO */                                                    /*CFT006*/ /*229655*/
/*******ENDDO */                                                               /*CFT006*/ /*229526*/
/**/                                                                 /*S01117*/
/** set up override **/                                              /*S01117*/
/**/                                                                 /*S01117*/
             IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE '   +
                          ')) THEN(DO)
             OVRDBF     FILE(NONAUBB) POSITION(*KEY 1 *N &RENT)
             OPNDBF     FILE(NONAUBB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(NONAUBB) +
                          POSITION(*END))
             ENDDO
/**/
/**     CALL PGM(FT0230) PARM(&TYPE)                             **/ /*S01117*/
        CALL PGM(FT0230) PARM(&TYPE &RSEQ &RLEV &RENT 'B')           /*S01117*/
        IF   COND(%SWITCH(XXXXXX11))   THEN(GOTO DBERR)                                   /*229655*/
/**/                                                                                      /*229655*/
/** set up override **/                                                                   /*229655*/
/**/                                                                                      /*229655*/
             IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE '   +
                          ')) THEN(DO)                                                    /*229655*/
             OVRDBF     FILE(FT101HLF) POSITION(*KEY 1 *N &RENT)                          /*229655*/
             OVRDBF     FILE(FT102HLF) POSITION(*KEY 1 *N &RENT)                          /*229655*/
             OPNDBF     FILE(FT101HLF) OPTION(*INP)                                       /*229655*/
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(FT101HLF) +
                          POSITION(*END))                                                 /*229655*/
             OPNDBF     FILE(FT102HLF) OPTION(*INP)                                       /*229655*/
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(FT102HLF) +
                          POSITION(*END))                                                 /*229655*/
             ENDDO                                                                        /*229655*/
/**/                                                                                      /*229655*/
        CALL PGM(FT0231) PARM(&PARM &RSEQ &RLEV &RENT 'B')                                /*229655*/
        IF   COND(&PARM *EQ 'Y') THEN(CHGVAR   VAR(&TYPE) +
                              VALUE('Y'))                                                 /*229655*/
DBERR:                                                                                    /*229655*/
/**/
/**   DATABASE ERROR HANDLING   **/
/**/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/**          RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&MEM)     **/ /*S01194*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)         /*S01194*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
/**/                                                                 /*S01117*/
/** delete overrides **/                                             /*S01117*/
/**/                                                                 /*S01117*/
             DLTOVR     FILE(NONAUBB)                                /*S01117*/
             MONMSG     MSGID(CPF9841)                               /*S01117*/
             DLTOVR     FILE(FT101HLF)                                                    /*229655*/
             MONMSG     MSGID(CPF9841)                                                    /*229655*/
             DLTOVR     FILE(FT102HLF)                                                    /*229655*/
             MONMSG     MSGID(CPF9841)                                                    /*229655*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
ENDPGM:                                                              /*CFT006*/
        ENDPGM
