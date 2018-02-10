/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Customer Status Change')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1030 - PROCESS CUSTOMER STATUS CHANGE                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 11May95              */
/*                      S01496             Date 09Nov94              */
/*                      S01486             DATE 28SEP94              */
/*                      049421             DATE 18JAN93              */
/*                      S01189     GB      DATE 25MAR92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook PMC1030MP1                   */
/*       S01496 - Incorporation of Jyske Enhancements (S10978)       */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       R00300 - Message file changes.                              */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*>>S01189>>*/
/**********  PGM                                                     */
             PGM        PARM(&CNAM &CSEQ)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/*<<S01189<<*/
             DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ECD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
/*********   DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)              S01189   **/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01496*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01496*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01496*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01496*/
             DCL        VAR(&S01496) TYPE(*CHAR) LEN(1)               /*S01496*/
/**/                                                                  /*S01496*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01496*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01496*/
             CHGVAR     VAR(&SAR) VALUE('S01496')                     /*S01496*/
             CHGVAR     VAR(&S01496) VALUE('N')                       /*S01496*/
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')           *S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1030MP1                                          */
                                                                      /*S01408*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1030 - PM Customer Status Change') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/                                                                  /*S01496*/
/**  Check if Jyske Enhancements is installed */                      /*S01496*/
/**/                                                                  /*S01496*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01496*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*S01496*/
                CHGVAR     VAR(&S01496) VALUE('Y')                    /*S01496*/
             ENDDO                                                    /*S01496*/
 
/* RESET SWITCHES                                              */
             CHGJOB     SWS(00000000)
 
/********************************************************************/
/*  RETRIEVE DATES AND BUSY FLAG FROM DTAARA/PMSTAT                 */
/********************************************************************/
 
             RTVDTAARA  DTAARA(PMSTAT) RTNVAR(&PMSTAT)
             CHGVAR     VAR(&ECD) VALUE(%SST(&PMSTAT 1 5))
             CHGVAR     VAR(&RUN) VALUE(%SST(&PMSTAT 6 5))
/*>>S01189>>*/
/**********  CHGVAR     VAR(&BUSY) VALUE(%SST(&PMSTAT 16 3))        */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
 
/*  IF RESTART OVERRIDE FILES                                       */
 
/*>>S01189>>*/
/*********** IF         COND(&BUSY = 'NEW') THEN(DO)                  */
             IF         COND(&BUSY = 'Y') THEN(DO)
/*<<S01189<<*/
 
/************OVRDBF     FILE(XPMCPOSPP) SEQONLY(*YES 100)              *S01486*/
             OVRDBF     FILE(XPMCPOSPD) SEQONLY(*YES 100)             /*S01486*/
             OVRDBF     FILE(XSDPLCSPD) SEQONLY(*YES 100)
/**/                                                                  /*S01496*/
/**  If Jyske Enhancements is installed, override ER files */         /*S01496*/
/**/                                                                  /*S01496*/
             IF         COND(&S01496 = 'Y') THEN(DO)                  /*S01496*/
                OVRDBF     FILE(XCDEPPD)   SEQONLY(*YES 100)          /*S01496*/
                OVRDBF     FILE(XCDEPPA)   SEQONLY(*YES 100)          /*S01496*/
                OVRDBF     FILE(XSEERALPD) SEQONLY(*YES 100)          /*S01496*/
                OVRDBF     FILE(XSEBLKPPD) SEQONLY(*YES 100)          /*S01496*/
             ENDDO                                                    /*S01496*/
 
/*     RESTORE FILES SECURITY COPIES                        */
 
/************CPYF       FROMFILE(XPMCPOSPP) TOFILE(PMCPOSPP) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +               *S01486*/
/************           EXEC(CLRPFM PMCPOSPP)                          *S01486*/
/************                                                          *S01486*/
/************CPYF       FROMFILE(XPMCPOSZZ) TOFILE(PMCPOSZZ) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +               *S01486*/
/************           EXEC(CLRPFM PMCPOSZZ)                          *S01486*/
             CPYF       FROMFILE(XPMCPOSPD) TOFILE(PMCPOSPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM PMCPOSPD)                         /*S01486*/
 
             CPYF       FROMFILE(XPMCPOSPA) TOFILE(PMCPOSPA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM PMCPOSPA)                         /*S01486*/
 
             CPYF       FROMFILE(XSDPLCSPD) TOFILE(SDPLCSPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SDPLCSPD)
