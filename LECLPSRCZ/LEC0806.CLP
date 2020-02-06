/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE INTEREST ACCRUALS REPORT')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LEC0806 - CUSTOMER LENDING INTEREST ACCRUALS REPORT         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*           1989                                                    */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      081966             Date 20Jan95              */
/*                      064219             Date 19May94              */
/*                      E40440             DATE 05AUG92              */
/*                      BHF798             DATE 09OCT90              */
/*                      S01194             DATE 07FEB90              */
/*                      S01117             DATE 07FEB90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       081966 - LEACXZZ & LEACXAC empty when LBC0690 runs          */
/*       064219 - CPF error occurs when pgm tries to close file SLACX*/
/*                w/out successfully opening it in the first place.  */
/*                Put a MONMSG in every CLOF SLACX cmd.              */
/*       E40440 - ALLOW CALL IF LEVEL IS BLANK                       */
/*       BHF798 - CLOF ALL OPNDBF AT END OF PGM                      */
/*       S01194 - NEW STANDING DATA                                  */
/*       S01117 - REL.10 MULTIBRANCHING                              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                     * *S01117*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             SNDPGMMSG  MSG('INTEREST ACCRUALS REPORT') +
                        TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(LEACXHH)
             CLRPFM     FILE(LEACXAC)
             CLRPFM     FILE(LEACXZZ)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)       */          /*S01194*/
             OVRDBF     FILE(CLOANC) TOFILE(CLOAN) SHARE(*NO)
             CALL       PGM(LE1110)
/*/COPY WNCPYSRC,LEC0806001                                          */
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/************** CALL       PGM(LE1120)                     */         /*S01194*/
/******IF*******  COND(&RLEV *EQ 'S') THEN(DO)              /*S01117*  *E40440*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DO)                                    /*E40440*/
                      CALL    PGM(LE1122) PARM(&RSEQ)                 /*S01117*/
                   ENDDO                                              /*S01117*/
                   IF         COND(&RLEV *EQ 'C') THEN(DO)            /*S01117*/
/* POSITION FILE TO THE PARTICULAR COMPANY                           * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SLACXL1) POSITION(*KEY 1 LEACXACF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SLACXL1) OPTION(*ALL)                 /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SLACXL1)                         /*S01117*/
                 ENDDO                                                /*S01117*/
                 CLOF OPNID(SLACXL1)
                 MONMSG     MSGID(CPF0000)                           /*064219*/
             ENDDO                                                    /*S01117*/
                      CALL    PGM(LE1121) PARM(&RSEQ &RENT)           /*S01117*/
                   ENDDO                                              /*S01117*/
                   IF         COND(&RLEV *EQ 'B') THEN(DO)            /*S01117*/
/* POSITION FILE TO THE PARTICULAR BRANCH                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SLACX) POSITION(*KEY 1 LEACXACF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SLACX) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SLACX)                           /*S01117*/
                 ENDDO                                                /*S01117*/
                 CLOF OPNID(SLACX)
                 MONMSG     MSGID(CPF0000)                           /*064219*/
             ENDDO                                                    /*S01117*/
                      CALL    PGM(LE1120) PARM(&RSEQ &RENT)           /*S01117*/
                   ENDDO                                              /*S01117*/
/**/
/***********    CLRPFM     FILE(LEACXHH)                               *081966*/
/***********    CLRPFM     FILE(LEACXAC)                               *081966*/
/***********    CLRPFM     FILE(LEACXZZ)                               *081966*/
/**/
             ENDDO
/**/
             CLOF       OPNID(SLACXL1)                                /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             CLOF       OPNID(SLACX)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
