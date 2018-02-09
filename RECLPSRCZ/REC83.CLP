/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail charges audit report')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                               */
/*                                                                   */
/*       REC83 - RETAIL CHARGES AUDIT REPORT                         */
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
/*       Prev Amend No. S01408             Date 10May95              */
/*                      S01413             Date 13Apr93              */
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
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook REC83MP1                     */
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
                          Finastra International Limited +
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
/*           DCLDTAARA DTAARA(RESTAT)                   */            /*S01179*/
/********    DCL     VAR(&RESTAT) TYPE(*CHAR) LEN(256)     /*S01179*/ /*S01189*/
/*           DCLDTAARA DTAARA(SDSTAT)                   */  /*S01179*  *S01147*/
             DCL     VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                /*S01179*/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
/********    RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)     /*S01179*/ /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/*           RCVDTAARA DTAARA(SDSTAT)                   */  /*S01179*  *S01147*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
/**/
             SNDPGMMSG MSG('REC83 - Retail Charges Audit Report') +
                       TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(10000000)
/**/                                                                  /*S01147*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*S01147*/
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')   /*S01147 S01337*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01337*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC83MP1                                            */
                                                                      /*S01408*/
/**/
/**/
/********       IF COND(%SST(&RESTAT 15 1) = 'N') THEN(DO)            /*S01189*/
                IF COND(&STAT *EQ 'N') THEN(DO)                       /*S01189*/
/********          ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))               /*S01189*/
                   DLTF   FILE(XRECRGA)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XRECRGD)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XRECRGZ)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
/*********         CLRPFM FILE(XRECRGA)                    **********  *S01098*/
/*********         CLRPFM FILE(XRECRGD)                    **********  *S01098*/
/*********         CLRPFM FILE(XRECRGZ)                    **********  *S01098*/
/*********CPYF FROMFILE(RECRGA) TOFILE(XRECRGA) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(RECRGA) TOFILE(XRECRGA) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01147*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XRECRGA)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(RECRGA) TOFILE(XRECRGA.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(RECRGA) TOFILE(&TOLIB/XRECRGA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869)
/**/                                                                  /*S01147*/
/*********CPYF FROMFILE(RECRGZ) TOFILE(XRECRGZ) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(RECRGZ) TOFILE(XRECRGZ) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01147*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XRECRGZ)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(RECRGZ) TOFILE(XRECRGZ.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(RECRGZ) TOFILE(&TOLIB/XRECRGZ) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869)               /*S01147*/
/**/                                                                  /*S01147*/
/*********CPYF FROMFILE(RECRGD) TOFILE(XRECRGD) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(RECRGD) TOFILE(XRECRGD) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01147*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XRECRGD)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(RECRGD) TOFILE(XRECRGD.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(RECRGD) TOFILE(&TOLIB/XRECRGD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869)               /*S01147*/
/**/                                                                  /*S01147*/
/********          CHGVAR VAR(%SST(&RESTAT 15 1)) VALUE('Y')          /*S01189*/
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
                   RMVM       FILE(RECRG) MBR(RECRG)                  /*S01098*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
/*********         CLRPFM FILE(RECRGA)                     **********  *S01098*/
/*********         CLRPFM FILE(RECRGD)                     **********  *S01098*/
/*********         CLRPFM FILE(RECRGZ)                     **********  *S01098*/
/**/                                                                  /*S01098*/
/*********CPYF FROMFILE(XRECRGA) TOFILE(RECRGA) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
                   CPYF       FROMFILE(XRECRGA) TOFILE(RECRGA) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM RECRGA)                     /*S01098*/
/*********CPYF FROMFILE(XRECRGZ) TOFILE(RECRGZ) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/*********         MONMSG MSGID(CPF2817)                         ****  *S01098*/
                   CPYF       FROMFILE(XRECRGZ) TOFILE(RECRGZ) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM RECRGZ)                     /*S01098*/
/*********CPYF FROMFILE(XRECRGD) TOFILE(RECRGD) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
                   CPYF       FROMFILE(XRECRGD) TOFILE(RECRGD) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM RECRGD)                     /*S01098*/
/**/                                                                  /*S01098*/
/*                 ADDLFM     FILE(RECRG) MBR(RECRG) */    /*S01098*/ /*BHF982*/
                   ADDLFM     FILE(RECRG) MBR(RECRG) SHARE(*YES)      /*BHF982*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
                ENDDO
/**/
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/**/
/*********** CALL PGM(RE0530)                                         /*S01117*/
             CALL PGM(RE0530)   PARM('     ')                         /*S01117*/
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
/*****             CLRPFM FILE(XRECRGA)                         *****  *S01147*/
/*****             CLRPFM FILE(XRECRGD)                         *****  *S01147*/
/*****             CLRPFM FILE(XRECRGZ)                         *****  *S01147*/
                   DLTF   FILE(XRECRGA)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XRECRGD)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XRECRGZ)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                ENDDO
/**/
                ELSE CMD(DO)
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                  SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0530') TOMSGQ(MOPERQ)
                ENDDO
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
         /*     RCVDTAARA DTAARA(LDA)                         */      /*S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/***************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))            * *S01194*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
                ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
