/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL FRA/IRS i/c 0 rate fix days - control 2')    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - FRA/IRS MODULE                                  */
/*                                                                   */
/*       DLC1921 - ZERO RATE FIX CONTROL - 2                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD048071           Date 08Nov17              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD028276           Date 25Nov14              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      240412             Date 03Jul06              */
/*                      236177             Date 22Sep05              */
/*                      227443             Date 25Jun04              */
/*                      BUG7795            Date 10May05              */
/*                      BUG6752            Date 10May05              */
/*                      BUG6098            Date 09May05              */
/*                      BUG6604            Date 20Apr05              */
/*                      LSC124             Date 05Jul04              */
/*                      228542             Date 05Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205448             Date 02May02              */
/*                      CCG015             DATE 14Nov01              */
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSW097             Date 02Dec99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP006             DATE 10MAY99              */
/*                      107800             DATE 17feb98              */
/*                      CSW011             Date 19Mar97              */
/*                      CSW005             Date 01Aug96              */
/*                      090998             Date 16Feb96              */
/*                      CIR001             Date 12Sep95              */
/*                      081938             DATE 30JAN95              */
/*                      081957             DATE 16JAN95              */
/*                      S01522             DATE 18NOV94              */
/*                      046820             DATE 13DEC93              */
/*                      046856             DATE 18NOV93              */
/*                      E29419             DATE 11OCT91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD048071 - Input Cycle Batch Job DLC1921 Looping. Add error */
/*                  monitoring after ROLLBACK so that when it fails  */
/*                  job will end.                                    */
/*       MD046248 - Finastra Rebranding                              */
/*       MD028276 - MT341 messages generated not saved on MGF341TR   */
/*                  during IC                                        */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       240412 - Do not clear DLOLACPD and DLOLCFPD. Applied 236794 */
/*                Applied as 227443.                                 */
/*       236177 - Applied fix 227443 to prevent locking problem.     */
/*       227443 - Remove clearing of files DLOLACPD and DLOLCFPD as  */
/*                this is not necessary.                             */
/*       BUG7795 - Add override to xxMIUSRMSG                        */
/*       BUG6752 - Change default option to rate fixing run for      */
/*                 DL1924. Also setup &RERUN for DL1922.             */
/*       BUG6098  Update option not valid for member DEALS           */
/*                in program DL1705.                                 */
/*       BUG6604- Removal of RCLRSC from this program                */
/*       LSC124 - Retry FRA/IRS I/C 0 Rate Fix up to 5 times if      */
/*                Midas already producing confirmations.             */
/*                Hooks used : DLC1921007, DLC1921008.               */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       205448 - UDC module must be on for Correspondence Manager   */
/*       CCG015 - Correspondence Manager - Phase 1                   */
/*       CSC011 - 24x7 Midas Availability                            */
/*       CCB009 - Journal files throughout close of business         */
/*       CSW097 - SWIFT 97 changes to MT340s and MT360s.             */
/*       CAP006 - APIs Phase IV                                      */
/*                Scope commitment control to the job rather than    */
/*                the activation group                               */
/*       107800 - FRA ARE FIXED BEFORE THEIR FIXING DATE : OPNQRYF   */
/*                DOES NOT SELECT DEALS WITH VDAT=RUND.              */
/*       CSW011 - Suppression of MT36n messages                      */
/*       CSW005 - MG34n and Mg36n message generation                 */
/*       090998 - Change 088675 causes a FOOB error in DL1705.       */
/*                A new logical file DLIND2 has been created and     */
/*                should be used instead of DLIND.                   */
/*       CIR001 - Interest Rate Calendars.                           */
/*       081938 - Reclaim resources after CG4000                     */
/*       081957 - Reclaim resources after CG4100                     */
/*       S01522 - USER DEFINED CORRESPONDENCE                        */
/*       046820 - Should use new logical file DLDLDGLF which also    */
/*                picks up reversed deals, which allows MT'92S to    */
/*                be generated. Add parameter to DL6320 for re-run.  */
/*       046856 - Add in a call to MEC0890.                          */
/*       E29419 - RE WRITTEN FOR S.W.I.F.T. Rationalisation.         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&FIVE) TYPE(*DEC) LEN(1 0) VALUE(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REON) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
 
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CHSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SLT) TYPE(*CHAR) LEN(89) VALUE('UBRTT +
                          *NE 0 & UFRFD *EQ 0 & VDAT *EQ       *OR +
                          TBRTT *NE 0 & TFRFD *EQ 0 & VDAT *EQ      ')
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*046856*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*046856*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*S01522*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01522*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01522*/
             DCL        VAR(&CSW005) TYPE(*CHAR) LEN(6)               /*CSW005*/
             DCL        VAR(&CSW5ON) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CSW005*/
             DCL        VAR(&CSW011) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CSW011*/
             DCL        VAR(&OPIO) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CIR001*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CIR001')  /*CIR001*/
             DCL        VAR(&SLTIR) TYPE(*CHAR) LEN(408)  +
               VALUE('DTYP *EQ "FR" & VDAT = 00000 *OR +
                      DTYP *NE "FR" & UINPM = "Y" & VDAT = 00000 *OR +
                      DTYP *NE "FR" & UINPM = "D" & VDAT = 00000 *OR +
                      DTYP *NE "FR" & UINPM = "Y" & UNIPD = 00000 *OR +
                      DTYP *NE "FR" & UINPM = "D" & UNIPD = 00000 *OR +
                      DTYP *NE "FR" & TINPM = "Y" & VDAT = 00000 *OR +
                      DTYP *NE "FR" & TINPM = "D" & VDAT = 00000 *OR +
                      DTYP *NE "FR" & TINPM = "Y" & TNIPD = 00000 *OR +
                      DTYP *NE "FR" & TINPM = "D" & TNIPD = 00000')   /*CIR001*/
                                                                      /*CSW005*/
/*  Multiple language support variables  */                           /*CSW005*/
                                                                      /*CSW005*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*CSW005*/
             DCL        VAR(&MIDASLG) TYPE(*CHAR) LEN(10)             /*CSW005*/
             DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)            /*082507*/
             DCL        VAR(&MIUSRMSG) TYPE(*CHAR) LEN(10)                               /*BUG7795*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)               /*CSW005*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)                /*CSW005*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*CSW005*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*CSW005*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*CSW005*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*/COPY WNCPYSRC,DLC1921004                                          */
 
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC011*/
             DCL        VAR(&S1SUPP) TYPE(*CHAR) LEN(2) VALUE(' ')                        /*CSC011*/
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(2) VALUE(' ')                          /*CSC011*/
                                                                                          /*CSC011*/
             DCL        VAR(&CSW2013) TYPE(*CHAR) LEN(7) VALUE('       ')               /*MD028276*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)                                  /*MD028276*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                 /*MD028276*/
             DCL        VAR(&COMACT) TYPE(*CHAR) LEN(1) VALUE(' ')                      /*MD048071*/
                                                                                        /*MD028276*/
