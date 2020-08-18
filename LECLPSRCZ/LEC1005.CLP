/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Guars/security/review report')               */
/********************************************************************/
/*                                                                  */
/*        Midas - Customer Lending Module                   */
/*                                                                  */
/*       LEC1005 - GUARANTEES/SECURITY/REVIEW REPORT                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. 256062             Date 27May14              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      116180             Date 18May98              */
/*                      S01408             Date 25May95              */
/*                      S01189              DATE 09FEB90            */
/*                      S01194              DATE 09FEB90            */
/*                      S01179              DATE 14/09/88           */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       256062 - Call LE0970 during monthend COB.                   */
/*              - Applied for MD-26864.                              */
/*       MD046248 - Finastra Rebranding                              */
/*       116180 - Allow report to be on request rather than monthly.*/
/*                This program has been changed only to run the     */
/*                extract LE0960 and update the GTEES file. A new   */
/*                program LEC1005R has been written to run LE0960   */
/*                & LE0970 but not to update GTEES. A new component */
/*                has been created which must be run before this.   */
/*                Applied fix 073739.                               */
/*       S01408 - Addition of core hook LEC1005MP1                  */
/*       S01189 - COB recovery processing.                          */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01179 - AS400 INCORPORATION                               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                  */  /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('GUARANTEES/SECURITY/REVIEW +
                        UPDATE')                                      /*116180*/
/***********************REPORT')                                      /*116180*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
/*/COPY WNCPYSRC,LEC1005002                                          */
/**/
/************DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*S01179*/
/************DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
/************DCL VAR(&LESTAT) TYPE(*CHAR) LEN(256)*/  /*S01179*/      /*S01189*/
/**/
/*  IF P/MFU INDICATOR 'OLD' THEN CLEAR PF/GTUPDxx ,                */
/*   UPDATE FILES AND P/MFU INDICATOR TO 'NEW'                      */
/**/
/*           RCVDTAARA  DTAARA(LESTAT)                              *  *S01179*/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/  /*S01179*/  /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/**/
/************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'OLD') +
 ***********************THEN(DO)****/                                 /*S01189*/
             IF         COND(&BUSY = 'N') THEN(DO)                    /*S01189*/
/**/
                CLRPFM     FILE(GTUPDHH)       /* NEW LF/GTEES FILE */
                CLRPFM     FILE(GTUPDGT)       /* OUTPUT FROM LE0960*/
                CLRPFM     FILE(GTUPDZZ)
/**/
                CLRPFM     FILE(GTEXTHH)       /* LF/GTEXT FILE     */
                CLRPFM     FILE(GTEXTGX)       /* OUTPUT FROM LE0960*/
                CLRPFM     FILE(GTEXTZZ)
/**/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/************** OVRDBF     FILE(TABLE) TOFILE(TABLEEI)               * *S01194*/
                CALL       PGM(LE0960)
/*/COPY WNCPYSRC,LEC1005001                                          */
/************** DLTOVR     FILE(TABLE)                               * *S01194*/
/**/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/***************** OVRDBF     FILE(TABLE)  TOFILE(TABLEEE)           * *S01194*/
/******************CALL       PGM(LE0970)                             /*116180*/
                   CALL       PGM(LE0970) PARM('     ' 'ALL')                             /*256062*/
/***************** DLTOVR     FILE(*ALL)                             * *S01194*/
/**/
                   IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/*********************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/      /*S01189*/
/*                    RCVDTAARA  DTAARA(LESTAT)                     *  *S01179*/
/*********************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)S01179 /*S01189*/
/*                    RCVDTAARA  DTAARA(LDA)                        *  *S01179*/
                      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)             /*S01179*/
/* P/MFU 'NEW'                                                      */
/************************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
 ***********************************VALUE('NEW')****/                 /*S01189*/
/************CHGDTAARA  DTAARA(LESTAT *ALL) VALUE(&LESTAT)*/          /*S01189*/
                      CHGVAR     VAR(&BUSY) VALUE('Y')                /*S01189*/
                      CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)       /*S01189*/
/*********************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/      /*S01189*/
/**/
                   ENDDO
/**/
                ENDDO
/**/
             ENDDO
/**/
/*   CLEAR GTEES - COPY GTUPD TO GTEES - CLEAR GTUPD - RESET IND */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/***************RCVDTAARA  DTAARA(LESTAT)                           *  *S01179*/
/***************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)/*S01179*/   /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE(' ')                      /*S01189*/
                CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
/***************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'NEW') +
 **************************THEN(DO)****/                              /*S01189*/
                IF         COND(&BUSY = 'Y') THEN(DO)                 /*S01189*/
/**/
                   CLRPFM     FILE(GTEESHH)
                   CLRPFM     FILE(GTEESGT)
                   CLRPFM     FILE(GTEESZZ)
/**/
/**/
/* UPDATE PF/GTEESxx                                                 */
                   CPYF       FROMFILE(GTUPDHH) TOFILE(GTEESHH) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
/**/
                   CPYF       FROMFILE(GTUPDGT) TOFILE(GTEESGT) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF2817)
/**/
                   CPYF       FROMFILE(GTUPDZZ) TOFILE(GTEESZZ) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC1005MP1                                          */
/**/                                                                  /*S01408*/
/* UPDATE P/MFU IND.                                                 */
/******************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
/*                 RCVDTAARA  DTAARA(LESTAT)                        *  *S01179*/
/******************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/        /*S01179*/
/******************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
 *****************************VALUE('OLD')****/                       /*S01189*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)*/               /*S01189*/
                   CHGVAR     VAR(&BUSY) VALUE('N')                   /*S01189*/
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)          /*S01189*/
/******************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
/**/
                   CLRPFM     FILE(GTUPDHH)
                   CLRPFM     FILE(GTUPDGT)
                   CLRPFM     FILE(GTUPDZZ)
/**/
                   CLRPFM     FILE(GTEXTHH)
                   CLRPFM     FILE(GTEXTGX)
                   CLRPFM     FILE(GTEXTZZ)
/**/
                ENDDO
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
