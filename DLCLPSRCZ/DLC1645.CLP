/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL OIS Settlement control')                     */
/********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC1645 - OIS Deal Settlement Control                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 05Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205448             Date 02May02              */
/*                      CCG015             Date 14Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CIR007  *CREATE    Date 11May01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*      CLE134 - Past Due Call Loan Processing (Recompile)           */
/*      228542 - RGZPFM has changed at R5V3                          */
/*      205448 - UDC module must be on for Correspondence Manager    */
/*      CCG015 - Correspondence Manager Phase 1                      */
/*      CIR007 - Overnight Index Swaps                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &PARMS)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&FIVE) TYPE(*DEC) LEN(1 0) VALUE(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&REON) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&RUNRAT) TYPE(*CHAR) LEN(1) VALUE('N')
 
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PARMS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)              /*CCG015*/
 
/** Multiple language support variables                            */
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MIDASLG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
/*/COPY WNCPYSRC,DLH00178                                            */
 
/** Declare SDBANKPD for run-date                                  */
             DCLF       FILE(SDBANKPD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/** Notify MRUNQ                                                   */
             SNDPGMMSG  MSG('Input Cycle OIS settlement and +
                          Pay/Receive') TOMSGQ(MRUNQ)
 
/** Find &RERUN from 1st Byte of &PARMS.                           */
             CHGVAR &RERUN VALUE(%SST(&PARMS 1 1))
 
/** Begin commitment control                                       */
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
/** Create LDA                                                     */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,DLH00179                                            */
 
/** Multiple Language Support -                                    */
/** Set up overrides for message files                             */
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)
 
             IF         COND(&MULT *EQ '  ') THEN(DO)
                CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO
 
/** Build Multiple Language Support Object Names                   */
             CHGVAR     VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')
             CHGVAR     VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ')
 
/** Apply Multiple Language Support Overrides                      */
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDASLG)
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)
 
/** Zero switches                                                  */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(00000000)
 
/** Access MMOD for module details                                 */
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/** If Retail or IoA switched on, set U2 for MEMOS update          */
             IF         COND((%SUBSTRING(&MMOD 23 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 16 1) = 'Y')) THEN(DO)
                CHGJOB     SWS(X1XXXXXX)
                CHGVAR     VAR(&REON) VALUE('Y')
             ENDDO
 
/** If SWIFT/Dealing or Telex/Dealing is on set U3 for DL0195      */
             IF         COND((%SST(&MMOD 25 1) = 'Y') *OR (%SST(&MMOD +
                          51 1) = 'Y') *AND (%SST(&MMOD 53 1) = 'Y')) +
                          THEN(DO)
                CHGJOB     SWS(XX1XXXXX)
             ENDDO
 
/** Check for confirmations still active                           */
RETRY:       RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
             IF         COND(%SST(&DLSTAT 6 1) *EQ 'Y') THEN(DO)
                RCVMSG     WAIT(60) RMV(*NO)
                CHGVAR     VAR(&FIVE) VALUE(&FIVE + 1)
 
                IF         COND(&FIVE *GT 5) THEN(GOTO CMDLBL(RETRY))
                ELSE       CMD(DO)
                   SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO END
                ENDDO
             ENDDO
 
/** Change data area to indicate that OIS Settlement is active     */
             CHGDTAARA  DTAARA(DLOISDTA (1 1)) VALUE('Y')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/** Block large files                                              */
             OVRDBF     FILE(PREXPH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX1PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX2PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX3PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX4PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX5PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX6PH) SEQONLY(*YES 50)
             OVRDBF     FILE(DLINDDM) SEQONLY(*YES 500)
 
/** Override transaction files                                     */
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
             IF COND(%SST(&DLSTAT 97 1) *EQ 'N') THEN(GOTO TAGN)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'O') THEN(GOTO TAGO)
             IF COND(%SST(&DLSTAT 97 1) *EQ 'P') THEN(GOTO TAGP)
 
/** Read SDBANKPD for run-date                                     */
             RCVF
 
/** Program DL1650 calculates settlement amounts and creates Pay & */
/** Receive data for OIS deals settling today.                     */
             CALL       PGM(DL1650) PARM(&RERUN)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                     %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR VAR(&MSG) VALUE('OIS Rate Deal settlement +
                  ended abnormally after calling DL1650')
                CLRPFM FILE(DLINDHH)
                CLRPFM FILE(DLINDDM)
                CLRPFM FILE(DLINDZX)
                GOTO   CMDLBL(ERROR)
             ENDDO
 
TAGC:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('C')
             CLRPFM     FILE(ECONXCY)
             CLRPFM     FILE(ECONXCZ)
 
/** User Defined Correspondence processing                         */
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
 
/** Access PF/SDMMODPD to determine whether UDC module is on       */
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
 
/** Database error handling                                        */
             IF         COND(&RTCD *NE '       ') THEN(DO)
                SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)
                GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)
