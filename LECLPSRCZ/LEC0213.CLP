/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Input cycle pay/receive')                    */
/*********************************************************************/
/*                                                                   */
/*     Midas - LENDING                                       */
/*                                                                   */
/*     LEC0213  - INPUT CYCLE PAY/RECEIVE PROCESSING                 * *E40242*/
/******LEC0213A*-*INPUT*CYCLE*PAY/RECEIVE PROCESSING                 * *E40242*/
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR322731           Date 01Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CSW209             Date 01Apr09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CLE014             Date 20Mar01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CLE009             Date 20Apr99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      152352             Date 19Jan99              */
/*                      124684             Date 07Jan98              */
/*                      S01427             Date 12Jul93              */
/*                   E40242       DATE 19JUN92                       */
/*                   E39477       DATE 05MAY92                       */
/*                   E29588       DATE 03FEB92                       */
/*                   S01310       DATE 23JUL91                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR322731 - LEC0212A and APISERVER locks LTRIX file. Apply   */
/*                  fix 252833A (Child:AR322732)                     */
/*       252833A - Prevent LTRIX RRN 1 from being locked             */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CSW209 - SWIFT 2009 Changes                                 */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CLE014 - Customer Driven Lending Enhancements               */
/*       CLE009 - SWIFT Message Generation for Fees                  */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       152352 - The message returned is not user friendly.         */
/*       124684 - If the confirmations job ends abnormally and does  */
/*                not change LESTAT position 6 back to 'N', no confs */
/*                are produced in subsequent runs. Fix is to use new */
/*                data area LECONF and ALCOBJ/DLCOBJ commands to     */
/*                to determine if the confirmations job is active -  */
/*                if the job fails, the data area is automatically   */
/*                de-allocated.                                      */
/*     S01427 - R10 CHIPS INCORPORATION                              */
/*     E40242 - CALL MEC0890 TO PRODUCE AUDIT LIST OF MESSAGES       */
/*              GENERATED                                            */
/*            - INCORRECT NAME IN HEADER BOX                         */
/*     E39477 - ONLY RUN LE0550 IF MUTIBRANCH                        */
/*     E29588 - POST COLLECTION RATIONALISATION FIXES.               */
/*     S01310 - RE WRITTEN FOR SWIFT RATIONALISATION                 */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&FIVE) TYPE(*DEC) LEN(1 0) VALUE(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MCSTAT) TYPE(*CHAR) LEN(256)             /*S01427*/
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)    /*E39477*/
                                                                      /*E40242*/
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
/*/COPY WNCPYSRC,LEC0213002                                          */
                                                                      /*152352*/
             DCL        VAR(&ERR)  TYPE(*CHAR) LEN(1) VALUE(' ')      /*152352*/
             DCL        VAR(&MSGQ) TYPE(*CHAR) LEN(10)                /*152352*/
                                                                      /*CLE009*/
             DCL        VAR(&CLE002) TYPE(*CHAR) LEN(1) VALUE('N')    /*CLE009*/
             DCL        VAR(&CLE009) TYPE(*CHAR) LEN(1) VALUE('N')    /*CLE009*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')     /*CLE009*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CLE014*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE014')                             /*CLE014*/
             DCL        VAR(&CLE014) TYPE(*CHAR) LEN(1) VALUE('N')    /*CLE014*/
/*/COPY WNCPYSRC,LEC0213010                                          */
 
             DCLF       FILE(SDMGMEPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/*/COPY WNCPYSRC,LEC0213004                                          */
 
/* Notify MRUNQ */
             SNDPGMMSG  MSG('Input Cycle Pay/Receive') +
                          TOMSGQ(MRUNQ)
 
/*/COPY WNCPYSRC,LEC0213011                                          */
/* Begin commitment control */
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))             /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
/* Zero switches */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(00000000)
/*/COPY WNCPYSRC,LEC0213001                                          */
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
                                                                      /*152352*/
