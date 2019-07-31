/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Interest Sub-Types Rate Changes')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC64 - INTEREST SUB-TYPES RATE CHANGES                     */
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
/*       PREV AMEND NO. S01413             DATE 13APR93              */
/*                      BHF982                  19FEB91              */
/*                      S01194                  12MAR90              */
/*                      S01189                  12MAR90              */
/*                      S01179                  21OCT88              */
/*                      S01098                  08JUL86              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413  -  Header Box Standardised                          */
/*       BHF982  -  Addlfm should be share(*YES)                     */
/*       S01189  -  COB recovery processing.                         */
/*       S01194  -  New Standing data                                */
/*       S01179  -  AS/400 Conversion                                */
/*       S01098  -  Amendment replaces data in copied files,         */
/*                  instead of clearing and adding                   */
/*                  from and to files are now 'BLOCKED'              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/************PGM                                                   */ /*S01189*/
             PGM     PARM(&CNAM &CSEQ)                                /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/************DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                   * *S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL     VAR(&CNAM) TYPE(*CHAR) LEN(10)                   /*S01189*/
             DCL     VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                   /*S01189*/
             DCL     VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')         /*S01189*/
/************DCL     VAR(&RESTAT) TYPE(*CHAR) LEN(256)*/              /*S01189*/
/**/
             SNDPGMMSG MSG('REC64 - Interest Sub-Types Rate Changes') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(XXXXXX00)
/**/
             CLRPFM FILE(UPRINA)
             CLRPFM FILE(UPRIND)
             CLRPFM FILE(UPRINZ)
/**/
/*   IF P/MFU INDICATOR IS 'OLD' THEN CLEAR P/REINUX,    */
/*  UPDATE FILE & P/MFU INDICATOR TO 'NEW'               */
/************RTVDTAARA DTAARA(RESTAT *ALL) RTNVAR(&RESTAT)*/          /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/*********IF COND(%SUBSTRING(&RESTAT 12 3) = 'OLD') THEN(DO)*/        /*S01189*/
          IF         COND(&STAT *EQ 'N') THEN(DO)                     /*S01189*/
             CLRPFM FILE(REINUA)
             CLRPFM FILE(REINUD)
             CLRPFM FILE(REINUZ)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/**/
             CALL PGM(RE0640)
/**/
             DLTOVR FILE(TABLE)
/**/
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/**************ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))*/                 /*S01189*/
/**************RTVDTAARA DTAARA(RESTAT *ALL) RTNVAR(&RESTAT)*/        /*S01189*/
/**************CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('NEW')*/    /*S01189*/
/*             SNDDTAARA DTAARA(RESTAT)                    *S01179*/
/**************CHGDTAARA DTAARA(RESTAT)     VALUE(&RESTAT) /*S01179*/ /*S01189*/
/**************DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))*/                 /*S01189*/
               CHGVAR     VAR(&STAT) VALUE('Y')                       /*S01189*/
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)         /*S01189*/
             ENDDO
          ENDDO
/**/
/*   CLEAR PF/REINTX - COPY REINUX TO REINTX        */
/*   RESET P/MFU INDICATOR & CLEAR REINU            */
/************RTVDTAARA DTAARA(RESTAT *ALL) RTNVAR(&RESTAT)*/          /*S01189*/
             CHGVAR     VAR(&STAT) VALUE(' ')                         /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/*********IF  COND(%SST(&RESTAT 12 3) *EQ 'NEW') THEN(DO)*/           /*S01189*/
          IF         COND(&STAT *EQ 'Y') THEN(DO)                     /*S01189*/
/**/                                                                  /*S01098*/
/*                      'BLOCK FILES'                       */        /*S01098*/
/**/                                                                  /*S01098*/
               OVRDBF FILE(REINUD) SEQONLY(*YES 100)                  /*S01098*/
               OVRDBF FILE(REINTD) SEQONLY(*YES 100)                  /*S01098*/