/* Declare SDBANKPD for run-date */
             DCLF       FILE(SDBANKPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/*/COPY WNCPYSRC,DLH00180                                            */
                                                                                          /*CSC011*/
/** Check if switchable feature CSW213 is on */                                         /*MD028276*/
 
             CALL       PGM(SWIF2013) PARM(&CSW2013)                                    /*MD028276*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)                         /*MD028276*/
             SNDPGMMSG  MSG('Call to SWIF2013 program failed.') +
                          TOPGMQ(*EXT)                                                  /*MD028276*/
                GOTO       CMDLBL(ERROR)                                                /*MD028276*/
             ENDDO                                                                      /*MD028276*/
                                                                                        /*MD028276*/
/** Check if switchable feature CSC011 is on */                                           /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSC011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC011*/
             CHGVAR     VAR(&SAR) VALUE('CSC011')                                         /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR)                              /*CSC011*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&CSC011) VALUE('Y')                                        /*CSC011*/
                RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&S1SUPP)                           /*CSC011*/
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBR)                             /*CSC011*/
             ENDDO
                                                                                          /*CSC011*/
             IF         COND((&CSC011 *EQ 'Y') *AND (&S1SUPP *EQ +
                &LIBR)) THEN(DO)                                                          /*CSC011*/
                  SNDPGMMSG  MSG('Input Cycle Pay/Receive requested, +
                     but not valid on the support system') +
                     TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)                     /*CSC011*/
                  GOTO       CMDLBL(END)                                                  /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/* Notify MRUNQ */
             SNDPGMMSG  MSG('Input Cycle FRA settlement and +
                          Pay/Receive') TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*/COPY WNCPYSRC,DLC1921009                                          */
 
/* Begin commitment control */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) **/        /*CAP006*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CAP006*/
                                                                                        /*MD048071*/
             CHGVAR     VAR(&COMACT) VALUE('Y')                                         /*MD048071*/
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
/*  Multiple Language Support -                  */                   /*CSW005*/
/*  Set up overrides for message files           */                   /*CSW005*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                              /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                 /*CSW005*/
                CHGVAR     VAR(&MULT) VALUE('GB')                     /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
