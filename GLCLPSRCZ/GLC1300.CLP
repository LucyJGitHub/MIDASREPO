/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Statement Message Generation.')              */
/*********************************************************************/
/*                                                                   */
/*       Midas        GENERAL LEDGER                                 */
/*                                                                   */
/*       GLC1300 - S.W.I.F.T. STATEMENT PRODUCTION                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Last Amend No. CDL008             Date 02May00             */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             DATE 10SEP99              */
/*                      CEU013             DATE 03APR98              */
/*                      101867             DATE 10MAR97              */
/*                      S01408             DATE 31JUL96              */
/*                      064105             DATE 15MAR94              */
/*                      E40283             DATE 23JUN92              */
/*                      E40242             DATE 19JUN92              */
/*                      E40395             DATE 19MAY92              */
/*                      E29588             DATE 16OCT91              */
/*                      S01310             DATE 09SEP91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CDL008 - Continuous Linked Settlement (Recompiled MGOREFPD) */
/*       CPK009 - Replace reference to SWPOSX1 with SWPOSAPD.        */
/*       CEU013 - EMU Account Postings Narrative                     */
/*       101867 - Check U8 out of balance indicator from GL1300.     */
/*                Applied fix 068212.                                */
/*       S01408 - Addition of core hook GLC1300INT                   */
/*                Addition of core hook GLC1300MPS                   */
/*                Addition of core hook GLC1300MPE                   */
/*                Addition of core hook GLC1300ERR                   */
/*                Addition of core hook GLC1300END                   */
/*                Addition of core hook GLC1300001                   */
/*       064105 - Check for FCOOB error from GL1300 and copy back    */
/*                messsage files if in error                         */
/*       E40283 - MAINTAIN 'GL SWIFT MESSAGES ALREADY SENT' FLAG FOR */
/*                USE IN GL1300                                      */
/*       E40242 - CALL MEC0890 TO PRODUCE AUDIT LIST OF STATEMENTS   */
/*                GENERATED                                          */
/*       E40395 - SET ON U1 DEPENDING ON IND ON SDMGMEPD             */
/*       E29588 - POST COLLECTION SWIFT RATIONALISATION FIXES        */
/*       S01310 - RE-WRITTEN FOR MG/ME SWIFT RATIONALISATION         */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&CNAM &CSEQ)
 
/*/COPY WNCPYSRC,mmCnnnnINT                                          */
/*/COPY WNCPYSRC,GLC1300008                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
                                                                      /*E40242*/
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&RDATE) TYPE(*CHAR) LEN(7)                /*E40242*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*E40242*/
                                                                      /*E40283*/
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(256)             /*E40283*/
/*/COPY WNCPYSRC,GLC1300005                                          */
                                                                      /*E40242*/
             DCLF       FILE(SDMGMEPD)
 
/*/COPY WNCPYSRC,GLC1300012                                          */
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,mmCnnnnMPS                                          */
 
/* Allocate message reference file */
 TRY:        ALCOBJ     OBJ((MGOREFPD *FILE *EXCL)) WAIT(30)
             MONMSG     MSGID(CPF1619) EXEC(GOTO CMDLBL(TRY))
 
/* Set up back up files */
             CLRPFM     FILE(MGOMSGBK)
             CLRPFM     FILE(MGOREFBK)
             CPYF       FROMFILE(MGOMSGPD) TOFILE(MGOMSGBK) +
                          MBROPT(*ADD)
             CPYF       FROMFILE(MGOREFPD) TOFILE(MGOREFBK) +
                          MBROPT(*ADD)
/*/COPY WNCPYSRC,GLC1300010                                          */
 
/* Check CoB status */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
 
