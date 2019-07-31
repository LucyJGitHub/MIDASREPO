/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE LENDING PORTFOLIO BY CUSTOMER+ORG BR')       */
/********************************************************************/
/*                                                                  */
/*        Midas - Customer Lending Module                   */
/*                                                                  */
/*       LEC0802B - LENDING PORTFOLIO BY CUSTOMER REPORT BY ORG BRCH*/
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      240012             Date 26May06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 19Jun95              */
/*                      S01473             Date 16Nov94              */
/*                      S01473            DATE  10NOV94             */
/*                      S01473            DATE  29JUL94             */
/*                      E40440            DATE  05AUG92             */
/*                      RT0168              DATE  25JUN91           */
/*                      BHF798              DATE  09OCT90           */
/*                      BHF154              DATE  07AUG90           */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)         */
/*       240012 - Produce a dump if there's a problem before the    */
/*                change job.  Applied fix 164198 and 214113.       */
/*       S01408 - Addition of core hooks LEC0802BM1                 */
/*                                       LEC0802BM2                 */
/*       S01473 - Midas Leo Integration.                            */
/*                LE0742 should not be called with parm(&seq).      */
/*       S01473 - Midas Leo Integration.                            */
/*                LE0742 needs to use Leo pgm CAOUBR. Set it up.    */
/*       S01473 - Midas Leo Integration.                            */
/*                Inclusion of LEO transactions on report           */
/*       E40440 - ALLOW CALL IF LEVEL IS BLANK                      */
/*       RT0168 - REMOVE REFERENCE TO REDUNDANT PGM LE0733 & LE0742 */
/*       BHF798 - CLOF ALL OPNDBF AT END OF PGM                     */
/*       BHF154 - NEW PROGRAMME TO RUN BY ORIGINATING BRANCH        */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
     DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                         /*S01473*/
     DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')        /*S01473*/
     DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01473')         /*S01473*/
     DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                        /*S01473*/
     DCL        VAR(&S01473) TYPE(*CHAR) LEN(1)                       /*S01473*/
     DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(2)                       /*S01473*/
     DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)                      /*S01473*/
     DCL        VAR(&LDLIB) TYPE(*CHAR) LEN(10)                       /*S01473*/
     DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)                       /*S01473*/
     DCL        VAR(&PARM1) TYPE(*CHAR) LEN(10)                       /*S01473*/
     DCL        VAR(&PARM2) TYPE(*CHAR) LEN(10)                       /*S01473*/
     DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(2)                        /*S01473*/
/**/
             DCL VAR(&MMOD) TYPE(*CHAR) LEN(256)
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/**/
             CLRPFM     FILE(FPORTH2)
             CLRPFM     FILE(FPORTFP)
/*/COPY WNCPYSRC,LEC0802B01                                          */
             CLRPFM     FILE(FPORTT2)
/**/
             CALL       PGM(LE0730)
/**/
             IF         COND(%SWITCH(XXXXXXX0)&(%SST(&MMOD 4 1)=Y))   +
                           THEN(CALL PGM(LE0731))
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(CALL PGM(LE0734))
/**/
             IF         COND(%SWITCH(XXXXXXX0)&(%SST(&MMOD 4 1)=Y))   +
                           THEN(CALL PGM(LE0731))
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                OVRDBF    FILE(CLOANC) TOFILE(CLOAN) SHARE(*NO)
                CALL PGM(LE0740)
                DLTOVR    FILE(CLOANC)
             ENDDO
/**/
/*/COPY WNCPYSRC,LEC0802B02                                          */
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
                IF         COND(%SUBSTRING(&MMOD 2 1) *EQ 'Y') +
                           THEN(CALL PGM(LE0732))
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
                IF         COND(%SUBSTRING(&MMOD 2 1) *EQ 'Y') +
                           THEN(CALL PGM(LE0736))
             ENDDO
/**/
/**********  IF         COND(%SST(&MMOD 6 1) *EQ 'Y')  THEN(DO)         RT0168*/
/**/
/**********     IF         COND(%SWITCH(XXXXXXX0))                    + RT0168*/
/**********                THEN(CALL PGM(LE0733))                       RT0168*/
/**/
/**********     IF         COND(%SWITCH(XXXXXXX0))                    + RT0168*/
/**********                THEN(CALL PGM(LE0742))                       RT0168*/
/**********  ENDDO                                                      RT0168*/
                                                                      /*S01473*/
/* Access switchable features file to see if feature S01473     */    /*S01473*/
/* is installed  */                                                   /*S01473*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*S01473*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01473) VALUE('Y'))                    /*S01473*/
                                                                      /*S01473*/
             IF COND(%SWITCH(XXXXXXX0) *AND (&S01473 *EQ 'Y')) +
                                              THEN(DO)                /*S01473*/
             RTVDTAARA  DTAARA(LOPREF) RTNVAR(&DTAARA)                /*S01473*/
/* If either position is blank, this is an error */                   /*S01473*/
             IF         COND((%SST(&DTAARA 1 1) *EQ ' ') *OR +
                          (%SST(&DTAARA 2 1) *EQ ' ')) +
                          THEN(GOTO CMDLBL(SKIP))                     /*S01473*/
                                                                      /*S01473*/
             CHGVAR     VAR(&DTALIB) VALUE(&DTAARA *CAT 'DTALIB')     /*S01473*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0802BM1                                     */    /*S01408*/