/*  Retrieve User Message Queue  */                                   /*152352*/
             RTVUSRPRF  MSGQ(&MSGQ)                                   /*152352*/
 
/* Check for pay/receive still active/failed */
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT) /*E39477*/
 
             IF         COND((%SUBSTRING(&LESTAT 7 1) *EQ Y) *OR +
                          (%SUBSTRING(&LESTAT 97 1) *NE ' ')) THEN(DO)
             SNDPGMMSG  MSG('LENDING PAY/RECEIVE PRINT REQUESTED BUT +
                          PAY/RECEIVE ALREADY ACTIVE/FAILED') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ &MSGQ) +
                          MSGTYPE(*INFO)                              /*152352*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)  /*152352*/
             GOTO END
             ENDDO
 
/*         CHECK FOR MIDAS/CHIPS LENDING INTERFACE                 */ /*S01427*/
/**/                                                                  /*S01427*/
             IF         COND((%SUBSTRING(&MMOD 43 1) = 'Y')) THEN(DO) /*S01427*/
RTVDTAARA  DTAARA(*LIBL/MCSTAT) RTNVAR(&MCSTAT)                       /*S01427*/
/**/                                                                  /*S01427*/
               IF  COND(%SST(&MCSTAT 15 1) = 'Y') THEN(DO)  /*SMCMG*/ /*S01427*/
             SNDPGMMSG  MSG('PROCEDURE CANNOT BE RUN UNTIL +
                          OUTSTANDING CHIPS MESSAGES ARE SENT') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ &MSGQ)           /*152352*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ)       */ /*S01427 152352*/
                     GOTO       CMDLBL(END)                           /*S01427*/
                ENDDO                                                 /*S01427*/
/**/                                                                  /*S01427*/
/**/                                                                  /*S01427*/
             ENDDO                                                    /*S01427*/
/*/COPY WNCPYSRC,LEC0213003                                          */
/**/                                                                  /*S01427*/
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report.                                         /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
 
             ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
             CHGVAR     VAR(%SUBSTRING(&LESTAT 7 1)) VALUE(Y)
             CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)
             DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
 
/* Call confirmation stop program */
/************IF         COND(%SST(&LESTAT 6 1) *EQ 'Y') THEN(CALL +   /*124684*/
/************             PGM(LE0140))                                /*124684*/
 
             ALCOBJ     OBJ((LECONF *DTAARA *EXCL)) WAIT(0)           /*124684*/
/**********  MONMSG     MSGID(CPF0000) EXEC(CALL PGM(LE0140))) */                 /*124684 252833A*/
             MONMSG     MSGID(CPF0000)                                                   /*252833A*/
                                                                      /*124684*/
/* Check for confirmations still active */
/**********RETRY:       RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)     /*124684*/
 
/************       IF       COND(%SST(&LESTAT 6 1) *EQ 'Y') THEN(DO) /*124684*/
                                                                      /*124684*/
RETRY:       ALCOBJ     OBJ((LECONF *DTAARA *EXCL)) WAIT(0)           /*124684*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*124684*/
                                                                      /*124684*/
             RCVMSG     WAIT(60) RMV(*NO)
             CHGVAR     VAR(&FIVE) VALUE(&FIVE + 1)
 
/************IF         COND(&FIVE *GT 5) THEN(GOTO CMDLBL(RETRY))    /*124684*/
             IF         COND(&FIVE *LT 5) THEN(GOTO CMDLBL(RETRY))    /*124684*/
             ELSE       CMD(DO)
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO END
             ENDDO
             ENDDO
 
/* Should not run Pay/Recs if last Confirmation run ended in error */ /*E29588*/
             IF       COND(%SUBSTRING(&LESTAT 98 1) *NE ' ') THEN(DO) /*E29588*/
             SNDPGMMSG  MSG('Lending Pay/Receive print requested but +
                          last Confirmation run ended in error') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ &MSGQ) +
                          MSGTYPE(*INFO)                              /*152352*/
/***********    TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)  */ /*E29588 152352*/
             GOTO END                                                 /*E29588*/
             ENDDO                                                    /*E29588*/
 
             IF COND(%SST(&LESTAT 99 1) *EQ 'D') THEN(GOTO TAGD)
             IF COND(%SST(&LESTAT 99 1) *EQ 'E') THEN(GOTO TAGE)
             IF COND(%SST(&LESTAT 99 1) *EQ 'F') THEN(GOTO TAGF)
             IF COND(%SST(&LESTAT 99 1) *EQ 'G') THEN(GOTO TAGG)
             IF COND(%SST(&LESTAT 99 1) *EQ 'H') THEN(GOTO TAGH)
             IF COND(%SST(&LESTAT 99 1) *EQ 'I') THEN(GOTO TAGI)
             IF COND(%SST(&LESTAT 99 1) *EQ 'J') THEN(GOTO TAGJ)
             IF COND(%SST(&LESTAT 99 1) *EQ 'K') THEN(GOTO TAGK)
             IF COND(%SST(&LESTAT 99 1) *EQ 'M') THEN(GOTO TAGM)     /*S01427*/
 
/* DLC2350A */
             CHGJOB     SWS(XXXXXX0X)
 
             SNDPGMMSG  MSG('Create Pay/Receive Extract Files') +
                          TOMSGQ(MRUNQ)
 
             CLRPFM     FILE(LTRIEHD)
             CLRPFM     FILE(LTRIEDL)
             CLRPFM     FILE(LTRIEZZ)
             CALL LE1060
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive extract failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGD:        CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE('D')
 
/* Create pay/receive extract file */
 
             CLRPFM     FILE(LETX1HH)
             CLRPFM     FILE(LETX1PR)
             CLRPFM     FILE(LETX1ZZ)
             CLRPFM     FILE(LETX2HH)
             CLRPFM     FILE(LETX2PR)
             CLRPFM     FILE(LETX2ZZ)
             CLRPFM     FILE(LETX3HH)
             CLRPFM     FILE(LETX3PR)
             CLRPFM     FILE(LETX3ZZ)
 
             CHGJOB     SWS(XXX1XXXX)
             CLRPFM     FILE(LEPXTAA)
             CLRPFM     FILE(LEPXTAB)
             CLRPFM     FILE(LEPXTAC)
/**/                                                                  /*S01427*/
/*  MIDAS/CHIPS LENDING EXTRACTS                                 */   /*S01427*/
             IF         COND(%SST(&MMOD 43 1) *EQ 'Y') THEN(DO)  /*     S01427*/
                CHGJOB     SWS(1XXXXXXX)                              /*S01427*/
                CLRPFM     FILE(*LIBL/LETX6HH)                        /*S01427*/
                CLRPFM     FILE(*LIBL/LETX6PR)                        /*S01427*/
                CLRPFM     FILE(*LIBL/LETX6ZZ)                        /*S01427*/
             ENDDO                                                    /*S01427*/
 
/*/COPY WNCPYSRC,LEC0213012                                          */
/* If SWIFT Direct Link switched on */
/* call the SWIFT Direct Link program LE1067 */
 
             IF         COND(%SST(&MMOD 18 1) *EQ 'Y') THEN(CALL +
                          PGM(LE1067))
 
/* call the non-SWIFT Direct Link program */
             ELSE       CMD(CALL PGM(LE1068))
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Create pay/receive extract +
                          file failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
/**/                                                                  /*CLE014*/
/* Check if CLE014 is installed                                */     /*CLE014*/
/**/                                                                  /*CLE014*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD)      /*CLE014*/
             IF         (&PRTCD *EQ ' ') (CHGVAR (&CLE014) +
                   VALUE('Y'))                                        /*CLE014*/
             ELSE  IF (&PRTCD *NE '*NRF   ') THEN(DO)                 /*CLE014*/
                   SNDPGMMSG  MSG('LE Input cycle pay/receive +
                          failure - AOSARDR0 ERROR') +
                           TOMSGQ(MOPERQ)                             /*CLE014*/
                   GOTO   CMDLBL(ERROR)                               /*CLE014*/
             ENDDO                                                    /*CLE014*/
                                                                      /*CLE009*/
/*/COPY WNCPYSRC,LEC0213007                                          */
/**/                                                                  /*CLE009*/
/*  SWIFT MESSAGE GENERATION FOR FEES                          */     /*CLE009*/
/*  Check if CLE007(Cust. Lending enhancement) CLE002(Lendings */     /*CLE009*/
/*  Authorisation) CLE009(Swift msg gener. for fees) are       */     /*CLE009*/
/*  installed                                                  */     /*CLE009*/
                                                                      /*CLE009*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CLE007')          /*CLE009*/
                                                                      /*CLE009*/
             IF (&PRTCD *EQ ' ') THEN(DO)                             /*CLE009*/
               CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CLE009')        /*CLE009*/
                                                                      /*CLE009*/
               IF (&PRTCD *EQ ' ') THEN(DO)                           /*CLE009*/
                 CHGVAR (&CLE009) VALUE('Y')                          /*CLE009*/
                 CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CLE002')      /*CLE009*/
                                                                      /*CLE009*/
                 IF (&PRTCD *EQ ' ') (CHGVAR (&CLE002) VALUE('Y'))    /*CLE009*/
/*  If error during the use of AOSARDR0  ( for CLE002) */             /*CLE009*/
                 ELSE IF (&PRTCD *NE '*NRF') THEN(DO)                 /*CLE009*/
/* Send database error message to workstation & MOPERQ */             /*CLE009*/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)       /*CLE009*/
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)          /*CLE009*/
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)                /*CLE009*/
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)          /*CLE009*/
                 ENDDO                                                /*CLE009*/
                                                                      /*CLE009*/
               ENDDO                                                  /*CLE009*/