/* Send message to MRUNQ */
             IF         COND(&BUSY = 'N') THEN(DO)
             SNDPGMMSG  MSG('S.W.I.F.T. Statements Message +
                          Production') TOMSGQ(MRUNQ)
             RCVF        /*E40395*/
             IF         COND(&ENSPFR *EQ 'Y') THEN(CHGJOB +
                          SWS(1XXXXXXX)) /* E40395 */
                                                                      /*E40283*/
/* Check posn 58 on MSSTAT - if this is 'Run' then the previous    */ /*E40283*/
/* run may have ended abnormally and the messages may have already */ /*E40283*/
/* been sent. In this event, set the warning flag to 'Y'           */ /*E40283*/
                   RTVDTAARA  DTAARA(MSSTAT) RTNVAR(&MSSTAT)          /*E40283*/
             IF         COND(%SST(&MSSTAT 58 1) = 'R') THEN(DO)       /*E40283*/
             CHGDTAARA  DTAARA(MSSTAT (58 1)) VALUE('Y')              /*E40283*/
             ENDDO                                                    /*E40283*/
             ELSE DO                                                  /*E40283*/
             CHGDTAARA  DTAARA(MSSTAT (58 1)) VALUE('R')              /*E40283*/
             ENDDO                                                    /*E40283*/
 
/* Set up SWIFT posting/SWIFT account files */
             CLRPFM     FILE(SWPOOHH)
             CLRPFM     FILE(SWPOORA)
             CLRPFM     FILE(SWPOOPD)
             CLRPFM     FILE(SWPOOAPD)                                /*CEU013*/
             CLRPFM     FILE(SWPOOZZ)
             CLRPFM     FILE(SWACNSA)
             CLRPFM     FILE(SWACNSB)
             CLRPFM     FILE(SWACNSC)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC1300001                                          */
                                                                      /*S01408*/
             OVRDBF     FILE(SWPOSHH) TOFILE(SWPOOHH)
             OVRDBF     FILE(SWPOSRA) TOFILE(SWPOORA)
             OVRDBF     FILE(SWPOSPD) TOFILE(SWPOOPD)
             OVRDBF     FILE(SWPOSZZ) TOFILE(SWPOOZZ)
 
/* Call SWIFT Statement production program */
             CALL       PGM(GL1300)
/*/COPY WNCPYSRC,GLC1300006                                          */
 
/* If program ends in error, clear down messages produced */
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)   */  /*E29588*/
/************CLRPFM     FILE(MGOMSGPD)                            */  /*E29588*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(CLRF))                               /*E29588*/
/*/COPY WNCPYSRC,GLC1300004                                          */
 
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)   */ /*E29588 064105*/
/************IF         COND(%SWITCH(XXXXXX11) *OR +
/**************************  %SWITCH(XXXXXXX1)) THEN(DO)      /*064105 101867*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                             %SWITCH(XXXXXXX1)) THEN(DO)             /*101867*/
 CLRF:       CLRPFM     FILE(MGOMSGPD)                                /*E29588*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(MGOREFPD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CPYF       FROMFILE(MGOMSGBK) TOFILE(MGOMSGPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CPYF       FROMFILE(MGOREFBK) TOFILE(MGOREFPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,GLC1300009                                          */
             DLCOBJ     OBJ((MGOREFPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/*/COPY WNCPYSRC,GLC1300002                                          */
             ENDDO
 
             DLTOVR     FILE(*ALL)
 
/* If program ends successfully inform CoB control */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
                                                                      /*E40283*/
/* Run completed normally so reset warning flag    */
             CHGDTAARA  DTAARA(MSSTAT (58 1)) VALUE('N')              /*E40283*/
 
/* If SWIFT postings are to be produced update SWIFT postings files */
/************RCVF                                                   */ /*40395*/
             IF         COND(&ENSPFR *EQ 'Y') THEN(DO)
             CLRPFM     FILE(SWPOSHH)
             CLRPFM     FILE(SWPOSPD)
             CLRPFM     FILE(SWPOSAPD)                                /*CEU013*/
             CLRPFM     FILE(SWPOSRA)
             CLRPFM     FILE(SWPOSZZ)
             CPYF       FROMFILE(SWPOOHH) TOFILE(SWPOSHH) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             CPYF       FROMFILE(SWPOORA) TOFILE(SWPOSRA) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
             CPYF       FROMFILE(SWPOOPD) TOFILE(SWPOSPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
/**********  CPYF       FROMFILE(SWPOOAPD) TOFILE(SWPOSX1) +
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)      /*CEU013*/ /*CPK009*/
             CPYF       FROMFILE(SWPOOAPD) TOFILE(SWPOSAPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPK009*/
             MONMSG     MSGID(CPF2817)                                /*CEU013*/
             CPYF       FROMFILE(SWPOOZZ) TOFILE(SWPOSZZ) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             ENDDO
 
/* Update SWIFT Acs files */
             CLRPFM     FILE(SWACSSA)
             CLRPFM     FILE(SWACSSB)
             CLRPFM     FILE(SWACSSC)
             CPYF       FROMFILE(SWACNSA) TOFILE(SWACSSA) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             CPYF       FROMFILE(SWACNSB) TOFILE(SWACSSB) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
             CPYF       FROMFILE(SWACNSC) TOFILE(SWACSSC) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
/*/COPY WNCPYSRC,GLC1300003                                          */
 
/* Inform CoB control */
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
 
/* Clear files used for this run */
             CLRPFM     FILE(SWACNSA)
             CLRPFM     FILE(SWACNSB)
             CLRPFM     FILE(SWACNSC)
             CLRPFM     FILE(SWPOOHH)
             CLRPFM     FILE(SWPOORA)
             CLRPFM     FILE(SWPOOPD)
             CLRPFM     FILE(SWPOOZZ)
/*/COPY WNCPYSRC,GLC1300007                                          */
             ENDDO
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
/* Clear down messages produced */
             CLRPFM     FILE(MGOMSGPD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(MGOREFPD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CPYF       FROMFILE(MGOMSGBK) TOFILE(MGOMSGPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CPYF       FROMFILE(MGOREFBK) TOFILE(MGOREFPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,GLC1300011                                          */
             ENDDO
 
/* Call Message Generation Audit Report                            */ /*E40242*/
             CHGVAR     VAR(&RPARM) VALUE('GL            9501234')    /*E40242*/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RDATE)           /*E40242*/
             IF         COND(%SST(&RDATE 1 1) *EQ ' ') THEN(CHGVAR +
                          VAR(%SST(&RDATE 1 1)) VALUE('0'))           /*E40242*/
             CALL       PGM(ZM0085) PARM(&RDATE &SDATE)               /*E40242*/
             CHGVAR     VAR(%SST(&RPARM 23 6)) VALUE(&SDATE)          /*E40242*/
             CHGVAR     VAR(%SST(&RPARM 29 6)) VALUE(&SDATE)          /*E40242*/
             CALL       PGM(MEC0810) PARM('     ' 'B' 'ALL ' &RPARM)  /*E40242*/
 
/*/COPY WNCPYSRC,GLC1300MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Outgoing S.W.I.F.T Messages Generation +
                          Program ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,GLC1300ERR                                          */
 
 END:        DLTOVR     FILE(*ALL)
             DLCOBJ     OBJ((MGOREFPD *FILE *EXCL))
                                                                      /*E40242*/
/*/COPY WNCPYSRC,GLC1300END                                          */
                                                                      /*E40242*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
 