/*  Build Multiple Language Support Object Names  */                  /*CSW005*/
             CHGVAR     VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')  /*CSW005*/
             CHGVAR     VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ') /*CSW005*/
             CHGVAR     VAR(&MIUSRMSG) VALUE(&MULT *CAT 'MIUSRMSG  ')                    /*BUG7795*/
                                                                      /*CSW005*/
/*  Apply Multiple Language Support Overrides  */                     /*CSW005*/
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDASLG)                  /*CSW005*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)              /*CSW005*/
             OVRMSGF    MSGF(MIUSRMSG) TOMSGF(&MIUSRMSG)                                 /*BUG7795*/
                                                                      /*CSW005*/
 
/* Zero switches */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(00000000)
/*/COPY WNCPYSRC,DLC1921002                                          */
 
/* Access MMOD for module details */
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/* If the C.H.I.P.S. i/f is in the system check for o/s messages     */
             IF         COND(%SST(&MMOD 41 1) *EQ 'Y') THEN(DO)
             RTVDTAARA  DTAARA(CHSTAT) RTNVAR(&CHSTAT)
 
             IF         COND(%SST(&CHSTAT 1 1) *EQ 'Y') THEN(DO)
             SNDPGMMSG  MSG('Previous C.H.I.P.S. Messages still +
                          outstanding - JOB CANNOT BE RUN') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO END
             ENDDO
             ENDDO
 
/* If Retail or IoA switched on, set U2 for MEMOS update */
             IF         COND((%SUBSTRING(&MMOD 23 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 16 1) = 'Y')) THEN(DO)
             CHGJOB     SWS(X1XXXXXX)
             CHGVAR     VAR(&REON) VALUE(Y)
             ENDDO
 
/* If SWIFT/Dealing or Telex/Dealing is on set U3 for DL0195 */
             IF         COND((%SST(&MMOD 25 1) = Y) *OR (%SST(&MMOD +
                          51 1) = Y) *AND (%SST(&MMOD 53 1) = Y)) +
                          THEN(DO)
             CHGJOB     SWS(XX1XXXXX)
             ENDDO
 
/*/COPY WNCPYSRC,DLC1921003                                          */
/* Check if CSW005 is existing in SCSARDPD */                         /*CSW005*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSW005*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSW005*/
             CHGVAR     VAR(&CSW005) VALUE('CSW005')                  /*CSW005*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &CSW005 ' ')   /*CSW005*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSW5ON) VALUE('Y'))                    /*CSW005*/
             ELSE       CMD(CHGVAR VAR(&CSW5ON) VALUE('N'))           /*CSW005*/
                                                                      /*CSW011*/
             CHGVAR     VAR(&CSW005) VALUE('CSW011')                  /*CSW011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &CSW005 ' ')   /*CSW011*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSW011) VALUE('Y'))                    /*CSW011*/
                                                                      /*CSW011*/
/* Check for confirmations still active */
RETRY:       RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
             IF         COND(%SST(&DLSTAT 6 1) *EQ 'Y') THEN(DO)
             RCVMSG     WAIT(60) RMV(*NO)
             CHGVAR     VAR(&FIVE) VALUE(&FIVE + 1)
 
/*/COPY WNCPYSRC,DLC1921007                                          */
             IF         COND(&FIVE *GT 5) THEN(GOTO CMDLBL(RETRY))
/*/COPY WNCPYSRC,DLC1921008                                          */
             ELSE       CMD(DO)
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO END
             ENDDO
             ENDDO
 
/* Block large files */
             OVRDBF     FILE(PREXPH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX1PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX2PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX3PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX4PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX5PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX6PH) SEQONLY(*YES 50)
             OVRDBF     FILE(DLINDDM) SEQONLY(*YES 500)
 
/* Override transaction files */
             OVRDBF     FILE(TRANS) TOFILE(DLIND)
             OVRDBF     FILE(DEAMS) TOFILE(DAUPD)
 
             IF COND(%SST(&DLSTAT 97 1) *EQ 'C') THEN(GOTO TAGC)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'D') THEN(GOTO TAGD)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'E') THEN(GOTO TAGE)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'F') THEN(GOTO TAGF)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'G') THEN(GOTO TAGG)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'H') THEN(GOTO TAGH)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'I') THEN(GOTO TAGI)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'J') THEN(GOTO TAGJ)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'K') THEN(GOTO TAGK)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'L') THEN(GOTO TAGL)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'M') THEN(GOTO TAGM)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'N') THEN(GOTO TAGN)      /*CSW005*/
             IF COND(%SST(&DLSTAT 97 1) *EQ 'O') THEN(GOTO TAGO)      /*CSW005*/
             IF COND(%SST(&DLSTAT 97 1) *EQ 'P') THEN(GOTO TAGP)      /*CSW005*/
 
