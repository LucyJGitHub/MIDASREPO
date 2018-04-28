/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Default retail accounts audit file')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                               */
/*                                                                   */
/*       REC86 - DEFAULT RETAIL ACCOUNTS AUDIT REPORT                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. S01408             DATE 10MAY95              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             DATE 10MAY95              */
/*                      S01413             DATE 13APR93              */
/*                      S01337                  17APR91              */
/*                      BHF982                  19FEB91              */
/*                      S01117                  16MAR90              */
/*                      S01194                  12MAR90              */
/*                      S01189                  12MAR90              */
/*                      S01179                  10OCT87              */
/*                      S01147                  30NOV87              */
/*                      S01098                  21JUL86              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       S01408 - Addition of core hook REC86MP1                     */
/*       S01413  -  Retail 3 Incorporation                           */
/*       S01337  -  SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRARIES   */
/*       BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                     */
/*       S01117  -  MULTIBRANCHING                                   */
/*       S01194  -  NEW STANDING DATA                                */
/*       S01189  -  COB recovery processing.                         */
/*       S01179  -  AS400 CONVERSION                                 */
/*       S01147  -  RELEASE 22                                       */
/*       S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,         */
/*                  INSTEAD OF CLEARING AND ADDING                   */
/*                                                                   */
/*********************************************************************/
/********    PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                   * *S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&TOLIB) TYPE(*CHAR) LEN(10)                  /*S01147*/
             DCL     VAR(&PRE) TYPE(*CHAR) LEN(2)                     /*S01147*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
/*           DCLDTAARA  DTAARA(LDA)   */                              /*S01179*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)                   /*S01179*/
/**/
             DCL     VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL     VAR(&PGM) TYPE(*CHAR) LEN(6)
/*           DCLDTAARA DTAARA(RESTAT)                   */            /*S01179*/
/********    DCL     VAR(&RESTAT) TYPE(*CHAR) LEN(256)     /*S01179*/ /*S01189*/
/*           DCLDTAARA DTAARA(SDSTAT)                   */  /*S01179*  *S01147*/
             DCL     VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                /*S01179*/
/*/COPY WNCPYSRC,REC86001                                            */
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
/********    RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)     /*S01179*/ /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/*           RCVDTAARA DTAARA(SDSTAT)                   */  /*S01179*  *S01147*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
/**/
             SNDPGMMSG MSG('REC86 - Default Retail Accounts Audit Report') +
                          TOMSGQ(MRUNQ)
/**/                                                                  /*S01147*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*S01147*/
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')   /*S01147 S01337*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01337*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC86MP1                                            */
                                                                      /*S01408*/
/**/
             CLRPFM FILE(REDEXAA)
             CLRPFM FILE(REDEXAB)
             CLRPFM FILE(REDEXAC)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
             CHGJOB SWS(10000000)
/*/COPY WNCPYSRC,REC86002                                            */
             CALL PGM(RE0560)
/*/COPY WNCPYSRC,REC86003                                            */
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
             CHGVAR VAR(&PGM) VALUE('RE0560')
             GOTO CMDLBL(ERROR)
             ENDDO
/**/
/********    IF COND(%SUBSTRING(&RESTAT 15 1) = 'N') THEN(DO)         /*S01189*/
             IF COND(&STAT *EQ 'N') THEN(DO)                          /*S01189*/
/********          ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))               /*S01189*/
               DLTF   FILE(XREDEFA)                                   /*S01147*/
               MONMSG MSGID(CPF0000)                                  /*S01147*/
               DLTF   FILE(XREDEFD)                                   /*S01147*/
               MONMSG MSGID(CPF0000)                                  /*S01147*/
               DLTF   FILE(XREDEFZ)                                   /*S01147*/
               MONMSG MSGID(CPF0000)                                  /*S01147*/