/**/                                                                  /*S01496*/
             IF         COND(&S01496 = 'Y') THEN(DO)                  /*S01496*/
/**/                                                                  /*S01496*/
                CPYF       FROMFILE(XCDEPPD) TOFILE(CDEPPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01496*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM CDEPPD)                      /*S01496*/
/**/                                                                  /*S01496*/
                CPYF       FROMFILE(XCDEPPA) TOFILE(CDEPPA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01496*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM CDEPPA)                      /*S01496*/
/**/                                                                  /*S01496*/
                CPYF       FROMFILE(XSEERALPD) TOFILE(SEERALPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01496*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SEERALPD)                    /*S01496*/
/**/                                                                  /*S01496*/
                CPYF       FROMFILE(XSEBLKPPD) TOFILE(SEBLKPPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01496*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SEBLKPPD)                    /*S01496*/
/**/                                                                  /*S01496*/
             ENDDO                                                    /*S01496*/
/**/                                                                  /*S01496*/
             ENDDO
 
/*  IF FIRST RUN                                                    */
 
/*>>S01189>>*/
/**********  IF         COND(&BUSY = 'OLD') THEN(DO)                **/
             IF         COND(&BUSY = 'N') THEN(DO)
/*<<S01189<<*/
 
/*     OVERRIDE FILES FOR FIRST RUN                         */
 
/************OVRDBF     FILE(PMCPOSPP) SEQONLY(*YES 100)               *S01486*/
             OVRDBF     FILE(PMCPOSPD) SEQONLY(*YES 100)              /*S01486*/
             OVRDBF     FILE(SDPLCSPD) SEQONLY(*YES 100)
/**/                                                                  /*S01496*/
/**  If Jyske Enhancements is installed, override ER files */         /*S01496*/
/**/                                                                  /*S01496*/
             IF         COND(&S01496 = 'Y') THEN(DO)                  /*S01496*/
                OVRDBF     FILE(CDEPPD)   SEQONLY(*YES 100)           /*S01496*/
                OVRDBF     FILE(CDEPPA)   SEQONLY(*YES 100)           /*S01496*/
                OVRDBF     FILE(SEERALPD) SEQONLY(*YES 100)           /*S01496*/
                OVRDBF     FILE(SEBLKPPD) SEQONLY(*YES 100)           /*S01496*/
             ENDDO                                                    /*S01496*/
 
/*     TAKE A SECURITY COPY OF FILES                        */
 
/************CPYF       FROMFILE(PMCPOSPP) TOFILE(&TOLIB/XPMCPOSPP) +  *S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +               *S01486*/
/************           EXEC(CLRPFM XPMCPOSPP)                         *S01486*/
/************                                                          *S01486*/
/************CPYF       FROMFILE(PMCPOSZZ) TOFILE(&TOLIB/XPMCPOSZZ) +  *S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +               *S01486*/
/************           EXEC(CLRPFM XPMCPOSZZ)                         *S01486*/
             CPYF       FROMFILE(PMCPOSPD) TOFILE(&TOLIB/XPMCPOSPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XPMCPOSPD)                        /*S01486*/
                                                                      /*S01486*/
             CPYF       FROMFILE(PMCPOSPA) TOFILE(&TOLIB/XPMCPOSPA) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XPMCPOSPA)                        /*S01486*/
 
             CPYF       FROMFILE(SDPLCSPD) TOFILE(&TOLIB/XSDPLCSPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSDPLCSPD)
 
             IF         COND(&S01496 = 'Y') THEN(DO)                  /*S01496*/
/**/                                                                  /*S01496*/
             CPYF       FROMFILE(CDEPPD) TOFILE(&TOLIB/XCDEPPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01496*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XCDEPPD)                          /*S01496*/
/**/                                                                  /*S01496*/
             CPYF       FROMFILE(CDEPPA) TOFILE(&TOLIB/XCDEPPA) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01496*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XCDEPPA)                          /*S01496*/
