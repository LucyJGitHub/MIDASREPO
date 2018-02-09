/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL ICT netting pay/receive processing')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0360 - Midas I/C Term. Netting Pay/Receives              */
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
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CDL002             Date 17Apr97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CDL002 - FX Netting                                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ERR)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FIVE) TYPE(*DEC) LEN(1 0) VALUE(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REON) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MCSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')
             DCL        VAR(&SDMGME) TYPE(*CHAR) LEN(800)
             DCL        VAR(&ENFFAR) TYPE(*CHAR) LEN(1)
/*/COPY WNCPYSRC,DLC0360001                                          */
 
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/* Notify MRUNQ */
 
             SNDPGMMSG  MSG('Input Cycle Term Net Pay/Receive') +
                          TOMSGQ(MRUNQ)
 
/* switch 5 ON to denote NETTING mode*/
 
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(00001000)
 
/* Access MMOD for module details */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/* If Retail or IoA switched on, set Retail-on flag */
 
             IF         COND((%SUBSTRING(&MMOD 23 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 16 1) = 'Y')) +
                          THEN(CHGVAR VAR(&REON) VALUE(Y))
 
/*/COPY WNCPYSRC,DLC0360002                                          */
 
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
/* Block large files */
             OVRDBF     FILE(PREXPH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX1PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX2PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX3PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX4PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX5PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX6PH) SEQONLY(*YES 50)
 
/* Retrieve System Date and Time - required to extract journal      */
/* entries for audit report of Pay/Receives produced                */
 
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)
 
/* Set Type of Run flag to 'Pay/Receives' for Audit report          */
 
             CHGVAR     VAR(&TYPR) VALUE('P')
 
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
 
             CHGJOB     SWS(0100X000)
 
             SNDPGMMSG  MSG('Create Pay/Receive Extract Files') +
                          TOMSGQ(MRUNQ)
 
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
 
             CALL       PGM(DL0320) PARM('     ')
 
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
 
             CALL       PGM(DL0308) PARM('     ')
 
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
 
             CALL       PGM(DL0312) PARM('     ')
 
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
 
             CALL       PGM(DL0314) PARM('     ')
 
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
 
             CALL       PGM(DL0318) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Internal Settlements +
                             failure')
                GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF         COND(%SST(&MMOD 25 1) *EQ 'Y') THEN(DO)
 
 TAGJ:          CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('J')
 
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
 
 TAGK:          CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('K')
 
/* GDFs records are deleted as they are processed */
 
/* Process customer transfer messages */
/*/COPY WNCPYSRC,DLC0360003                                          */
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
                             MSG('Nostro transfer formatting +
                             failure') TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                             MSGTYPE(*INFO))
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   ROLLBACK
                   GOTO       CMDLBL(ERROR)
                ENDDO
 
/* Process Bank transfer messages */
 
                CALL       PGM(MG0202)
 
                IF         COND(%SWITCH(XXXXXX1X) *OR +
                             %SWITCH(XXXXXXX1)) THEN(SNDPGMMSG +
                             MSG('Bank transfer formatting +
                             failure') TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                             MSGTYPE(*INFO))
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
/*/COPY WNCPYSRC,DLC0360004                                          */
 
/**********     RGZPFM     FILE(MGF100PD)                                                 /*228542*/
/**********     MONMSG     MSGID(CPF2995 CPF2981)                                         /*228542*/
                CALL       PGM(SCC000060) PARM('MGF100PD' '*FIRST')                       /*228542*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                           CMDLBL(ERROR))                                                 /*228542*/
 
/**********     RGZPFM     FILE(MGF200PD)                                                 /*228542*/
/**********     MONMSG     MSGID(CPF2995 CPF2981)                                         /*228542*/
                CALL       PGM(SCC000060) PARM('MGF200PD' '*FIRST')                       /*228542*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                           CMDLBL(ERROR))                                                 /*228542*/
 
/**********     RGZPFM     FILE(MGF202PD)                                                 /*228542*/
/**********     MONMSG     MSGID(CPF2995 CPF2981)                                         /*228542*/
                CALL       PGM(SCC000060) PARM('MGF202PD' '*FIRST')                       /*228542*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                           CMDLBL(ERROR))                                                 /*228542*/
 
/**********     RGZPFM     FILE(MGF210PD)                                                 /*228542*/
/**********     MONMSG     MSGID(CPF2995 CPF2981)                                         /*228542*/
                CALL       PGM(SCC000060) PARM('MGF210PD' '*FIRST')                       /*228542*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                           CMDLBL(ERROR))                                                 /*228542*/
 
             ENDDO
 
/* If ISO advices required (PF/SDMGMEPD, ENFFAR='N') print messages */
 
             CALL       PGM(AOMGMER0) PARM(&RTCD &OPTN &SDMGME)
 
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&ENFFAR) VALUE(%SST(&SDMGME 23 1)))
 
             IF         COND(&ENFFAR = 'N') THEN(DO)
                CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                             TEXT('Outgoing ISO mail data queue')
                MONMSG     MSGID(CPF9870)
                CALL PGM(ME0865)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('ISO print failure')
                   GOTO       CMDLBL(ERROR)
                ENDDO
             ENDDO
 
 TAGL:       CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE('L')
 
/* Generate C.H.I.P.S. messages if interface present */
 
             IF         COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +
                          THEN(DO)
 
/* Reset switches for appropriate phase (were changed in SWC2350) */
 
                CHGJOB     SWS(010XXXXX)
 
                CALL       PGM(CHC01)
 
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                   RTVDTAARA  DTAARA(MCSTAT) RTNVAR(&MCSTAT)
                   CHGVAR     VAR(%SUBSTRING(&MCSTAT 2 1)) VALUE('N')
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
 
 
/* Telex Interface */
 
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
 
/* Call Message Generation Audit Report with parameters of Module  */
/* ID, Type of run, Current Journal and Date and Time of job       */
 
             CALL       PGM(MEC0890) PARM('DL' &TYPR 'ICJRN     ' +
                          &SDATE &STIME)
 
             CHGVAR     VAR(&TYPR) VALUE(' ')
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERROR)
 
/* Indicate that there has been no error within the CL stream */
 
             CHGDTAARA  DTAARA(DLSTAT (100 1)) VALUE(' ')
 
             CHGVAR     VAR(&ERR) VALUE('N')
 
             GOTO       CMDLBL(END)
ERROR:
 
/* Indicate that there has been an error within the CL stream */
 
             CHGVAR     VAR(&ERR) VALUE('Y')
 
             CHGJOB     SWS(XXXXXX11)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
