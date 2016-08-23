/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL I/c netting pay/receive processing')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0350 - Midas I/C Netting Pay/Receives                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CDL002             Date 17Apr97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CDL002 - FX Netting                                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &WRK100)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REON) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&WRK100) TYPE(*CHAR) LEN(100)
             DCL        VAR(&WRKSTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MCSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)
/*/COPY WNCPYSRC,DLC0350001                                          */
 
             DCLF       FILE(SDMGMEPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/*  Access the Workstation address */
 
             CHGVAR     VAR(&WRKSTN) VALUE(%SST(&WRK100 1 10))
 
/* Notify MRUNQ */
 
             SNDPGMMSG  MSG('Input Cycle Net Pay/Receive') +
                          TOMSGQ(MRUNQ)
 
/* Begin commitment control */
 
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))             /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
/* Zero switches */
/* switch 5 ON to denote NETTING mode*/
 
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(00001000)
 
/* Create LDA */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('MIDAS SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
/* Access MMOD for module details */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/* If Retail or IoA switched on, set Retail-on flag */
 
             IF         COND((%SUBSTRING(&MMOD 23 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 16 1) = 'Y')) +
                          THEN(CHGVAR VAR(&REON) VALUE(Y))
 
/* C.H.I.P.S. processing */
 
             IF         COND(%SST(&MMOD 41 1) *EQ 'Y') THEN(DO)
 
                RTVDTAARA  DTAARA(MCSTAT) RTNVAR(&MCSTAT)
 
                IF         COND(%SST(&MCSTAT 3 1) *EQ 'Y') THEN(DO)
                   SNDPGMMSG  MSG('Previous C.H.I.P.S. Messages still +
                                outstanding - JOB CANNOT BE RUN') +
                                TOMSGQ(MOPERQ &WRKSTN)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
/*/COPY WNCPYSRC,DLC0350002                                          */
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
             IF         COND((%SUBSTRING(&DLSTAT 7 1) *EQ Y) *OR +
                          (%SUBSTRING(&DLSTAT 100 1) *NE ' ') *OR +
                          (%SUBSTRING(&DLSTAT 97 1) *NE ' ')) +
                          THEN(DO)
 
                SNDPGMMSG  MSG('Netting pay/receive print requested +
                             but pay/receive already +
                             active/failed') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ &WRKSTN)
 
                GOTO       CMDLBL(END)
 
             ENDDO
 
/*  Retrieve System Date and Time - required to extract journal      */
/*  entries for audit report.                                        */
 
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)
 
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
 
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
             CHGVAR     VAR(%SUBSTRING(&DLSTAT 7 1)) VALUE(Y)
 
             CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)
 
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
 
/* DLC2350Z */
 
/* Check for confirmations still active */
 
/* Should not run Pay/Recs if last Confirmation run ended in error */
 
             IF       COND(%SUBSTRING(&DLSTAT 98 1) *NE ' ') THEN(DO)
                SNDPGMMSG  MSG('Netting Pay/Receive print requested +
                            but last Confirmation run ended in +
                            error') TOPGMQ(*EXT) TOMSGQ(MOPERQ &WRKSTN)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Block large files */
 
             OVRDBF     FILE(PREXPH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX1PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX2PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX3PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX4PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX5PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX6PH) SEQONLY(*YES 50)
 
             OVRDBF     FILE(TRANS) TOFILE(DTRIN)
 
             IF         COND(%SST(&DLSTAT 100 1) *EQ 'D') THEN(GOTO +
                          CMDLBL(TAGD))
 
             IF         COND(%SST(&DLSTAT 100 1) *EQ 'E') THEN(GOTO +
                          CMDLBL(TAGE))
 
             IF         COND(%SST(&DLSTAT 100 1) *EQ 'F') THEN(GOTO +
                          CMDLBL(TAGF))
 
             IF         COND(%SST(&DLSTAT 100 1) *EQ 'G') THEN(GOTO +
                          CMDLBL(TAGG))
 
             IF         COND(%SST(&DLSTAT 100 1) *EQ 'H') THEN(GOTO +
                          CMDLBL(TAGH))
 
             IF         COND(%SST(&DLSTAT 100 1) *EQ 'I') THEN(GOTO +
                          CMDLBL(TAGI))
 
             IF         COND(%SST(&DLSTAT 100 1) *EQ 'J') THEN(GOTO +
                          CMDLBL(TAGJ))
 
             IF         COND(%SST(&DLSTAT 100 1) *EQ 'K') THEN(GOTO +
                          CMDLBL(TAGK))
 
             IF         COND(%SST(&DLSTAT 100 1) *EQ 'L') THEN(GOTO +
                          CMDLBL(TAGL))
 
             IF         COND(%SST(&DLSTAT 100 1) *EQ 'M') THEN(GOTO +
                          CMDLBL(TAGM))
 
/* DLC2350A */
/* keep switch 5 ON to denote NETTING mode*/
 
             CHGJOB     SWS(1000X000)
 
             SNDPGMMSG  MSG('Create Pay/Receive Extract Files') +
                          TOMSGQ(MRUNQ)
 
 
 TAGD:       CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('D')
 
             CLRPFM     FILE(PREXHH)
             CLRPFM     FILE(PREXPH)
             CLRPFM     FILE(PREXZZ)
 
             CALL       PGM(DL0350)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
               CHGVAR     VAR(&MSG) VALUE('Create pay/receive extract +
                            file failure')
               GOTO       CMDLBL(ERROR)
             ENDDO
 
 TAGE:       CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('E')
 
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
                CHGVAR     VAR(&MSG) VALUE('Pay/receive file split +
                             failure')
                GOTO       CMDLBL(ERROR)
             ENDDO
 
             SNDPGMMSG  MSG('Pay/Receive Settlements Report') +
                          TOMSGQ(MRUNQ)
 
             CALL       PGM(DL0320) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Pay/receive settlements +
                             failure')
                GOTO       CMDLBL(ERROR)
             ENDDO
 
 TAGF:       CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('F')
 
/* DLC2350B */
             SNDPGMMSG  MSG('Pay/Receive Telexes Report') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX1X)
 
             CALL       PGM(DL0308) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Complete pay/receive +
                             telexes failure')
                GOTO       CMDLBL(ERROR)
             ENDDO
 
 TAGG:       CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('G')
 
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
 
 TAGH:       CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('H')
 
             SNDPGMMSG  MSG('Bankers Authorisations Report') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX1X)
 
             CALL       PGM(DL0314) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Bankers authorisations +
                             failure')
                GOTO       CMDLBL(ERROR)
 
             ENDDO
 
 TAGI:       CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('I')
 
             SNDPGMMSG  MSG('Internal Settlements Report') +
                          TOMSGQ(MRUNQ)
 
/* Set switch for Retail/IoA (U1 in DL0318) */
 
             IF         COND(&REON *EQ Y) THEN(CHGJOB SWS(1XXXXXXX))
 
             CALL       PGM(DL0318) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Internal Settlements +
                             failure')
                GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF         COND(%SST(&MMOD 25 1) *EQ 'Y') THEN(DO)
 
 TAGJ:       CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('J')
 
/* DLC2350D */
 
             OVRDBF     FILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(DEALS) SHARE(*NO)
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)
 
             CALL       PGM(DL6315) /* COMIT DEALS ONLY */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Pay/receive message +
                             generation failure')
 
                ROLLBACK
 
                CLRPFM     FILE(MGF100PD)
                CLRPFM     FILE(MGF200PD)
                CLRPFM     FILE(MGF202PD)
                CLRPFM     FILE(MGF210PD)
 
                GOTO       CMDLBL(ERROR)
 
             ENDDO
 
 TAGK:       CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('K')
 
/* GDFs records are deleted as they are processed */
 
/* Process customer transfer messages */
 
/*/COPY WNCPYSRC,DLC0350003                                          */
             CALL       PGM(MG0100)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(SNDPGMMSG +
                          MSG('Customer transfer formatting +
                          failure') TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO))
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
               ROLLBACK
               GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process nostro transfer messages */
             CALL       PGM(MG0200)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(SNDPGMMSG +
                          MSG('Nostro transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO))
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                ROLLBACK
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process Bank transfer messages */
 
             CALL       PGM(MG0202)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(SNDPGMMSG +
                          MSG('Bank transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO))
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                ROLLBACK
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process notice to receive messages */
 
             CALL       PGM(MG0210)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(SNDPGMMSG +
                          MSG('Notice to receive formatting +
                          failure') TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO))
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                ROLLBACK
                GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC0350004                                          */
 
/**********  RGZPFM     FILE(MGF100PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF100PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
 
/**********  RGZPFM     FILE(MGF200PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF200PD' '*FIRST')                          /*228542*/
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
 
             ENDDO
 
/* If ISO advices required (PF/SDMGMEPD, ENFFAR='N') print messages */
 
             RCVF
 
             IF         COND(&ENFFAR = 'N') THEN(DO)
                CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                             TEXT('Outgoing ISO mail data queue')
                CALL       PGM(ME0865)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('ISO print failure')
                   GOTO       CMDLBL(ERROR)
                ENDDO
             ENDDO
 
 TAGL:       CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('L')
 
/* Generate C.H.I.P.S. messages if interface present */
 
             IF         COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +
                          THEN(DO)
 
/*    RESET SWITCHES FOR APPROPRIATE PHASE (WERE CHANGED IN SWC2350) */
 
                CHGJOB     SWS(100XXXXX)
                CALL       PGM(CHC01)
 
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                   RTVDTAARA  DTAARA(MCSTAT) RTNVAR(&MCSTAT)
                   CHGVAR VAR(%SUBSTRING(&MCSTAT 2 1)) VALUE('N')
                   CHGDTAARA  DTAARA(MCSTAT) VALUE(&MCSTAT)
                   CLRPFM     FILE(CRCSVDD)
                   CLRPFM     FILE(CRCSVTT)
                ENDDO
 
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('C.H.I.P.S. message +
                             generation failure')
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/*  TELEX INTERFACE                                                 */
 
 TAGM:       CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('M')
 
/* DLC2350C */
 
             CALL       PGM(DL0352)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Update pay/receive +
                             indicators failure')
                ROLLBACK
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Indicate that there has been no error within the CL stream */
 
             CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE(' ')
 
             CHGVAR     VAR(&ERR) VALUE('N')
 
             GOTO       CMDLBL(END)
 
ERROR:       IF         COND(&MSG = ' ') THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Pay/receive generation +
                             failure')
             ENDDO
 
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Indicate that there has been an error within the CL stream */
 
             CHGVAR     VAR(&ERR) VALUE('Y')
 
/* Send database error message to MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
 
             CHGJOB     SWS(XXXXXX11)
 
/* Reset busy flag in DLSTAT */
 
END:         ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD)) WAIT(32000)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGDTAARA  DTAARA(DLSTAT (7 1)) VALUE(N)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Call Message Generation Audit Report with parameters of Module  */
/* ID, Type of run, Current Journal and Date and Time of job       */
 
             CALL       PGM(MEC0890) PARM('DL' 'P' 'ICJRN     ' +
                          &SDATE &STIME)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Report to the user the Pay/Receive run has completed              */
/*  &ERR = 'Y' - error occured within the CL stream                  */
/*  &ERR = 'N' - no errors occured during CL stream                  */
/*  &ERR = ' ' - job could not be started, message already sent      */
 
             IF         COND(&ERR *EQ 'Y') THEN(CHGVAR VAR(&MSG) +
                          VALUE('Netting Pay/Receive run completed +
                          - ABNORMALLY'))
 
             IF         COND(&ERR *EQ 'N') THEN(CHGVAR VAR(&MSG) +
                          VALUE('Netting Pay/Receive run completed +
                          - SUCCESSFULLY'))
 
             IF         COND(&ERR *NE ' ') THEN(DO)
               SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          &WRKSTN) MSGTYPE(*INFO)
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
