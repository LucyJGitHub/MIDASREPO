/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Input cycle confirmation print')             */
/********************************************************************/
/*                                                                  */
/*  Midas - Securities Trading Module                               */
/*                                                                  */
/*  SEC0304 - INPUT CYCLE CONFIRMATION PRINT                        */
/*                                                                  */
/*       Function: To generate the Paper Confirmations for Trades,  */
/*                 (including Bulk Input), and Depot Movements.     */
/*                 Also to generate MT5XX SE S.W.I.F.T. Messages if */
/*                 the Switchable Feature, S01401, is present.      */
/*                                                                  */
/*       1) Submitted by SEC02 in Input Cycle;                      */
/*       2) Run during I/C Termination.                             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. 261402             Date 11May16              */
/*                      CCB023             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG8853            Date 10Oct05              */
/*                      CGP001             Date 23May03              */
/*                      CSW203             Date 26May03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205448             Date 02May02              */
/*                      CCG015             Date 09Aug01              */
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE017             Date 20Oct99              */
/*                      CSE006             Date 27Jul99             */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CSW098             Date 01MAY98             */
/*                      103511             DATE 22MAY96             */
/*                      100018             DATE 24MAY96             */
/*                      095130             DATE 26OCT95             */
/*                      088442             DATE 31MAY95             */
/*                      086141             DATE 02MAR95             */
/*                      081938             DATE 30JAN95             */
/*                      S01522             DATE 12JAN95             */
/*                      S01502             DATE 08JUL94             */
/*                      S01401             DATE 16JUN93             */
/*                      E28925             DATE 27SEP91             */
/*                      E28924             DATE 27SEP91             */
/*                      S01117             DATE 10DEC90             */
/*                      S01271             DATE 08JUN90             */
/*                      E16870             DATE 08MAY89             */
/*                      E16903             DATE 08FEB89             */
/*                      S01179             DATE 23OCT88             */
/*                      S01169             DATE 07AUG88             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       261402 - Duplicate records in MGF51NPD after restart of     */
/*                SEC05.                                             */
/*              - Applied for MD-37893.                              */
/*  CCB023 - COB Restructure - Input Cycle Termination              */
/*           Restructuring                                          */
/*  BUG8853- Ensure error processing is performed after calling     */
/*           CGC3605.                                               */
/*  CGP001 - Global Processing                                      */
/*  CSW203 - SWIFT 2003 Standards Update                            */
/*  205448 - UDC module must be on for Correspondence Manager       */
/*  CCG015 - Correspondence Manager Phase 1                         */
/*  CSC011 - 24x7 Midas Availability                                */
/*  CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)       */
/*  CSE006 - Repurchase agreement (Repo) enhancement.  New program  */
/*           SE4110 (Buy-Sell Backs Confirmation Print) called.     */
/*  CPK009 - Packaging for DBA3 release. STRCMTCTL values set       */
/*                to CMTSCOPE(*JOB).                                */
/*  CSW098 - SWIFT 1998 changes.                                    */
/*  103511 - Commitment control error due to MG9510                 */
/*  100018 - Override TRADSDY1 SHARE(*NO). This will allow the file */
/*           to be used by two pgms at the same time. Error is      */
/*           caused by 089717.                                      */
/*  095130 - Only call CGC5217 if UDC switched on.                  */
/*  088442 - Standard format confirmations produced for items       */
/*           which should be UDC.                                   */
/*            o Override xxxCONF to xxxCONFS (which select only     */
/*              items suppressed by UDC) before calling standard    */
/*              confirmation program.                               */
/*  086141 - Reclaim resources after CG4300                         */
/*  081938 - Reclaim resources after CG4200                         */
/*  S01522 - USER DEFINED CORRESPONDENCE                            */
/*  S01502 - BLI Telekurs Processing.  Recompiled due to            */
/*           change in length of SESTAT, 133 long.                  */
/*  S01401 - Generate S.W.I.F.T. Confirmation Messages if           */
/*           MT5xx Feature switched on.                             */
/*  E28925 - Should delete override to TRADF only once if the file  */
/*           cannot be positioned to the branch and there is a      */
/*           database error.                                        */
/*  E28924 - Confirmations active indicator on SESTAT should be     */
/*           reset if the program ends in error.                    */
/*  S01117 - MULTIBRANCHING                                         */
/*  S01271 - PAY RECEIVE IN INPUT CYCLE - PREVENT FILE LOCKS        */
/*           WITH I/C PAY/RECEIVES ( & OTHER CONFIRMATION           */
/*           PRINTS IN INPUT CYCLE).  (ALSO MAKE COMMENTED          */
/*           OUT CODE MORE CLEAR).                                  */
/*  E16903 - SESTAT REDEFINED AS 128 BYTES.                         */
/*  E16903 - AUTOSETTLEMENT INDICATOR NOT REQUIRED, BULK            */
/*           INPUT IND. REQUIRED FOR SE3005.                        */
/*  S01179 - ABS INCORPORATION                                      */
/*  S01169 - SECURITIES TRADING (BAER INCORPORATION)                */
/*                                                                  */
/********************************************************************/
/************PGM                                                     * *S01117*/
                                                                      /*S01401*/
/***  (Sequence Number is not required as Reports are mandatory) ***/ /*S01401*/
                                                                      /*S01401*/
