/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL EVENTS REPORTING')                           */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0804 - EVENT2 REPORTING BY DATE/CUSTOMER                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 03Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CDL038             Date 10May05              */
/*                      CDL021            Date  03Feb04             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E27942            DATE  03SEP91             */
/*                      E289              DATE  21MAR90             */
/*                      S01117            DATE  17/07/89            */
/*                      S01194            DATE  17/07/89            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                        */
/*       CDL038 - Extended Deal Sub Type                            */
/*       CDL021 - Reports by Deal Type                              */
/*       E27942  -  FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A    */
/*                  LEVEL OF BLANKS                                 */
/*       E289   - REMOVE CALL TO DL0670 TO ENABLE RCF PROCESSING    */
/*                TO TIE UP THE RELEVANT REPORTS WITH THIS PROGRAM  */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01194 - STANDING DATA CHANGES                             */
/*                                                                  */
/********************************************************************/
/************PGM                                                        S01117*/
/************PGM PARM(&RSEQ &RLEV &RENT) */                                        /*S01117 CDL021*/
/*/COPY WNCPYSRC,DLH00121                                            */
             PGM PARM(&RSEQ &RLEV &RENT &PARMS)                                           /*CDL021*/
/*/COPY WNCPYSRC,DLH00122                                            */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/**DCL*VAR(&PARMS)*TYPE(*CHAR)*LEN(4)********************************************CDL021*/ /*CDL038*/
/*/COPY WNCPYSRC,DLH00126                                            */
   DCL VAR(&PARMS) TYPE(*CHAR) LEN(8)                                                     /*CDL038*/
/*/COPY WNCPYSRC,DLH00127                                            */
             DCL        VAR(&SWS)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) VALUE('Job +
                          terminated - database in error')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) VALUE('File +
                          controls out of balance')
             DCL        VAR(&TYP1) TYPE(*CHAR) LEN(2)                                     /*CDL021*/
             DCL        VAR(&TYP2) TYPE(*CHAR) LEN(2)                                     /*CDL021*/
             DCL        VAR(&TYP3) TYPE(*CHAR) LEN(4)                                     /*CDL038*/
/*/COPY WNCPYSRC,DLC0804001                                          */
/**/
             SNDMSG     MSG('EVENTS REPORTING - BY DATE/CUSTOMER') TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,DLC0804005                                          */
/**/
             CHGJOB     SWS(00000000)
             SNDMSG     MSG('FX DEALS BY VALUE DATE REPORT')  TOMSGQ(MRUNQ)
/*********** OVRDBF     FILE(TABLE)   TOFILE(TABDLEE)                 /*S01194*/
/*********** OVRDBF     FILE(TABLED)  TOFILE(TABDLEI)                 /*S01194*/
/*********** CALL       PGM(DL0700)                                   /*S01117*/
                                                                      /*S01117*/
/*  REPORT BY SYSTEM  */                                              /*S01117*/
/***IF COND(&RLEV *EQ 'S') THEN(CALL PGM(DL0700) PARM(&RSEQ)) *S01117* *E27942*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CALL PGM(DL0700) PARM(&RSEQ))          /*E27942*/
                                                                      /*S01117*/
/*  REPORT BY BRANCH  */                                              /*S01117*/
    IF COND(&RLEV *EQ 'B') THEN(CALL PGM(DL0701) PARM(&RSEQ &RENT))   /*S01117*/
                                                                      /*S01117*/
/*  REPORT BY COMPANY */                                              /*S01117*/
    IF COND(&RLEV *EQ 'C') THEN(CALL PGM(DL0702) PARM(&RSEQ &RENT))   /*S01117*/
                                                                      /*S01117*/
/*/COPY WNCPYSRC,DLC0804006                                          */
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
/**/
                SNDMSG     MSG('DEPOSITS BY MATURITY DATE REPORT') +
                           TOMSGQ(MRUNQ)
/***************CALL       PGM(DL0710)                                /*S01117*/
                                                                      /*S01117*/
             CHGVAR     VAR(&TYP1) VALUE(%SST(&PARMS 1 2))                                /*CDL021*/
             CHGVAR     VAR(&TYP2) VALUE(%SST(&PARMS 3 2))                                /*CDL021*/
             CHGVAR     VAR(&TYP3) VALUE(%SST(&PARMS 5 4))                                /*CDL038*/
/*/COPY WNCPYSRC,DLC0804003                                          */
/*  REPORT BY SYSTEM  */                                              /*S01117*/
/***IF COND(&RLEV *EQ 'S') THEN(CALL PGM(DL0710) PARM(&RSEQ)) *S01117* *E27942*/
/**********  IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CALL PGM(DL0710) PARM(&RSEQ)) */                    /*E27942 CDL021*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DO)                                                        /*CDL021*/
             OVRDBF     FILE(EVNT2J) SHARE(*YES)                                          /*CDL021*/
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *NE '**' *AND +
                          &TYP1 *NE '  ') THEN(DO)                                        /*CDL021*/
