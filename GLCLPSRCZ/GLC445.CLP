/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Shadow postings')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC445 - SHADOW POSTINGS                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR992022           Date 26Apr16              */
/*       Prev Amend No. CAP207             Date 10Feb11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      260259             Date 14May09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      245635             Date 13Feb07              */
/*                      241672A            Date 09Jan07              */
/*                      243716             Date 17Nov06              */
/*                      BUG13062           Date 18Jan07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      241672             Date 28Aug06              */
/*                      CPK022             Date 05Jul04              */
/*                      BUG2714            Date 25May04              */
/*                      CSC022             Date 24Feb04              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      170383             Date 08NOV99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL009             Date 17Sep99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      S01408             Date 21Apr95              */
/*                      S01408             Date 22Feb95              */
/*                      078325             DATE 22NOV94              */
/*                      S01413             DATE 13APR93              */
/*                      E30087                  13FEB92              */
/*                      S01229 (S01251)         04APR90              */
/*                      S01194                  14FEB90              */
/*                      S01117                  14FEB90              */
/*                      E19313                  14FEB90              */
/*                      E17597                  26JAN89              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR992022 - On line Retail Advices are not being printed for */
/*                  journal entries (CRE020). Pattern retail advice  */
/*                  process after GLC1400 and in other modules.      */
/*                - Applied for MD033905                             */
/*       CAP207 - Account Balance Check extended to other APIs       */
/*       260259 - Batch acceptance delay problem. Fix is to:         */
/*              - sbmjob REC0880 to MIDASJOBQ; and                   */
/*              - stop spurious error message in MOPERQ on exit of   */
/*                pgm.                                               */
/*       245635 - Move SBMJOB of REC0880 to this program.            */
/*       241672A- REC0880 in MSGW do record lock in GLJENHL0.        */
/*       243716 - Remove fix 241672 to prevent locking GLJENHL0.     */
/*              - annotated as BUG13062                              */
/*       BUG13062 - Apply core fix 243716                            */
/*       241672 - Complete job GLC445 before processing REC0880.     */
/*       CPK022 - BUG2714 was applied incorrectly when reversing     */
/*                CSC022.                                            */
/*       BUG2714 - STRCMTCTL should separately be done here because  */
/*                 the scope of the commitment control by java, is   */
/*                 for QZDASOINIT job only. Thus, this component is  */
/*                 not affected because it is submitted. Reverse     */
/*                 CSC022 changes.                                   */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       170383 - Override GLJENPPD to share (*no) before calling    */
/*                GL2828.                                            */
/*       CGL009 - Midas-Fontis Inter-Account Transfers (IAT) and     */
/*                Third Party Payments (TPP) Interface               */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       S01408 - Addition of core hook GLC445END                    */
/*       S01408 - Addition of core hook GLC445INT                    */
/*                Addition of core hook GLC445MPS                    */
/*       078325 - Add Global Monitor Message processing              */
/*              - Extend commenting-out asterisks                    */
/*       S01413 - Header Box Standardised                            */
/*       E30087 - OVRMSGF MIDAS TO APPROPRIATE LANGUAGE              */
/*       S01251 - SYNON PROGRAM/FILE/FIELD NAME CHANGES              */
/*       S01229 - SYNON file name changes                            */
/*       S01194 - NEW STANDING DATA                                  */
/*       S01117 - RELEASE 10 MULTIBRANCHING                          */
/*       E19313 - OVERRIDE ADDED BECAUSE OF NEW FILE IN GL4445       */
/*                FILE ADDDED TO AVOID LOCKING                       */
/*       E17597 - CALL PROGRAM WITH CORRECT PARAMETERS AND           */
/*                UNDER COMMITMENT CONTROL                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BNUM &WRKSTN)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')

/************DCL VAR(&MSG)   TYPE(*CHAR) LEN(50)                   */ /*S01117*/
/************DCL VAR(&BNUM)  TYPE(*DEC)  LEN(3 0)                     /*E17597*/
             DCL VAR(&BNUM)  TYPE(*CHAR) LEN(3)                       /*E17597*/
             DCL VAR(&WRKSTN) TYPE(*CHAR) LEN(10)
             DCL VAR(&MEM) TYPE(*CHAR) LEN(44)                        /*E17597*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*E17597*/
/* START OF FIX E30087 */
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CGL009*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CGL009*/
             DCL        VAR(&CGL009) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CGL009*/
             DCL        VAR(&MIDAS) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE('N')                /*CSC022 BUG2714*/