/* Read SDBANKPD for run-date, and insert this into OPNQRYF */
             RCVF
/*********** OVRDBF     FILE(DLDLDGLC) SHARE(*YES)                */ /*107800*/
/**/                                                                  /*CIR001*/
/* Check for CIR001 and process IRSs as well if switched on.       */ /*CIR001*/
/**/                                                                  /*CIR001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CIR001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPIO &SAR ' ')      /*CIR001*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CIR001*/
               CHGVAR VAR(%SST(&SLTIR 024 5)) VALUE(&BJRDNB)          /*CIR001*/
               CHGVAR VAR(%SST(&SLTIR 071 5)) VALUE(&BJRDNB)          /*CIR001*/
               CHGVAR VAR(%SST(&SLTIR 118 5)) VALUE(&BJRDNB)          /*CIR001*/
               CHGVAR VAR(%SST(&SLTIR 166 5)) VALUE(&BJRDNB)          /*CIR001*/
               CHGVAR VAR(%SST(&SLTIR 214 5)) VALUE(&BJRDNB)          /*CIR001*/
               CHGVAR VAR(%SST(&SLTIR 261 5)) VALUE(&BJRDNB)          /*CIR001*/
               CHGVAR VAR(%SST(&SLTIR 308 5)) VALUE(&BJRDNB)          /*CIR001*/
               CHGVAR VAR(%SST(&SLTIR 356 5)) VALUE(&BJRDNB)          /*CIR001*/
               CHGVAR VAR(%SST(&SLTIR 404 5)) VALUE(&BJRDNB)          /*CIR001*/
               OVRDBF     FILE(DLDLDGLF) TOFILE(DLDLDGLG) SHARE(*YES) /*CIR001*/
             IF         COND(&CSW5ON *EQ 'N') THEN(DO)               /*CSW005*/
             IF         COND(&CSW011 *NE 'Y') THEN(DO)                /*CSW011*/
               OPNQRYF    FILE(DLDLDGLG) OPTION(*INP) +
                          QRYSLT(&SLTIR) KEYFLD(*FILE)                /*CIR001*/
             ENDDO                                                    /*CSW011*/
             ENDDO                                                    /*CSW005*/
             ENDDO                                                    /*CIR001*/
             ELSE       CMD(DO)                                       /*CIR001*/
             CHGVAR VAR(%SST(&SLT 38 5)) VALUE(&BJRDNB)
             CHGVAR VAR(%SST(&SLT 85 5)) VALUE(&BJRDNB)