/*********         CLRPFM FILE(XREDEFA)                    **********  *S01098*/
/*********         CLRPFM FILE(XREDEFD)                    **********  *S01098*/
/*********         CLRPFM FILE(XREDEFZ)                    **********  *S01098*/
/**/                                                                  /*S01098*/
/*********CPYF FROMFILE(REDEFA) TOFILE(XREDEFA) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(REDEFA) TOFILE(XREDEFA) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01147*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XREDEFA)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*              CPYF      FROMFILE(REDEFA) TOFILE(XREDEFA.&TOLIB) +     S01179*/
                CPYF      FROMFILE(REDEFA) TOFILE(&TOLIB/XREDEFA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/*********CPYF FROMFILE(REDEFZ) TOFILE(XREDEFZ) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(REDEFZ) TOFILE(XREDEFZ) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01147*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XREDEFZ)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*              CPYF      FROMFILE(REDEFZ) TOFILE(XREDEFZ.&TOLIB) +     S01179*/
                CPYF      FROMFILE(REDEFZ) TOFILE(&TOLIB/XREDEFZ) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/**/                                                                  /*S01147*/
/*********CPYF FROMFILE(REDEFD) TOFILE(XREDEFD) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(REDEFD) TOFILE(XREDEFD) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01147*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XREDEFD)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*              CPYF      FROMFILE(REDEFD) TOFILE(XREDEFD.&TOLIB) +     S01179*/
                CPYF      FROMFILE(REDEFD) TOFILE(&TOLIB/XREDEFD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/********          CHGVAR VAR(%SUBSTRING(&RESTAT 15 1)) VALUE('Y')    /*S01189*/
/**/
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
/********          CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/ /*S01189*/
/********          DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))               /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE('Y')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
             ENDDO
/**/
             ELSE CMD(DO)
/**/                                                                  /*S01098*/
/*   REMOVE LOGICAL FILE OVER PHYSICALS BEFORE COPYING      */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
                   RMVM       FILE(REDEF) MBR(REDEF)                  /*S01098*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/
/*********         CLRPFM FILE(REDEFA)                     **********  *S01098*/
/*********         CLRPFM FILE(REDEFD)                     **********  *S01098*/
/*********         CLRPFM FILE(REDEFZ)                     **********  *S01098*/
/**/
/*********CPYF FROMFILE(XREDEFA) TOFILE(REDEFA) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
                   CPYF       FROMFILE(XREDEFA) TOFILE(REDEFA) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM REDEFA)                     /*S01098*/
/*********CPYF FROMFILE(XREDEFZ) TOFILE(REDEFZ) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/*********         MONMSG MSGID(CPF2817)                         ****  *S01098*/
                   CPYF       FROMFILE(XREDEFZ) TOFILE(REDEFZ) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM REDEFZ)                     /*S01098*/
/*********CPYF FROMFILE(XREDEFD) TOFILE(REDEFD) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
                   CPYF       FROMFILE(XREDEFD) TOFILE(REDEFD) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM REDEFD)                     /*S01098*/
/**/                                                                  /*S01098*/
/*                 ADDLFM     FILE(REDEF) MBR(REDEF) */    /*S01098*/ /*BHF982*/
                   ADDLFM     FILE(REDEF) MBR(REDEF) SHARE(*YES)      /*BHF982*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
             ENDDO
/**/
/************CALL PGM(RE0562)*/                                       /*S01117*/
             CALL PGM(RE0562) PARM('     ' 'ALL')                     /*S01117*/
/**/
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/********      ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))                   /*S01189*/
/********      CHGVAR VAR(%SST(&RESTAT 15 1)) VALUE('N')              /*S01189*/
/*             SNDDTAARA DTAARA(RESTAT)                    *S01179*/
/********      CHGDTAARA DTAARA(RESTAT)     VALUE(&RESTAT) /*S01179*/ /*S01189*/
/********      DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))                   /*S01189*/
               CHGVAR     VAR(&STAT) VALUE('N')                       /*S01189*/
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)         /*S01189*/
/*****         CLRPFM FILE(XREDEFA)                             *****  *S01147*/
/*****         CLRPFM FILE(XREDEFD)                             *****  *S01147*/
/*****         CLRPFM FILE(XREDEFZ)                             *****  *S01147*/
               DLTF   FILE(XREDEFA)                                   /*S01147*/
               MONMSG MSGID(CPF0000)                                  /*S01147*/
               DLTF   FILE(XREDEFD)                                   /*S01147*/
               MONMSG MSGID(CPF0000)                                  /*S01147*/
               DLTF   FILE(XREDEFZ)                                   /*S01147*/
               MONMSG MSGID(CPF0000)                                  /*S01147*/
             ENDDO
             ELSE CMD(DO)
               CHGVAR VAR(&PGM) VALUE('RE0562')
             ENDDO
/**/
             DLTOVR FILE(TABLE)
/**/
/*           E R R O R     M E S S A G E S                           */
/**/
ERROR:       IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
         /*     RCVDTAARA DTAARA(LDA)                         */      /*S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/***************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))            * *S01194*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/*********** IF COND(%SWITCH(XXXXXXX1)) THEN(DO)                      /*S01117*/
             IF COND(%SWITCH(XXXXXX01)) THEN(DO)                      /*S01117*/
/**********     CHGVAR     VAR(&MSG) VALUE('FILES OUT OF BALANCE - '****&PGM)        */ /*BG18886*/
                CHGVAR     VAR(&MSG) VALUE('FILES OUT OF BALANCE - ' *CAT &PGM)         /*BG18886*/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)             /*S01117*/
             ENDDO
/**/
             RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
