/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL INTEREST ACCRUALS')                          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0801 - INTEREST ACCRUALS                                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date  02Jun08            */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL038             Date  10May05            */
/*                      CDL021             Date  03Feb04            */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 30OCT95             */
/*                      S01440             DATE 23NOV93             */
/*                      S01440             DATE 16SEP93             */
/*                      E27942             DATE 03SEP91             */
/*                      S01117             DATE 21/04/89            */
/*                      S01194             DATE 21/04/89            */
/*                      S01098             DATE 22/09/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       BG18886 - Amend non-standard codes.                        */
/*       CDL038 - Extended Deal Sub Type                            */
/*       CDL021 -   Reports by Deal Type                            */
/*       S01408  -  ADDITION OF CORE HOOK DLC0801INT                */
/*                  ADDITION OF CORE HOOK DLC0801MPS                */
/*                  ADDITION OF CORE HOOK DLC0801END                */
/*       S01440  -  REMOVE TABLE FILE REFERENCES                    */
/*       S01440  -  AMENDED TO CALL THE INTEREST OUTRIGHT ACCRUALS  */
/*                  EXTRACT PROGRAM, FOLLOWED BY THE INTEREST       */
/*                  OUTRIGHT ACCRUALS REPORT                        */
/*       E27942  -  FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A    */
/*                  LEVEL OF BLANKS                                 */
/*       S01117  -  MULTI-BRANCHING                                 */
/*       S01194  -  STANDING DATA CHANGES                           */
/*       S01098  -  AMENDMENT BLOCKS SELECTED LARGE FILES           */
/*                                                                  */
/********************************************************************/
/**********  PGM                                                        S01117*/
/*/COPY WNCPYSRC,DLC0801005                                          */
/************PGM PARM(&RSEQ &RLEV &RENT) */                                        /*S01117 CDL021*/
             PGM PARM(&RSEQ &RLEV &RENT &PARMS)                                           /*CDL021*/
/*/COPY WNCPYSRC,DLC0801006                                          */
 
/*/COPY WNCPYSRC,DLC0801INT                                        */ /*S01408*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,DLC0801007                                          */
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/**DCL*VAR(&PARMS)*TYPE(*CHAR)*LEN(4)********************************************CDL021*/ /*CDL038*/
   DCL VAR(&PARMS) TYPE(*CHAR) LEN(8)                                                     /*CDL038*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) VALUE('Job +
                          terminated - database in error')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) VALUE('FILE +
                          CONTROLS OUT OF BALANCE')
/**/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*S01440*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ') /*S01440*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(79)                 /*S01440*/
             DCL        VAR(&BNAOIO) TYPE(*CHAR) LEN(1)               /*S01440*/
             DCL        VAR(&TYP1) TYPE(*CHAR) LEN(2)                                     /*CDL021*/
             DCL        VAR(&TYP2) TYPE(*CHAR) LEN(2)                                     /*CDL021*/
             DCL        VAR(&TYP3) TYPE(*CHAR) LEN(4)                                     /*CDL038*/
/*/COPY WNCPYSRC,DLC0801008                                          */
/**/
             CHGJOB     SWS(00000000)                                 /*S01440*/
 
/*/COPY WNCPYSRC,DLC0801MPS                                        */ /*S01408*/
/**/                                                                  /*S01440*/
             CLRPFM     FILE(ACCEXAN)
             CLRPFM     FILE(ACCEXAO)
             CLRPFM     FILE(ACCEXAP)
/*/COPY WNCPYSRC,DLC0801009                                          */
/**/
             SNDMSG     MSG('DEALS FILE EXTRACT')  TOMSGQ(MRUNQ)
/*********** OVRDBF     FILE(TABLE)   TOFILE(TABDLEE)                 /*S01194*/
/**/                                                                  /*S01098*/
/*                BLOCK LARGE FILES                                 *  *S01098*/
/**/                                                                  /*S01098*/
             OVRDBF     FILE(ACCEXAO) SEQONLY(*YES 100)               /*S01098*/
/*/COPY WNCPYSRC,DLC0801010                                          */
             CALL       PGM(DL0500)
             DLTOVR      FILE(ACCEXAO)                                /*S01098*/
