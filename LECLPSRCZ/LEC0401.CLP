/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE I/c termination conf. print')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - LENDING                                         */
/*                                                                   */
/*       LEC0401 - INPUT CYCLE TERMINATION CONFIRMATION PRINT        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD040628           Date 07Sep16              */
/*       Prev Amend No. MD021155           Date 19Jul13              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CSW208             Date 15Apr08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 10Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205448             Date 02May02              */
/*                      CCG015             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      176139             Date 26Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      114395             Date 05Nov97              */
/*                      CLE004             Date 02DEC96              */
/*                      S01408             Date 15MAY96              */
/*                      CCG008             Date 30OCT95              */
/*                      071204             DATE 08AUG95              */
/*                      S01465             DATE 22MAR94              */
/*                      E46234             DATE 01FEB93              */
/*                      E40242             DATE 19JUN92              */
/*                      S01310             DATE 16APR91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD040628 - If error occurs, return to calling program       */
/*                  with correct job switches.                       */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - Apply Standard Midas Journaling                  */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       CSW208 - SWIFT 2008 Changes                                 */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       205448 - UDC module must be on for Correspondence Manager   */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*       176139 - Override CLOAN with SHARE(*NO) before call to      */
/*                LE4500 to avoid CPF5125 (Update option not valid)  */
/*                for CLOAN in MG9210 - override before call to      */
/*                CG6000 will not be executed if UDC not installed.  */
/*       114395 - Issue OVRDBF CLOAN SHARE(*NO) before calling       */
/*                CG6000                                             */
/*       CLE004 - Customer Lending Enhancements - Syndications       */
/*       S01048 - Core hook LEC0401002 added                         */
/*                Core hook LEC0401001 added                         */
/*       CCG008 - User Defined Correspondence - Lending              */
/*       071204 - MGOREFL0 needs to be SHARE(*NO). This file is      */
/*                opened by MG9200 which calls MG9205 which also     */
/*                opens the file and tries to delete the record      */
/*                which MG9200 is pointed to, causing CPF4293.       */
/*       S01465 - BLI Lending Enhancement                            */
/*       E46234 - CRTDTAQ command will fail if data queue MEISOPRT   */
/*                already exist in QTEMP, either because it was      */
/*                created already in the program, or because I/C     */
/*                TERM was restarted. Fix is to monitor for CPF9870  */
/*       E40242 - CALL MEC0890 TO PRODUCE AUDIT LIST OF MESSAGES     */
/*                GENERATED                                          */
/*       S01310 - RE WRITTEN FOR SWIFT RATIONALISATION               */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
                                                                     /*S01465*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                 /*S01465*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)            /*S01465*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*CCG008*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*CCG008*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*CCG008*/
             DCL        VAR(&DSFDY)  TYPE(*CHAR) LEN(200)             /*CLE004*/
             DCL        VAR(&DSSDY)  TYPE(*CHAR) LEN(800)                                 /*CLE134*/
             DCL        VAR(&CONR) TYPE(*CHAR) LEN(1) VALUE(' ')      /*CLE004*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
                                                                                          /*CSW208*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CSW208*/
             DCL        VAR(&CSW208) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSW208*/
/*/COPY WNCPYSRC,LEC0401005                                          */
 
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
 
/* Zero switches */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(10100000)
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
 
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report.                                         /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
/*/COPY WNCPYSRC,LEH01029                                            */
/**/                                                                                      /*CSW208*/
/*  Check if SWIFT 2008 is installed. */                                                  /*CSW208*/
/**/                                                                                      /*CSW208*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CSW208*/
             CALL       PGM(SWIF2008) PARM(&PRTCD)                                        /*CSW208*/
             IF         COND(&PRTCD *EQ 'CSW2008') THEN(DO)                               /*CSW208*/
                CHGVAR     VAR(&CSW208) VALUE('Y')                                        /*CSW208*/
             ENDDO                                                                        /*CSW208*/
 
