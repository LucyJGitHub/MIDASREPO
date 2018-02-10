/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Portfolio closure')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC101 - PM PORTFOLIO CLLOSURE                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. 147295             Date 08Nov98              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 11May95              */
/*                      S01486             Date 02Jun94              */
/*                      049421             DATE 18JAN93              */
/*                      S01189     GB      DATE 25MAR92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       147295  -  Include RCF processing.                          */
/*                  See also PM1010.                                 */
/*       S01408  -  Addition of core hook PMC101MP1                  */
/*       S01486  -  PRIVATE BANKING UPGRADE                          */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       S01189  -  COB RECOVERY PROCESSING                          */
/*       R00300  -  Message file changes.                            */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*>>S01189>>*/
/**********  PGM                                                     */
/**********  PGM        PARM(&CNAM &CSEQ)                               147295*/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLVL &RENT)           /*147295*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/*<<S01189<<*/
/* DECLARE VARIABLES */
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)                 *S01486*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*S01486*/
/*********   DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)              S01189   **/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DAT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*147295*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*147295*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*147295*/
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR*****VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')           *S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC101MP1                                           */
                                                                      /*S01408*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC101  - PM Portfolio Closure ') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* RETRIEVE TODAYS DATE */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAT)
 
/* CHECK FOR COMPONENT RESTART */
/*>>S01189>>*/
/**********  RTVDTAARA  DTAARA(PMSTAT (16 3)) RTNVAR(&BUSY)            */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
 
/* IF RESTART AFTER ANY ERROR */
/*>>S01189>>*/
/*********** IF         COND(&BUSY = 'NEW') THEN(DO)                  */
             IF         COND(&BUSY = 'Y') THEN(DO)
/*<<S01189<<*/
 
/************OVRDBF     FILE(XPMPORTPP) SEQONLY(*YES 100)              *S01486*/
/************CPYF       FROMFILE(XPMPORTPP) TOFILE(PMPORTPP) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(PMPORTPP))                              *S01486*/
/************                                                          *S01486*/
/************OVRDBF     FILE(XPMPORTZZ) SEQONLY(*YES 100)              *S01486*/
/************CPYF       FROMFILE(XPMPORTZZ) TOFILE(PMPORTZZ) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(PMPORTZZ))                              *S01486*/
/************                                                          *S01486*/
/************OVRDBF     FILE(XPMTRSFPP) SEQONLY(*YES 100)              *S01486*/
/************CPYF       FROMFILE(XPMTRSFPP) TOFILE(PMTRSFPP) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(PMTRSFPP))                              *S01486*/
/************                                                          *S01486*/
/************OVRDBF     FILE(XPMTRSFZZ) SEQONLY(*YES 100)              *S01486*/
/************CPYF       FROMFILE(XPMTRSFZZ) TOFILE(PMTRSFZZ) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(PMTRSFZZ))                              *S01486*/
             OVRDBF     FILE(XPMPORTPD) SEQONLY(*YES 100)             /*S01486*/
             CPYF       FROMFILE(XPMPORTPD) TOFILE(PMPORTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMPORTPD))                             /*S01486*/
                                                                      /*S01486*/
             OVRDBF     FILE(XPMPORTPA) SEQONLY(*YES 100)             /*S01486*/
             CPYF       FROMFILE(XPMPORTPA) TOFILE(PMPORTPA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMPORTPA))                             /*S01486*/
                                                                      /*S01486*/
             OVRDBF     FILE(XPMTRSFPD) SEQONLY(*YES 100)             /*S01486*/
             CPYF       FROMFILE(XPMTRSFPD) TOFILE(PMTRSFPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMTRSFPD))                             /*S01486*/
                                                                      /*S01486*/
             OVRDBF     FILE(XPMTRSFPA) SEQONLY(*YES 100)             /*S01486*/
             CPYF       FROMFILE(XPMTRSFPA) TOFILE(PMTRSFPA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMTRSFPA))                             /*S01486*/
 
             ENDDO
 
/* IF FIRST RUN */
/*>>S01189>>*/
/**********  IF         COND(&BUSY = 'OLD') THEN(DO)                **/
             IF         COND(&BUSY = 'N') THEN(DO)
/*<<S01189<<*/
 