/* */                                                                /*CCG015*/
/* If Correspondence manager is switched on, override files          /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')               /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                   /*CCG015*/
/* */                                                                /*CCG015*/
                CALL       PGM(CG4100) PARM(&W0RTN &W0CMT)
 
                RCLRSC
                IF         COND(&W0RTN *NE '       ') THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
                          Extract failure')
                   ROLLBACK
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                   GOTO       CMDLBL(ERROR)
                ENDDO
/* */                                                                /*CCG015*/
/* If Correspondence manager is switched on, call custom defined     /*CCG015*/
/* extract program                                                   /*CCG015*/
/* */                                                                /*CCG015*/
             CALL       PGM(CGC3604)                                 /*CCG015*/
/* */                                                                /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)             /*CCG015*/
             CHGVAR     VAR(&MSG) VALUE('Correspondence Manager +
                        Custom-Defined Data Extract failed')         /*CCG015*/
             GOTO       CMDLBL(ERROR)                                /*CCG015*/
             ENDDO                                                   /*CCG015*/
/* */                                                                /*CCG015*/
             ENDDO
 
             CHGJOB     SWS(00XXXXXX)
             OVRDBF     FILE(DLIND) TOFILE(DLIND2)
 
             CALL       DL0195
             DLTOVR     FILE(DLIND)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('OIS pay/receive extract - +
                          Confirmation print failure')
                GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGD:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('D')
 
             CLRPFM     FILE(PREXHH)
             CLRPFM     FILE(PREXPH)
             CLRPFM     FILE(PREXZZ)
/*/COPY WNCPYSRC,DLH00472                                            */
             CHGJOB     SWS(XXXXXX00)
             CALL       DL1705
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Create OIS pay/receive +
                          extract file failure')
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
 
             CALL       PGM(DL0307)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('OIS Pay/receive file split +
                          failure')
                GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGF:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('F')
 
             SNDPGMMSG  MSG('OIS Pay/Receive Telexes Report') +
                          TOMSGQ(MRUNQ)
 
             CALL       PGM(DL0308) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Complete OIS pay/receive +
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
                CHGVAR     VAR(&MSG) VALUE('Incomplete OIS Pay/receive +
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
 
/** Set switch for Retail/IoA (U1 in DL0318)                       */
             IF         COND(&REON *EQ 'Y') THEN(CHGJOB SWS(1XXXXXXX))
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
 
             CALL       PGM(DL6320) PARM(&RERUN)   /* COMIT DEALS */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('OIS pay/receive message +
                          generation failure')
                ROLLBACK
                CLRPFM     FILE(MGF100PD)
                CLRPFM     FILE(MGF202PD)
                CLRPFM     FILE(MGF210PD)
                GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGK:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('K')
 
/** GDFs records are deleted as they are processed                 */
/** Retrieve System Date and Time - required to extract journal    */
/** entries for audit report.                                      */
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)
 
/** Process customer transfer messages                             */
             CALL       PGM(MG0100)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Customer transfer +
                          formatting failure')
                ROLLBACK
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/** Process Bank transfer messages                                 */
             CALL       PGM(MG0202)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Bank transfer formatting +
                          failure')
                ROLLBACK
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/** Process notice to receive messages                             */
             CALL       PGM(MG0210)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Notice to receive +
                          formatting failure')
                ROLLBACK
                GOTO       CMDLBL(ERROR)
             ENDDO
 
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
 
TAGM:        CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('M')
 
             DLTOVR     FILE(TRANS DEAMS)
 
/** Set switch for FRA/IRS (U5 in DL0330)                          */
             CHGJOB     SWS(XXXX1XXX)
             CALL       PGM(DL0330) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Update pay/receive +
                          indicators failure')
                ROLLBACK
                GOTO       CMDLBL(ERROR)
             ENDDO
 
 TAGN:       CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('N')
 
 TAGO:       CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('O')
 
 TAGP:       CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE('P')
 
/** Set 'phase' flag to indicate successful completion and skip    */
/** error processing                                               */
             CHGDTAARA  DTAARA(DLSTAT (97 1)) VALUE(' ')
 
/** Call Message Generation Audit Report with parameters of Module */
/** ID, Type of run, Current Journal and Date and Time of job      */
             CALL       PGM(MEC0890) PARM('DL' 'P' 'ICJRN     ' +
                          &SDATE &STIME)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/** Prompt for immediate print                                     */
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)
                CALL       PGM(CGC5217) PARM(' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/** Successful completion                                          */
/** Change data area to indicate that OIS Settlement is complete   */
 
             CHGDTAARA  DTAARA(DLOISDTA (1 1)) VALUE('N')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             GOTO       CMDLBL(END)
 
ERROR:       IF         COND(&MSG = ' ') THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('OIS Pay/receive generation +
                          failure')
             ENDDO
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/** Reset OIS Control data are to indicate no longer active        */
             CHGDTAARA  DTAARA(DLOISDTA (1 1)) VALUE('N')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/** Send database error message to workstation & MOPERQ            */
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
 
             ROLLBACK
 
 END:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/** Ensure stop confirmations indicator set off                    */
             CALL       PGM(DL0106)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/** Reset busy flag in DLSTAT                                      */
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD)) WAIT(32000)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE(N)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
