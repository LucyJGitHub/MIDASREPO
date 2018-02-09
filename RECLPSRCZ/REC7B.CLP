/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Interest rate changes report')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC7B - INTEREST RATE CHANGES REPORT                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR826169           Date 12Sep11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CRE005             Date 18Jan10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01413             Date 13APR93              */
/*                      S01117                  16MAR90              */
/*                      S01194                  12MAR90              */
/*                      S01098                  18JUL86              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR826169 - Opening debit and credit rate are                */
/*                  zero (Child:AR826170)                            */
/*       CRE005 - Changes to STRAN                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       S01413  -  Retail 3 Incorporation                           */
/*       S01117  -  Multibranching                                   */
/*                  Please note the change in the name of the called */
/*                  Program   from RE743A to RE7430                  */
/*       S01194  -  New Standing data                                */
/*       S01098  -  Amendment replaces data in copied files,         */
/*                  instead of clearing and adding                   */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/************DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                   * *S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)                                 /*AR826169*/
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)                                 /*AR826169*/
             DCL        VAR(&SARD)   TYPE(*CHAR) LEN(6)                                 /*AR826169*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                               /*AR826169*/
             DCL        VAR(&CRE005) TYPE(*CHAR) LEN(1)                                 /*AR826169*/
/**/
             SNDPGMMSG  MSG('REC7B - Interest Base Rate Change Report') +
                        TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(SRCIP2HH)
             CLRPFM     FILE(SRCIP2P1)
             CLRPFM     FILE(SRCIP2P2)
             CLRPFM     FILE(SRCIP2P3)
             CLRPFM     FILE(SRCIP2ZZ)
             CHGVAR     VAR(&CRE005) VALUE('N')                                         /*AR826169*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*AR826169*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*AR826169*/
             CHGVAR     VAR(&SARD) VALUE('CRE005')                                      /*AR826169*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                   /*AR826169*/
/**/                                                                                    /*AR826169*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                              /*AR826169*/
                  CHGVAR     VAR(&CRE005) VALUE('Y')                                    /*AR826169*/
             ENDDO                                                                      /*AR826169*/
/**/
/*********   CLRPFM     FILE(SRCIP3)                       **********  *S01098*/
/**/
/*********   CPYF FROMFILE(STRAN) TOFILE(SRCIP3) MBROPT(*ADD) + *****  *S01098*/
/*********          INCCHAR(RECI 1 *EQ 'R') FMTOPT(*NOCHK)      *****  *S01098*/
/**********  CPYF   FROMFILE(STRAN) TOFILE(SRCIP3) MBROPT(*REPLACE) +
                    INCCHAR(RECI 1 *EQ 'R') FMTOPT(*NOCHK)      */             /*S01098*/ /*CRE005*/
             IF     COND(&CRE005 *EQ 'N') THEN(DO)                                      /*AR826169*/
             CPYF   FROMFILE(STRAN) TOFILE(SRCIP3) MBROPT(*REPLACE) +
                    INCCHAR(RECI 1 *EQ 'R') FMTOPT(*NOCHK)                              /*AR826169*/
             MONMSG (CPF2817) CMPDTA(CPF2869) +
                    EXEC(CLRPFM SRCIP3)                               /*S01098*/
             ENDDO                                                                      /*AR826169*/
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABRE2)
/**/
/*********** CALL       PGM(RE743A)                                   /*S01117*/
             CALL       PGM(RE7430)                                   /*S01117*/
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/*********** CHGVAR VAR(&PGM) VALUE('RE743A')                         /*S01117*/
             CHGVAR VAR(&PGM) VALUE('RE7430')                         /*S01117*/
             GOTO CMDLBL(ERROR)
             ENDDO
             ELSE  CMD(DO)
             CLRPFM FILE(RCHGHH)
             CLRPFM FILE(RCHGRA)
             CLRPFM FILE(RCHGZZ)
             CLRPFM FILE(RCHGR1)                                     /*S01413*/
             CLRPFM FILE(RCHGR2)                                     /*S01413*/
             CLRPFM FILE(RCHGR3)                                     /*S01413*/
             CALL PGM(RE0743)
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(CHGVAR VAR(&PGM) +
                VALUE('RE0743'))
             ENDDO
/**/
      DLTOVR FILE(TABLE)
/**/
/**/
ERROR:       IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
/***************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))            * *S01194*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**********        CHGVAR     VAR(&MSG) VALUE('FILES OUT OF BALANCE - '****&PGM)      */ /*BG18886*/
                   CHGVAR     VAR(&MSG) VALUE('FILES OUT OF BALANCE - ' *CAT &PGM)       /*BG18886*/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)
                ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
      ENDPGM
