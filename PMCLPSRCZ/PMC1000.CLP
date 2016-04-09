/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Save Deleted Customer Details')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1000 - PROCESS CUSTOMERS DELETED TODAY                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 11MAY95              */
/*       PREV AMEND NO. S01486             DATE 05JUL94              */
/*                      S01189             DATE 26OCT93              */
/*                      038430             DATE 04AUG93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01408 - Addition of core hook PMC1000MP1                   */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       S01189 - COB RECOVERY PROCESSING                            */
/* CREATED FOR 038430  ENHANCEMENTS TO CUSTOMER INSERTION/DELETION   */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*>>S01189>>*/
/************PGM*/
             PGM        PARM(&CNAM &CSEQ)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/*<<S01189<<*/
/************DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)              *S01486*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)                 *S01486*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01486*/
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
/*********   DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                   S01189*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')           *S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1000MP1                                          */
                                                                      /*S01408*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1000 - PM Process customers deleted +
                          today') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* RESET SWITCHES                                              */
             CHGJOB     SWS(00000000)
 
/************RTVDTAARA  DTAARA(PMSTAT) RTNVAR(&PMSTAT)                 *S01486*/
/*>>S01189>>*/
/************CHGVAR     VAR(&BUSY) VALUE(%SST(&PMSTAT 16 3))           ***/
/************RTVDTAARA  DTAARA(PMSTAT (16 3)) RTNVAR(&BUSY)           ***/
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
 
/* IF RESTART AFTER ANY ERROR */
/*>>S01189>>*/
/**********  IF         COND(&BUSY = 'NEW') THEN(DO)   ***/
             IF         COND(&BUSY = 'Y') THEN(DO)
/*<<S01189<<*/
 
/************CPYF       FROMFILE(XPMPORTZZ) TOFILE(PMPORTZZ) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(PMPORTZZ))                              *S01486*/
 
/************CPYF       FROMFILE(XPMPORTPP) TOFILE(PMPORTPP) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(PMPORTPP))                              *S01486*/
             CPYF       FROMFILE(XPMPORTPA) TOFILE(PMPORTPA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMPORTPA))                             /*S01486*/
             CPYF       FROMFILE(XPMPORTPD) TOFILE(PMPORTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMPORTPD))                             /*S01486*/
 
             ENDDO
 
/* IF FIRST RUN */
/*>>S01189>>*/
/**********  IF         COND(&BUSY = 'OLD') THEN(DO)                ***/
             IF         COND(&BUSY = 'N') THEN(DO)
/*<<S01189<<*/
 
/************CPYF       FROMFILE(PMPORTZZ) TOFILE(&TOLIB/XPMPORTZZ) +  *S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(XPMPORTZZ))                             *S01486*/
 
/************CPYF       FROMFILE(PMPORTPP) TOFILE(&TOLIB/XPMPORTPP) +  *S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(XPMPORTPP))                             *S01486*/
 
             CPYF       FROMFILE(PMPORTPA) TOFILE(&TOLIB/XPMPORTPA) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMPORTPA))                            /*S01486*/
             CPYF       FROMFILE(PMPORTPD) TOFILE(&TOLIB/XPMPORTPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMPORTPD))                            /*S01486*/
/*>>S01189>>*/
/*********   CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')              ****/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* SELECT CUSTOMERS DELETED TODAY                                    */
             OVRDBF     FILE(SDPLCSPD) SHARE(*YES)
/************OPNQRYF    FILE((SDPLCSPD)) OPTION(*ALL) QRYSLT('QBRECI + *S01486*/
/************             *EQ "D" *AND QBCHTP *EQ "D"')                *S01486*/
             OPNQRYF    FILE((SDPLCSPD)) OPTION(*ALL) QRYSLT('QBRECI +
                          *EQ "D" *AND QBTYLC *EQ "D"')               /*S01486*/
             CALL       PGM(PM1000)
             CLOF       OPNID(SDPLCSPD)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/************   CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 132 52))  *S01486*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +   *S01486*/
/************             TOPGMQ(*EXT) TOMSGQ(*TOPGMQ)                 *S01486*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 132 50)) /*S01486*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)                       /*S01486*/
             CHGVAR     VAR(&MEM) VALUE('PMC1000  - JOB TERMINATED, +
                          DATABASE IN ERROR')
/************SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(*TOPGMQ)         *S01486*/
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)             /*S01486*/
             ENDDO
 
/* FOR NORMALY COMPLETED JOB, DELETE SECURITY COPY OF FILES     */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/*>>S01189>>*/
/**********  CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')                ***/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
 
/************DLTF       FILE(XPMPORTZZ)                                *S01486*/
             DLTF       FILE(XPMPORTPA)                               /*S01486*/
             MONMSG MSGID(CPF2105)
 
/************DLTF       FILE(XPMPORTPP)                                *S01486*/
             DLTF       FILE(XPMPORTPD)                               /*S01486*/
             MONMSG MSGID(CPF2105)
 
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