/************OPNQRYF    FILE(DLDLDGLC) OPTION(*INP) +             */ /*046820*/
/************             QRYSLT(&SLT) KEYFLD(*FILE)              */ /*046820*/
             IF         COND(&CSW5ON *EQ 'N') THEN(DO)               /*CSW005*/
             IF         COND(&CSW011 *NE 'Y') THEN(DO)                /*CSW011*/
             OVRDBF     FILE(DLDLDGLF) SHARE(*YES)                   /*107800*/
             OPNQRYF    FILE(DLDLDGLF) OPTION(*INP) +
                             QRYSLT(&SLT) KEYFLD(*FILE)              /*046820*/
             ENDDO                                                    /*CSW011*/
             ENDDO                                                    /*CSW005*/
             ENDDO                                                    /*CIR001*/
 
/* Call DL1922 to create work file DLIND */
/************IF         COND(&CSW5ON *EQ 'N') THEN(DO)     /*CSW005*/ /*CSW011*/
             IF         COND((&CSW5ON *EQ 'N') & (&CSW011 *NE 'Y')) +
                          THEN(DO)                                    /*CSW011*/
/**********  CHGVAR     VAR(&RERUN) VALUE(%SST(&RPARM 1 1))                              /*BUG6752*/
             IF         ((%SST(&RPARM 1 1) *NE '1')) THEN( +
                CHGVAR     VAR(&RERUN) VALUE('N'))                                       /*BUG6752*/
             ELSE       CHGVAR     VAR(&RERUN) VALUE('Y')                                /*BUG6752*/
             CALL       PGM(DL1922) PARM(&RERUN)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive extract failure')
             CLRPFM     FILE(DLINDHH)
             CLRPFM     FILE(DLINDDM)
             CLRPFM     FILE(DLINDZX)
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO                                                    /*CSW005*/
 
/* Call DL1924 with re-run parameter*/                                /*CSW005*/
/************IF         COND(&CSW5ON *EQ 'Y') THEN(DO)     /*CSW005*/ /*CSW011*/
             IF         COND((&CSW5ON *EQ 'Y') *OR (&CSW011 *EQ +
                          'Y')) THEN(DO)                              /*CSW011*/