/*/COPY WNCPYSRC,DLC0801011                                          */
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&TYP1) VALUE(%SST(&PARMS 1 2))                                /*CDL021*/
             CHGVAR     VAR(&TYP2) VALUE(%SST(&PARMS 3 2))                                /*CDL021*/
             CHGVAR     VAR(&TYP3) VALUE(%SST(&PARMS 5 4))                                /*CDL038*/
 
/*  REPORT BY SYSTEM      */                                          /*S01117*/
/************IF         COND(&RLEV *EQ 'S') THEN(DO)          *S01117* *E27942*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DO)                                    /*E27942*/
 
/******IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)*/      /*S01117*/
/******SNDMSG     MSG('ACCRUALS REPORT')  TOMSGQ(MRUNQ)             *  *S01117*/
 
             SNDMSG   MSG('ACCRUALS REPORT BY SYSTEM') TOMSGQ(MRUNQ)  /*S01117*/
             OVRDBF     FILE(SACEX) SHARE(*YES)                                           /*CDL021*/
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *NE '**' *AND +
                          &TYP1 *NE '  ') THEN(DO)                                        /*CDL021*/
/**********  OPNQRYF    FILE((SACEX *FIRST ACCEXAOF)) +
                          FORMAT(SACEX ACCEXAOF) QRYSLT('DTYP *EQ +
                          "'****&TYP1****'" & DLST *EQ "'****+
                                &TYP2****'" & CLAS *EQ "'****+
                          &TYP3****'" ') KEYFLD((RECI) (CCY) +
                          (RCDC) (DTYP) (DLST) (CLAS))       ********/ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((SACEX *FIRST ACCEXAOF)) +
                          FORMAT(SACEX ACCEXAOF) QRYSLT('DTYP *EQ +
                          "' *CAT &TYP1 *CAT '" & DLST *EQ "' *CAT +
                                &TYP2 *CAT '" & CLAS *EQ "' *CAT +
                          &TYP3 *CAT '" ') KEYFLD((RECI) (CCY) +
                          (RCDC) (DTYP) (DLST) (CLAS))                 /*CDL038*/ /*BG18886*/
/************OPNQRYF    FILE((SACEX *FIRST ACCEXAOF)) +            ********************/  /*CDL038*/
/************             FORMAT(SACEX ACCEXAOF) QRYSLT('DTYP *EQ +********************/  /*CDL038*/
/************             "' ***&TYP1****'" & DLST *EQ "'****+     ********************/  /*CDL038*/
/************             &TYP2****'" ') KEYFLD((RECI) (CCY) +     ********************/  /*CDL038*/
/************             (RCDC) (DTYP) (DLST))                    *************CDL021*/  /*CDL038*/
             ENDDO                                                                        /*CDL021*/
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *EQ '**') +
                          THEN(DO)                                                        /*CDL021*/
/**********  OPNQRYF    FILE((SACEX *FIRST ACCEXAOF)) +
                          FORMAT(SACEX ACCEXAOF) QRYSLT('DTYP *EQ +
                          "'****&TYP1****'" ') KEYFLD((RECI) +
                          (CCY) (RCDC) (DTYP) (DLST) (CLAS))       ***/ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((SACEX *FIRST ACCEXAOF)) +
                          FORMAT(SACEX ACCEXAOF) QRYSLT('DTYP *EQ +
                          "' *CAT &TYP1 *CAT '" ') KEYFLD((RECI) +
                          (CCY) (RCDC) (DTYP) (DLST) (CLAS))            /*CDL038*/ /*BG18886*/
/************OPNQRYF    FILE((SACEX *FIRST ACCEXAOF)) +            ********************/  /*CDL038*/
/************             FORMAT(SACEX ACCEXAOF) QRYSLT('DTYP *EQ +********************/  /*CDL038*/
/************             "' ***&TYP1 ***'" ') KEYFLD((RECI) +     ********************/  /*CDL038*/
/************             (CCY) (RCDC) (DTYP) (DLST))              *************CDL021*/  /*CDL038*/
             ENDDO                                                                        /*CDL021*/
