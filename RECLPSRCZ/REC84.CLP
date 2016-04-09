/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail ICD by currency audit report')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                               */
/*                                                                   */
/*       REC84 - RETAIL ICD BY CURRENCY AUDIT REPORT                 */
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
/*                      S01189                  20APR90              */
/*                      S01117                  17APR90              */
/*                      S01179                  10SEP88              */
/*                      S01147                  30NOV87              */
/*                      S01098                  21JUL86              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01408 - Addition of core hook REC84MP1                     */
/*       S01413  -  Retail 3 Incorporation                           */
/*       S01337  -  SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRARIES   */
/*       BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                     */
/*       S01189  -  COB recovery processing.                         */
/*       S01117  -  MULTIBRANCHING                                   */
/*       S01179  -  AS400 CONVERSION                                 */
/*       S01147  -  RELEASE 22                                       */
/*       S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,         */
/*                  INSTEAD OF CLEARING AND ADDING                   */
/*                                                                   */
/*********************************************************************/
/********    PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
/********    DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                 */ /*S01117*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01117*/
             DCL     VAR(&TOLIB) TYPE(*CHAR) LEN(10)                  /*S01147*/
             DCL     VAR(&PRE) TYPE(*CHAR) LEN(2)                     /*S01147*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
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
             SNDPGMMSG MSG('REC84 - Retail ICD By Currency Audit Report') +
                       TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(10000000)
/**/                                                                  /*S01147*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*S01147*/
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')   /*S01147 S01337*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01337*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC84MP1                                            */
                                                                      /*S01408*/
/**/
/********       IF COND(%SST(&RESTAT 15 1) = 'N') THEN(DO)            /*S01189*/
                IF COND(&STAT *EQ 'N') THEN(DO)                       /*S01189*/
/********          ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))               /*S01189*/
                   DLTF   FILE(XRECCYA)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XRECCYD)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XRECCYZ)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
/*********         CLRPFM FILE(XRECCYA)                    **********  *S01098*/
/*********         CLRPFM FILE(XRECCYD)                    **********  *S01098*/
/*********         CLRPFM FILE(XRECCYZ)                    **********  *S01098*/
/*********CPYF FROMFILE(RECCYA) TOFILE(XRECCYA) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(RECCYA) TOFILE(XRECCYA) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01147*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XRECCYA)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(RECCYA) TOFILE(XRECCYA.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(RECCYA) TOFILE(&TOLIB/XRECCYA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869)               /*S01147*/
/**/                                                                  /*S01147*/
/*********CPYF FROMFILE(RECCYZ) TOFILE(XRECCYZ) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(RECCYZ) TOFILE(XRECCYZ) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01147*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XRECCYZ)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(RECCYZ) TOFILE(XRECCYZ.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(RECCYZ) TOFILE(&TOLIB/XRECCYZ) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869)               /*S01147*/
/**/                                                                  /*S01147*/
/*********CPYF FROMFILE(RECCYD) TOFILE(XRECCYD) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF       FROMFILE(RECCYD) TOFILE(XRECCYD) +*****  *S01147*/
/*****                        MBROPT(*REPLACE) FMTOPT(*NONE)    *****  *S01098*/
/*****             MONMSG     (CPF2817) CMPDTA(CPF2869) +       *****  *S01147*/
/*****                        EXEC(CLRPFM XRECCYD)              *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(RECCYD) TOFILE(XRECCYD.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(RECCYD) TOFILE(&TOLIB/XRECCYD) +
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
                   RMVM       FILE(RECCY) MBR(RECCY)                  /*S01098*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
/*********         CLRPFM FILE(RECCYA)                     **********  *S01098*/
/*********         CLRPFM FILE(RECCYD)                     **********  *S01098*/
/*********         CLRPFM FILE(RECCYZ)                     **********  *S01098*/
/**/                                                                  /*S01098*/
/*********CPYF FROMFILE(XRECCYA) TOFILE(RECCYA) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
                   CPYF       FROMFILE(XRECCYA) TOFILE(RECCYA) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM RECCYA)                     /*S01098*/
/*********CPYF FROMFILE(XRECCYZ) TOFILE(RECCYZ) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
/*********         MONMSG MSGID(CPF2817)                         ****  *S01098*/
                   CPYF       FROMFILE(XRECCYZ) TOFILE(RECCYZ) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM RECCYZ)                     /*S01098*/
/*********CPYF FROMFILE(XRECCYD) TOFILE(RECCYD) MBROPT(*ADD)   + ****  *S01098*/
/*********              FMTOPT(*NOCHK)                           ****  *S01098*/
                   CPYF       FROMFILE(XRECCYD) TOFILE(RECCYD) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01098*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM RECCYD)                     /*S01098*/
/**/                                                                  /*S01098*/
/*                 ADDLFM     FILE(RECCY) MBR(RECCY) */    /*S01098*/ /*BHF982*/
                   ADDLFM     FILE(RECCY) MBR(RECCY) SHARE(*YES)      /*BHF982*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
                ENDDO
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/**/
/*********** CALL PGM(RE0540)                                         /*S01117*/
             CALL PGM(RE0540)   PARM('     ')                         /*S01117*/
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
/*****             CLRPFM FILE(XRECCYA)                         *****  *S01147*/
/*****             CLRPFM FILE(XRECCYD)                         *****  *S01147*/
/*****             CLRPFM FILE(XRECCYZ)                         *****  *S01147*/
                   DLTF   FILE(XRECCYA)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XRECCYD)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                   DLTF   FILE(XRECCYZ)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
                ENDDO
/**/
                ELSE CMD(DO)
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                  SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0540') TOMSGQ(MOPERQ)
                ENDDO
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
         /*     RCVDTAARA DTAARA(LDA)                         */      /*S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/********       CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))        */   /*S01117*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01117*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
                ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