/*********** PGM        PARM(&RSEQ &RLEV &RENT)             /*S01117*  *S01401*/
             PGM                                                      /*S01401*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/*********** DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)      /*S01117*/ /*S01401*/
             DCL (&RSEQ) TYPE(*CHAR) LEN(5) VALUE('     ')            /*S01401*/
/*********** DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)      /*S01117*/ /*S01401*/
/*********** DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)      /*S01117*/ /*S01401*/
/*           DCL VAR(&MEM)    TYPE(*CHAR) LEN(44)                  */ /*S01117*/
             DCL VAR(&MEM)    TYPE(*CHAR) LEN(50)                     /*S01117*/
             DCL VAR(&PARM1) TYPE(*CHAR) LEN(1)                      /*S01169*/
             DCL VAR(&MSG) TYPE(*CHAR) LEN(70)                        /*S01401*/
             DCL VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')            /*S01401*/
             DCL VAR(&S01401) TYPE(*CHAR) LEN(1) VALUE(' ')           /*S01401*/
             DCL VAR(&CSW098) TYPE(*CHAR) LEN(7)                      /*CSW098*/
             DCL VAR(&ICTERM) TYPE(*CHAR) LEN(1) VALUE('N')           /*S01401*/
             DCL VAR(&CSE006) TYPE(*CHAR) LEN(1) VALUE(' ')           /*CSE006*/
                                                                      /*S01401*/
/***  Fields to call SF0410 to identify Mult Lang prefix;  ***/       /*S01401*/
/***  (&MIDASLG and &MULT only ones used).                 ***/       /*S01401*/
                                                                      /*S01401*/
             DCL VAR(&MIDASLG) TYPE(*CHAR) LEN(10)                    /*S01401*/
             DCL VAR(&MULT) TYPE(*CHAR) LEN(2)                        /*S01401*/
             DCL VAR(&GROUP) TYPE(*CHAR) LEN(50)                      /*S01401*/
             DCL VAR(&USER) TYPE(*CHAR) LEN(25)                       /*S01401*/
             DCL VAR(&SLEVEL) TYPE(*DEC) LEN(4)                       /*S01401*/
             DCL VAR(&TIMEO) TYPE(*DEC) LEN(5)                        /*S01401*/
             DCL VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)              /*S01401*/
             DCL VAR(&FMT)    TYPE(*CHAR) LEN(200)                    /*S01522*/
             DCL VAR(&UDC)    TYPE(*CHAR) LEN(1)                      /*S01522*/
             DCL VAR(&W0RTN)  TYPE(*CHAR) LEN(7)                      /*S01522*/
             DCL VAR(&W0CMT)  TYPE(*CHAR) LEN(3) VALUE('YES')         /*S01522*/
             DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)            /*086141*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
/**/
/*           DCLDTAARA DTAARA(LDA)                                  *  *S01179*/
/*           DCLDTAARA DTAARA(SESTAT)                    */ /* S01169* +
*S01179*/
             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256)              /*S01179*/
/*           DCL        VAR(&SESTAT)   TYPE(*CHAR)  LEN(256)    /*S01179E16870*/
/************DCL        VAR(&SESTAT)   TYPE(*CHAR)  LEN(128)*/ /*E16870 S01502*/
             DCL        VAR(&SESTAT)   TYPE(*CHAR)  LEN(133)          /*S01502*/
/**********  DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE(' ') */              /*CSC011 CCB023*/
/**********  DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)             */              /*CSC011 CCB023*/
/**********  DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)             */              /*CSC011 CCB023*/
/**********  DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)          */              /*CSC011 CCB023*/
/**********  DCL        VAR(&S1SUPP) TYPE(*CHAR) LEN(2) VALUE(' ') */              /*CSC011 CCB023*/
/**********  DCL        VAR(&LIBR) TYPE(*CHAR) LEN(2) VALUE(' ')   */              /*CSC011 CCB023*/
                                                                                          /*CSC011*/
/*/COPY WNCPYSRC,SEC0304003                                          */
/**/
             MONMSG (CPF0000 RPG0000 MCH0000) EXEC(GOTO (ERROR))      /*S01401*/
             CHGVAR     VAR(&MSG) VALUE('SEC0304 - Processing error') /*S01522*/
                                                                      /*S01401*/
/**Check*if*switchable*feature*CSC011*is*on**/                                     /*CSC011 CCB023*/
                                                                                          /*CSC011*/
/**********  CHGVAR     VAR(&PRTCD) VALUE('       ')               */              /*CSC011 CCB023*/
/**********  CHGVAR     VAR(&POPTN) VALUE('*VERIFY')               */              /*CSC011 CCB023*/
/**********  CHGVAR     VAR(&PSARD) VALUE('CSC011')                */              /*CSC011 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD +
/**********               &SCSARD)                                 */              /*CSC011 CCB023*/
/**********  IF         COND(&PRTCD *EQ '       ') THEN(DO)        */              /*CSC011 CCB023*/
/**********  CHGVAR     VAR(&CSC011) VALUE('Y')                    */              /*CSC011 CCB023*/
/**********  RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&S1SUPP)       */              /*CSC011 CCB023*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBR)         */              /*CSC011 CCB023*/
/**********  ENDDO                                                 */              /*CSC011 CCB023*/
                                                                                          /*CSC011*/