/**********  DCL        VAR(&WCMTSK) TYPE(*CHAR) LEN(1) VALUE('N')                /*CSC022 BUG2714*/
/**********  DCL        VAR(&WSCCMTJOB) TYPE(*CHAR) LEN(256)                      /*CSC022 BUG2714*/
/**********  DCL        VAR(&WCMTNUM) TYPE(*DEC) LEN(3 0)                         /*CSC022 BUG2714*/
/**********  DCL        VAR(&WCMTJOB) TYPE(*CHAR) LEN(100)                        /*CSC022 BUG2714*/
/**********  DCL        VAR(&PRTN) TYPE(*CHAR) LEN(7)                             /*CSC022 BUG2714*/
/**********  DCL        VAR(&POPT) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')            /*CSC022 BUG2714*/
/**********  DCL        VAR(&PSAR) TYPE(*CHAR) LEN(6) VALUE('CSC022')             /*CSC022 BUG2714*/
/**********  DCL        VAR(&PFMT) TYPE(*CHAR) LEN(200)                           /*CSC022 BUG2714*/
/**********  DCL        VAR(&WJOB) TYPE(*CHAR) LEN(10)                            /*CSC022 BUG2714*/
/**********  DCL        VAR(&WSTR) TYPE(*DEC) LEN(2 0) VALUE(1)                   /*CSC022 BUG2714*/
             DCL        VAR(&GLHLCK) TYPE(*CHAR) LEN(1) VALUE('N')                       /*241672A*/
             DCL        VAR(&RETAIL2) TYPE(*CHAR) LEN(1)                                  /*245635*/
             DCL        VAR(&IOA)     TYPE(*CHAR) LEN(1)                                  /*245635*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*245635*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*245635*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*245635*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*245635*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*245635*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(50)                                  /*AR992022*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,GLC445INT                                           */
/* */                                                                 /*S01408*/
/* END OF FIX E30087 */