/*  If error during the use of AOSARDR0   ( for CLE009) */            /*CLE009*/
               ELSE IF (&PRTCD *NE '*NRF') THEN(DO)                   /*CLE009*/
/* Send database error message to workstation & MOPERQ  */            /*CLE009*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)         /*CLE009*/
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*CLE009*/
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)                /*CLE009*/
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*CLE009*/
               ENDDO                                                  /*CLE009*/
                                                                      /*CLE009*/
             ENDDO                                                    /*CLE009*/
/*  If error during the use of AOSARDR0   ( for CLE007) */            /*CLE009*/
             ELSE IF (&PRTCD *NE '*NRF') THEN(DO)                     /*CLE009*/
/* Send database error message to workstation & MOPERQ  */            /*CLE009*/
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)           /*CLE009*/
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)              /*CLE009*/
               SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*CLE009*/
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)              /*CLE009*/
             ENDDO                                                    /*CLE009*/
                                                                      /*CLE009*/
             IF         COND(&CLE009 *EQ 'Y') THEN(DO)                /*CLE009*/
                                                                      /*CLE009*/
/* Save Fee Settlement data     */                                    /*CLE009*/
             CLRPFM     FILE(XLEFEED)                                 /*CLE009*/
             CLRPFM     FILE(XLEFEEAD)                                /*CLE009*/
             CPYF       FROMFILE(LEFEED) TOFILE(XLEFEED) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CLE009*/
             MONMSG     MSGID(CPF2869)
             CPYF       FROMFILE(LEFEEAD) TOFILE(XLEFEEAD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CLE009*/
             MONMSG     MSGID(CPF2869)
                                                                      /*CLE009*/
             IF         COND(&CLE002 *EQ 'Y') THEN(DO)                /*CLE009*/
/* Select records within LEFEED */                                    /*CLE009*/
             OPNQRYF    FILE((LEFEED)) OPTION(*UPD *INP) +
                          QRYSLT('(FSTS *EQ "A") *AND (FESPTI *EQ " +
                          ") *AND (FEPPTI *EQ " ") *AND (FEEPTI *EQ +
                          " ") *OR (FSTS *EQ "A") *AND (FESWRI *NE +
                          " ")')
                                                                      /*CLE009*/
/* Select records within LEFEEAD */                                   /*CLE009*/
             OPNQRYF    FILE((LEFEEAD)) OPTION(*UPD *INP) +
                          QRYSLT('(FARECI *EQ "S") *AND (SSTS *EQ +
                          "A") *AND ((FASTTI *EQ " ") *OR (FASWRI +
                          *NE " "))')                                 /*CLE009*/
             ENDDO                                                    /*CLE009*/
                                                                      /*CLE009*/
/* If CLE002 is switched off     */                                   /*CLE009*/
             ELSE  DO                                                 /*CLE009*/
                                                                      /*CLE009*/
/* Select records within LEFEED  */                                   /*CLE009*/
             OPNQRYF    FILE((LEFEED)) OPTION(*UPD *INP) +
                          QRYSLT('(FELCHT *EQ "I") *AND (FESPTI *EQ +
                          " ") *AND (FEPPTI *EQ " ") *AND (FEEPTI +
                          *EQ " ") *OR (FELCHT *EQ "R") *AND +
                          (FESWRI *EQ "R") *OR (FELCHT *EQ "A") +
                          *AND ((FESWRI *EQ "A") *OR (FESWRI *EQ +
                          "G"))')                                     /*CLE009*/
                                                                      /*CLE009*/
/* Select records within LEFEEAD */                                   /*CLE009*/
             OPNQRYF    FILE((LEFEEAD)) OPTION(*UPD *INP) +
                          QRYSLT('((FARECI *EQ "S") *AND (FAACTN +
                          *EQ " I") *AND (FASTTI *EQ " ")) *OR +
                          ((FARECI *EQ "S") *AND ((FAACTN *EQ " A") +
                          *OR (FAACTN *EQ " D")) *AND (FASWRI *NE " +
                          "))')                                       /*CLE009*/
             ENDDO                                                    /*CLE009*/
                                                                      /*CLE009*/
             CLRPFM     FILE(LEFEETPD)                                /*CLE009*/
/**/                                                                  /*CLE014*/
             IF         COND(&CLE014 *EQ 'Y') THEN(DO)                /*CLE014*/
                CLRPFM     FILE(LEFEECPD)                             /*CLE014*/
             ENDDO                                                    /*CLE014*/
/**/                                                                  /*CLE014*/
             CALL       PGM(LE1069)                                   /*CLE009*/
                                                                      /*CLE009*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*CLE009*/
             CHGVAR     VAR(&MSG) VALUE('Create Extract file for +
                          Fees failure')                              /*CLE009*/
/* Restore Fee Settlement data     */                                 /*CLE009*/
             CLRPFM     FILE(LEFEED)                                  /*CLE009*/
             CLRPFM     FILE(LEFEEAD)                                 /*CLE009*/
             CPYF       FROMFILE(XLEFEED) TOFILE(LEFEED) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CLE009*/
             MONMSG     MSGID(CPF2869)
             CPYF       FROMFILE(XLEFEEAD) TOFILE(LEFEEAD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CLE009*/
             MONMSG     MSGID(CPF2869)
             GOTO       CMDLBL(ERROR)                                 /*CLE009*/
             ENDDO                                                    /*CLE009*/
                                                                      /*CLE009*/
/* Clear Temporary Files           */                                 /*CLE009*/
             CLRPFM     FILE(XLEFEED)                                 /*CLE009*/
             CLRPFM     FILE(XLEFEEAD)                                /*CLE009*/
                                                                      /*CLE009*/
/* Close Fees Files                */                                 /*CLE009*/
             CLOF       OPNID(LEFEED)                                 /*CLE009*/
             CLOF       OPNID(LEFEEAD)                                /*CLE009*/
             ENDDO                                                    /*CLE009*/
                                                                      /*CLE009*/
/*  END OF SWIFT MESSAGE GENERATION FOR FEES                     */   /*CLE009*/
/**/                                                                  /*CLE009*/
                                                                      /*CLE009*/
             IF COND(%SST(&MMOD 28 1) *EQ 'Y') THEN(DO)
 
/* CHECK IF SWIFT 2009 IS ON       */                                                     /*CSW209*/
             CALL       PGM(SWIF2009) PARM(&PRTCD)                                        /*CSW209*/
             IF         COND(&PRTCD *EQ 'CSW2009')  THEN(DO)                              /*CSW209*/
/* CLEAR COVER MESSAGE FILE ONLY IF NOT A RE-RUN OF LE4510 */                             /*CSW209*/
             CLRPFM     FILE(MGCOVRPD)                                                    /*CSW209*/
             ENDDO                                                                        /*CSW209*/
                                                                                          /*CSW209*/
TAGE:        CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE('E')
 
             OVRDBF     FILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)
             CALL LE4510  /* COMIT LOANS ONLY */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive message +
                          generation failure')
             ROLLBACK
             CLRPFM     FILE(MGF100PD)
             CLRPFM     FILE(MGF202PD)
             CLRPFM     FILE(MGF210PD)
/*/COPY WNCPYSRC,LEC0213005                                          */
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,LEC0213013                                          */
 
TAGF:        CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE('F')
 
/* GDFs records are deleted as they are processed */
/*/COPY WNCPYSRC,LEC0213008                                          */
 
/* Process customer transfer messages */
             CALL       PGM(MG0100)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Customer transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO))
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process Bank transfer messages */
             CALL       PGM(MG0202)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Bank transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO))
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process notice to receive messages */
             CALL       PGM(MG0210)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Notice to receive formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO))
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,LEC0213009                                          */
 