/**********  IF         COND((&CSC011 *EQ 'Y') *AND (&S1SUPP *EQ +
                &LIBR)) THEN(DO)                                   */              /*CSC011 CCB023*/
/**********       SNDPGMMSG  MSG('Confirmation requested, but not +
                     valid on the support system') TOPGMQ(*EXT) +
                     TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)           */              /*CSC011 CCB023*/
/**********       GOTO       CMDLBL(END)                           */              /*CSC011 CCB023*/
/**********  ENDDO                                                 */              /*CSC011 CCB023*/
                                                                                          /*CSC011*/
/***  Attempt to Start Commitment Control. If unable to start  ***/   /*S01401*/
/***  it because it is already active, then indicate that the  ***/   /*S01401*/
/***  program is running in I/C Termination.                   ***/   /*S01401*/
                                                                      /*S01401*/
/************STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))      /*S01401 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG (CPF8351) EXEC(CHGVAR (&ICTERM) VALUE('Y'))       /*S01401*/
                                                                      /*S01401*/
/***  Override message file, MIDAS, to correct language file  ***/    /*S01401*/
                                                                      /*S01401*/
             CALL (SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                &ERRORC &MULT)                                        /*S01401*/
             IF (&MULT *EQ '  ') (CHGVAR (&MULT) VALUE('GB'))         /*S01401*/
             CHGVAR (&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')         /*S01401*/
             OVRMSGF MSGF(MIDAS) TOMSGF(&MIDASLG)                     /*S01401*/
             CHGVAR     VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ') /*086141*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)              /*086141*/
                                                                      /*S01401*/
/***  Create LDA  ***/                                                /*S01401*/
                                                                      /*S01401*/
             CRTDTAARA (QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                TEXT('MIDAS SD AS400 LOCAL DATA AREA EQUIVALENT')     /*S01401*/
             MONMSG (CPF0000)                                         /*S01401*/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/*           RCVDTAARA DTAARA(SESTAT)                     *  *S01169*  *S01179*/
/*/COPY WNCPYSRC,SEC0304004                                          */
                                                                      /*S01401*/
/***  Access SESTAT, position 61, for Bulk Input Option  ***/         /*S01401*/
                                                                      /*S01401*/
             RTVDTAARA DTAARA(SESTAT) RTNVAR(&SESTAT)                 /*S01179*/
/**/
/*           CHGVAR     VAR(&PARM1) VALUE(%SST(&SESTAT 62 1))*S01169*  *E16903*/
             CHGVAR     VAR(&PARM1) VALUE(%SST(&SESTAT 61 1))         /*E16903*/
 
 
/*  CONFIRMATIONS CANNOT BE RUN IF THEY ARE ALREADY BEING      */     /*S01271*/
/*  PRINTED.                                                   */     /*S01271*/
/***                                                           */     /*S01271*/
/*********** IF    COND(%SUBSTRING(&SESTAT 73 1) *EQ 'Y') +           /*S01401*/
/*********** THEN(+                                                   /*S01401*/
/***********    SNDPGMMSG  MSG('CONFIRMATIONS PRINT REQUESTED +       /*S01401*/
/***********                    BUT ALREADY ACTIVE') +                /*S01401*/
/***********               TOPGMQ(*EXT) MSGTYPE(*INFO))    /*S01271*/ /*S01401*/
/*********** ELSE DO                                       /*S01271*/ /*S01401*/
             IF (%SUBSTRING(&SESTAT 73 1) *EQ 'Y') THEN(DO)           /*S01401*/
               SNDPGMMSG ('Confirmations Print requested but +
                          already active - JOB CANNOT BE RUN.') +
                          TOPGMQ(*EXT) MSGTYPE(*INFO)                 /*S01401*/
               GOTO (END)                                             /*S01401*/
             ENDDO                                                    /*S01401*/
                                                                      /*S01271*/
/*  CONFIRMATIONS CANNOT BE RUN IF PAY/RECEIVES ARE RUNNING    */     /*S01271*/
/*  AS FILES WILL NOT BE AVAILABLE.                            */     /*S01271*/
                                                                      /*S01271*/
/*********** RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)     /*S01271*/ /*S01401*/
/*********** IF    COND(%SUBSTRING(&SESTAT 74 1) *EQ 'Y') +           /*S01401*/
/*********** THEN(+                                                   /*S01401*/
/*********** SNDPGMMSG  MSG('CONFIRMATIONS CANNOT BE RUN AS +         /*S01401*/
/***********                 PAY/RECEIVES ARE ACTIVE') +              /*S01401*/
/***********            TOPGMQ(*EXT) MSGTYPE(*INFO))       /*S01271*/ /*S01401*/
/***********                                               /*S01271*/ /*S01401*/
/*********** ELSE DO                                       /*S01271*/ /*S01401*/
             IF (%SUBSTRING(&SESTAT 74 1) *EQ 'Y') THEN(DO)           /*S01401*/
               SNDPGMMSG ('Confirmations Print requested but Pay/+
                          Receives active - JOB CANNOT BE RUN.') +
                          TOPGMQ(*EXT) MSGTYPE(*INFO)                 /*S01401*/
               GOTO (END)                                             /*S01401*/
             ENDDO                                                    /*S01401*/
                                                                      /*S01271*/
/*  ALLOCATE SESTAT, INDICATE CONFIRMATION PRINT IS ACTIVE  */        /*S01271*/
/*  AND THEN DEALLOCATE.                                    */        /*S01271*/
                                                                      /*S01271*/
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))                 /*S01271*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*S01271*/
             CHGVAR     VAR(%SUBSTRING(&SESTAT 73 1)) VALUE('Y')      /*S01271*/
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)                 /*S01271*/
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))                 /*S01271*/
                                                                      /*S01271*/
