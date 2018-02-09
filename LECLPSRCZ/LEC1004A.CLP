/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Update Year to Date file')                   */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC1004A - UPDATE YEAR-TO-DATE FILE                        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01189             Date 09Jan90              */
/*                      S01194             Date 09Feb90              */
/*                      S01179              DATE  14/09/88          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01189 - COB recovery processing.                          */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01179 - AS400 INCORPORATION                               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                   */ /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*********** DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/*********** DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
/************DCL VAR(&LESTAT) TYPE(*CHAR) LEN(256)*/                  /*S01189*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
/**/
             SNDPGMMSG  MSG('UPDATE YEAR-TO-DATE FILE') +
                        TOMSGQ(MRUNQ)
/**/
/**/
/*  IF P/MFU INDICATOR 'OLD' THEN CLEAR PF/UPYTDxx ,                */
/*   UPDATE FILES AND P/MFU INDICATOR TO 'NEW'                      */
/**/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/              /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/**/
/************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'OLD') +
 ***********************THEN(DO)****/                                 /*S01189*/
             IF         COND(&BUSY = 'N') THEN(DO)                    /*S01189*/
/**/
                CLRPFM     FILE(UPYTDHH)       /* LF/UPYTD FILE */
                CLRPFM     FILE(UPYTDYT)       /* OUTPUT FROM LE0910*/
                CLRPFM     FILE(UPYTDZY)
/**/
/************** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)               * *S01194*/
                CALL       PGM(LE0910)
/************** DLTOVR     FILE(TABLE)                               * *S01194*/
/**/
/* P/MFU 'NEW'                                                      */
/**/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/******************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/              /*S01189*/
/******************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
 *****************************VALUE('NEW')****/                       /*S01189*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)*/               /*S01189*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')                   /*S01189*/
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)          /*S01189*/
/******************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
/**/
                ENDDO
/**/
             ENDDO
/**/
/*   CLEAR LEYTD - COPY UPYTD TO LEYTD - CLEAR UPYTD - RESET IND */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/              /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE(' ')                      /*S01189*/
                CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
/***************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'NEW') +
 **************************THEN(DO)*/                                 /*S01189*/
                IF         COND(&BUSY = 'Y') THEN(DO)                 /*S01189*/
/**/
                   CLRPFM     FILE(LEYTDHH)
                   CLRPFM     FILE(LEYTDYT)
                   CLRPFM     FILE(LEYTDZZ)
/**/
/* UPDATE PF/LEYTDxx                                                 */
                   CPYF       FROMFILE(UPYTDHH) TOFILE(LEYTDHH) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
/**/
                   CPYF       FROMFILE(UPYTDYT) TOFILE(LEYTDYT) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF2817)
/**/
                   CPYF       FROMFILE(UPYTDZY) TOFILE(LEYTDZZ) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
/**/
/* UPDATE P/MFU IND.                                                 */
/******************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/              /*S01189*/
/******************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
 *****************************VALUE('OLD')****/                       /*S01189*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)*/               /*S01189*/
                   CHGVAR     VAR(&BUSY) VALUE('N')                   /*S01189*/
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)          /*S01189*/
/******************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
/**/
                   CLRPFM     FILE(UPYTDHH)
                   CLRPFM     FILE(UPYTDYT)
                   CLRPFM     FILE(UPYTDZY)
/**/
                ENDDO
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