/************OPNQRYF    FILE((EVNT2J *FIRST EVNT2JF)) +               *****/ /*CDL038*/ /*BG18886*/
/************             FORMAT(EVNT2J EVNT2JF) QRYSLT('DTYP +       *****/ /*CDL038*/ /*BG18886*/
/************             *EQ "' ** &TYP1 ** '" & DLST *EQ "' ** +    *****/ /*CDL038*/ /*BG18886*/
/************                       &TYP2 ** '" & CLAS *EQ "' ** +    *****/ /*CDL038*/ /*BG18886*/
/************             &TYP3 ** '" ') KEYFLD((EDAT) (FFVD) +       *****/ /*CDL038*/ /*BG18886*/
/************             (CASK) (CUNR) (DLNO) (DLST) (CLAS))         *****/ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((EVNT2J *FIRST EVNT2JF)) FORMAT(EVNT2J +
                          EVNT2JF) QRYSLT('DTYP *EQ "' *CAT &TYP1 +
                          *CAT '" & DLST *EQ "' *CAT &TYP2 *CAT '" +
                          & CLAS *EQ "' *CAT &TYP3 *CAT '" ') +
                          KEYFLD((EDAT) (FFVD) (CASK) (CUNR) (DLNO) +
                          (DLST) (CLAS))                              /*CDL038*/ /*BG18886*/
/************OPNQRYF    FILE((EVNT2J *FIRST EVNT2JF)) +            ********************/  /*CDL038*/
/************             FORMAT(EVNT2J EVNT2JF) QRYSLT('DTYP +    ********************/  /*CDL038*/
/************             *EQ "' ** &TYP1 ** '" & DLST *EQ "' ** + ********************/  /*CDL038*/
/************             &TYP2 ** '" ') KEYFLD((EDAT) (FFVD) +    ********************/  /*CDL038*/
/************             (CASK) (CUNR) (DLNO) (DLST))             *************CDL021*/  /*CDL038*/
             ENDDO                                                                        /*CDL021*/
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *EQ '**') +
                          THEN(DO)                                                        /*CDL021*/
/************OPNQRYF    FILE((EVNT2J *FIRST EVNT2JF)) +            ****/ /*CDL038*/ /*BG18886*/
/************             FORMAT(EVNT2J EVNT2JF) QRYSLT('DTYP +    ****/ /*CDL038*/ /*BG18886*/
/************             *EQ "' ** &TYP1 ** '" ') KEYFLD((EDAT) + ****/ /*CDL038*/ /*BG18886*/
/************             (FFVD) (CASK) (CUNR) (DLNO) (DLST) (CLAS)****/ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((EVNT2J *FIRST EVNT2JF)) FORMAT(EVNT2J +
                          EVNT2JF) QRYSLT('DTYP *EQ "' *CAT &TYP1 +
                          *CAT '" ') KEYFLD((EDAT) (FFVD) (CASK) +
                          (CUNR) (DLNO) (DLST) (CLAS))                   /*CDL038*/ /*BG18886*/
/************OPNQRYF    FILE((EVNT2J *FIRST EVNT2JF)) +            ********************/  /*CDL038*/
/************             FORMAT(EVNT2J EVNT2JF) QRYSLT('DTYP +    ********************/  /*CDL038*/
/************             *EQ "' ** &TYP1 ** '" ') KEYFLD((EDAT) + ********************/  /*CDL038*/
/************             (FFVD) (CASK) (CUNR) (DLNO) (DLST))      *************CDL021*/  /*CDL038*/
             ENDDO                                                                        /*CDL021*/