/**/
             SNDPGMMSG  MSG('Input Cycle Confirmation Print') +
                          TOMSGQ(MRUNQ)
/**/
/*        IF COND((&PARM1) *EQ 'Y') THEN(DO)                 *S01179*  *E16903*/
/*********** CHGJOB     SWS(00000000)                                 /*S01401*/
/***********                                                          /*S01401*/
/********POSITION*FILE*TO*THE*PARTICULAR*BRANCH********** * *S01117*/ /*S01401*/
/*********** IF         COND((&RENT *NE '   ') *AND (&RENT *NE +      /*S01401*/
/***********              'ALL')) THEN(DO)                 /*S01117*/ /*S01401*/
/*********** OVRDBF     FILE(TRDCONF) +                    /*S01117*/ /*S01401*/
/***********               POSITION(*KEY 1 TRADSDF &RENT)  /*S01117*/ /*S01401*/
/*********** OPNDBF     FILE(TRDCONF) OPTION(*ALL)         /*S01117*/ /*S01401*/
/*********** MONMSG     MSGID(CPF0000) EXEC(DO)            /*S01117*/ /*S01401*/
/*********** DLTOVR     FILE(TRDCONF)                      /*S01117*/ /*S01401*/
/*********** ENDDO                                         /*S01117*/ /*S01401*/
/*********** CLOF       OPNID(TRDCONF)                     /*S01117*/ /*S01401*/
/*********** MONMSG     MSGID(CPF0000)                     /*S01117*/ /*S01401*/
/*********** ENDDO                                         /*S01117*/ /*S01401*/
/************CALL       PGM(SE0550)                                  * *S01117*/
/*********** CALL       PGM(SE0550) PARM(&RSEQ &RENT)      /*S01117*/ /*S01401*/
/***********                                                          /*S01401*/
/***ABNORMAL*TERMINATION*MESSAGE*-*DATABASE*ERROR***************** */ /*S01401*/
/***********                                                          /*S01401*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01401*/
/*           RCVDTAARA  DTAARA(LDA)                                 *  *S01179*/
/*********** RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)           /*S01179*/ /*S01401*/
/*           CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))         */ /*S01117*/
/*********** CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50)) /*S01117*/ /*S01401*/
/*********** SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +     /*S01401*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01401*/
/*********** SNDPGMMSG MSG('(SE0550) - Database Error') TOPGMQ(*EXT) +/*S01401*/
/***********              TOMSGQ(MOPERQ MRUNQ)                        /*S01401*/
/*********** GOTO ENDPGM                                              /*S01401*/
/*********** ENDDO                                                    /*S01401*/
/*           ENDDO                                          *S01179*  *E16903*/
/***********                                                          /*S01401*/
/*        IF COND((&PARM1) *EQ 'Y') THEN(DO)                *S01169*  *E16903*/
/********POSITION*FILE*TO*THE*PARTICULAR*BRANCH********** * *S01117*/ /*S01401*/
/*********** IF         COND((&RENT *NE '   ') *AND (&RENT *NE +      /*S01401*/
/***********              'ALL')) THEN(DO)                 /*S01117*/ /*S01401*/
/*********** OVRDBF     FILE(DPTCONF) +                    /*S01117*/ /*S01401*/
/***********               POSITION(*KEY 1 DPTMVDF &RENT)  /*S01117*/ /*S01401*/
/*********** OPNDBF     FILE(DPTCONF) OPTION(*ALL)         /*S01117*/ /*S01401*/
/*********** MONMSG     MSGID(CPF0000) EXEC(DO)            /*S01117*/ /*S01401*/
/*********** DLTOVR     FILE(DPTCONF)                      /*S01117*/ /*S01401*/
/*********** ENDDO                                         /*S01117*/ /*S01401*/
/*********** CLOF       OPNID(DPTCONF)                     /*S01117*/ /*S01401*/
/*********** MONMSG     MSGID(CPF0000)                     /*S01117*/ /*S01401*/
/*********** ENDDO                                         /*S01117*/ /*S01401*/
/************CALL       PGM(SE0560)                                  * *S01117*/
/*********** CALL       PGM(SE0560) PARM(&RSEQ &RENT)      /*S01117*/ /*S01401*/
/***********                                                          /*S01401*/
/***ABNORMAL*TERMINATION*MESSAGE*-*DATABASE*ERROR***************** */ /*S01401*/
/***********                                                          /*S01401*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01401*/
/*           RCVDTAARA  DTAARA(LDA)                                 *  *S01179*/
/*********** RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)           /*S01179*/ /*S01401*/
/*           CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))         */ /*S01117*/
/*********** CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50)) /*S01117*/ /*S01401*/
/*********** SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +     /*S01401*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01401*/
/*********** SNDPGMMSG MSG('(SE0560) - Database Error') TOPGMQ(*EXT) +/*S01401*/
/***********              TOMSGQ(MOPERQ MRUNQ)                        /*S01401*/
/*********** ENDDO                                                    /*S01401*/
/*           ENDDO                                                   /*E16903*/
/***********                                               /*S01169*/ /*S01401*/
/*********** IF COND((&PARM1) *EQ 'Y') THEN(DO)          /*  S01169*/ /*S01401*/
/****BULK*TRANSACTIONS*CONFIRMATIONS********************** /*S01169*/ /*S01401*/
/*********** CHGJOB     SWS(00000000)                      /*S01169*/ /*S01401*/
/***********                                                         /*S01169*/
/********POSITION*FILE*TO*THE*PARTICULAR*BRANCH********** * *S01117*/ /*S01401*/
/*********** IF         COND((&RENT *NE '   ') *AND (&RENT *NE +      /*S01401*/
/***********              'ALL')) THEN(DO)                 /*S01117*/ /*S01401*/
/************OVRDBF     FILE(TRADF) NBRRCDS(1) SEQONLY(*YES 1)*S01169* *S01117*/
/*********** OVRDBF     FILE(TRADF) POSITION(*KEY 1 TRADSDF &RENT) +  /*S01401*/
/***********              NBRRCDS(1) SEQONLY(*YES 1)       /*S01117*/ /*S01401*/
/*********** OPNDBF     FILE(TRADF) OPTION(*ALL)           /*S01117*/ /*S01401*/
/*********** MONMSG     MSGID(CPF0000) EXEC(DO)            /*S01117*/ /*S01401*/
/*********** DLTOVR     FILE(TRADF)                        /*S01117*/ /*S01401*/
/*********** ENDDO                                         /*S01117*/ /*S01401*/
/*********** CLOF       OPNID(TRADF)                       /*S01117*/ /*S01401*/
/*********** MONMSG     MSGID(CPF0000)                     /*S01117*/ /*S01401*/
/*********** ENDDO                                         /*S01117*/ /*S01401*/
/************CALL       PGM(SE3005)                           *S01169* *S01117*/
/*********** CALL       PGM(SE3005) PARM(&RSEQ &RENT)      /*S01117*/ /*S01401*/
/***********                                               /*S01169*/ /*S01401*/
/***ABNORMAL*TERMINATION*MESSAGE*-*DATABASE*ERROR******* *  *S01169*/ /*S01401*/
/***********                                               /*S01169*/ /*S01401*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)   /*S01169*/ /*S01401*/
/*           RCVDTAARA  DTAARA(LDA)                      *  *S01169*/ /* +
S01179*/
/*********** RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)           /*S01179*/ /*S01401*/
/*           CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))         */ /*S01117*/
/*********** CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50)) /*S01117*/ /*S01401*/
/*********** SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +     /*S01401*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)/*S01169*/ /*S01401*/
/*********** SNDPGMMSG ('(SE3005) - Database Error') TOPGMQ(*EXT) +   /*S01401*/
/***********              TOMSGQ(MOPERQ MRUNQ)                        /*S01401*/
/************GOTO ENDPGM                                             /*E28924*/
/*********** GOTO STATUS                                   /*E28924*/ /*S01401*/
/*********** ENDDO                                                    /*S01401*/
/***********                                                          /*S01401*/
/*********** DLTOVR TRADF                                             /*S01401*/
/*********** MONMSG     MSGID(CPF0000)                     /*E28925*/ /*S01401*/
/*********** ENDDO                                         /*S01169*/ /*S01401*/
/**/                                                                  /*S01401*/
/***  Access Switchable Features file to see if MT5XX present  ***/   /*S01401*/
                                                                      /*S01401*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'S01401')          /*S01401*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&S01401) VALUE('Y'))        /*S01401*/
