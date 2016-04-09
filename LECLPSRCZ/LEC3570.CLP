/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Facilities/currency conversion control')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Lending Module                                      */
/*                                                                   */
/*       LEC3570 - Facilities Currency Conversion - Control          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CLE106             Date 01Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 08Jul02              */
/*                      205448             Date 02May02              */
/*                      CCG015             Date 09Aug01              */
/*                      199785             Date 28Dec01              */
/*                      199698             Date 28Dec01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      157588             Date 07Jun00              */
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CUE021  *CREATE    Date 13May98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CLE106 - Syndication Manager                                */
/*       CPK015 - R4.01 Packaging:                                   */
/*                - Delete X* files before copy to avoid upgrade     */
/*                  problems.                                        */
/*       205448 - UDC module must be on for Correspondence Manager   */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*       199785 - Call LE3610 to convert Facility Amendment amounts. */
/*       199698 - Call LE3620 to convert Manual Facility Utilisations*/
/*       157588 - Move global monitor message in case of error.      */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CEU021 - EMU LE Facility Currency Conversion                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/* ------------------------------------------------------------------*/
/* Define non-standard data items.                                   */
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('FACILITY CURRENCY CONVERSION ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE('     ')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/* Global monitor message                                             /*157588*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERR99))                              /*157588*/
/*/COPY WNCPYSRC,LEC3570002                                          */
/* ------------------------------------------------------------------*/
/* Initialisation.                                                   */
 
             CHGJOB     SWS(XXXXXX00)
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/*-------------------------------------------------------------------*/
/**Global*monitor*message                                             /*157588*/
 
/*********** MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERR99))                              /*157588*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*-------------------------------------------------------------------*/
/* Start commitment control                                          */
 
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))             /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF0000)
/*-------------------------------------------------------------------*/
/* Create LDA if not present                                         */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
/*-------------------------------------------------------------------*/
/* Send program message                                              */
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/*-------------------------------------------------------------------*/
/*/COPY WNCPYSRC,LEC3570003                                          */
/* Derive the backup library name                                    */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
/*-------------------------------------------------------------------*/
/* Determine the restart status of this component                    */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/*-------------------------------------------------------------------*/
/* Restart Processing ?                                              */
 
             IF         COND(&STAT *EQ 'N') THEN(DO)
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Copy Files To Backup Files,                                       */
/*            Monitoring for CPF2817 - Cpyf ended because of error   */
/*                           CPF2869 - Empty member                  */
/*                                                                   */
             DLTF       FILE(&TOLIB/XFCLTYHH)                                             /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(FCLTYHH) +
                          TOFILE(&TOLIB/XFCLTYHH) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XFCLTYHH)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XFCLTYFM)                                             /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(FCLTYFM) +
                          TOFILE(&TOLIB/XFCLTYFM) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XFCLTYFM)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XFCLTYFN)                                             /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(FCLTYFN) +
                          TOFILE(&TOLIB/XFCLTYFN) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XFCLTYFN)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XFCLTYZZ)                                             /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(FCLTYZZ) +
                          TOFILE(&TOLIB/XFCLTYZZ) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XFCLTYZZ)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XLEPARTPD)                                            /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(LEPARTPD) +
                          TOFILE(&TOLIB/XLEPARTPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XLEPARTPD)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XCLOANHH)                                             /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(CLOANHH) +
                          TOFILE(&TOLIB/XCLOANHH) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCLOANHH)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XCLOANCL)                                             /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(CLOANCL) +
                          TOFILE(&TOLIB/XCLOANCL) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCLOANCL)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XCLOANCK)                                             /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(CLOANCK) +
                          TOFILE(&TOLIB/XCLOANCK) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCLOANCK)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XCLOANZ1)                                             /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(CLOANZ1) +
                          TOFILE(&TOLIB/XCLOANZ1) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCLOANZ1)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XLEFCAMPD)                                            /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(LEFCAMPD) +
                          TOFILE(&TOLIB/XLEFCAMPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XLEFCAMPD)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XLEMNFUPD)                                            /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(LEMNFUPD) +
                          TOFILE(&TOLIB/XLEMNFUPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XLEMNFUPD)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XLEFED)                                               /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(LEFEED) +
                          TOFILE(&TOLIB/XLEFED) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XLEFED)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XFACHISH)                                             /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(FACHISH) +
                          TOFILE(&TOLIB/XFACHISH) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XFACHISH)
                                                                                          /*CPK015*/
             DLTF       FILE(&TOLIB/XFACHISA)                                             /*CPK015*/
             MONMSG     MSGID(CPF2105)                                                    /*CPK015*/
                                                                                          /*CPK015*/
             CPYF       FROMFILE(FACHISA) +
                          TOFILE(&TOLIB/XFACHISA) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XFACHISA)
 
                CHGVAR     VAR(&STAT) VALUE('Y')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Restart, Copy Files From Backup Files,                            */