/*************  CALL       PGM(DL0520) PARM(&RSEQ) */                                     /*CDL021*/
                CALL       PGM(DL0520) PARM(&RSEQ &PARMS)                                 /*CDL021*/
             CLOF       OPNID(SACEX)                                                      /*CDL021*/
             MONMSG     MSGID(CPF4520)                                                    /*CDL021*/
             DLTOVR     FILE(SACEX)                                                       /*CDL021*/
             MONMSG     MSGID(CPF9841)                                                    /*CDL021*/
/*/COPY WNCPYSRC,DLC0801001                                          */
                RTVJOBA    SWS(&SWS)
/**/
             ENDDO
/**/
/*  REPORT BY BRANCH      */                                          /*S01117*/
             IF         COND(&RLEV *EQ 'B') THEN(DO)                  /*S01117*/
                                                                      /*S01117*/
       SNDMSG     MSG('ACCRUALS REPORT BY BRANCH')  TOMSGQ(MRUNQ)     /*S01117*/
/*/COPY WNCPYSRC,DLC0801004                                          */
             OVRDBF     FILE(SACEXL1) SHARE(*YES)                                         /*CDL021*/
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *NE '**' *AND +
                          &TYP1 *NE '  ') THEN(DO)                                        /*CDL021*/
/**********  OPNQRYF    FILE((SACEXL1 *FIRST ACCEXAOF)) +
                          FORMAT(SACEXL1 ACCEXAOF) QRYSLT('DTYP *EQ +
                          "'****&TYP1****'" & DLST *EQ "'****+
                                &TYP2****'" & CLAS *EQ "'****+
                          &TYP3****'" ') KEYFLD((BRCA) (RECI) (CCY) +
                          (RCDC) (DTYP) (DLST) (CLAS))           *****/ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((SACEXL1 *FIRST ACCEXAOF)) +
                          FORMAT(SACEXL1 ACCEXAOF) QRYSLT('DTYP *EQ +
                          "' *CAT &TYP1 *CAT '" & DLST *EQ "' *CAT +
                                &TYP2 *CAT '" & CLAS *EQ "' *CAT +
                          &TYP3 *CAT '" ') KEYFLD((BRCA) (RECI) (CCY) +
                          (RCDC) (DTYP) (DLST) (CLAS))                  /*CDL038*/ /*BG18886*/
/************OPNQRYF    FILE((SACEXL1 *FIRST ACCEXAOF)) +          ********************/  /*CDL038*/
/************             FORMAT(SACEXL1 ACCEXAOF) QRYSLT('DTYP *EQ********************/  /*CDL038*/
/************             "'****&TYP1****'" & DLST *EQ "'****+     ********************/  /*CDL038*/
/************             &TYP2****'" ') KEYFLD((BRCA) (RECI) (CCY)********************/  /*CDL038*/
/************             (RCDC) (DTYP) (DLST))                    *************CDL021*/  /*CDL038*/
             ENDDO                                                                        /*CDL021*/
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *EQ '**') +
                          THEN(DO)                                                        /*CDL021*/
/**********  OPNQRYF    FILE((SACEXL1 *FIRST ACCEXAOF)) +
                          FORMAT(SACEXL1 ACCEXAOF) QRYSLT('DTYP *EQ +
                          "'****&TYP1****'" ') KEYFLD((BRCA) (RECI) +
                          (CCY) (RCDC) (DTYP) (DLST) (CLAS))        ****/ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((SACEXL1 *FIRST ACCEXAOF)) +
                          FORMAT(SACEXL1 ACCEXAOF) QRYSLT('DTYP *EQ +
                          "' *CAT &TYP1 *CAT '" ') KEYFLD((BRCA) (RECI) +
                          (CCY) (RCDC) (DTYP) (DLST) (CLAS))              /*CDL038*/ /*BG18886*/
/************OPNQRYF    FILE((SACEXL1 *FIRST ACCEXAOF)) +          ********************/  /*CDL038*/
/************             FORMAT(SACEXL1 ACCEXAOF) QRYSLT('DTYP *EQ********************/  /*CDL038*/
/************             "' ***&TYP1*** '" ') KEYFLD((BRCA) (RECI)********************/  /*CDL038*/
/************             (CCY) (RCDC) (DTYP) (DLST))              *************CDL021*/  /*CDL038*/
             ENDDO                                                                        /*CDL021*/