/* Global message monitor :                                     */    /*078325*/
                                                                      /*078325*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*078325*/
                                                                                         /*241672A*/
             SNDPGMMSG  MSG('GLC445 - Batch entry Shadow Postings +
                          for batch' *BCAT &BNUM *BCAT 'from +
                          device' *BCAT &WRKSTN) TOMSGQ(MRUNQ)                           /*241672A*/
                                                                                          /*245635*/
/* Check if CRE020 is enabled. */                                                         /*245635*/
                                                                                          /*245635*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*245635*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*245635*/
             CHGVAR     VAR(&PSARD) VALUE('CRE020')                                       /*245635*/
             CHGVAR     VAR(&CRE020) VALUE('N')                                           /*245635*/
                                                                                          /*245635*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*245635*/
                                                                                          /*245635*/
             IF         COND(&PRTCD *EQ '       ') THEN(DO)                               /*245635*/
             CHGVAR     VAR(&CRE020) VALUE('Y')                                           /*245635*/
             ENDDO                                                                        /*245635*/
                                                                                          /*245635*/
             IF         COND(&PRTCD *NE '       ' *AND +
                             &PRTCD *NE '*NRF   ') THEN(DO)                               /*245635*/
             DMPCLPGM                                                                     /*245635*/
             GOTO       CMDLBL(ABNOR)                                                     /*245635*/
             ENDDO                                                                        /*245635*/
/**/
/*   Create Local Data Area                                       */ /*CGL009*/
/**/                                                                 /*CGL009*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)                               /*CGL009*/
/*********************************************************************/           /*CSC022 BUG2714*/
/**Retrieve*Commitment*Control*Jobs*data*area*************************/           /*CSC022 BUG2714*/
/*********************************************************************/           /*CSC022 BUG2714*/
/**********  CALL       PGM(AOSARDR0) PARM(&PRTN &POPT &PSAR &PFMT) */            /*CSC022 BUG2714*/
/*********************************************************************/           /*CSC022 BUG2714*/
/**********  IF         COND(&PRTN *EQ *BLANKS) THEN(DO) */                       /*CSC022 BUG2714*/
/**********  CHGVAR     VAR(&CSC022) VALUE('Y') */                                /*CSC022 BUG2714*/
/**********  CHGVAR     VAR(&WCMTSK) VALUE('N') */                                /*CSC022 BUG2714*/
/*********************************************************************/           /*CSC022 BUG2714*/
/**********  RTVDTAARA  DTAARA(SCCMTJOB) RTNVAR(&WSCCMTJOB) */                    /*CSC022 BUG2714*/
/**********  CHGVAR     VAR(&WCMTNUM) VALUE(%SST(&WSCCMTJOB 1 3)) */              /*CSC022 BUG2714*/
/**********  CHGVAR     VAR(&WCMTJOB) VALUE(%SST(&WSCCMTJOB 4 103)) */            /*CSC022 BUG2714*/
/*********************************************************************/           /*CSC022 BUG2714*/
/**********  IF         COND(&WCMTNUM *GT 0) THEN(DO) */                          /*CSC022 BUG2714*/
/**********  RTVJOBA    JOB(&WJOB) */                                             /*CSC022 BUG2714*/
/*********************************************************************/           /*CSC022 BUG2714*/
/*SCAN:****   IF         COND(&WJOB *EQ %SST(&WCMTJOB &WSTR 10)) +
                          THEN(CHGVAR VAR(&WCMTSK) VALUE('Y')) */                 /*CSC022 BUG2714*/
/*********************************************************************/           /*CSC022 BUG2714*/
/**********  ELSE       CMD(DO) */                                                /*CSC022 BUG2714*/
/**********  CHGVAR     VAR(&WSTR) VALUE(&WSTR + 10) */                           /*CSC022 BUG2714*/
/**********  IF         COND(&WSTR *LT 100) THEN(GOTO CMDLBL(SCAN)) */            /*CSC022 BUG2714*/
/**********  ENDDO */                                                             /*CSC022 BUG2714*/
/*********************************************************************/           /*CSC022 BUG2714*/
/**********  ENDDO */                                                             /*CSC022 BUG2714*/
/**********  ENDDO */                                                             /*CSC022 BUG2714*/
/**********  ELSE       CMD(IF COND(&PRTN *NE '*NRF') THEN(GOTO +
                          CMDLBL(ABNOR))) */                                      /*CSC022 BUG2714*/

/**********  STRCMTCTL  LCKLVL(*CHG)                           /*E17597 CPK009*/
/**********  IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +
                          'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO) */               /*CSC022 BUG2714*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
/**********  ENDDO */                                                             /*CSC022 BUG2714*/

/* START OF FIX E30087 */
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)

             IF         COND(&MULT *EQ '  ') THEN(DO)
                CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO

             CHGVAR     VAR(&MIDAS) VALUE(&MULT *CAT 'MIDAS')
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDAS)
/* END OF FIX E30087 */
                                                                      /*E19313*/
/**/                                                                  /*CGL009*/
/*    Check if Fontis IAT/TPP Interface (CGL009) is active            /*CGL009*/
/**/                                                                  /*CGL009*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CGL009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL009' +
                          &FMT)                                       /*CGL009*/
/**/                                                                  /*CGL009*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CGL009*/
             CHGVAR     VAR(&CGL009) VALUE('Y')                       /*CGL009*/
             OVRDBF     FILE(GLJENPPD) SHARE(*NO)                     /*170383*/
             CALL       PGM(GL2828) PARM(&BNUM)                       /*CGL009*/
             DLTOVR     FILE(GLJENPPD)                                /*170383*/
/**/                                                                  /*CGL009*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)       /*CGL009*/
/**********  IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +
                          'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO) */               /*CSC022 BUG2714*/
             ROLLBACK                                                 /*CGL009*/
/**********  ENDDO */                                                             /*CSC022 BUG2714*/
/**********  ELSE       CMD(CHGJOB     SWS(XXXXXX11)) */                          /*CSC022 BUG2714*/
             SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                          Enter to continue.') TOMSGQ(&WRKSTN MOPERQ) /*CGL009*/
             GOTO       CMDLBL(ENDPGM)                                /*CGL009*/
             ENDDO                                                    /*CGL009*/