/*/COPY WNCPYSRC,LEC0213014                                          */
/**********  RGZPFM     FILE(MGF100PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF100PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGF202PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF202PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGF210PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF210PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/*/COPY WNCPYSRC,LEC0213006                                          */
 
/* If ISO pay/receives required print messages */
             RCVF
             IF         COND(&ENFFAR = 'N') THEN(DO)
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                          TEXT('Outgoing ISO mail data queue')
             CALL PGM(ME0865)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('ISO print failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
             ENDDO
 
TAGG:        CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE('G')
 
/* Print pay/receive reports */
 
             SNDPGMMSG  MSG('Pay/receive telexes report') +
                        TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX1X)
             IF         COND(%SST(&MMOD 36 1) *EQ Y) THEN(DO)
                CHGJOB SWS(XXX1XXXX)
                CLRPFM FILE(LEPTXHH)
                CLRPFM FILE(LEPTXDD)
             ENDDO
             CALL       PGM(LE0500) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive telexes +
                          report failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGH:        CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE('H')
 
/* Incomplete instructions report */
             SNDPGMMSG  MSG('Incomplete instructions report') +
                        TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX1X)
             CALL       PGM(LE0510) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Incomplete instructions +
                          report failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGI:        CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE('I')
 
/* Bankers authorisations report */
             SNDPGMMSG  MSG('Bankers authorisations report') +
                        TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX1X)
             CALL       PGM(LE0520) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Bankers authorisations +
                          report failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGJ:        CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE('J')
 
             IF         COND(%SST(&RUNDAT 13 1) *EQ Y) THEN(DO)  /*E39477*/