/**********   IF         ((%SST(&RPARM 1 1) *EQ '0')) THEN( +
                CHGVAR     VAR(&RERUN) VALUE('N'))                                    */ /*BUG6752*/
              IF         ((%SST(&RPARM 1 1) *NE '1')) THEN( +
                CHGVAR     VAR(&RERUN) VALUE('N'))                                       /*BUG6752*/
              ELSE       CHGVAR     VAR(&RERUN) VALUE('Y')            /*CSW005*/
             IF         COND(&RERUN *EQ 'Y') THEN(OVRDBF +
                          FILE(DLDLDGLJ) TOFILE(DLDLDGLK))            /*CSW005*/
             CALL       PGM(DL1924) PARM(&RERUN)                      /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*CSW005*/
             CHGVAR     VAR(&MSG) VALUE('FRA/IRS Rate Fix and +
                          Settlement failure.')                       /*CSW005*/
             CLRPFM     FILE(DLINDHH)                                 /*CSW005*/
             CLRPFM     FILE(DLINDDM)                                 /*CSW005*/
             CLRPFM     FILE(DLINDZX)                                 /*CSW005*/
             GOTO       CMDLBL(ERROR)                                 /*CSW005*/
             ENDDO                                                    /*CSW005*/
             ENDDO                                                    /*CSW005*/
TAGC:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('C')
             CLRPFM     FILE(ECONXCY)                                 /*CSW005*/
             CLRPFM     FILE(ECONXCZ)                                 /*CSW005*/
/* */                                                                 /*S01522*/
/* User Defined Correspondence processing  */                         /*S01522*/
/* */                                                                 /*S01522*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01522*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S01522*/
/* */                                                                 /*S01522*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*S01522*/
/* */                                                                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S01522*/
/* */                                                                 /*S01522*/
/** Database error handling                                           /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S01522*/
             SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                              /*S01522*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
                                                                      /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             STRJRNPF   FILE(ECONXCY ECONXCZ DLINDDM DAINDDL) +
                          JRN(ICJRN) IMAGES(*BOTH)                    /*CSW005*/
             ENDDO                                                    /*CCB009*/
                                                                                          /*CCG015*/
/* Override relevant files for Correspondent Manager module */                            /*CCG015*/
                                                                                          /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
/* */                                                                                     /*CCG015*/
             CALL       PGM(CG4100) PARM(&W0RTN &W0CMT)               /*S01522*/
                                                                      /*S01522*/
/*******     RCLRSC                                                   /*081957*/    /*BUG6604*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
                          Extract failure')                           /*S01522*/
             ROLLBACK                                                 /*081957*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(ECONXCY ECONXCZ DLINDDM DAINDDL) +
                          JRN(ICJRN)                                  /*CSW005*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CSW005*/
             ENDDO                                                    /*CCB009*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(ECONXCY ECONXCZ DLINDDM DAINDDL) +
                          JRN(ICJRN)                                  /*CSW005*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CSW005*/
             ENDDO                                                    /*CCB009*/
/************ENDDO                                            /*S01522/*205448*/
                                                                                          /*CCG015*/
/* If Correspondence manager is switched on, call custom defined */                       /*CCG015*/
/* extract program                                               */                       /*CCG015*/
                                                                                          /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
/* */                                                                                     /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
             CHGVAR     VAR(&MSG) VALUE('Correspondence Manager +
                        Custom-Defined Data Extract failed.')                             /*CCG015*/
             GOTO       CMDLBL(ERROR)                                                     /*CCG015*/
             ENDDO                                                                        /*CCG015*/
             ENDDO                                                                        /*205448*/
 
             CHGJOB     SWS(00XXXXXX)
/************IF         COND(&CSW5ON *EQ 'Y') THEN(DO) */  /*CSW005*/ /*CSW011*/
             IF         COND((&CSW5ON *EQ 'Y') *OR (&CSW011 *EQ +
                          'Y')) THEN(DO)                              /*CSW011*/
             CHGJOB     SWS(XXX1XXXX)                                 /*CSW005*/
             ENDDO                                                    /*CSW005*/
             OVRDBF     FILE(DLIND) TOFILE(DLIND2)                    /*090998*/
/*/COPY WNCPYSRC,DLC1921001                                          */
             CALL DL0195
             DLTOVR     FILE(DLIND)                                   /*090998*/
             CHGJOB     SWS(XXX0XXXX)                                 /*CSW005*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('FRA/IRS pay/receive extract +
                          - Confirmation print failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGD:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('D')
 
             CLRPFM     FILE(PREXHH)
             CLRPFM     FILE(PREXPH)
             CLRPFM     FILE(PREXZZ)
/*/COPY WNCPYSRC,DLH00473                                            */
             CHGJOB     SWS(XXXXXX00)
             OVRDBF     FILE(DEALS) SHARE(*NO)                                           /*BUG6098*/
             CALL DL1705
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Create pay/receive extract +
                          file failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGE:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('E')
             CLRPFM     FILE(DLINDHH)
             CLRPFM     FILE(DLINDDM)
             CLRPFM     FILE(DLINDZX)
 
             CLRPFM     FILE(PREX1HH)
             CLRPFM     FILE(PREX1PH)
             CLRPFM     FILE(PREX1ZZ)
             CLRPFM     FILE(PREX2HH)
             CLRPFM     FILE(PREX2PH)
             CLRPFM     FILE(PREX2ZZ)
             CLRPFM     FILE(PREX3HH)
             CLRPFM     FILE(PREX3PH)
             CLRPFM     FILE(PREX3ZZ)
             CLRPFM     FILE(PREX4HH)
             CLRPFM     FILE(PREX4PH)
             CLRPFM     FILE(PREX4ZZ)
             CLRPFM     FILE(PREX5HH)
             CLRPFM     FILE(PREX5PH)
             CLRPFM     FILE(PREX5ZZ)
             CLRPFM     FILE(PREX6HH)
             CLRPFM     FILE(PREX6PH)
             CLRPFM     FILE(PREX6ZZ)
/*/COPY WNCPYSRC,DLC1921010                                          */
 
             CALL       PGM(DL0307)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive file split +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC1921011                                          */
 
TAGF:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('F')
 
             SNDPGMMSG  MSG('Pay/Receive Telexes Report') TOMSGQ(MRUNQ)
 
/*           CHGJOB     SWS(XXXXXX1X)           */
             CALL       PGM(DL0308) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Complete pay/receive +
                          telexes failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGG:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('G')
 
             SNDPGMMSG  MSG('Incomplete Instructions Report') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX1X)
             CALL       PGM(DL0312) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Incomplete pay/receive +
                          telexes failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGH:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('H')
 
             SNDPGMMSG  MSG('Bankers Authorisations Report') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX1X)
             CALL       PGM(DL0314) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Bankers Authorisations +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGI:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('I')
 
             SNDPGMMSG  MSG('Internal Settlements Report') +
                          TOMSGQ(MRUNQ)
 