/**/                                                                  /*CGL009*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)                      /*CGL009*/
               RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                    /*CGL009*/
               CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))    /*CGL009*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*CGL009*/
               CHGVAR     VAR(&MEM) VALUE('GLC445 - Job Termination, +
                          Database in Error')                         /*CGL009*/
               SNDPGMMSG  MSG(&MEM) TOMSGQ(&WRKSTN MOPERQ)            /*CGL009*/
/**********    IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +
                          'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO) */               /*CSC022 BUG2714*/
               ROLLBACK                                               /*CGL009*/
/**********    ENDDO */                                                           /*CSC022 BUG2714*/
/**********    ELSE       CMD(CHGJOB     SWS(XXXXXX11))                           /*CSC022 BUG2714*/
               GOTO ENDPGM                                            /*CGL009*/
             ENDDO                                                    /*CGL009*/
/**/                                                                  /*CGL009*/
             ENDDO                                                    /*CGL009*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,GLC445MPS                                           */
/* */                                                                 /*S01408*/
/************OVRDBF     FILE(GLBTXXX2) TOFILE(GLBTREL2) SH /*S01229*/ /*E19313*/
             OVRDBF     FILE(GLJEXXX2) TOFILE(GLJENPL2) SHARE(*NO)    /*S01229*/
                                                                      /*E19313*/
/**********  CHGDTAARA DTAARA(GLC0445 (1 1)) VALUE('R')                          /*241672 BUG13062*/
                                                                                          /*CAP207*/
             CHKOBJ     OBJ(QTEMP/GPRESERVID) OBJTYPE(*DTAARA)                            /*CAP207*/
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/GPRESERVID) TYPE(*CHAR) LEN(15))                   /*CAP207*/
             CHGDTAARA  DTAARA(QTEMP/GPRESERVID) VALUE(*BLANK)                            /*CAP207*/
                                                                                          /*CAP207*/
             CALL PGM(GL4445) PARM(&BNUM)

             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
/**********     IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +
                          'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO) */               /*CSC022 BUG2714*/
                ROLLBACK