/* LEC0401 */
             IF COND(%SST(&LESTAT 98 1) *EQ 'A') THEN(GOTO TAGA)
             IF COND(%SST(&LESTAT 98 1) *EQ 'B') THEN(GOTO TAGB)
             IF COND(%SST(&LESTAT 98 1) *EQ 'C') THEN(GOTO TAGC)
 
             SNDPGMMSG  MSG('Input Cycle Termination Confirmation +
                        Print') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXX1XXXX)
/**/                                                                  /*CLE004*/
/** Access SDCLNDPD to determine if Consolidated Confirmation     */  /*CLE004*/
/** is required                                                   */  /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')                    /*CLE004*/
/**********  CALL       PGM(AOCLNDR0) PARM(&RTCD &OPTN &DSFDY) */                  /*CLE004 CLE134*/
             CALL       PGM(AOCLNDR0) PARM(&RTCD &OPTN &DSSDY)                            /*CLE134*/
/**/                                                                  /*CLE004*/
/*  Database error handling.                                          /*CLE004*/
/**/                                                                  /*CLE004*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*CLE004*/
                CHGVAR     VAR(&MSG) VALUE('Error on access to ICD  +
                             file SDCLNDPD')                          /*CLE004*/
                GOTO       CMDLBL(ERROR)                              /*CLE004*/
             ENDDO                                                    /*CLE004*/
/**/                                                                  /*CLE004*/
/**********  IF         COND(%SST(&DSFDY 53 1) *EQ 'Y') THEN(DO) */                /*CLE004 CLE134*/
             IF         COND(%SST(&DSSDY 53 1) *EQ 'Y') THEN(DO)      /*CLE004*/
             CHGVAR     VAR(&CONR) VALUE('Y')                         /*CLE004*/
             ENDDO                                                    /*CLE004*/
/**/                                                                  /*CCG008*/
/*  User Defined Correspondence processing. */                        /*CCG008*/
/**/                                                                  /*CCG008*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CCG008*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CCG008*/
/**/                                                                  /*CCG008*/
/*  Access PF/SDMMODPD to determine whether UDC module is on.         /*CCG008*/
/**/                                                                  /*CCG008*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*CCG008*/
/**/                                                                  /*CCG008*/
/*  Database error handling.                                          /*CCG008*/
/**/                                                                  /*CCG008*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*CCG008*/
                CHGVAR     VAR(&MSG) VALUE('Error on access to ICD  +
                             file SDMMODPD')                          /*CCG008*/
                GOTO       CMDLBL(ERROR)                              /*CCG008*/
             ENDDO                                                    /*CCG008*/
/**/                                                                  /*CCG008*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*CCG008*/
                OVRDBF     FILE(CLOAN) SHARE(*NO)                     /*114395*/
                                                                                          /*CCG015*/
/** Call Extract File Instance Management */                                              /*CCG015*/
                CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
                                                                                          /*CCG015*/
                CALL       PGM(CG6000) PARM(&W0RTN &W0CMT)            /*CCG008*/
                RCLRSC                                                /*CCG008*/
                IF         COND(&W0RTN *NE '       ') THEN(DO)        /*CCG008*/
                   CHGVAR     VAR(&MSG) VALUE('User Defined +
                                Correspondence Extract failure')      /*CCG008*/
                   ROLLBACK                                           /*CCG008*/
                   CLRPFM     FILE(LEEXTAA)                           /*CCG008*/
                   CLRPFM     FILE(LEEXTAB)                           /*CCG008*/
                   CLRPFM     FILE(LEEXTAC)                           /*CCG008*/
                   GOTO       CMDLBL(ERROR)                           /*CCG008*/
                ENDDO                                                 /*CCG008*/
/**********     CPYF       FROMFILE(LEEXTAB) TOFILE(QTEMP/XLEEXTAB) +
                              MBROPT(*REPLACE) CRTFILE(*YES)                  */ /*CCG008 MD021155*/
             ENDDO                                                    /*CCG008*/
/*/COPY WNCPYSRC,LEC0401006                                          */
/**/                                                                 /*S01465*/
/** Access SAR file to determine if switchable feature S01465     */ /*S01465*/
/** is switched ON                                                */ /*S01465*/
/**/                                                                 /*S01465*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                  /*S01465*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                  /*S01465*/
             CHGVAR     VAR(&SAR) VALUE('S01465')                    /*S01465*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD) /*S01465*/
/*/COPY WNCPYSRC,LEC0401009                                          */
             IF         COND(&RTCD *EQ '       ') THEN(DO)           /*S01465*/
/*/COPY WNCPYSRC,LEH01206                                            */
                OVRDBF     FILE(CLOAN2) TOFILE(CLOAN) SHARE(*NO)     /*S01465*/
/*/COPY WNCPYSRC,LEC0401003                                          */
                CALL       PGM(LE1150) PARM('     ' 'ALL')           /*S01465*/
/*/COPY WNCPYSRC,LEC0401004                                          */
                ENDDO                                                /*S01465*/
             ELSE       CMD(DO)                                      /*S01465*/
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,LEC0401001                                          /*S01408*/
/*                                                                   /*S01408*/
             CALL       PGM(LE0130) PARM('     ' 'ALL')
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,LEC0401002                                          /*S01408*/
/*                                                                   /*S01408*/
             ENDDO                                                   /*S01465*/
/**/                                                                  /*CLE004*/
             IF         COND(*NOT %SWITCH(XXXXXX1X) *AND +
                          *NOT %SWITCH(XXXXXXX1)) THEN(DO)            /*CLE004*/
 
             IF         COND(&CONR *EQ 'Y') THEN(DO)                  /*CLE004*/
/**/                                                                  /*CLE004*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*CLE004*/
             CHGVAR     VAR(&W0RTN) VALUE('       ')                  /*CLE004*/
                OVRDBF     FILE(CLOAN) SHARE(*NO)                     /*CLE004*/
                OVRDBF     FILE(LELOANL4) SHARE(*NO)                  /*CLE004*/
                OVRDBF     FILE(LOAMS) SHARE(*NO)                     /*CLE004*/
             CALL       PGM(CG6061) PARM(&W0RTN &W0CMT 'ALL' 'B')     /*CLE004*/
                DLTOVR     FILE(CLOAN LELOANL4 LOAMS)                 /*CLE004*/
                RCLRSC                                                /*CLE004*/
                IF         COND(&W0RTN *NE '       ') THEN(DO)        /*CLE004*/
                   ROLLBACK                                           /*CLE004*/
                   CHGVAR     VAR(&MSG) VALUE('User Defined +
                                Correspondence Extract failure')      /*CLE004*/
                   GOTO       CMDLBL(ERROR)                           /*CLE004*/
                ENDDO                                                 /*CLE004*/
             ENDDO                                                    /*CLE004*/
             CALL       PGM(LE1180) PARM('     ' 'ALL' 'B')           /*CLE004*/
             ENDDO                                                    /*CLE004*/
             ENDDO                                                    /*CLE004*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
/** Call Custom Defined Data Extract pgm */                                               /*CCG015*/
                CALL       PGM(CGC3604)                                                   /*CCG015*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*CCG015*/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)                           /*CCG015*/
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                              /*CCG015*/
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)                         /*CCG015*/
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                              /*CCG015*/
                   GOTO       CMDLBL(ERROR)                                               /*CCG015*/
                ENDDO                                                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmations print failure')
             ROLLBACK
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*CCG008*/
/**********  CPYF       FROMFILE(XLEEXTAB) TOFILE(LEEXTAB) +
                          MBROPT(*REPLACE)                                    */ /*CCG008 MD021155*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEEXTAB))                                      */ /*CCG008 MD021155*/
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
/* Determine Stating  Journal Sequence Number of Current Job */                         /*MD021155*/
/**/                                                                                    /*MD021155*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*MD021155*/
/**/                                                                                    /*MD021155*/
/* Remove Journal Changes */                                                            /*MD021155*/
/**/                                                                                    /*MD021155*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                      /*MD021155*/
             RMVJRNCHG  JRN(ICJRN) FILE((LEEXTAB)) RCVRNG(&SJRNRCVR +
                          &FJRNRCVR) FROMENT(&START) TOENT(&FINISH)                     /*MD021155*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*MD021155*/
             ENDDO                                                                      /*MD021155*/
 
             CLRPFM     FILE(LEEXTAA)                                 /*CCG008*/
             CLRPFM     FILE(LEEXTAC)                                 /*CCG008*/
             GOTO       CMDLBL(ERROR)                                 /*CCG008*/
             ENDDO                                                    /*CCG008*/
             ELSE (DO)                                                /*CCG008*/
             CLRPFM     FILE(LEEXTAA)
             CLRPFM     FILE(LEEXTAB)
             CLRPFM     FILE(LEEXTAC)
             GOTO       CMDLBL(ERROR)
             ENDDO                                                    /*CCG008*/
             ENDDO
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF COND(%SST(&MMOD 28 1) *EQ 'Y') THEN(DO)
 
TAGA:        CHGDTAARA  DTAARA(LESTAT (98 1)) VALUE('A')
 
/** File over-ride for MGOREFL0                                   */ /*071204*/
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)                    /*071204*/
                                                                     /*071204*/
/* Extract messages */
             OVRDBF     FILE(CLOAN) SHARE(*NO)                        /*176139*/
             CALL       PGM(LE4500) /* COMIT ONLY LOANS */
 
/* If all CONEX not processed report failure */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmation extract failure')
             ROLLBACK
             CLRPFM     FILE(MGF320PD)
             CLRPFM     FILE(MGF330PD)
             IF         COND(&CSW208 *EQ 'Y') THEN(DO)                                    /*CSW208*/
                CLRPFM     FILE(MGX320PD)                                                 /*CSW208*/
             ENDDO                                                                        /*CSW208*/
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGB:        CHGDTAARA  DTAARA(LESTAT (98 1)) VALUE('B')
             CLRPFM     FILE(LEEXTAA)
             CLRPFM     FILE(LEEXTAB)
             CLRPFM     FILE(LEEXTAC)
 
/* GDFs records are deleted as they are processed */
/*/COPY WNCPYSRC,LEC0401007                                          */
 
/* Process fixed loan/deposit confirmations */
             CALL       PGM(MG0320)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process call loan/deposits */
             CALL       PGM(MG0330)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Call loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,LEC0401008                                          */
 
/**********  RGZPFM     FILE(MGF320PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF320PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGF330PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             IF         COND(&CSW208 *EQ 'Y') THEN(DO)                                    /*CSW208*/
                RGZPFM     FILE(MGX320PD)                                                 /*CSW208*/
                MONMSG     MSGID(CPF2995 CPF2981)                                         /*CSW208*/
             ENDDO                                                                        /*CSW208*/
             CALL       PGM(SCC000060) PARM('MGF330PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
 
TAGC:        CHGDTAARA  DTAARA(LESTAT (98 1)) VALUE('C')
 
/* If ISO confirmations required print messages */
             RCVF
             IF         COND(&ENFFCR = 'N') THEN(DO)
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                          TEXT('Outgoing ISO mail data queue')
             MONMSG     MSGID(CPF9870)                               /*E46234*/
             CALL       PGM(ME0865)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('ISO print failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
             ENDDO
 
/* Reset  of Lending Confs Flag moved to after audit program */       /*E40242*/
/************CHGDTAARA  DTAARA(LESTAT (98 1)) VALUE(' ') */           /*E40242*/
/**/                                                                                    /*MD021155*/
/* Write Current Journal Sequence Number to File SCJSEQPD, Using */                     /*MD021155*/
/* Command SCWRTJREG */                                                                 /*MD021155*/
/**/                                                                                    /*MD021155*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*MD021155*/
             CHGVAR     VAR(&STEXT) VALUE('END OF ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*MD021155*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*MD021155*/
 
             GOTO       CMDLBL(END)
 
ERROR:       IF         COND(&MSG = ' ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmation +
                          generation failure')
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
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
             CHGJOB     SWS(XXXXXX11)                                                   /*MD040628*/
             RETURN                                                                     /*MD040628*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                      /*E40242*/
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
             CALL       PGM(MEC0890) PARM('LE' 'C' 'ICJRN     ' +
                          &SDATE &STIME)                              /*E40242*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E40242*/
                                                                      /*E40242*/
             CHGDTAARA  DTAARA(LESTAT (98 1)) VALUE(' ')              /*E40242*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E40242*/
                                                                      /*E40242*/
             ENDPGM
