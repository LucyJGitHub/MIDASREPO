/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Interest sub-types audit report')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                               */
/*                                                                   */
/*       REC81 - INTEREST SUB-TYPES AUDIT REPORT                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 10MAY95              */
/*       PREV AMEND NO. S01413             DATE 13APR93              */
/*                      S01337                  17APR91              */
/*                      BHF982                  19FEB91              */
/*                      S01117                  16MAR90              */
/*                      S01194                  12MAR90              */
/*                      S01189                  12MAR90              */
/*                      S01179                  10SEP88              */
/*                      S01147                  30NOV87              */
/*                      S01098                  21JUL86              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01408 - Addition of core hook REC81MPS                     */
/*       S01413 - Retail 3 Incorporation                             */
/*       S01337 - Split 'D' library into 'DP' and 'DV' libraries     */
/*       BHF982 - ADDLFM should be SHARE(*YES)                       */
/*       S01117 - Multibranching                                     */
/*       S01194 - New Standing Data                                  */
/*       S01189 - COB recovery processing.                           */
/*       S01179 - AS400 CONVERSION                                   */
/*       S01147 - Release 22                                         */
/*       S01098 - Amendment replaces date in copied files,           */
/*                Instead of clearing and adding                     */
/*                                                                   */
/*********************************************************************/
/********    PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*           DCLDTAARA  DTAARA(LDA)                        */         /*S01179*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)                   /*S01179*/
/************DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                   * *S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&TOLIB) TYPE(*CHAR) LEN(10)                  /*S01147*/
             DCL     VAR(&PRE) TYPE(*CHAR) LEN(2)                     /*S01147*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
/**/
/**/
/*           DCLDTAARA DTAARA(RESTAT)                     */          /*S01179*/
/********    DCL     VAR(&RESTAT) TYPE(*CHAR) LEN(256)     /*S01179*/ /*S01189*/
/*           DCLDTAARA DTAARA(SDSTAT)                     *  *S01179*  *S01147*/
             DCL     VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                /*S01179*/
/*           RCVDTAARA DTAARA(RESTAT)                                   S01179*/
/********    RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)     /*S01179*/ /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/*           RCVDTAARA DTAARA(SDSTAT)             */        /*S01179*  *S01147*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT) /*S01147*/     /*S01179*/
/**/
             SNDPGMMSG MSG('REC81 - Interest Sub-Types Audit Report') +
                       TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(10000000)
/**/                                                                  /*S01147*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*S01147*/
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')   /*S01147 S01337*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01337*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC81MPS                                            */
                                                                      /*S01408*/
/**/
/********       IF COND(%SST(&RESTAT 15 1) = 'N') THEN(DO)            /*S01189*/
             IF         COND(&STAT *EQ 'N') THEN(DO)                  /*S01189*/
/********          ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))               /*S01189*/
                   DLTF   FILE(XREINTA)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XREINTD)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XREINTZ)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
/*********         CLRPFM FILE(XREINTA)                    **********  *S01098*/
/*********         CLRPFM FILE(XREINTD)                    **********  *S01098*/
/*********         CLRPFM FILE(XREINTZ)                    **********  *S01098*/
/**/                                                                  /*S01098*/
/*********CPYF FROMFILE(REINTA) TOFILE(XREINTA) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(REINTA) TOFILE(XREINTA) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01147*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XREINTA)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(REINTA) TOFILE(XREINTA.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(REINTA) TOFILE(&TOLIB/XREINTA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869)               /*S01147*/
/**/                                                                  /*S01147*/
/*********CPYF FROMFILE(REINTZ) TOFILE(XREINTZ) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/*********         MONMSG MSGID(CPF2817)                         ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(REINTZ) TOFILE(XREINTZ) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01147*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XREINTZ)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(REINTZ) TOFILE(XREINTZ.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(REINTZ) TOFILE(&TOLIB/XREINTZ) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869)               /*S01147*/
/**/                                                                  /*S01147*/
/*********CPYF FROMFILE(REINTD) TOFILE(XREINTD) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(REINTD) TOFILE(XREINTD) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01147*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XREINTD)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(REINTD) TOFILE(XREINTD.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(REINTD) TOFILE(&TOLIB/XREINTD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869)               /*S01147*/
/**/                                                                  /*S01098*/
/********          CHGVAR VAR(%SST(&RESTAT 15 1)) VALUE('Y')          /*S01189*/
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
/********          CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/ /*S01189*/
/********          DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))               /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE('Y')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
                ENDDO
/**/
                ELSE CMD(DO)
/*********         CLRPFM FILE(REINTA)                     **********  *S01098*/
/*********         CLRPFM FILE(REINTD)                     **********  *S01098*/
/*********         CLRPFM FILE(REINTZ)                     **********  *S01098*/
/**/                                                                  /*S01098*/
/*   REMOVE LOGICAL FILES OVER PHYSICALS BEFORE COPYING     */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
                   RMVM       FILE(REINT) MBR(REINT)                  /*S01098*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
/********* CPYF FROMFILE(XREINTA) TOFILE(REINTA) MBROPT(*ADD)   + ***  *S01098*/
/*********              FMTOPT(*NOCHK)                            ***  *S01098*/
                   CPYF       FROMFILE(XREINTA) TOFILE(REINTA) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM REINTA)                     /*S01098*/
/********* CPYF FROMFILE(XREINTZ) TOFILE(REINTZ) MBROPT(*ADD)   + ***  *S01098*/
/*********              FMTOPT(*NOCHK)                            ***  *S01098*/
/*********         MONMSG MSGID(CPF2817)                          ***  *S01098*/
                   CPYF       FROMFILE(XREINTZ) TOFILE(REINTZ) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM REINTZ)                     /*S01098*/
/********* CPYF FROMFILE(XREINTD) TOFILE(REINTD) MBROPT(*ADD)   + ***  *S01098*/
/*********              FMTOPT(*NOCHK)                            ***  *S01098*/
                   CPYF       FROMFILE(XREINTD) TOFILE(REINTD) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM REINTD)                     /*S01098*/
/**/                                                                  /*S01098*/
/*                 ADDLFM     FILE(REINT) MBR(REINT) */    /*S01098*/ /*BHF982*/
                   ADDLFM     FILE(REINT) MBR(REINT) SHARE(*YES)      /*BHF982*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
                ENDDO
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/**/
/*********** CALL PGM(RE0510)                                         /*S01117*/
             CALL PGM(RE0510) PARM('     ')                           /*S01117*/
/**/
             DLTOVR FILE(TABLE)
/**/
                IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/********          ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))               /*S01189*/
/********          CHGVAR VAR(%SST(&RESTAT 15 1)) VALUE('N')          /*S01189*/
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
/********          CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/ /*S01189*/
/********          DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))               /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE('N')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
/*****             CLRPFM FILE(XREINTA)                         *****  *S01147*/
/*****             CLRPFM FILE(XREINTD)                         *****  *S01147*/
/*****             CLRPFM FILE(XREINTZ)                         *****  *S01147*/
                   DLTF   FILE(XREINTA)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XREINTD)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XREINTZ)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                ENDDO
/**/
                ELSE CMD(DO)
 /***********   IF COND(%SWITCH(XXXXXXX1)) THEN(DO)                   /*S01117*/
                IF COND(%SWITCH(XXXXXX01)) THEN(DO)                   /*S01117*/
                  SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0510') TOMSGQ(MOPERQ)
                ENDDO
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
 /*             RCVDTAARA DTAARA(LDA)                    */          /*S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                     /*S01179*/
/***************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))           * *S01194*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
                ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