/**/
             CPYF       FROMFILE(SEERALPD) TOFILE(&TOLIB/XSEERALPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01496*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSEERALPD)                        /*S01496*/
/**/                                                                  /*S01496*/
             CPYF       FROMFILE(SEBLKPPD) TOFILE(&TOLIB/XSEBLKPPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01496*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSEBLKPPD)                        /*S01496*/
/**/                                                                  /*S01496*/
             ENDDO                                                    /*S01496*/
/**/                                                                  /*S01496*/
/*     CHANGE DATA AREA TO 'NEW'                            */
 
/*>>S01189>>*/
/*********   CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')     **/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
 
             ENDDO
 
/************OVRDBF     FILE(SDPLCSPT) SHARE(*YES)                     *S01486*/
             OVRDBF     FILE(SDPLCSPT) TOFILE(SDPLCSL0) SHARE(*YES)   /*S01486*/
 
/************OPNQRYF    FILE((SDPLCSPT)) OPTION(*ALL) QRYSLT('QBCHTP + *S01486*/
/************             *EQ "I" *AND *MAPFLD/LCD1 *EQ "' *CAT &RUN + *S01486*/
/************             *CAT '" *OR QBCHTP *EQ "D" *AND +            *S01486*/
/************             *MAPFLD/LCD1 *EQ "' *CAT &RUN *CAT '"') +    *S01486*/
/************             KEYFLD((SDPLCSPT/QBCUST)) MAPFLD((LCDD +     *S01486*/
/************             QBLCD *ZONED 5) (LCD1 LCDD *CHAR 5)) +       *S01486*/
/************             IGNDECERR(*YES)                              *S01486*/
             OPNQRYF    FILE((SDPLCSPT)) OPTION(*ALL) QRYSLT('QBTYLC +
                          *EQ "I" *AND *MAPFLD/LCD1 *EQ "' *CAT +
                          &RUN *CAT '" *OR QBTYLC *EQ "D" *AND +
                          *MAPFLD/LCD1 *EQ "' *CAT &RUN *CAT '"') +
                          KEYFLD((SDPLCSPT/QBCUST)) MAPFLD((LCDD +
                          QBLCD *ZONED 5) (LCD1 LCDD *CHAR 5)) +
                          IGNDECERR(*YES)                             /*S01486*/
 
             CALL       PGM(PM1030) PARM(&ECD)
 
             CLOF       OPNID(SDPLCSPT)
 
             DLTOVR     FILE(*ALL)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 132 52))
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOPGMQ(*EXT) TOMSGQ(*TOPGMQ)               */
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +   *S01486*/
/************             TOPGMQ(*EXT) TOMSGQ(*TOPGMQ)                 *S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(*TOPGMQ)                /*S01486*/
/*                                                                    /*R00300*/
             CHGVAR     VAR(&MEM) VALUE('PMC1030  - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(*TOPGMQ)
             ENDDO
 
/* FOR NORMALY COMPLETED JOB, DELETE SECURITY COPY OF FILES     */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/*>>S01189>>*/
/*********** CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')      **/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
 
/************DLTF FILE(XPMCPOSPP)                                      *S01486*/
             DLTF FILE(XPMCPOSPD)                                     /*S01486*/
             MONMSG MSGID(CPF2105)
/************DLTF FILE(XPMCPOSZZ)                                      *S01486*/
             DLTF FILE(XPMCPOSPA)                                     /*S01486*/
             MONMSG MSGID(CPF2105)
             DLTF FILE(XSDPLCSPD)
             MONMSG MSGID(CPF2105)
/**/                                                                  /*S01496*/
             IF         COND(&S01496 = 'Y') THEN(DO)                  /*S01496*/
                DLTF FILE(XCDEPPD)                                    /*S01496*/
                MONMSG MSGID(CPF2105)                                 /*S01496*/
                DLTF FILE(XCDEPPA)                                    /*S01496*/
                MONMSG MSGID(CPF2105)                                 /*S01496*/
                DLTF FILE(XSEERALPD)                                  /*S01496*/
                MONMSG MSGID(CPF2105)                                 /*S01496*/
                DLTF FILE(XSEBLKPPD)                                  /*S01496*/
                MONMSG MSGID(CPF2105)                                 /*S01496*/
             ENDDO                                                    /*S01496*/
 
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