/* Pay/receive settlements in other branches */
             SNDPGMMSG  MSG('Pay/rec other branches report ') +
                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             CALL       PGM(LE0550) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/rec other branches +
                          report failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO         /*E39477*/
 
TAGK:        CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE('K')
/**/                                                                  /*S01427*/
             IF         COND(%SST(&MMOD 43 1) *EQ 'Y') THEN(DO)       /*S01427*/
                CHGJOB     SWS(00000000)                              /*S01427*/
/**/                                                                  /*S01427*/
             CHGJOB     SWS(100XXXXX)                                 /*S01427*/
/**/                                                                  /*S01427*/
CALL       PGM(*LIBL/MCC01)                                           /*S01427*/
/**/                                                                  /*S01427*/
                IF  COND(%SWITCH(XXXXXXX0)) THEN(DO)                  /*S01427*/
CLRPFM     FILE(*LIBL/LETX6HH)                                        /*S01427*/
CLRPFM     FILE(*LIBL/LETX6PR)                                        /*S01427*/
CLRPFM     FILE(*LIBL/LETX6ZZ)                                        /*S01427*/
                ENDDO                                                 /*S01427*/
/**/                                                                  /*S01427*/
             ENDDO                                                    /*S01427*/
TAGM:        CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE('M')              /*S01427*/
 