/*            Monitoring for CPF2817 - Cpyf ended because of error   */
/*                           CPF2869 - Empty member                  */
 
             ELSE       CMD(DO)
 
             CPYF       FROMFILE(&TOLIB/XFCLTYHH) +
                          TOFILE(FCLTYHH) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FCLTYHH)
             CPYF       FROMFILE(&TOLIB/XFCLTYFM) +
                          TOFILE(FCLTYFM) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FCLTYFM)
             CPYF       FROMFILE(&TOLIB/XFCLTYFN) +
                          TOFILE(FCLTYFN) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FCLTYFN)
             CPYF       FROMFILE(&TOLIB/XFCLTYZZ) +
                          TOFILE(FCLTYZZ) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FCLTYZZ)
             CPYF       FROMFILE(&TOLIB/XLEPARTPD) +
                          TOFILE(LEPARTPD) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM LEPARTPD)
             CPYF       FROMFILE(&TOLIB/XCLOANHH) +
                          TOFILE(CLOANHH) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CLOANHH)
             CPYF       FROMFILE(&TOLIB/XCLOANCL) +
                          TOFILE(CLOANCL) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CLOANCL)
             CPYF       FROMFILE(&TOLIB/XCLOANCK) +
                          TOFILE(CLOANCK) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CLOANCK)
             CPYF       FROMFILE(&TOLIB/XCLOANZ1) +
                          TOFILE(CLOANZ1) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CLOANZ1)
             CPYF       FROMFILE(&TOLIB/XLEFCAMPD) +
                          TOFILE(LEFCAMPD) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM LEFCAMPD)
             CPYF       FROMFILE(&TOLIB/XLEMNFUPD) +
                          TOFILE(LEMNFUPD) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM LEMNFUPD)
             CPYF       FROMFILE(&TOLIB/XLEFED) +
                          TOFILE(LEFEED) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM LEFEED)
             CPYF       FROMFILE(&TOLIB/XFACHISH) +
                          TOFILE(FACHISH) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FACHISH)
             CPYF       FROMFILE(&TOLIB/XFACHISA) +
                          TOFILE(FACHISA) MBROPT(*REPLACE) +
                          FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FACHISA)
             ENDDO
/*-------------------------------------------------------------------*/
/* Reset External Switches                                           */
 
             CHGJOB     SWS(00000000)
/*===================================================================*/
/* Call Facility Currency Conversion Programs                        */
/*                                                                   */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**Convert*Currency*Of*Risk*Participants*File*************************/                   /*CLE106*/
/* Convert Currency Of Assignments File                              */                   /*CLE106*/
 
             CALL       PGM(LE3590) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX10)) THEN(GOTO ERR10)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR11)
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Convert Currency Of Exchange Rates For Loans File                 */
 
             CALL       PGM(LE3600) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX10)) THEN(GOTO ERR10)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR11)
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                      /*199785*/
/* Convert amounts on the Facility Amendments file                                        /*199785*/
                                                                                          /*199785*/
             CALL       PGM(LE3610) PARM(&RSEQ)                                           /*199785*/
                                                                                          /*199785*/
             IF         COND(%SWITCH(XXXXXX10)) THEN(GOTO ERR10)                          /*199785*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR11)                          /*199785*/
                                                                                         /* 199785*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                     /* 199698*/
/* Convert exchange rates on Manual Facility Utilisations file                           /* 199698*/
                                                                                         /* 199698*/
             CALL       PGM(LE3620) PARM(&RSEQ)                                          /* 199698*/
                                                                                         /* 199698*/
             IF         COND(%SWITCH(XXXXXX10)) THEN(GOTO ERR10)                         /* 199698*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR11)                         /* 199698*/
                                                                                         /* 199698*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Convert Currency Of History Amounts File                          */
 
             CALL       PGM(LE3670) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX10)) THEN(GOTO ERR10)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR11)
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Convert Currency Of History Header File                           */
 
             CALL       PGM(LE3660) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX10)) THEN(GOTO ERR10)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR11)
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Convert Currency Of Fees File                                     */
 
             CALL       PGM(LE3650) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX10)) THEN(GOTO ERR10)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR11)
/*-------------------------------------------------------------------*/
/*/COPY WNCPYSRC,LEC3570001                                          */
/* Convert Currency Of Facilities File                               */
 
             CALL       PGM(LE3580) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX10)) THEN(GOTO ERR10)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR11)
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Produce Customer Advices (UDC)                                    */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
 
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
              SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                           MSGTYPE(*INFO)
              GOTO       CMDLBL(ERR10)
             ENDDO
 
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             STRJRNPF   FILE(LEFCUPPD) JRN(CGCOBJRN) IMAGES(*BOTH)
             ENDDO                                                    /*CCB009*/
                                                                                          /*CCG015*/
/** Call Extract File Instance Management */                                              /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
                                                                                          /*CCG015*/
             CALL       PGM(CG4650) PARM(&W0RTN &W0CMT)
             ROLLBACK
             RCLRSC
 
              IF         COND(&W0RTN *NE '       ') THEN(DO)
               GOTO       CMDLBL(ERR10)
              ENDDO
                                                                                          /*CCG015*/
/** Call Custom Defined Data Extract pgm */                                               /*CCG015*/
             IF         COND(%SWITCH(XXXXXX10)) THEN(GOTO ERR10)                          /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR11)                          /*CCG015*/
                                                                                          /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
                                                                                          /*CCG015*/
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX10)) THEN(GOTO ERR10)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR11)
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Produce Customer Advices (Non UDC)                                */
 
             CALL       PGM(LE3680) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX10)) THEN(GOTO ERR10)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR11)
/*-------------------------------------------------------------------*/
/* If U7 and U8 off, Change Status                                   */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
                CHGVAR     VAR(&STAT) VALUE('N')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
             ENDDO
/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Clear the Facilities Currency Conversion File for the Next Day.   */
/*                                                                   */
             CLRPFM     FILE(LEFCONPD)
 
             GOTO       CMDLBL(ENDPGM)
/*-------------------------------------------------------------------*/
/* Abnormal termination                                              */
 
 ERR10:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC3570 ended abnormally (XXXXXX10) - see +
                          job log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             GOTO       CMDLBL(ENDPGM)
 
 ERR11:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC3570 ended abnormally (XXXXXX11) - see +
                          job log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             GOTO       CMDLBL(ENDPGM)
 
 ERR99:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC3570 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             GOTO       CMDLBL(ENDPGM)
/*-------------------------------------------------------------------*/
/* End of Program                                                    */
 
 ENDPGM:
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(LEFCUPPD)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             ENDDO                                                    /*CCB009*/
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