/************** CALL       PGM(DL0521) PARM(&RSEQ &RENT) */                        /*S01117 CDL021*/
                CALL       PGM(DL0521) PARM(&RSEQ &RENT &PARMS)                           /*CDL021*/
/*/COPY WNCPYSRC,DLC0801002                                          */
                RTVJOBA    SWS(&SWS)                                  /*S01117*/
             CLOF       OPNID(SACEXL1)                                                    /*CDL021*/
             MONMSG     MSGID(CPF4520)                                                    /*CDL021*/
             DLTOVR     FILE(SACEXL1)                                                     /*CDL021*/
             MONMSG     MSGID(CPF9841)                                                    /*CDL021*/
                                                                      /*S01117*/
             ENDDO                                                    /*S01117*/
/*  REPORT BY COMPANY     */                                          /*S01117*/
             IF         COND(&RLEV *EQ 'C') THEN(DO)                  /*S01117*/
                                                                      /*S01117*/
       SNDMSG     MSG('ACCRUALS REPORT BY COMPANY')  TOMSGQ(MRUNQ)    /*S01117*/
             OVRDBF     FILE(SACEXL2) SHARE(*YES)                                         /*CDL021*/
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *NE '**' *AND +
                          &TYP1 *NE '  ') THEN(DO)                                        /*CDL021*/
/**********  OPNQRYF    FILE((SACEXL2 *FIRST ACCEXAOF)) +
                          FORMAT(SACEXL2 ACCEXAOF) QRYSLT('DTYP *EQ +
                          "'****&TYP1****'" & DLST *EQ "'****+
                                &TYP2****'" & CLAS *EQ "'****+
                          &TYP3****'" ') KEYFLD((CMPYM) (RECI) (CCY) +
                          (RCDC) (DTYP) (DLST) (CLAS))           *****/ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((SACEXL2 *FIRST ACCEXAOF)) +
                          FORMAT(SACEXL2 ACCEXAOF) QRYSLT('DTYP *EQ +
                          "' *CAT &TYP1 *CAT '" & DLST *EQ "' *CAT +
                                &TYP2 *CAT '" & CLAS *EQ "' *CAT +
                          &TYP3 *CAT '" ') KEYFLD((CMPYM) (RECI) (CCY) +
                          (RCDC) (DTYP) (DLST) (CLAS))                  /*CDL038*/ /*BG18886*/
/************OPNQRYF    FILE((SACEXL2 *FIRST ACCEXAOF)) +          ********************/  /*CDL038*/
/************             FORMAT(SACEXL2 ACCEXAOF) QRYSLT('DTYP *EQ********************/  /*CDL038*/
/************             "'****&TYP1****'" & DLST *EQ "'****+     ********************/  /*CDL038*/
/************             &TYP2****'" ') KEYFLD((CMPYM) (RECI) (CCY********************/  /*CDL038*/
/************             (RCDC) (DTYP) (DLST))                    *************CDL021*/  /*CDL038*/
             ENDDO                                                                        /*CDL021*/
             IF         COND(&TYP1 *NE '**' *AND &TYP2 *EQ '**') +
                          THEN(DO)                                                        /*CDL021*/
/************OPNQRYF    FILE((SACEXL2 *FIRST ACCEXAOF)) +              *****/ /*CDL038*/ /*BG18886*/
/************             FORMAT(SACEXL2 ACCEXAOF) QRYSLT('DTYP *EQ +  *****/ /*CDL038*/ /*BG18886*/
/************             "'****&TYP1****'" ') KEYFLD((CMPYM) (RECI) + *****/ /*CDL038*/ /*BG18886*/
/************             (CCY) (RCDC) (DTYP) (DLST) (CLAS))           *****/ /*CDL038*/ /*BG18886*/
             OPNQRYF    FILE((SACEXL2 *FIRST ACCEXAOF)) +
                          FORMAT(SACEXL2 ACCEXAOF) QRYSLT('DTYP *EQ +
                          "' *CAT &TYP1 *CAT '" ') KEYFLD((CMPYM) (RECI) +
                          (CCY) (RCDC) (DTYP) (DLST) (CLAS))                              /*CDL038*/