/* Update pay/receive indicators on CLOAN file */
             SNDPGMMSG  MSG('Update pay/receive indicators') +
                          TOMSGQ(MRUNQ)
             CALL       PGM(LE1080)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Update pay/receive +
                          indicators failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE(' ')
                                                                      /*152352*/
/* Indicate that program has run successfully */                      /*152352*/
             CHGVAR     VAR(&ERR) VALUE('N')                          /*152352*/
                                                                      /*152352*/
             GOTO       CMDLBL(END)
 
ERROR:       IF         COND(&MSG = ' ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive generation +
                          failure')
             ENDDO
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Send database error message to workstation & MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
             CHGJOB     SWS(XXXXXX11)
                                                                      /*152352*/
             CHGVAR     VAR(&ERR) VALUE('Y')                          /*152352*/
                                                                      /*E40242*/
/**Reset*busy*flag*in*LESTAT**/                                       /*E40242*/
/************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD)) WAIT(32000)     /*E40242*/
                                                                      /*E40242*/
END:                                                                  /*E40242*/
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
             CALL       PGM(MEC0890) PARM('LE' 'P' 'ICJRN     ' +
                          &SDATE &STIME)                              /*E40242*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E40242*/
                                                                      /*E40242*/
/* Reset busy flag in LESTAT */                                       /*E40242*/
             ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD)) WAIT(32000)     /*E40242*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(LESTAT (7 1)) VALUE(N)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                    /*152352*/
/* Report to the user the Pay/Receive run has completed               /*152352*/
/*  &ERR = 'Y' - error occured within the CL stream                   /*152352*/
/*  &ERR = 'N' - no errors occured during CL stream                   /*152352*/
/*  &ERR = ' ' - job could not be started, message already sent       /*152352*/
                                                                      /*152352*/
             IF         COND(&ERR *EQ 'Y') THEN(CHGVAR VAR(&MSG) +
                          VALUE('Lending Pay/Receive run completed +
                          - ABNORMALLY'))                             /*152352*/
                                                                      /*152352*/
             IF         COND(&ERR *EQ 'N') THEN(CHGVAR VAR(&MSG) +
                          VALUE('Lending Pay/Receive run completed +
                          - SUCCESSFULLY'))                           /*152352*/
                                                                      /*152352*/
             IF         COND(&ERR *NE ' ') THEN(DO)                   /*152352*/
               SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ &MSGQ) +
                          MSGTYPE(*INFO)                              /*152352*/
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)              /*152352*/
             ENDDO                                                    /*152352*/
/**/                                                                  /*124684*/
             DLCOBJ     OBJ((LECONF *DTAARA *EXCL))                   /*124684*/
             MONMSG     MSGID(CPF0000)                                /*124684*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
