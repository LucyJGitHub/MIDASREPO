/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Deposits Ladder Report')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Dealing Module                                  */
/*                                                                   */
/*       DLC2685 - DEPOSITS LADDER REPORT                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. 248796             Date 06Jul07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU011             Date 16Mar98              */
/*                      S01473             Date 18Aug94              */
/*                      E27942             DATE 03SEP91              */
/*                        E58                DATE  20NOV89          */
/*                        S01117             DATE  31/08/89         */
/*                        S01194             DATE  31/08/89         */
/*                                                                  */
/********************************************************************/
/*       CEU011 - Position/Risk Enquiries & Reports                 */
/*       S01473 - Leo Midas Integration. If the switchable feature  */
/*                is present, override the DL event files, to files */
/*                containing the Leo files.                         */
/*                                                                  */
/*       E27942 - FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A      */
/*                LEVEL OF BLANKS                                   */
/*       E58    - SHOULD RECEIVE SEQ. NO. AS AN ENTRY PARAMETER     */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/************PGM*/                                                  /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                     /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)               /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)               /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)               /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                      /* S01473 */  /*S01473*/
/* Declare the variables to check the enhancements file */            /*S01473*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01473*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*S01473*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01473') /*S01473*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*S01473*/
             DCL        VAR(&S01473) TYPE(*CHAR) LEN(1)               /*S01473*/
             DCL        VAR(&CEU011) TYPE(*CHAR) LEN(1)               /*CEU011*/
/*/COPY WNCPYSRC,DLC2685001                                          */
                                                                      /*S01473*/
/* Access switchable features file to see if feature S01473     */    /*S01473*/
/* is installed  */                                                   /*S01473*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*S01473*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01473) VALUE('Y'))                    /*S01473*/
/*                                                                    /*S01473*/
/**/                                                                  /*CEU011*/
/* Check if CEU011 is installed */                                    /*CEU011*/
/**/                                                                  /*CEU011*/
             CHGVAR     VAR(&SARD) VALUE('CEU011')                    /*CEU011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CEU011*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU011) VALUE('Y'))                    /*CEU011*/
/*/COPY WNCPYSRC,DLC2685002                                          */
/**/                                                                  /*CEU011*/
/* Error */                                                           /*CEU011*/
/**/                                                                  /*CEU011*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                         /*CEU011*/
                SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                                TOMSGQ(MOPERQ)                        /*CEU011*/
                CHGJOB (XXXXXX11)                                     /*CEU011*/
                GOTO       CMDLBL(END)                                /*CEU011*/
             ENDDO                                                    /*CEU011*/
/**/
             CHGJOB     SWS(00000000)
/**/
             SNDMSG     MSG('DEPOSITS LADDER REPORT')  TOMSGQ(MRUNQ)
/************OVRDBF*****FILE(TABLE)   TOFILE(TABDLI)********************S01194*/
/************CALL       PGM(DL2685)*/                                 /*S01117*/
/************IF*********COND(&RLEV *EQ 'S') THEN(CALL PGM(DL2685))*S01117/*E58*/
/************IF         COND(&RLEV *EQ 'S') THEN(CALL PGM(DL2685) +
/************             PARM(&RSEQ))                           *E58* *E27942*/
/* If the Midas Leo Enhancement is present, override the file */      /*S01473*/
                                                                      /*S01473*/
             IF         COND(&S01473 *EQ 'Y') THEN(DO)                /*S01473*/
               IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(DO)                                    /*S01473*/
                 OVRDBF     FILE(EVDLS) TOFILE(EVDLSL2)               /*S01473*/
               ENDDO                                                  /*S01473*/
               IF         COND(&RLEV *EQ 'B') THEN(DO)                /*S01473*/
                 OVRDBF     FILE(EVDLSL1) TOFILE(EVDLSL3)             /*S01473*/
               ENDDO                                                  /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
             IF         COND(&CEU011 *EQ 'Y') THEN(DO)                /*CEU011*/
                CLRPFM     FILE(DLEVEUPD)                             /*CEU011*/
             ENDDO                                                    /*CEU011*/
/**/                                                                                      /*248796*/
                CLRPFM     FILE(DLROLPF)                                                  /*248796*/
/**/                                                                  /*CEU011*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CALL PGM(DL2685) PARM(&RSEQ))          /*E27942*/
             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(DL2683) +
                        PARM(&RSEQ &RENT))                            /*S01117*/
/************DLTOVR*****FILE(TABLE)*************************************S01194*/
/**/
             IF         COND(&CEU011 *EQ 'Y') THEN(DO)                /*CEU011*/
               IF         COND(%SWITCH(XXXXXX00)) THEN(DO)            /*CEU011*/
                 IF        COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                           THEN(DO)                                   /*CEU011*/
                           OVRDBF FILE(DLEVDLL0) TOFILE(DLEVEUL0)     /*CEU011*/
                 ENDDO                                                /*CEU011*/
                 IF        COND(&RLEV *EQ 'B') THEN(DO)               /*CEU011*/
                           OVRDBF FILE(DLEVDLL1) TOFILE(DLEVEUL1)     /*CEU011*/
                 ENDDO                                                /*CEU011*/
                            CHGJOB SWS(1XXXXXXX)                      /*CEU011*/
               IF        COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                           THEN(CALL PGM(DL2685) PARM(&RSEQ))         /*CEU011*/
               IF        COND(&RLEV *EQ 'B') THEN(CALL PGM(DL2683) +
                              PARM(&RSEQ &RENT))                      /*CEU011*/
               ENDDO                                                  /*CEU011*/
               IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)            /*CEU011*/
                 IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                              THEN(DO)                                /*CEU011*/
                            DLTOVR FILE(DLEVDLL0)                     /*CEU011*/
                 ENDDO                                                /*CEU011*/
                 IF         COND(&RLEV *EQ 'B') THEN(DO)
                            DLTOVR FILE(DLEVDLL1)                     /*CEU011*/
                 ENDDO                                                /*CEU011*/
               ENDDO                                                  /*CEU011*/
             ENDDO                                                    /*CEU011*/
/*/COPY WNCPYSRC,DLC2685003                                          */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(SNDPGMMSG +
                        MSG('JOB TERMINATED - DATABASE IN ERROR') +
                        TOMSGQ(MRUNQ MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**********  ENDPGM ***/                                              /*CEU011*/
END:         ENDPGM                                                   /*CEU011*/