/**********  ENDDO *************************************************************CDL021*/  /*CDL038*/
                          CALL PGM(DL0710) PARM(&RSEQ &PARMS)                             /*CDL021*/
             CLOF       OPNID(EVNT2J)                                                     /*CDL021*/
             MONMSG     MSGID(CPF4520)                                                    /*CDL021*/
             DLTOVR     FILE(EVNT2J)                                                      /*CDL021*/
             MONMSG     MSGID(CPF9841)                                                    /*CDL021*/
                          ENDDO                                                           /*CDL021*/
/*  REPORT BY BRANCH  */                                              /*S01117*/
/***IF COND(&RLEV *EQ 'B') THEN(CALL PGM(DL0711) PARM(&RSEQ &RENT)) */             /*S01117 CDL021*/
             IF         COND(&RLEV *EQ 'B') THEN(DO)                                      /*CDL021*/
             OVRDBF     FILE(EVNT2JL1) SHARE(*YES)                                        /*CDL021*/
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *NE '**' *AND +
                          &TYP1 *NE '  ') THEN(DO)                                        /*CDL021*/
/************OPNQRYF    FILE((EVNT2JL1 *FIRST EVT2JL1F)) +             ***/ /*CDL038*/ /*BG18886*/
/************             FORMAT(EVNT2JL1 EVT2JL1F) QRYSLT('DTYP +     ***/ /*CDL038*/ /*BG18886*/
/************             *EQ "' ** &TYP1 ** '" & DLST *EQ "' ** +     ***/ /*CDL038*/ /*BG18886*/
/************                       &TYP2 ** '" & CLAS *EQ "' ** +     ***/ /*CDL038*/ /*BG18886*/
/************             &TYP3 ** '" ') KEYFLD((BRCA) (EDAT) (FFVD) + ***/ /*CDL038*/ /*BG18886*/
/************             (CASK) (CUNR) (DLNO) (DLST) (CLAS))          ***/ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((EVNT2JL1 *FIRST EVT2JL1F)) +
                          FORMAT(EVNT2JL1 EVT2JL1F) QRYSLT('DTYP +
                          *EQ "' *CAT &TYP1 *CAT '" & DLST *EQ "' *CAT +
                                    &TYP2 *CAT '" & CLAS *EQ "' *CAT +
                          &TYP3 *CAT '" ') KEYFLD((BRCA) (EDAT) (FFVD) +
                          (CASK) (CUNR) (DLNO) (DLST) (CLAS))               /*CDL038*/ /*BG18886*/
/************OPNQRYF    FILE((EVNT2JL1 *FIRST EVT2JL1F)) +            *****************/  /*CDL038*/
/************             FORMAT(EVNT2JL1 EVT2JL1F) QRYSLT('DTYP +    *****************/  /*CDL038*/
/************             *EQ "' ** &TYP1 ** '" & DLST *EQ "' ** +    *****************/  /*CDL038*/
/************             &TYP2 ** '" ') KEYFLD((BRCA) (EDAT) (FFVD) +*****************/  /*CDL038*/
/************             (CASK) (CUNR) (DLNO) (DLST))                **********CDL021*/  /*CDL038*/
             ENDDO
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *EQ '**') +
                          THEN(DO)                                                        /*CDL021*/
/************OPNQRYF    FILE((EVNT2JL1 *FIRST EVT2JL1F)) +                */ /*CDL038*/ /*BG18886*/
/************             FORMAT(EVNT2JL1 EVT2JL1F) QRYSLT('DTYP +        */ /*CDL038*/ /*BG18886*/
/************             *EQ "' ** &TYP1 ** '" ') KEYFLD((BRCA) (EDAT) + */ /*CDL038*/ /*BG18886*/
/************             (FFVD) (CASK) (CUNR) (DLNO) (DLST) (CLAS))      */ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((EVNT2JL1 *FIRST EVT2JL1F)) +
                          FORMAT(EVNT2JL1 EVT2JL1F) QRYSLT('DTYP +
                          *EQ "' *CAT &TYP1 *CAT '" ') KEYFLD((BRCA) (EDAT) +
                          (FFVD) (CASK) (CUNR) (DLNO) (DLST) (CLAS))         /*CDL038*/ /*BG18886*/