/**/                                                                  /*S01098*/
/*   REMOVE LOGICAL FILE OVER PHYSICAL BEFORE COPYING       */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
               RMVM       FILE(REINT) MBR(REINT)                      /*S01098*/
               MONMSG     MSGID(CPF0000)                              /*S01098*/
/**/                                                                  /*S01098*/
/*********     CLRPFM FILE(REINTA)                         **********  *S01098*/
/*********     CLRPFM FILE(REINTD)                         **********  *S01098*/
/*********     CLRPFM FILE(REINTZ)                         **********  *S01098*/
/**/                                                                  /*S01098*/
/*********     CPYF FROMFILE(REINUA) TOFILE(REINTA) MBROPT(*ADD) +***  *S01098*/
/*********       FMTOPT(*NOCHK)                                   ***  *S01098*/
               CPYF   FROMFILE(REINUA) TOFILE(REINTA) +
                      MBROPT(*REPLACE) FMTOPT(*NONE)                  /*S01098*/
               MONMSG (CPF2817) CMPDTA(CPF2869) +
                      EXEC(CLRPFM REINTA)                             /*S01098*/
/*********     CPYF FROMFILE(REINUZ) TOFILE(REINTZ) MBROPT(*ADD) +***  *S01098*/
/*********       FMTOPT(*NOCHK)                                   ***  *S01098*/
               CPYF   FROMFILE(REINUZ) TOFILE(REINTZ) +
                      MBROPT(*REPLACE) FMTOPT(*NONE)                  /*S01098*/
               MONMSG (CPF2817) CMPDTA(CPF2869) +
                      EXEC(CLRPFM REINTZ)                             /*S01098*/
/*********     CPYF FROMFILE(REINUD) TOFILE(REINTD) MBROPT(*ADD) +***  *S01098*/
/*********       FMTOPT(*NOCHK)                                   ***  *S01098*/
               CPYF   FROMFILE(REINUD) TOFILE(REINTD) +
                      MBROPT(*REPLACE) FMTOPT(*NONE)                  /*S01098*/
               MONMSG (CPF2817) CMPDTA(CPF2869) +
                      EXEC(CLRPFM REINTD)                             /*S01098*/
/**/                                                                  /*S01098*/
               DLTOVR FILE(REINUD)                                    /*S01098*/
               DLTOVR FILE(REINTD)                                    /*S01098*/
/**/                                                                  /*S01098*/
/*             ADDLFM     FILE(REINT) MBR(REINT) */        /*S01098*/ /*BHF982*/
               ADDLFM     FILE(REINT) MBR(REINT) SHARE(*YES)          /*BHF982*/
               MONMSG     MSGID(CPF0000)                              /*S01098*/
/**/                                                                  /*S01098*/
/**************ALCOBJ     ((RESTAT *DTAARA *EXCLRD))*/                /*S01189*/
/**************RTVDTAARA DTAARA(RESTAT *ALL) RTNVAR(&RESTAT)*/        /*S01189*/
/**************CHGVAR    VAR(%SST(&RESTAT 12 3)) VALUE('OLD')*/       /*S01189*/
/*             SNDDTAARA DTAARA(RESTAT)                    *S01179*/
/**************CHGDTAARA DTAARA(RESTAT)     VALUE(&RESTAT)/*S01179*/  /*S01189*/
/**************DLCOBJ    ((RESTAT *DTAARA *EXCLRD))*/                 /*S01189*/
               CHGVAR     VAR(&STAT) VALUE('N')                       /*S01189*/
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)         /*S01189*/
/**/
               CLRPFM FILE(REINUA)
               CLRPFM FILE(REINUD)
               CLRPFM FILE(REINUZ)
          ENDDO
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                  SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0640') TOMSGQ(MOPERQ)
               ENDDO
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
/***************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))            * *S01194*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT)
             ENDDO
               IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                  SNDPGMMSG MSG('DATABASE IN ERROR - RE0640') TOMSGQ(MOPERQ)
               ENDDO
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