/* Set switch for Retail/IoA (U1 in DL0318) */
             IF         COND(&REON *EQ Y) THEN(CHGJOB SWS(1XXXXXXX))
             CALL       PGM(DL0318) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Internal Settlements failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGJ:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('J')
 
             OVRDBF     FILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(DEALS) SHARE(*NO)
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)
 
/************CALL DL6320  /* COMIT DEALS ONLY                     */ /*046820*/
             CALL       PGM(DL6320) PARM(&RERUN)   /* COMIT DEALS */ /*046820*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('FRA/IRS pay/receive message +
                          generation failure')
             ROLLBACK
             CLRPFM     FILE(MGF100PD)
             CLRPFM     FILE(MGF202PD)
             CLRPFM     FILE(MGF210PD)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGK:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('K')
 
/* GDFs records are deleted as they are processed */
/* */                                                                 /*046856*/
/** Retrieve System Date and Time - required to extract journal    */ /*046856*/
/** entries for audit report.                                      */ /*046856*/
/* */                                                                 /*046856*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*046856*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*046856*/
 
/*/COPY WNCPYSRC,DLC1921005                                          */
/* Process customer transfer messages */
             CALL       PGM(MG0100)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Customer transfer +
                          formatting failure')
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process Bank transfer messages */
             CALL       PGM(MG0202)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Bank transfer formatting +
                          failure')
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process notice to receive messages */
             CALL       PGM(MG0210)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Notice to receive +
                          formatting failure')
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC1921006                                          */
 
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
                                                                                          /*228542*/
 
TAGL:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('L')
 
/* Generate C.H.I.P.S. messages if interface present */
             IF         COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +
                          THEN(CALL PGM(CHC01))
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('C.H.I.P.S. message +
                          generation failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGM:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('M')
 
             DLTOVR     FILE(TRANS DEAMS)
 
/* Set switch for FRA/IRS (U5 in DL0330) */
             CHGJOB     SWS(XXXX1XXX)
             CALL       PGM(DL0330) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Update pay/receive +
                          indicators failure')
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
 TAGN:       CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('N')              /*CSW005*/
/************IF         COND(&CSW5ON *EQ 'Y') THEN(DO)     /*CSW005*/ /*CSW011*/
             IF         COND((&CSW5ON *EQ 'Y') *OR (&CSW011 *EQ +
                          'Y')) THEN(DO)                              /*CSW011*/
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)                     /*CSW005*/
             OVRDBF     FILE(DEALS) SHARE(*NO)                        /*CSW097*/
             OVRDBF     FILE(DLOLACPD) SHARE(*NO)                     /*CSW097*/
             CALL       PGM(DL6330)                                   /*CSW005*/
                                                                      /*CSW097*/