/************OVRDBF     FILE(PMPORTPP) SEQONLY(*YES 100)               *S01486*/
/************CPYF       FROMFILE(PMPORTPP) TOFILE(&TOLIB/XPMPORTPP) +  *S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(XPMPORTPP))                             *S01486*/
/************                                                          *S01486*/
/************OVRDBF     FILE(PMPORTZZ) SEQONLY(*YES 100)               *S01486*/
/************CPYF       FROMFILE(PMPORTZZ) TOFILE(&TOLIB/XPMPORTZZ) +  *S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(XPMPORTZZ))                             *S01486*/
/************                                                          *S01486*/
/************OVRDBF     FILE(PMTRSFPP) SEQONLY(*YES 100)               *S01486*/
/************CPYF       FROMFILE(PMTRSFPP) TOFILE(&TOLIB/XPMTRSFPP) +  *S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(XPMTRSFPP))                             *S01486*/
/************                                                          *S01486*/
/************OVRDBF     FILE(PMTRSFZZ) SEQONLY(*YES 100)               *S01486*/
/************CPYF       FROMFILE(PMTRSFZZ) TOFILE(&TOLIB/XPMTRSFZZ) +  *S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(XPMTRSFZZ))                             *S01486*/
             OVRDBF     FILE(PMPORTPD) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMPORTPD) TOFILE(&TOLIB/XPMPORTPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMPORTPD))                            /*S01486*/
                                                                      /*S01486*/
             OVRDBF     FILE(PMPORTPA) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMPORTPA) TOFILE(&TOLIB/XPMPORTPA) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMPORTPA))                            /*S01486*/
                                                                      /*S01486*/
             OVRDBF     FILE(PMTRSFPD) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMTRSFPD) TOFILE(&TOLIB/XPMTRSFPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMTRSFPD))                            /*S01486*/
                                                                      /*S01486*/
             OVRDBF     FILE(PMTRSFPA) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMTRSFPA) TOFILE(&TOLIB/XPMTRSFPA) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMTRSFPA))                            /*S01486*/
 
/*>>S01189>>*/
/*********   CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')     **/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* SELECT ALL OPEN PORTFOLIOS WITH CLOSURE DUE OR PRIOR TO TODAY*/
/************OVRDBF     FILE(PMPORTPP) SHARE(*YES)                     *S01486*/
/************OPNQRYF    FILE((PMPORTPP)) OPTION(*ALL) +                *S01486*/
/************             FORMAT(PMPORTPP) QRYSLT('W1DPCL *NE 0 *AND + *S01486*/
/************             WWDPCL *LE "' *CAT &DAT *CAT '" *AND +       *S01486*/
/************             PNRECI *EQ "D" ') KEYFLD((PMPORTPP/PNCNUM) + *S01486*/
/************             (PMPORTPP/PNPTFR)) MAPFLD((W1DPCL PNDPCL +   *S01486*/
/************             *ZONED 5) (WWDPCL W1DPCL *CHAR 5))           *S01486*/
             OVRDBF     FILE(PMPORTPD) SHARE(*YES)                    /*S01486*/
             OPNQRYF    FILE((PMPORTPD)) OPTION(*ALL) +
                          FORMAT(PMPORTPD) QRYSLT('W1DPCL *NE 0 *AND +
                          WWDPCL *LE "' *CAT &DAT *CAT '" *AND +
                          PNRECI *EQ "D" ') KEYFLD((PMPORTPD/PNCNUM) +
                          (PMPORTPD/PNPTFR)) MAPFLD((W1DPCL PNDPCL +
                          *ZONED 5) (WWDPCL W1DPCL *CHAR 5))          /*S01486*/
 
/* CALL PROGRAM TO PROCESS PORTFOLIO CLOSURES */
/*********** CALL       PGM(PM1010)                                   /*147295*/
             CALL       PGM(PM1010) PARM(&RSEQ &RLVL &RENT)           /*147295*/
/************CLOF       OPNID(PMPORTPP)                                *S01486*/
             CLOF       OPNID(PMPORTPD)                               /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA)-
                           TOMSGQ(MOPERQ MRUNQ)                       /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)          *S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* IF JOB ENDED NORMALLY */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*>>S01189>>*/
/*********** CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')      **/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
/************DLTF       FILE(XPMPORTPP)                                *S01486*/
             DLTF       FILE(XPMPORTPD)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
/************DLTF       FILE(XPMPORTZZ)                                *S01486*/
             DLTF       FILE(XPMPORTPA)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
/************DLTF       FILE(XPMTRSFPP)                                *S01486*/
             DLTF       FILE(XPMTRSFPD)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
/************DLTF       FILE(XPMTRSFZZ)                                *S01486*/
             DLTF       FILE(XPMTRSFPA)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
             ENDDO
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