/**********     ENDDO */                                                          /*CSC022 BUG2714*/
/**********     ELSE       CMD(CHGJOB     SWS(XXXXXX11))                          /*CSC022 BUG2714*/
                SNDPGMMSG  MSG('Transaction failed. Re-input +
                          necessary. Enter to continue.') +
                          TOMSGQ(&WRKSTN MOPERQ)
                GOTO ENDPGM
             ENDDO
/*/COPY WNCPYSRC,GLC445001                                           */

             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                    /*E17597*/
/***CHGVAR*****VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))    /*E17594*/ /*S01194*/
               CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))    /*S01194*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*E17597*/
               CHGVAR     VAR(&MEM) VALUE('GLC445 - Job Termination, +
                          Database in Error')                         /*E17597*/
               SNDPGMMSG  MSG(&MEM) TOMSGQ(&WRKSTN MOPERQ)            /*E17597*/
/**********    IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +               /*CSC022 CPK022*/
/**********               'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO)                   /*CSC022 CPK022*/
               ROLLBACK                                               /*E17597*/
/**********    ENDDO                                                               /*CSC022 CPK022*/
/**********    ELSE       CMD(CHGJOB     SWS(XXXXXX11))                            /*CSC022 CPK022*/
/************CHGVAR   VAR(&MSG) VALUE('JOB TERMINATED - DATABASE IN + /*E17597*/
/************             ERROR')                                     /*E17597*/
/************   ROLLBACK                                              /*E17597*/
/************                                                         /*E17597*/
/************   SNDPGMMSG  MSG(&MSG) TOMSGQ(&WRKSTN MOPERQ) +         /*E17597*/
/************             MSGTYPE(*INFO)                              /*E17597*/
             GOTO       CMDLBL(ABNOR)                                                    /*241672A*/
             ENDDO

/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,GLC445END                                           */
/* */                                                                 /*S01408*/
                                                                                          /*245635*/
/** Submit the Retail advices print if retail present  */                                 /*245635*/
/** and the online printing of advices is disabled.    */                                 /*245635*/
                                                                                          /*245635*/
             RTVDTAARA  DTAARA(MMOD (16 1)) RTNVAR(&RETAIL2)                              /*245635*/
             RTVDTAARA  DTAARA(MMOD (23 1)) RTNVAR(&IOA)                                  /*245635*/
                                                                                          /*245635*/
             IF         COND((&RETAIL2 *EQ 'Y' *OR &IOA *EQ 'Y') *AND +
                              &CRE020 *EQ 'N') THEN(DO)                                   /*245635*/
                                                                                          /*245635*/
/**********  SBMJOB     JOB(REC0880) JOBD(MBATCH) JOBQ(MICJOBQ) +    */                   /*260259*/
/**********               OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +    */                   /*260259*/
/**********               RQSDTA('CALL REC0880 PARM(''' *CAT &BNUM  +*/                   /*260259*/
/**********               *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +   */                   /*260259*/
/**********               INLLIBL(*JOBD) MSGQ(MOPERQ)                */            /*245635 260259*/
             SBMJOB     JOB(REC0880) JOBD(MBATCH) JOBQ(MIDASJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL REC0880 PARM(''' *CAT &BNUM +
                          *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*260259*/
                                                                                          /*245635*/
             ENDDO                                                                        /*245635*/
                                                                                        /*AR992022*/
/* Print On line Retail Advices if CRE020 is enabled. */                                /*AR992022*/
                                                                                        /*AR992022*/
             IF         COND(&CRE020 *EQ 'Y') THEN(DO)                                  /*AR992022*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(' +
                        *CAT '''GLBITHUPD'' ''GL''' *CAT ')')                           /*AR992022*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*AR992022*/
             ENDDO                                                                      /*AR992022*/
                                                                      /*078325*/
             SNDPGMMSG  MSG('GLC445 - Ended normally for batch' +
                          *BCAT &BNUM *BCAT 'from device' +
                          *BCAT &WRKSTN) TOMSGQ(MRUNQ)                                   /*241672A*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*241672A*/
                                                                                         /*241672A*/
             GOTO       CMDLBL(ENDPGM)                                /*078325*/
                                                                      /*078325*/
ABNOR:                                                                /*078325*/
             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)                                 /*241672A*/
                CHGVAR     VAR(&GLHLCK) VALUE('Y')                                       /*241672A*/
                MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                                /*241672A*/
             ENDDO                                                                       /*241672A*/
             CHGVAR     VAR(&MEM) VALUE('GLC445 - Job terminated in +
                          error.  See Joblog for details')            /*078325*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078325*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(&WRKSTN MOPERQ)              /*078325*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078325*/
/**********  IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +                 /*CSC022 CPK022*/
/**********               'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO)                   /*CSC022 CPK022*/
             ROLLBACK                                                 /*078325*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078325*/
/**********  ENDDO                                                                 /*CSC022 CPK022*/
/**********  ELSE       CMD(CHGJOB     SWS(XXXXXX11))                              /*CSC022 CPK022*/
                                                                      /*078325*/
/*DPGM:******ENDPGM                                                   /*E17597*/
/*DPGM:******ENDCMTCTL                                                             /*E17597 CSC022*/
ENDPGM:      ENDCMTCTL                                                                    /*CPK022*/
/*ENDPGM:                                                                          /*CSC022 CPK022*/
/**********  IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +                        /*CPK022*/
/**********               'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO)                   /*CSC022 CPK022*/
/**********  ENDCMTCTL                                                             /*CSC022 CPK022*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078325*/
                                                                                         /*241672A*/
/** Generate report for jobs locking GLJENHPD */                                         /*241672A*/
                                                                                         /*241672A*/
             IF         COND(%SWITCH(XX1XXXXX) *OR +
                            (&GLHLCK *EQ 'Y')) THEN(DO)                                  /*241672A*/
                CALL       PGM(SCDOBJLCK) PARM('GLJENHPD' '*LIBL' +
                             '*FILE' '*PRINT')                                           /*241672A*/
                MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                                /*241672A*/
                                                                                         /*241672A*/
                CHGJOB     SWS(XXXXXX11)                                                 /*241672A*/
                MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                                /*241672A*/
                                                                                         /*241672A*/
             SNDPGMMSG  MSG('GLC445 - Unable to allocate record on +
                          GLJENHL0, batch ' *BCAT &BNUM *CAT ', see +
                          joblog and dumps') TOMSGQ(MRUNQ MOPERQ)                        /*241672A*/
                MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                                /*241672A*/
/**********  ENDDO                                                   */           /*241672A 260259*/
                                                                                         /*241672A*/
             SNDPGMMSG  MSG('GLC445 - Ended in error, batch' *BCAT +
                          &BNUM *BCAT '(not Accepted) from device' +
                          *BCAT &WRKSTN) TOMSGQ(MRUNQ MOPERQ)                            /*241672A*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*241672A*/
             ENDDO                                                                        /*260259*/
/**********  ENDDO                                                                 /*CSC022 CPK022*/
/**********  CHGDTAARA DTAARA(GLC0445 (1 2)) VALUE('C ')                         /*241672 BUG13062*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078325*/
             ENDPGM                                                   /*E17597*/