/**/                                                                  /*CSW098*/
/*    Check if CSW098 enhancement is present or date is after    */   /*CSW098*/
/*    16th October 1998.                                         */   /*CSW098*/
                                                                      /*CSW098*/
             CALL       PGM(SWIFT98) PARM(&CSW098)                    /*CSW098*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*CSW098*/
             CHGVAR     VAR(&MSG) VALUE('SWIFT98 - I/C SWIFT98 +
                          Enhancment check failed')                   /*CSW098*/
                  GOTO (ERROR)                                        /*CSW098*/
               ENDDO                                                  /*CSW098*/
                                                                      /*CSW098*/
/***  Access Switchable Features file to see if CSE006 is present **/ /*CSE006*/
                                                                      /*CSE006*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSE006')          /*CSE006*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSE006) VALUE('Y'))        /*CSE006*/
/**/                                                                  /*CSE006*/
/* */                                                                 /*S01522*/
/* User Defined Correspondence processing  */                         /*S01522*/
/* */                                                                 /*S01522*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                  /*S01522*/
/* */                                                                 /*S01522*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*S01522*/
/* */                                                                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&PRTCD '*FIRST ' &FMT)     /*S01522*/
/* */                                                                 /*S01522*/
/** Database error handling                                           /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(&PRTCD *NE '       ') THEN(DO)           /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('SEC0304 - Error on access to +
                          SDMMODPD')                                  /*S01522*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
             CHGVAR (&UDC) VALUE('Y')                                 /*S01522*/
             ENDDO                                                    /*S01522*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(&UDC *EQ 'Y') THEN(DO)                                       /*205448*/