/************OPNQRYF    FILE((EVNT2JL1 *FIRST EVT2JL1F)) +            *****************/  /*CDL038*/
/************             FORMAT(EVNT2JL1 EVT2JL1F) QRYSLT('DTYP +    *****************/  /*CDL038*/
/************             *EQ "' ** &TYP1 ** '" ') KEYFLD((BRCA) (EDAT*****************/  /*CDL038*/
/************             (FFVD) (CASK) (CUNR) (DLNO) (DLST))         **********CDL021*/  /*CDL038*/
             ENDDO                                                                        /*CDL021*/
             CALL PGM(DL0711) PARM(&RSEQ &RENT &PARMS)                                    /*CDL021*/
             CLOF       OPNID(EVNT2JL1)                                                   /*CDL021*/
             MONMSG     MSGID(CPF4520)                                                    /*CDL021*/
             DLTOVR     FILE(EVNT2JL1)                                                    /*CDL021*/
             MONMSG     MSGID(CPF9841)                                                    /*CDL021*/
             ENDDO                                                                        /*CDL021*/
                                                                      /*S01117*/
/*  REPORT BY COMPANY */                                              /*S01117*/
/***IF COND(&RLEV *EQ 'C') THEN(CALL PGM(DL0712) PARM(&RSEQ &RENT)) */             /*S01117 CDL021*/
             IF         COND(&RLEV *EQ 'C') THEN(DO)                                      /*CDL021*/
/*********** IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +                 ********/ /*CDL038*/
/***********              THEN(DO)                                              *CDL021*/ /*CDL038*/
             OVRDBF     FILE(EVNT2JL2) SHARE(*YES)                                        /*CDL021*/
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *NE '**' *AND +
                          &TYP1 *NE '  ') THEN(DO)                                        /*CDL021*/
/************OPNQRYF    FILE((EVNT2JL2 *FIRST EVT2JL2F)) +              */ /*CDL038*/ /*BG18886*/
/************             FORMAT(EVNT2JL2 EVT2JL2F) QRYSLT('DTYP +      */ /*CDL038*/ /*BG18886*/
/************             *EQ "' ** &TYP1 ** '" & DLST *EQ "' ** +      */ /*CDL038*/ /*BG18886*/
/************                       &TYP2 ** '" & CLAS *EQ "' ** +      */ /*CDL038*/ /*BG18886*/
/************             &TYP3 ** '" ') KEYFLD((COBB) (EDAT) (FFVD) +  */ /*CDL038*/ /*BG18886*/
/************             (CASK) (CUNR) (DLNO) (DLST) (CLAS))           */ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((EVNT2JL2 *FIRST EVT2JL2F)) +
                          FORMAT(EVNT2JL2 EVT2JL2F) QRYSLT('DTYP +
                          *EQ "' *CAT &TYP1 *CAT '" & DLST *EQ "' *CAT +
                                    &TYP2 *CAT '" & CLAS *EQ "' *CAT +
                          &TYP3 *CAT '" ') KEYFLD((COBB) (EDAT) (FFVD) +
                          (CASK) (CUNR) (DLNO) (DLST) (CLAS))              /*CDL038*/ /*BG18886*/
/************OPNQRYF    FILE((EVNT2JL2 *FIRST EVT2JL2F)) +              ***************/  /*CDL038*/
/************             FORMAT(EVNT2JL2 EVT2JL2F) QRYSLT('DTYP +      ***************/  /*CDL038*/
/************             *EQ "' ** &TYP1 ** '" & DLST *EQ "' ** +      ***************/  /*CDL038*/
/************             &TYP2 ** '" ') KEYFLD((COBB) (EDAT) (FFVD) +  ***************/  /*CDL038*/
/************             (CASK) (CUNR) (DLNO) (DLST))                  ********CDL021*/  /*CDL038*/
             ENDDO                                                                        /*CDL021*/
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *EQ '**') +
                          THEN(DO)                                                        /*CDL021*/