/**********  IF         COND(%SWITCH(XXXXXX00)) THEN(DO) */           /*CSW097*/   /*CSW097 227443*/
/**********     CLRPFM     FILE(DLOLACPD) */                          /*CSW097*/   /*CSW097 227443*/
/**********     CLRPFM     FILE(DLOLCFPD) */                          /*CSW097*/   /*CSW097 227443*/
/**********  ENDDO */                                                 /*CSW097*/   /*CSW097 227443*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*CSW005*/
             CHGVAR     VAR(&MSG) VALUE('FRA/IRS Rate Fix and +
                          Settlement Confirmation Extract +
                          failure.')                                  /*CSW005*/
             ROLLBACK                                                 /*CSW005*/
             CLRPFM     FILE(MGF341PD)                                                  /*MD028276*/
             GOTO       CMDLBL(ERROR)                                 /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
 TAGO:       CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('O')              /*CSW005*/
/************IF         COND(&CSW5ON *EQ 'Y') THEN(DO) */  /*CSW005*/ /*CSW011*/
             IF         COND((&CSW5ON *EQ 'Y') *OR (&CSW011 *EQ +
                          'Y')) THEN(DO)                              /*CSW011*/
                                                                                        /*MD028276*/
             IF         COND(&CSW2013 *EQ 'CSW2013') THEN(DO)                           /*MD028276*/
                                                                                        /*MD028276*/
             CPYF       FROMFILE(MGF341PD) TOFILE(QTEMP/MGF341EX) +
                          CRTFILE(*YES) INCREL((*IF MGACMI *EQ 'Y'))                    /*MD028276*/
             ENDDO                                                                      /*MD028276*/
                                                                                        /*MD028276*/
             CALL       PGM(MG0341)                                   /*CSW005*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*CSW005*/
             CHGVAR     VAR(&MSG) VALUE('Format FRA Rate Fix and +
                          Settlement Confirmation failure.')          /*CSW005*/
             ROLLBACK                                                 /*CSW005*/
             GOTO       CMDLBL(ERROR)                                 /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                                        /*MD028276*/
/** SWIFT 2013 archiving */                                                             /*MD028276*/
                                                                                        /*MD028276*/
             IF         COND(&CSW2013 *EQ 'CSW2013') THEN(DO)                           /*MD028276*/
                                                                                        /*MD028276*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                            /*MD028276*/
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')                         /*MD028276*/
                                                                                        /*MD028276*/
             CPYF       FROMFILE(MGF341EX) TOFILE(&DMLIB/MGF341TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                                    /*MD028276*/
                                                                                        /*MD028276*/
             ENDDO                                                                      /*MD028276*/
                                                                      /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
 TAGP:       CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('P')              /*CSW005*/
             IF         COND(&CSW5ON *EQ 'Y') THEN(DO)                /*CSW005*/
             CALL       PGM(MG0362)                                   /*CSW005*/
                                                                      /*CSW097*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CSW097*/
             CLRPFM     FILE(MGX36NPD)                                /*CSW097*/
             CLRPFM     FILE(MGY36NPD)                                /*CSW097*/
             ENDDO                                                    /*CSW097*/
                                                                      /*CSW005*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*CSW005*/
             CHGVAR     VAR(&MSG) VALUE('Format IRS Rate Fix and +
                          Settlement Confirmation failure.')          /*CSW005*/
             ROLLBACK                                                 /*CSW005*/
             GOTO       CMDLBL(ERROR)                                 /*CSW005*/
             ENDDO                                                    /*CSW005*/
 
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
/* Set 'phase' flag to indicate successful completion and skip error */
/* processing */
             CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE(' ')
/* */                                                                 /*046856*/
/** Call Message Generation Audit Report with parameters of Module */ /*046856*/
/** ID, Type of run, Current Journal and Date and Time of job      */ /*046856*/
/* */                                                                 /*046856*/
             CALL       PGM(MEC0890) PARM('DL' 'P' 'ICJRN     ' +
                          &SDATE &STIME)                              /*046856*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*046856*/
                                                                      /*081938*/
/* Prompt for immediate print */                                      /*081938*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
             CALL       PGM(CGC5217) PARM(' ')                        /*081938*/
             MONMSG     MSGID(CPF0000)                                /*081938*/
             ENDDO
                                                                      /*081938*/
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
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
 
             IF         COND(&COMACT = 'Y')  THEN(DO)                                   /*MD048071*/
             ROLLBACK                                                 /*CSW005*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                  /*MD048071*/
             ENDDO                                                                      /*MD048071*/
 
/**END:*****    ENDCMTCTL                                             /*CAP006*/
 END:                                                                 /*CAP006*/
             RCLACTGRP  ACTGRP(*ELIGIBLE)                             /*CAP006*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CAP006*/
             ENDCMTCTL                                                /*CAP006*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Ensure stop confirmations indicator set off */
             CALL       PGM(DL0106)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Reset busy flag in DLSTAT */
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD)) WAIT(32000)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(DLSTAT (7 1)) VALUE(N)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
