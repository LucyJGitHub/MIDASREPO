/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Input cycle term pay/receives')              */
/*********************************************************************/
/*                                                                   */
/*     Midas - LENDING                                               */
/*                                                                   */
/*     LEC0402  - INPUT CYCLE TERMINATION PAY/RECEIVE PROCESSING     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD021155           Date 19Jul13              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
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
/*                      099376  (100437)   DATE 14APR97              */
/*                      S01427             DATE 12JUL93              */
/*                      E46234             DATE 01FEB93              */
/*                      E40242             DATE 19JUN92              */
/*                      E39477             DATE 05MAY92              */
/*                   E29588       DATE 03FEB92                       */
/*                   S01310       DATE 23JUL91                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD021155 - COB Restructure Phase 1 Remnants                 */
/*                - Apply Standard Midas Journaling                  */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CLE014 - Customer Driven Lending Enhancements               */
/*       CLE009 - SWIFT Message Generation for Fees                  */
/*       099376 - Retrieve system date and time must be done prior   */
/*                to any GOTO END commands to prevent MEC0890 from   */
/*                falling over in trying to convert blank dates.     */
/*              - Also removed the checking on whether confirmation  */
/*                job is active or not as I/C term confirmation      */
/*                (LEC0401) is always being run prior to this P/R    */
/*                job (i.e. called from LEC04).                      */
/*       S01427 - R10 CHIPS INCORPORATION                            */
/*       E46234 - CRTDTAQ command will fail if data queue MEISOPRT   */
/*                already exist in QTEMP, either because it was      */
/*                created already in the program, or because I/C     */
/*                TERM was restarted. Fix is to monitor for CPF9870  */
/*     E40242 - CALL MEC0890 TO PRODUCE AUDIT LIST OF MESSAGES       */
/*              GENERATED                                            */
/*            - RETRY CODING INCORRECT - *GT REPLACED BY *LT         */
/*     E39477 - ONLY RUN LE0550 IF MUTIBRANCH                        */
/*     E29588 - POST COLLECTION RATIONALISATION FIXES.               */
/*     S01310 - RE WRITTEN FOR SWIFT RATIONALISATION                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE('     ')
             DCL        VAR(&FIVE) TYPE(*DEC) LEN(1 0) VALUE(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)    /*E39477*/
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&MCSTAT) TYPE(*CHAR) LEN(256)             /*S01427*/
                                                                      /*CLE009*/
             DCL        VAR(&CLE002) TYPE(*CHAR) LEN(1) VALUE('N')    /*CLE009*/
             DCL        VAR(&CLE009) TYPE(*CHAR) LEN(1) VALUE('N')    /*CLE009*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')     /*CLE009*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CLE014*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE014')                             /*CLE014*/
             DCL        VAR(&CLE014) TYPE(*CHAR) LEN(1) VALUE('N')    /*CLE014*/
/*/COPY WNCPYSRC,LEC0402001                                          */
 
             DCLF       FILE(SDMGMEPD)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                                  /*MD021155*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                                  /*MD021155*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*MD021155*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                 /*MD021155*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*MD021155*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*MD021155*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*MD021155*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*MD021155*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*MD021155*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*MD021155*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*MD021155*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*MD021155*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/**/                                                                                    /*MD021155*/
/* Write current journal sequence number to file SCJSEQPD  */                           /*MD021155*/
/**/                                                                                    /*MD021155*/
             CHGVAR     VAR(&CNAM) VALUE('LEC0004')                                     /*MD021155*/
             CHGVAR     VAR(&CSEQ) VALUE('00001')                                       /*MD021155*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*MD021155*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*MD021155*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*MD021155*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*MD021155*/
 
/* Notify MRUNQ */
             SNDPGMMSG  MSG('Input Cycle Termination Pay/Receive') +
                          TOMSGQ(MRUNQ)
 
/*/COPY WNCPYSRC,LEC0402005                                          */
/* Begin commitment control */
/*********** STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) ************/
/*********** MONMSG     MSGID(CPF0000 MCH0000) ***********************/
 
/* Zero switches */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(00000000)
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
/*  Retrieve System Date and Time - required to extract journal       /*099376*/
/*  entries for audit report.                                         /*099376*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*099376*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*099376*/
                                                                      /*099376*/