/************OPNQRYF    FILE((EVNT2JL2 *FIRST EVT2JL2F)) +                */ /*CDL038*/ /*BG18886*/
/************             FORMAT(EVNT2JL2 EVT2JL2F) QRYSLT('DTYP +        */ /*CDL038*/ /*BG18886*/
/************             *EQ "' ** &TYP1 ** '" ') KEYFLD((COBB) (EDAT) + */ /*CDL038*/ /*BG18886*/
/************             (FFVD) (CASK) (CUNR) (DLNO) (DLST) (CLAS))      */ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((EVNT2JL2 *FIRST EVT2JL2F)) +
                          FORMAT(EVNT2JL2 EVT2JL2F) QRYSLT('DTYP +
                          *EQ "' *CAT &TYP1 *CAT '" ') KEYFLD((COBB) (EDAT) +
                          (FFVD) (CASK) (CUNR) (DLNO) (DLST) (CLAS))         /*CDL038*/ /*BG18886*/
/************OPNQRYF    FILE((EVNT2JL2 *FIRST EVT2JL2F)) +              ***************/  /*CDL038*/
/************             FORMAT(EVNT2JL2 EVT2JL2F) QRYSLT('DTYP +      ***************/  /*CDL038*/
/************             *EQ "' ** &TYP1 ** '" ') KEYFLD((COBB) (EDAT) ***************/  /*CDL038*/
/************             (FFVD) (CASK) (CUNR) (DLNO) (DLST))           ********CDL021*/  /*CDL038*/
             ENDDO                                                                        /*CDL021*/
           CALL PGM(DL0712) PARM(&RSEQ &RENT &PARMS)                                      /*CDL021*/
             CLOF       OPNID(EVNT2JL2)                                                   /*CDL021*/
             MONMSG     MSGID(CPF4520)                                                    /*CDL021*/
             DLTOVR     FILE(EVNT2JL2)                                                    /*CDL021*/
             MONMSG     MSGID(CPF9841)                                                    /*CDL021*/
             ENDDO                                                                        /*CDL021*/
             ENDDO                                                                        /*CDL038*/
/*/COPY WNCPYSRC,DLC0804004                                          */
                                                                      /*S01117*/
                RTVJOBA    SWS(&SWS)
/*/COPY WNCPYSRC,DLC0804002                                          */
/**/
/*******        IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00')THEN(DO*/ /*289*/
/********                                                            */ /*289*/
/*  NO DL0670 FOR COMPANY REPORTS  */                      /*S01117* */ /*289*/
/*********         IF      COND(&RLEV *NE 'C') THEN(DO)    /*S01117  */ /*289*/
/*********                                                 /*S01117  */ /*289*/
/*  FOR SYSTEM REQUESTS TREAT AS BRANCH  */                /*S01117  */ /*289*/
/*******              IF      COND(&RLEV *EQ 'S') THEN(DO) /*S01117  */ /*289*/
/*******                   CHGVAR     VAR(&RENT) VALUE('ALL')/*S01117*/ /*289*/
/*******              ENDDO                                /*S01117  */ /*289*/
/**/                                                       /*S01117  */ /*289*/
/*******           SNDMSG    MSG('OUTSTANDING DELIVERY INSTRUCTIONS +*/ /*289*/
/*******                         REPORT') TOMSGQ(MRUNQ)              */ /*289*/
/******************CALL      PGM(DL0670)                   /*S01117  */ /*289*/
/*******           CALL      PGM(DL0670) PARM(&RSEQ &RENT) /*S01117  */ /*289*/
/*******           RTVJOBA   SWS(&SWS)                               */ /*289*/
/**/                                                       /*S01117  */ /*289*/
/*******           ENDDO                                   /*S01117  */ /*289*/
/**/                                                                    /*289*/
/*******        ENDDO                                                */ /*289*/
/**/
/*********** ENDDO *******************************************************/               /*CDL038*/
/**/
/*********** DLTOVR     FILE(TABLE TABLED)                            /*S01194*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') +
                          THEN(SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '01') +
                          THEN(SNDMSG MSG(&MSG2) TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,DLC0804007                                          */
             ENDPGM
/*/COPY WNCPYSRC,DLC0804008                                          */