/************OPNQRYF    FILE((SACEXL2 *FIRST ACCEXAOF)) +             *****************/  /*CDL038*/
/************             FORMAT(SACEXL2 ACCEXAOF) QRYSLT('DTYP *EQ + *****************/  /*CDL038*/
/************             "'****&TYP1****'" ') KEYFLD((CMPYM) (RECI) +*****************/  /*CDL038*/
/************             (CCY) (RCDC) (DTYP) (DLST))                 **********CDL021*/  /*CDL038*/
             ENDDO                                                                        /*CDL021*/
/*************  CALL       PGM(DL0522) PARM(&RSEQ &RENT) */                        /*S01117 CDL021*/
                CALL       PGM(DL0522) PARM(&RSEQ &RENT &PARMS)                           /*CDL021*/
             CLOF       OPNID(SACEXL2)                                                    /*CDL021*/
             MONMSG     MSGID(CPF4520)                                                    /*CDL021*/
             DLTOVR     FILE(SACEXL2)                                                     /*CDL021*/
             MONMSG     MSGID(CPF9841)                                                    /*CDL021*/
/*/COPY WNCPYSRC,DLC0801003                                          */
                RTVJOBA    SWS(&SWS)                                  /*S01117*/
/**/                                                                  /*S01117*/
             ENDDO                                                    /*S01117*/
/*********** DLTOVR     FILE(TABLE)                                   /*S01194*/
/**/
/************IF*********COND(%SUBSTRING(&SWS 7 2) *EQ '11') +           S01440*/
/*************************THEN(SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ))        S01440*/
/************IF*********COND(%SUBSTRING(&SWS 7 2) *EQ '01') +           S01440*/
/*************************THEN(SNDMSG MSG(&MSG2) TOMSGQ(MOPERQ))        S01440*/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '11') THEN(DO)  /*S01440*/
               SNDMSG     MSG(&MSG1) TOMSGQ(MOPERQ)                   /*S01440*/
               GOTO       CMDLBL(ENDCLPGM)                            /*S10440*/
             ENDDO                                                    /*S01440*/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '01') THEN(DO)  /*S01440*/
               SNDMSG     MSG(&MSG2) TOMSGQ(MOPERQ)                   /*S01440*/
               GOTO       CMDLBL(ENDCLPGM)                            /*S01440*/
             ENDDO                                                    /*S01440*/
/*/COPY WNCPYSRC,DLC0801012                                          */
/**/                                                                  /*S01440*/
/* Access dealing I.C.D. file PF/SDDEALPD                               S01440*/
/**/                                                                  /*S01440*/
             CALL       PGM(AODEALR0) PARM(&RTCD &OPTN &FMT)          /*S01440*/
/**/                                                                  /*S01440*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S01440*/
              SNDPGMMSG  MSG('Error on access to ICD file SDDEALPD') +
                           TOMSGQ(MRUNQ MOPERQ)                       /*S01440*/
              CHGJOB     SWS(XXXXXX11)                                /*S01440*/
              GOTO       CMDLBL(ENDCLPGM)                             /*S01440*/
             ENDDO                                                    /*S01440*/
    /**/                                                              /*S01440*/
             CHGVAR     VAR(&BNAOIO) VALUE(%SST(&FMT 77 1))           /*S01440*/
/**/                                                                  /*S01440*/
/* If the 'Accruals on Interest Outrights file is 'Y''                /*S01440*/
/**/                                                                  /*S01440*/
             IF         COND(&BNAOIO *EQ 'Y') THEN(DO)                /*S01440*/
               CLRPFM     FILE(DLINTAPD)                              /*S01440*/
               OVRDBF     FILE(DLINTAPD) SEQONLY(*YES 100)            /*S01440*/