/* Check for pay/receive still active/failed */
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT) /*E39477*/
 
/* Should not run Pay/Recs if last Confirmation run ended in error */ /*E29588*/
             IF      COND(%SUBSTRING(&LESTAT 98 1) *NE ' ') THEN(DO)  /*E29588*/
             SNDPGMMSG  MSG('Lending Pay/Receive print requested but +
                          last Confirmation run ended in error') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)  /*E29588*/
             GOTO END                                                 /*E29588*/
             ENDDO                                                    /*E29588*/
             IF         COND((%SUBSTRING(&LESTAT 7 1) *EQ Y) *OR +
                          (%SUBSTRING(&LESTAT 97 1) *NE ' ')) THEN(DO)
             SNDPGMMSG  MSG('LENDING PAY/RECEIVE PRINT REQUESTED BUT +
                          PAY/RECEIVE ALREADY ACTIVE/FAILED') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO END
             ENDDO
/*/COPY WNCPYSRC,LEC0402002                                          */
 
             ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
             CHGVAR     VAR(%SUBSTRING(&LESTAT 7 1)) VALUE(Y)
             CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)
             DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
 
/**Call*confirmation*stop*program */
/************IF******** COND(%SST(&LESTAT 6 1) *EQ 'Y') THEN(CALL +     099376*/
/************************ PGM(LE0140))                                  099376*/
/**********************                                                 099376*/
/**Check*for*confirmations*still*active                                 099376*/
/*RETRY:****** RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)                099376*/
/**********************                                                 099376*/
/************IF******** COND(%SST(&LESTAT 6 1) *EQ 'Y') THEN(DO)        099376*/
/************RCVMSG**** WAIT(60) RMV(*NO)                               099376*/
/************CHGVAR**** VAR(&FIVE) VALUE(&FIVE + 1)                     099376*/
/**********************                                                 099376*/
/**Incorrect*Retry*coding*amended                            */ /*E40242099376*/
/************IF***COND(&FIVE *GT 5) THEN(GOTO CMDLBL(RETRY)) */ /*E40242099376*/
/************IF** COND(&FIVE *LT 5) THEN(GOTO CMDLBL(RETRY))    /*E40242099376*/
/************ELSE****** CMD(DO)                                         099376*/
/************SNDPGMMSG* MSG('JOB CANNOT BE RUN AT THIS TIME') +         099376*/
/************************ TOPGMQ(*EXT) TOMSGQ(MOPERQ)                   099376*/
/************GOTO END****                                               099376*/
/************ENDDO*******                                               099376*/
/************ENDDO*******                                               099376*/
/************************                                               099376*/
/***Retrieve*System*Date*and*Time*-*required*to*extract*journal /*E40242099376*/
/***entries*for*audit*report.*                                  /*E40242099376*/
/************RTVSYSVAL* SYSVAL(QTIME) RTNVAR(&STIME)            /*E40242099376*/
/************RTVSYSVAL* SYSVAL(QDATE) RTNVAR(&SDATE)            /*E40242099376*/
 
 
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
 
/*/COPY WNCPYSRC,LEC0402006                                          */
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
                   SNDPGMMSG  MSG('LE Input cycle term pay/receive +
                          failure - AOSARDR0 ERROR') +
                           TOMSGQ(MOPERQ)                             /*CLE014*/
                   GOTO   CMDLBL(ERROR)                               /*CLE014*/
             ENDDO                                                    /*CLE014*/
 
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
/*********   CLRPFM     FILE(XLEFEED)                                         */ /*CLE009 MD021155*/
/*********   CLRPFM     FILE(XLEFEEAD)                                        */ /*CLE009 MD021155*/
/*********   CPYF       FROMFILE(LEFEED) TOFILE(XLEFEED) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                         */ /*CLE009 MD021155*/
/*********   CPYF       FROMFILE(LEFEEAD) TOFILE(XLEFEEAD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                         */ /*CLE009 MD021155*/
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
                                                                      /*CLE009*/
             CALL       PGM(LE1069)                                   /*CLE009*/
                                                                      /*CLE009*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*CLE009*/
             CHGVAR     VAR(&MSG) VALUE('Create Extract file for +
                          Fees failure')                              /*CLE009*/
/* Restore Fee Settlement data     */                                 /*CLE009*/
/**********  CLRPFM     FILE(LEFEED)                                          */ /*CLE009 MD021155*/
/**********  CLRPFM     FILE(LEFEEAD)                                         */ /*CLE009 MD021155*/
/**********  CPYF       FROMFILE(XLEFEED) TOFILE(LEFEED) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                         */ /*CLE009 MD021155*/
/**********  CPYF       FROMFILE(XLEFEEAD) TOFILE(LEFEEAD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                         */ /*CLE009 MD021155*/
/**/                                                                                    /*MD021155*/
/* Retrieve The Most Recent Journal Entry Sequence Number */                            /*MD021155*/
/* for The Specific Job                                   */                            /*MD021155*/
/**/                                                                                    /*MD021155*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                             /*MD021155*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*MD021155*/
             CHGVAR     VAR(&START) VALUE(0)                                            /*MD021155*/
             ENDDO                                                                      /*MD021155*/
/**/                                                                                    /*MD021155*/
/* Determine Starting Journal Sequence Number of Current Job */                         /*MD021155*/
/**/                                                                                    /*MD021155*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*MD021155*/
/**/                                                                                    /*MD021155*/
/* Remove Journal Changes */                                                            /*MD021155*/
/**/                                                                                    /*MD021155*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                      /*MD021155*/
             RMVJRNCHG  JRN(ICJRN) FILE((LEFEED) (LEFEEAD)) +
                          RCVRNG(&SJRNRCVR &FJRNRCVR) +
                          FROMENT(&START) TOENT(&FINISH)                                /*MD021155*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*MD021155*/
             ENDDO                                                                      /*MD021155*/
 
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
/*/COPY WNCPYSRC,LEC0402009                                          */
             IF COND(%SST(&MMOD 28 1) *EQ 'Y') THEN(DO)
 
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
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,LEC0402007                                          */
 
TAGF:        CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE('F')
 
/* GDFs records are deleted as they are processed */
/*/COPY WNCPYSRC,LEC0402003                                          */
 
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
/*/COPY WNCPYSRC,LEC0402004                                          */
 
/*/COPY WNCPYSRC,LEC0402008                                          */
/**********  RGZPFM     FILE(MGF100PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF100PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGF202PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF202PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGF210PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF210PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
 
/* If ISO pay/receives required print messages */
             RCVF
             IF         COND(&ENFFAR = 'N') THEN(DO)
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                          TEXT('Outgoing ISO mail data queue')
             MONMSG     MSGID(CPF9870)                               /*E46234*/
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
             CHGJOB     SWS(010XXXXX)                                 /*S01427*/
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
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
                CLRPFM     FILE(LETX1HH)
                CLRPFM     FILE(LETX1PR)
                CLRPFM     FILE(LETX1ZZ)
                CLRPFM     FILE(LETX2HH)
                CLRPFM     FILE(LETX2PR)
                CLRPFM     FILE(LETX2ZZ)
                CLRPFM     FILE(LETX3HH)
                CLRPFM     FILE(LETX3PR)
                CLRPFM     FILE(LETX3ZZ)
                CLRPFM     FILE(LTRIEHD)
                CLRPFM     FILE(LTRIEDL)
                CLRPFM     FILE(LTRIEZZ)
                CLRPFM     FILE(LEPXTAA)
                CLRPFM     FILE(LEPXTAB)
                CLRPFM     FILE(LEPXTAC)
             ENDDO
 
             CHGDTAARA  DTAARA(LESTAT (99 1)) VALUE(' ')
/**/                                                                                    /*MD021155*/
/* Write Current Journal Sequence NUmber to File SCJSEQPD, Using */                     /*MD021155*/
/* Command SCWRTJREG */                                                                 /*MD021155*/
/**/                                                                                    /*MD021155*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*MD021155*/
             CHGVAR     VAR(&STEXT) VALUE('END OF ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*MD021155*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*MD021155*/
 
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
 
/**Reset*busy*flag*in*LESTAT */                                       /*E40242*/
/*D:*********ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD)) WAIT(32000)  */ /*E40242*/
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
 
/*********** ENDCMTCTL ***********************************************/
/*********** MONMSG     MSGID(CPF0000 RPG0000 MCH0000) ***************/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