/** Call Extract File Instance Management */                                              /*CCG015*/
                CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
                                                                      /*S01401*/
/***  Restart Recovery Processing.  ***/                              /*S01401*/
                                                                      /*S01401*/
             IF (%SST(&SESTAT 76 1) *EQ 'A') (GOTO TAGA)              /*S01401*/
             IF (%SST(&SESTAT 76 1) *EQ 'B') (GOTO TAGB)              /*S01401*/
             IF (%SST(&SESTAT 76 1) *EQ 'C') (GOTO TAGC)              /*S01401*/
             IF (%SST(&SESTAT 76 1) *EQ 'D') (GOTO TAGD)              /*S01401*/
             IF (%SST(&SESTAT 76 1) *EQ 'E') (GOTO TAGE)              /*S01401*/
             IF (%SST(&SESTAT 76 1) *EQ 'F') (GOTO TAGF)              /*S01401*/
/*/COPY WNCPYSRC,SEC0304001                                          */
                                                                      /*S01401*/
TAGA:        CHGDTAARA (SESTAT (76 1)) VALUE('A')                     /*S01401*/
                                                                      /*S01401*/
/***  If MT5XX messages Feature present...                       ***/ /*S01401*/
/***  Call the Extract pgms; handle Database Error if needed.    ***/ /*S01401*/
/***  NB. Extracting for MT5XX messages must happen before the   ***/ /*S01401*/
/***  Paper Confirmations are processed in order to enable       ***/ /*S01401*/
/***  'DO NOT SEND OUT' to be printed on a Confirmations if the  ***/ /*S01401*/
/***  corresponding S.W.I.F.T. Message is also being generated.  ***/ /*S01401*/
                                                                      /*S01401*/
             IF (&S01401 *EQ 'Y') THEN(DO)                            /*S01401*/
               OVRDBF (MGOREFL0) SHARE(*NO)                           /*S01401*/
                                                                      /*100018*/
               OVRDBF (TRADSDY1) SHARE(*NO)                           /*100018*/
                                                                      /*S01401*/
             IF         COND(&CSW098 *EQ 'CSW098 ') THEN(DO)          /*CSW098*/
               CALL (SE1875) PARM(&RSEQ)                              /*CSW098*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*CSW098*/
                  CHGVAR (&MSG) VALUE('SE1875 - I/C SWIFT Trade +
                     Confirmations Extract failed')                   /*CSW098*/
                  GOTO (ERROR)                                        /*CSW098*/
               ENDDO                                                  /*CSW098*/
                                                                      /*CSW098*/
             OVRDBF     FILE(DPTMVDY1) SHARE(*NO)                     /*CSW098*/
               CALL (SE1876) PARM(&ICTERM)                            /*CSW098*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*CSW098*/
                  CHGVAR (&MSG) VALUE('SE1876 - I/C SWIFT Trade +
                     Confirmations Extract failed')                   /*CSW098*/
                  GOTO (ERROR)                                        /*CSW098*/
               ENDDO                                                  /*CSW098*/
              ENDDO                                                   /*CSW098*/
              ELSE       CMD(DO)                                      /*CSW098*/
               CALL (SE1870) PARM(&RSEQ)                              /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 CHGVAR (&MSG) VALUE('SE1870 - I/C SWIFT Trade +
                    Confirmations Extract failed')                    /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
               OVRDBF (DPTMVDY1) SHARE(*NO)                           /*103511*/
                                                                      /*103511*/
               CALL (SE1872) PARM(&ICTERM)                            /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 CHGVAR (&MSG) VALUE('SE1872 - I/C SWIFT Depot +
                    Movement Confirmations Extract failed')           /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
                                                                      /*S01401*/
               ENDDO                                                  /*S01401*/
              ENDDO                                                   /*CSW098*/
               DLTOVR     FILE(MGOREFL0)                              /*S01401*/
             ENDDO                                                    /*S01401*/
                                                                      /*S01401*/
TAGB:        CHGDTAARA (SESTAT (76 1)) VALUE('B')                     /*S01401*/
                                                                      /*S01401*/
/***  Call the Trade Confirmations Print  ***/                        /*S01401*/
                                                                      /*S01401*/
             OVRDBF     FILE(TRDCONF) SHARE(*NO)                      /*S01522*/
             IF         COND(&UDC *EQ 'Y') THEN(DO)                   /*S01522*/
             CALL       PGM(CG4200) PARM(&W0RTN &W0CMT)               /*S01522*/
/*********** RCLRSC                                 ***/  /*081938*/  /*CGP001*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('CG4200 - User Defined +
                          Correspondence Extract failure')            /*S01522*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
 
/* 088442 - Ensure only items suppressed by UDC are processed by   */ /*088442*/
/* SE0550 if UDC switched on.                                      */ /*088442*/
/*           OVRDBF     FILE(TRDCONF) TOFILE(TRDCONFS)    /*088442*/  /*CSE006*/
             OVRDBF     FILE(TRDCONF) TOFILE(TRDCONFS) SHARE(*NO)     /*CSE006*/
             ENDDO                                                    /*S01522*/
                                                                      /*S01522*/
             CALL (SE0550) PARM(&RSEQ 'ALL')                          /*S01401*/
             IF (%SWITCH(XXXXXX11)) THEN(DO)                          /*S01401*/
               CHGVAR (&MSG) VALUE('SE0550 - I/C Trade +
                  Confirmations Print failed')                        /*S01401*/
               GOTO (ERROR)                                           /*S01401*/
             ENDDO                                                    /*S01401*/
                                                                      /*CSE006*/
/***  Call the Buy-Sell Backs Confirmations Print  ***/               /*CSE006*/
             IF (&CSE006 *EQ 'Y') THEN(DO)                            /*CSE006*/
               CHGVAR (&RSEQ) VALUE('     ')                          /*CSE006*/
             CALL (SE4110) PARM(&RSEQ 'ALL')                          /*CSE006*/
             IF (%SWITCH(XXXXXX11)) THEN(DO)                          /*CSE006*/
               CHGVAR (&MSG) VALUE('SE4110 - I/C Buy-Sell Backs +
                  Confirmations Print failed')                        /*CSE006*/
               GOTO (ERROR)                                           /*CSE006*/
             ENDDO                                                    /*CSE006*/
             ENDDO                                                    /*CSE006*/
                                                                      /*S01401*/
TAGC:        CHGDTAARA (SESTAT (76 1)) VALUE('C')                     /*S01401*/
                                                                      /*S01401*/
/***  Call the Depot Movement Confirmations Print  ***/               /*S01401*/
                                                                      /*S01401*/
             OVRDBF     FILE(DPTCONF) SHARE(*NO)                      /*S01522*/
             IF         COND(&UDC *EQ 'Y') THEN(DO)                   /*S01522*/
             CALL       PGM(CG4300) PARM(&W0RTN &W0CMT)               /*S01522*/
/*********** RCLRSC                             ***/       /*086141*/ /*CGP001*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('CG4300 - User Defined +
                          Correspondence Extract failure')            /*S01522*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
 
/* 088442 - Ensure only items suppressed by UDC are processed by   */ /*088442*/
/* SE0560 if UDC switched on.                                      */ /*088442*/
             OVRDBF     FILE(DPTCONF) TOFILE(DPTCONFS)                /*088442*/
             ENDDO                                                    /*S01522*/
                                                                      /*S01522*/
               CHGVAR (&RSEQ) VALUE('     ')                          /*CSE006*/
             CALL (SE0560) PARM(&RSEQ 'ALL')                          /*S01401*/
             IF (%SWITCH(XXXXXX11)) THEN(DO)                          /*S01401*/
               CHGVAR (&MSG) VALUE('SE0560 - I/C Depot +
                  Movement Confirmations Print failed')               /*S01401*/
               GOTO (ERROR)                                           /*S01401*/
             ENDDO                                                    /*S01401*/
                                                                      /*CGP001*/
             RCLRSC                                                   /*CGP001*/
                                                                      /*S01401*/
TAGD:        CHGDTAARA (SESTAT (76 1)) VALUE('D')                     /*S01401*/
                                                                      /*S01401*/
/***  If the Bulk Input Option is present in the System, Call  ***/   /*S01401*/
/***  the Bulk Trade Confirmations Print.                      ***/   /*S01401*/
                                                                      /*S01401*/
             IF ((&PARM1) *EQ 'Y') THEN(DO)                           /*S01401*/
               CALL (SE3005) PARM(&RSEQ 'ALL')                        /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 CHGVAR (&MSG) VALUE('SE3005 - I/C Bulk Trade +
                    Confirmations Print failed')                      /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
             ENDDO                                                    /*S01401*/
                                                                      /*S01401*/
TAGE:        CHGDTAARA (SESTAT (76 1)) VALUE('E')                     /*S01401*/
                                                                      /*S01401*/
/***  If MT5XX Feature present then generate MT510 Messages  ***/     /*S01401*/
                                                                      /*S01401*/
             IF (&S01401 *EQ 'Y') THEN(DO)                            /*S01401*/
             IF         COND(&CSW098 *NE 'CSW098 ') THEN(DO)          /*CSW098*/
                                                                      /*CSW098*/
               OVRDBF (MGF579PD) SHARE(*NO)                           /*S01401*/
               CALL (MG0510)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 CHGVAR (&MSG) VALUE('MG0510 - I/C SWIFT Trade +
                    Confirmation MT510 Generation failed')            /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
               DLTOVR (MGF579PD)                                      /*S01401*/
               ENDDO                                                  /*CSW098*/
                                                                      /*CSW098*/
              ELSE       CMD(DO)                                      /*CSW098*/
             OVRDBF     FILE(MGF51NPD) SHARE(*NO)                     /*CSW098*/
               OVRDBF (TRADSDY1) SHARE(*NO)                                               /*CSW203*/
               CALL (MG051N)                                          /*CSW098*/
               DLTOVR (MGF51NPD)                                      /*CSW098*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*CSW098*/
                 CHGVAR (&MSG) VALUE('MG051N - I/C SWIFT Trade +
                    Confirmation MT51N Generation failed')            /*CSW098*/
                 GOTO (ERROR)                                         /*CSW098*/
               ENDDO                                                  /*CSW098*/
               ENDDO                                                  /*CSW098*/
             ENDDO                                                    /*S01401*/
                                                                      /*S01401*/
TAGF:        CHGDTAARA (SESTAT (76 1)) VALUE('F')                     /*S01401*/
                                                                      /*S01401*/
/***  If MT5XX Feature present then generate MT512 Messages  ***/     /*S01401*/
                                                                      /*S01401*/
             IF (&S01401 *EQ 'Y') THEN(DO)                            /*S01401*/
             IF         COND(&CSW098 *NE 'CSW098 ') THEN(DO)          /*CSW098*/
               CALL (MG0512)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 CHGVAR (&MSG) VALUE('MG0512 - I/C SWIFT Trade +
                    Confirmation MT512 Generation failed')            /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
               ENDDO                                                  /*CSW098*/
             ENDDO                                                    /*S01401*/
/*/COPY WNCPYSRC,SEC0304002                                          */
                                                                      /*S01401*/
/***  Indicate I/C Confirmations have completed successfully  ***/    /*S01401*/
                                                                      /*S01401*/
             CHGDTAARA (SESTAT (76 1)) VALUE(' ')                     /*S01401*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(&UDC *EQ 'Y') THEN(DO)                                       /*205448*/
                                                                                          /*CCG015*/
/** Call Custom Defined Data Extract pgm */                                               /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                                 /*CCG015*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                     /*CCG015*/
             GOTO       CMDLBL(ERROR)                                                     /*CCG015*/
             ENDDO                                                                        /*CCG015*/
                                                                      /*081938*/
/* Prompt for immediate print */                                      /*081938*/
/************IF         COND(&UDC *EQ 'Y') THEN(DO)            /095130/*205448*/
             CALL       PGM(CGC5217) PARM(' ')                        /*081938*/
             MONMSG     MSGID(CPF0000)                                /*081938*/
             ENDDO                                                    /*095130*/
                                                                      /*081938*/
             GOTO (END)                                               /*S01401*/
                                                                      /*S01401*/
ERROR:                                                                /*S01401*/
             CHGJOB     SWS(XXXXXXX1)                                 /*S01522*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(&UDC *EQ 'Y') THEN(DO)                                       /*205448*/
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
             ENDDO                                                                        /*205448*/
             ROLLBACK                                                 /*S01401*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
             RTVDTAARA DTAARA(SESTAT) RTNVAR(&SESTAT)                                     /*261402*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*261402*/
             IF (%SST(&SESTAT 76 1) *EQ 'A') THEN(DO)                                     /*261402*/
             CLRPFM     FILE(MGF51NPD)                                                    /*261402*/
             ENDDO                                                                        /*261402*/
                                                                                         /*BUG8853*/
/* Set on switches 7 and 8 to ensure error processing is performed.                   */ /*BUG8853*/
                                                                                         /*BUG8853*/
                 CHGJOB SWS(XXXXXX11)                                                    /*BUG8853*/
                                                                                         /*BUG8853*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01522*/
             RTVDTAARA (LDA) RTNVAR(&LDA)                             /*S01401*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
             CHGVAR (&MEM) VALUE(%SST(&LDA 134 50))                   /*S01401*/
             SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)                     /*S01401*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
             ENDDO                                                    /*S01522*/
             SNDPGMMSG MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)    /*S01401*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
                                                                      /*S01401*/
/***  Whether successful or not, must Allocate and change SESTAT ***/ /*S01401*/
/***  to indicate that I/C Confirmations have completed.         ***/ /*S01401*/
END:                                                                  /*S01401*/
                                                                      /*S01401*/
/*************************************************************         *S01271*/
/******    FOLLOWING LINES INSERTED FOR S01271    ************   BEGIN *S01271*/
/*************************************************************         *S01271*/
                                                                      /*S01271*/
/***STATUS:***                                             /*E28924*/ /*S01401*/
/*  ALLOCATE SESTAT, INDICATE CONFIRMATION PRINT IS FINISHED */       /*S01271*/
/*  AND THEN DEALLOCATE.                                     */       /*S01271*/
                                                                      /*S01271*/
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))                 /*S01271*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*S01271*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
             CHGVAR     VAR(%SUBSTRING(&SESTAT 73 1)) VALUE('N')      /*S01271*/
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)                 /*S01271*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))                 /*S01271*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
/*********** ENDDO                                         /*S01271*/ /*S01401*/
/*********** ENDDO                                         /*S01271*/ /*S01401*/
                                                                      /*S01401*/
/*****End Commitment Control, (but only if this job was  ****S01401*/ /*S01522*/
/*****Submitted from Input Cycle).                       ****S01401*/ /*S01522*/
/************                                               *S01401*/ /*S01522*/
/************IF (&ICTERM *EQ 'N') THEN(DO)                  *S01401*/ /*S01522*/
/************  ENDCMTCTL                                    *S01401*/ /*S01522*/
/************  MONMSG (CPF8356) EXEC(DO)                    *S01401*/ /*S01522*/
/************    CHGVAR (&MSG) VALUE('SEC0304 - Ended +               /*S01522*/
/************       Commitment Control with pending changes'*S01401*/ /*S01522*/
/************    SNDPGMMSG (&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ*S01401*/ /*S01522*/
/************  ENDDO                                        *S01401*/ /*S01522*/
/************ENDDO                                          *S01401*/ /*S01522*/
                                                                      /*S01271*/
/*ENDPGM:****ENDPGM*******                                             *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