/**********    OVRDBF     FILE(TABLE)   TOFILE(TABDLEE)        *S01440* S01440*/
               SNDMSG     MSG('Interest Outright Accruals Extract') +
                          TOMSGQ(MRUNQ)                               /*S01440*/
               CALL       PGM(DL5000)                                 /*S01440*/
               DLTOVR     FILE(DLINTAPD)                              /*S01440*/
               RTVJOBA    SWS(&SWS)                                   /*S01440*/
/**/                                                                  /*S01440*/
/*  Report by system      */                                          /*S01440*/
/**/                                                                  /*S01440*/
               IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DO)                                    /*S01440*/
                                                                      /*S01440*/
                 SNDMSG     MSG('Interest Outright Accruals Report by +
                           System') TOMSGQ(MRUNQ)                     /*S01440*/
                 CALL       PGM(DL5001) PARM(&RSEQ)                   /*S01440*/
                 RTVJOBA    SWS(&SWS)                                 /*S01440*/
/**/                                                                  /*S01440*/
               ENDDO                                                  /*S01440*/
/**/                                                                  /*S01440*/
/*  Report by Branch      */                                          /*S01440*/
/**/                                                                  /*S01440*/
               IF         COND(&RLEV *EQ 'B') THEN(DO)                /*S01440*/
                                                                      /*S01440*/
                 SNDMSG     MSG('Interest Outright Accruals Report by +
                            Branch') TOMSGQ(MRUNQ)                    /*S01440*/
/**/                                                                  /*S01440*/
                 IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                            'ALL')) THEN(DO)                          /*S01440*/
                   OVRDBF     FILE(DLINTAL1) POSITION(*KEY 1 DLINTAD0 &RENT)
                   OPNDBF     FILE(DLINTAL1) OPTION(*ALL)             /*S01440*/
                   MONMSG     MSGID(CPF0000) EXEC(DO)                 /*S01440*/
                   DLTOVR FILE(DLINTAL1)                              /*S01440*/
                   ENDDO                                              /*S01440*/
                 ENDDO                                                /*S01440*/
                 CALL       PGM(DL5002) PARM(&RSEQ &RENT)             /*S01440*/
                 RTVJOBA    SWS(&SWS)                                 /*S01440*/
                 CLOF OPNID(DLINTAL1)                                 /*S01440*/
                 MONMSG     MSGID(CPF0000)                            /*S01440*/
                                                                      /*S01440*/
               ENDDO                                                  /*S01440*/
/**/                                                                  /*S01440*/
/*  Report by Company     */                                          /*S01440*/
/**/                                                                  /*S01440*/
               IF         COND(&RLEV *EQ 'C') THEN(DO)                /*S01440*/
                                                                      /*S01440*/
                 SNDMSG     MSG('Interest Outright Accruals Report by +
                            Company') TOMSGQ(MRUNQ)                   /*S01440*/
                 IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                            'ALL')) THEN(DO)                          /*S01440*/
                   OVRDBF     FILE(DLINTAL2) POSITION(*KEY 1 DLINTAD0 &RENT)
                   OPNDBF     FILE(DLINTAL2) OPTION(*ALL)             /*S01440*/
                   MONMSG     MSGID(CPF0000) EXEC(DO)                 /*S01440*/
                   DLTOVR FILE(DLINTAL2)                              /*S01440*/
                   ENDDO                                              /*S01440*/
                 ENDDO                                                /*S01440*/
                 CALL       PGM(DL5003) PARM(&RSEQ &RENT)             /*S01440*/
                 RTVJOBA    SWS(&SWS)                                 /*S01440*/
                 CLOF OPNID(DLINTAL2)                                 /*S01440*/
                 MONMSG     MSGID(CPF0000)                            /*S01440*/
/**/                                                                  /*S01440*/
               ENDDO                                                  /*S01440*/
             ENDDO                                                    /*S01440*/
/**/                                                                  /*S01440*/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '11') +
                          THEN(SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ))      /*S01440*/
/**/                                                                  /*S01440*/
ENDCLPGM:    CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             DLTOVR      FILE(*ALL)                                   /*S01440*/
 
/*/COPY WNCPYSRC,DLC0801END                                        */ /*S01408*/
 
             ENDPGM                                                   /*S01440*/
/**/                                                                  /*S01440*/
/************ENDPGM*/                                                 /*S01440*/