/**/                                                                  /*S01408*/
             CHGVAR     VAR(&LDLIB) VALUE(&DTAARA *CAT 'LDLIB')       /*S01473*/
             CHGVAR     VAR(&DMLIB) VALUE(&DTAARA *CAT 'DMLIB')       /*S01473*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0802BM2                                     */    /*S01408*/
/**/                                                                  /*S01408*/
/************CHGDTAARA  DTAARA(*LDA (51 20)) VALUE(' ')**/            /*S01473*/
             CHGDTAARA  DTAARA(*LDA (51 30)) VALUE(' ')               /*S01473*/
             RTVDTAARA  DTAARA(&DTALIB/LPHAS) RTNVAR(&LPHAS)          /*S01473*/
             IF         COND(&LPHAS *NE 'I ') THEN(GOTO CMDLBL(SKIP)) /*S01473*/
                                                                      /*S01473*/
/* Retrieve Library for program CAOUFD   */                           /*S01473*/
             CHGVAR     VAR(&PARM1) VALUE('CAOUFD')                   /*S01473*/
             CHGVAR     VAR(&PARM2) VALUE(' ')                        /*S01473*/
             CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)              /*S01473*/
             CHGVAR     VAR(%SUBSTRING(*LDA 51 10)) VALUE(&PARM2)     /*S01473*/
/* Retrieve Library for program CAOUCA   */                           /*S01473*/
             CHGVAR     VAR(&PARM1) VALUE('CAOUCA')                   /*S01473*/
             CHGVAR     VAR(&PARM2) VALUE(' ')                        /*S01473*/
             CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)              /*S01473*/
             CHGVAR     VAR(%SUBSTRING(*LDA 61 10)) VALUE(&PARM2)     /*S01473*/
/* Retrieve Library for program CAOUBR   */                           /*S01473*/
             CHGVAR     VAR(&PARM1) VALUE('CAOUBR')                   /*S01473*/
             CHGVAR     VAR(&PARM2) VALUE(' ')                        /*S01473*/
             CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)              /*S01473*/
             CHGVAR     VAR(%SUBSTRING(*LDA 71 10)) VALUE(&PARM2)     /*S01473*/
                                                                      /*S01473*/
             OVRDBF     FILE(CPACRN) TOFILE(&LDLIB/CPACRN)            /*S01473*/
             OVRDBF     FILE(FDRAW) TOFILE(&LDLIB/FDRAW)              /*S01473*/
             OVRDBF     FILE(TBBR) TOFILE(&DMLIB/TBBR)                /*S01473*/
                                                                      /*S01473*/
/************CALL       PGM(LE0742) PARM(&RSEQ) */                    /*S01473*/
             CALL       PGM(LE0742)                                   /*S01473*/
                                                                      /*S01473*/
SKIP:                                                                 /*S01473*/
             DLTOVR     FILE(*ALL)                                    /*S01473*/
/************CHGDTAARA  DTAARA(*LDA (51 20)) VALUE(' ')**/            /*S01473*/
             CHGDTAARA  DTAARA(*LDA (51 30)) VALUE(' ')               /*S01473*/
                                                                      /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
   IF     COND(%SWITCH(XXXXXXX0) *AND   +
         (%SST(&MMOD 21 1) *EQ 'Y')) THEN(CALL PGM(LE0752))
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)                               /*240012*/
                           GOTO CMDLBL(ENDPGM)                                            /*240012*/
                ENDDO                                                                     /*240012*/
             CHGJOB     SWS(01000000)
/******IF*******  COND(&RLEV *EQ 'S') THEN(DO)              /*S01117*  *E40440*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DO)                                    /*E40440*/
                   CALL    PGM(LE0747) PARM(&RSEQ)
                     ENDDO
          IF     COND(&RLEV *EQ 'C') THEN(DO)
/* POSITION FILE TO THE PARTICULAR ENTITY  */
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)
                 OVRDBF    FILE(PORTL4) POSITION(*KEY 1 FPORTFPF +
                           &RENT)
                 OPNDBF    FILE(PORTL4) OPTION(*ALL)
                 MONMSG    MSGID(CPF0000) EXEC(DO)
                     DLTOVR     FILE(PORTL4)
                 ENDDO
             ENDDO
                   CALL    PGM(LE0749) PARM(&RSEQ &RENT)
             CLOF       OPNID(PORTL4)
             MONMSG     MSGID(CPF0000)
                     ENDDO
          IF     COND(&RLEV *EQ 'B') THEN(DO)
/* POSITION FILE TO THE PARTICULAR ENTITY */
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)
                 OVRDBF    FILE(PORT2) POSITION(*KEY 1 FPORTFPF +
                           &RENT)
                 OPNDBF    FILE(PORT2) OPTION(*ALL)
                 MONMSG    MSGID(CPF0000) EXEC(DO)
                     DLTOVR     FILE(PORT2)
                 ENDDO
             ENDDO
                   CALL    PGM(LE0748) PARM(&RSEQ &RENT)
             CLOF       OPNID(PORT2)
             MONMSG     MSGID(CPF0000)
                     ENDDO
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
             CLRPFM     FILE(FPORTH2)
             CLRPFM     FILE(FPORTFP)
/*/COPY WNCPYSRC,LEC0802B03                                          */
             CLRPFM     FILE(FPORTT2)
/**/
             ENDDO
             CHGJOB     SWS(X0XXXXXX)
             CLOF       OPNID(PORTL4)                                 /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             CLOF       OPNID(PORT2)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
