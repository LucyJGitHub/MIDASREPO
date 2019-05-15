/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Retail II file reorganisations')             */
/********************************************************************/
/*                                                                  */
/*        Midas - Retail Module                             */
/*                                                                  */
/*     REC90  -  RETAIL II FILE REORGANISATIONS                     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD030959           Date 17Jun15              */
/*                      AR1097467          Date 01Apr13              */
/*                      BUG27667           Date 14May10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CAP187             Date 21Aug09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      117321             Date 26Feb98              */
/*                      S01408             Date 17Apr96              */
/*                    S01408             DATE  06SEP95              */
/*                    S01408             DATE  10MAY95              */
/*                    S01408             DATE  08MAR95              */
/*                    S01337             DATE  17APR91              */
/*                    BHF982             DATE  19FEB91              */
/*                    S01117             DATE  16MAR90              */
/*                    S01187             DATE  11/01/89             */
/*                    S01179             DATE  10/09/88             */
/*                    S01147             DATE  03/12/87             */
/*                    E10615             DATE  24/10/87             */
/*                    S01098             DATE  21/07/86             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     MD030959 - Recompiled due to changed PF/HELDIHC.              */
/*     AR1097467 - Expected 15% COB run optimization not met        */
/*     BUG27667 - Incorrect computation of held amount.             */
/*                Add error recovery processing for ACCNTAB.        */
/*     CAP187 - Document Linkage (Recompile)                         */
/*     CER001 - LUX Upgrade to MidasPlus                             */
/*     117321 - Remove the reference to removed LF HELDI            */
/*              Also, slight change to avoid CCSID problems.        */
/*     S01408 - Core Hook Added - REC90005                          */
/*     S01408 - Core Hook Added - REC90001                          */
/*            - Core Hook Added - REC90002                          */
/*            - Core Hook Added - REC90003                          */
/*            - Core Hook Added - REC90004                          */
/*     S01408 - Core Hook Added - REC90MP2                          */
/*            - Core Hook Added - REC90MP1                          */
/*            - Core Hook Added - REC90INT                          */
/*     S01408 - Core Hook Added - REC90MPS                          */
/*     S01337  -  SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRARIES    */
/*                                                                  */
/*     BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                      */
/*                                                                  */
/*     S01117  -  MULTIBRANCHING                                    */
/*                                                                  */
/*     S01187  -  RELEASE 1 TEST FIX (ERROR DURING AS400 CONVERSION)*/
/*                                                                  */
/*     S01179  -  AS400 CONVERSION                                  */
/*                                                                  */
/*     S01147  -  RELEASE 22                                        */
/*                                                                  */
/*     E10615  -  REC90 TO BE RUN WITH NEW PARAMETER IN ORDER       *  *E10615*/
/*                TO CLEAR DELETED RECORDS FROM REIAC FILE.         *  *E10615*/
/*                                                                  */
/*     S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,          *  *S01098*/
/*                INSTEAD OF CLEARING AND ADDING                    *  *S01098*/
/*                FROM AND TO FILES ARE NOW 'BLOCKED'               *  *S01098*/
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&STAT)
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,REC90INT                                             /*S01408*/
/* */                                                                 /*S01408*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL VAR(&STAT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)               /*E10615*/
             DCL        VAR(&PRE)   TYPE(*CHAR) LEN(2)                /*E10615*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CER001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CER001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CER001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CER001*/
             DCL        VAR(&ULX043) TYPE(*CHAR) LEN(1)                                   /*CER001*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*BUG27667*/
             DCL        VAR(&CMTTXT) TYPE(*CHAR) LEN(460)                               /*BUG27667*/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(3)                                   /*BUG27667*/
             DCL        VAR(&WSTI) TYPE(*CHAR) LEN(10)                                  /*BUG27667*/
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)                                 /*BUG27667*/
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)                                   /*BUG27667*/
             DCL        VAR(&BLNK327) TYPE(*CHAR) LEN(327) +
                        VALUE(' ')                                                      /*BUG27667*/
/*/COPY WNCPYSRC,REC90010                                            */
/**/
/*           DCLDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             DCL     VAR(&RESTAT) TYPE(*CHAR) LEN(256)                /*S01179*/
/*           DCLDTAARA DTAARA(SDSTAT)                   */  /*S01179*  *S01147*/
             DCL     VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                /*S01179*/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
/*           RCVDTAARA DTAARA(SDSTAT)                   */  /*S01179*  *S01147*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
/**/
             SNDPGMMSG MSG('REC90 - Retail II File Reorganisations') +
                       TOMSGQ(MRUNQ)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/**/                                                                  /*E10615*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*E10615*/
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')   /*S01147 S01337*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01337*/
                                                                      /*S01408*/
             CHGVAR     VAR(&SAR) VALUE('ULX043')                                         /*CER001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CER001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CER001*/
             CHGVAR     VAR(&ULX043) VALUE('N')                                           /*CER001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CER001*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                        VAR(&ULX043) VALUE('Y'))                                          /*CER001*/
                                                                                          /*CER001*/
             RTVJOBA    JOB(&JOB) USER(&USRID)                                          /*BUG27667*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)                                     /*BUG27667*/
             CHGVAR     VAR(&WSID) VALUE(&JOB)                                          /*BUG27667*/
             CHGVAR     VAR(&WSTI) VALUE(&JOB)                                          /*BUG27667*/
                                                                                        /*BUG27667*/
/*/COPY WNCPYSRC,REC90MP2                                            */
                                                                      /*S01408*/
/**/
             IF COND(&STAT = 'FIRST')  THEN(DO)
/**/
              IF COND(%SST(&RESTAT 8 1) = 'N') THEN(DO)
/**/
                ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/**/
                CLRPFM FILE(STOPOSC)
                CLRPFM FILE(STOPOSD)
                CLRPFM FILE(STOPOSE)
/**/
                CALL PGM(RE0910)
/**/
/***********    IF COND(%SWITCH(XXXXXXX0)) THEN(DO)                   /*S01117*/
                IF COND(%SWITCH(XXXXXX00)) THEN(DO)                   /*S01117*/
                   CHGVAR VAR(%SST(&RESTAT 8 1)) VALUE('Y')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                ENDDO
/**/
                DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/**/
              ENDDO
/**/
/***********  IF COND(%SWITCH(XXXXXXX0)) THEN(DO)                     /*S01117*/
              IF COND(%SWITCH(XXXXXX00)) THEN(DO)                     /*S01117*/
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
/**/
                IF COND(%SST(&RESTAT 8 1) = 'Y') THEN(DO)
/**/
                   ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/**/
/*********         CLRPFM FILE(STOPCSC)                    **********  *S01098*/
/*********         CLRPFM FILE(STOPCSD)                    **********  *S01098*/
/*********         CLRPFM FILE(STOPCSE)                    **********  *S01098*/
/**/
/*   REMOVE LOGICAL FILE OVER PHYSICALS BEFORE COPYING      */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
                   RMVM       FILE(STOPC) MBR(STOPC)                  /*S01098*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
/*********   CPYF FROMFILE(STOPOSC) TOFILE(STOPCSC) MBROPT(*ADD) + **  *S01098*/
/*********              FMTOPT(*NOCHK)                             **  *S01098*/
                   CPYF   FROMFILE(STOPOSC) TOFILE(STOPCSC) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01098*/
                   MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM STOPCSC)                        /*S01098*/
/*********   CPYF FROMFILE(STOPOSE) TOFILE(STOPCSE) MBROPT(*ADD) + **  *S01098*/
/*********              FMTOPT(*NOCHK)                             **  *S01098*/
                   CPYF   FROMFILE(STOPOSE) TOFILE(STOPCSE) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01098*/
                   MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM STOPCSE)                        /*S01098*/
/*********   CPYF FROMFILE(STOPOSD) TOFILE(STOPCSD) MBROPT(*ADD) + **  *S01098*/
/*********              FMTOPT(*NOCHK)                             **  *S01098*/
                   CPYF   FROMFILE(STOPOSD) TOFILE(STOPCSD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01098*/
                   MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM STOPCSD)                        /*S01098*/
/**/
/*                 ADDLFM     FILE(STOPC) MBR(STOPC) */    /*S01098*/ /*BHF982*/
                   ADDLFM     FILE(STOPC) MBR(STOPC) SHARE(*YES)      /*BHF982*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
                   CHGVAR VAR(%SST(&RESTAT 8 1)) VALUE('N')
/**/
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
/**/
                   DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/**/
                ENDDO
/**/
              ENDDO
/**/
              ELSE CMD(DO)
              CHGVAR VAR(&PGM) VALUE('RE0910')
              GOTO CMDLBL(ERROR)
              ENDDO
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
/**/
              IF COND(%SST(&RESTAT 9 1) = 'N') THEN(DO)
/**/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                                /*BUG27667*/
             MONMSG     MSGID(CPF8351 CPF9257)                                          /*BUG27667*/
                                                                                        /*BUG27667*/
                ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/**/
                CLRPFM FILE(HELDOHA)
                CLRPFM FILE(HELDOHB)
                CLRPFM FILE(HELDOHC)
/**/
                CALL PGM(RE0920)
/**/
/***********    IF COND(%SWITCH(XXXXXXX0)) THEN(DO)                   /*S01117*/
                IF COND(%SWITCH(XXXXXX00)) THEN(DO)                   /*S01117*/
                   CHGVAR VAR(%SST(&RESTAT 9 1)) VALUE('Y')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                ENDDO
/**/
                DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/**/
              ENDDO
/**/
/***********  IF COND(%SWITCH(XXXXXXX0)) THEN(DO)                     /*S01117*/
              IF COND(%SWITCH(XXXXXX00)) THEN(DO)                     /*S01117*/
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
/**/
                IF COND(%SST(&RESTAT 9 1) = 'Y') THEN(DO)
/**/
                   ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/**/
/*********         CLRPFM FILE(HELDIHA)                    **********  *S01098*/
/*********         CLRPFM FILE(HELDIHB)                    **********  *S01098*/
/*********         CLRPFM FILE(HELDIHC)                    **********  *S01098*/
/**/
/****REMOVE*LOGICAL*FILE*OVER*PHYSICALS*BEFORE*COPYING***/ /*S01098*/ /*117321*/
/*******************AND*REPLACE*AFTER********************/ /*S01098*/ /*117321*/
/**/                                                                  /*S01098*/
/***********       RMVMSG     FILE(HELDI) MBR(HELDI)       /*S01098*/ /*117321*/
/***********       MONMSG     MSGID(CPF0000)               /*S01098*/ /*117321*/
/**/                                                                  /*S01098*/
/*********   CPYF FROMFILE(HELDOHA) TOFILE(HELDIHA) MBROPT(*ADD) + **  *S01098*/
/*********              FMTOPT(*NOCHK)                             **  *S01098*/
                   CPYF   FROMFILE(HELDOHA) TOFILE(HELDIHA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01098*/
                   MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM HELDIHA)                        /*S01098*/
/*********   CPYF FROMFILE(HELDOHC) TOFILE(HELDIHC) MBROPT(*ADD) + **  *S01098*/
/*********              FMTOPT(*NOCHK)                             **  *S01098*/
                   CPYF   FROMFILE(HELDOHC) TOFILE(HELDIHC) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01098*/
                   MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM HELDIHC)                        /*S01098*/
/*********   CPYF FROMFILE(HELDOHB) TOFILE(HELDIHB) MBROPT(*ADD) + **  *S01098*/
/*********              FMTOPT(*NOCHK)                             **  *S01098*/
                   CPYF   FROMFILE(HELDOHB) TOFILE(HELDIHB) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01098*/
                   MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM HELDIHB)                        /*S01098*/
/**/
/***********       ADDLFM     FILE(HELDI) MBR(HELDI) */    /*S01098*/ /*BHF982*/
/*********** ADDLFM     FILE(HELDI) MBR(HELDI) SHARE(*YES) /*BHF982*/ /*117321*/
/***********       MONMSG     MSGID(CPF0000)               /*S01098*/ /*117321*/
/**/                                                                  /*S01098*/
/*/COPY WNCPYSRC,REC90005                                             /*S01408*/
/* */                                                                 /*S01408*/
                   CHGVAR VAR(%SST(&RESTAT 9 1)) VALUE('N')
/**/
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
/**/
                   DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
             CHGVAR     VAR(&CMTTXT) VALUE('       REC90   ' *CAT +
                          &WSID *CAT &TIME *CAT ' ' *CAT &USRID +
                          *CAT '               MIDAS Retail File +
                          Reorganisation - No committed +
                          transactions for this job' *CAT &BLNK327 +
                          *CAT &WSTI)                                                   /*BUG27667*/
             COMMIT     CMTID(&CMTTXT)                                                  /*BUG27667*/
/**/
                ENDDO
/**/
              ENDDO
/**/
              ELSE CMD(DO)
              CHGVAR VAR(&PGM) VALUE('RE0920')
              ROLLBACK                                                                  /*BUG27667*/
              GOTO CMDLBL(ERROR)
              ENDDO
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
/**/
              IF COND(%SST(&RESTAT 10 1) = 'N') THEN(DO)
/**/
                ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/**/
                CLRPFM FILE(STNDOSA)
                CLRPFM FILE(STNDOSB)
/*/COPY WNCPYSRC,REC90011                                            */
                CLRPFM FILE(STNDOSC)
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,REC90001                                             /*S01408*/
                IF      COND(&ULX043 *EQ 'Y') THEN(DO)                                    /*CER001*/
                        CLRPFM FILE(RESOX2PD)                                             /*CER001*/
                        MONMSG MSGID(CPF0000)                                             /*CER001*/
                ENDDO                                                                     /*CER001*/
/* */                                                                 /*S01408*/
/**/
                CALL PGM(RE0930)
/**/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,REC90MP1                                             /*S01408*/
/* */                                                                 /*S01408*/
/***********    IF COND(%SWITCH(XXXXXXX0)) THEN(DO)                   /*S01117*/
                IF COND(%SWITCH(XXXXXX00)) THEN(DO)                   /*S01117*/
                   CHGVAR VAR(%SST(&RESTAT 10 1)) VALUE('Y')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                ENDDO
/**/
                DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/**/
              ENDDO
/**/
/***********  IF COND(%SWITCH(XXXXXXX0)) THEN(DO)                     /*S01117*/
              IF COND(%SWITCH(XXXXXX00)) THEN(DO)                     /*S01117*/
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
/**/
                IF COND(%SST(&RESTAT 10 1) = 'Y') THEN(DO)
/**/
                   ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/**/
/*********         CLRPFM FILE(STANDSA)                    **********  *S01098*/
/*********         CLRPFM FILE(STANDSB)                    **********  *S01098*/
/*********         CLRPFM FILE(STANDSC)                    **********  *S01098*/
/**/
/*                      'BLOCK FILES'                       */        /*S01098*/
/**/                                                                  /*S01098*/
                   OVRDBF FILE(STANDSB) SEQONLY(*YES 100)             /*S01098*/
/*/COPY WNCPYSRC,REC90012                                            */
                   OVRDBF FILE(STNDOSB) SEQONLY(*YES 100)             /*S01098*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,REC90002                                             /*S01408*/
                IF      COND(&ULX043 *EQ 'Y') THEN(DO)                                    /*CER001*/
                        OVRDBF FILE(RESOX2PD) SEQONLY(*YES 100)                           /*CER001*/
                        MONMSG MSGID(CPF0000)                                             /*CER001*/
                ENDDO                                                                     /*CER001*/
/* */                                                                 /*S01408*/
/**/                                                                  /*S01098*/
/*   REMOVE LOGICAL FILE OVER PHYSICALS BEFORE COPYING      */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
                   RMVM       FILE(STAND) MBR(STAND)                  /*S01098*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
/*********   CPYF FROMFILE(STNDOSA) TOFILE(STANDSA) MBROPT(*ADD) + **  *S01098*/
/*********              FMTOPT(*NOCHK)                             **  *S01098*/
                   CPYF   FROMFILE(STNDOSA) TOFILE(STANDSA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01098*/
                   MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM STANDSA)                        /*S01098*/
/*********   CPYF FROMFILE(STNDOSC) TOFILE(STANDSC) MBROPT(*ADD) + **  *S01098*/
/*********              FMTOPT(*NOCHK)                             **  *S01098*/
                   CPYF   FROMFILE(STNDOSC) TOFILE(STANDSC) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01098*/
                   MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM STANDSC)                        /*S01098*/
/*/COPY WNCPYSRC,REC90013                                            */
/*********   CPYF FROMFILE(STNDOSB) TOFILE(STANDSB) MBROPT(*ADD) + **  *S01098*/
/*********              FMTOPT(*NOCHK)                             **  *S01098*/
                   CPYF   FROMFILE(STNDOSB) TOFILE(STANDSB) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01098*/
                   MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM STANDSB)                        /*S01098*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,REC90003                                             /*S01408*/
                IF      COND(&ULX043 *EQ 'Y') THEN(DO)                                    /*CER001*/
                        CPYF FROMFILE(RESOX2PD) TOFILE(RESOX1PD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                                  /*CER001*/
                        MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM RESOX1PD)                                           /*CER001*/
                ENDDO                                                                     /*CER001*/
/* */                                                                 /*S01408*/
/**/                                                                  /*S01098*/
/*                 ADDLFM     FILE(STAND) MBR(STAND) */    /*S01098*/ /*BHF982*/
                   ADDLFM     FILE(STAND) MBR(STAND) SHARE(*YES)      /*BHF982*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
                   DLTOVR FILE(STANDSB)                               /*S01098*/
/*/COPY WNCPYSRC,REC90014                                            */
                   DLTOVR FILE(STNDOSB)                               /*S01098*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,REC90004                                             /*S01408*/
                IF      COND(&ULX043 *EQ 'Y') THEN(DO)                                    /*CER001*/
                        DLTOVR FILE(RESOX2PD)                                             /*CER001*/
                        MONMSG MSGID(CPF0000)                                             /*CER001*/
                ENDDO                                                                     /*CER001*/
/* */                                                                 /*S01408*/
/**/
                   CHGVAR VAR(%SST(&RESTAT 10 1)) VALUE('N')
/**/
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
/**/
                   DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/**/
                ENDDO
/**/
              ENDDO
/**/
              ELSE CMD(DO)
              CHGVAR VAR(&PGM) VALUE('RE0930')
              GOTO CMDLBL(ERROR)
              ENDDO
/**/
             ENDDO
/**/
/*/COPY WNCPYSRC,REC90MPS                                    /*S01408*/
/**/
/**/
             DLTOVR FILE(TABLE)
/**/
             IF COND(&STAT = 'REDEF')  THEN(DO)
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                IF COND(%SUBSTRING(&RESTAT 12 3) = 'OLD') THEN(DO)
                   DLTF   FILE(XREDEFD)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
/*********         CLRPFM FILE(XREDEFD)                    **********  *S01098*/
/**/                                                                  /*S01098*/
/*********   CPYF FROMFILE(REDEFD) TOFILE(XREDEFD) MBROPT(*ADD) + ***  *S01098*/
/*********                 FMTOPT(*NOCHK)                         ***  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF   FROMFILE(REDEFD) TOFILE(XREDEFD) +    *****  *S01147*/
/*****                    MBROPT(*REPLACE) FMTOPT(*NONE)        *****  *S01147*/
/*****             MONMSG (CPF2817) CMPDTA(CPF2869) +           *****  *S01147*/
/*****                    EXEC(CLRPFM XREDEFD)                  *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(REDEFD) TOFILE(XREDEFD.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(REDEFD) TOFILE(&TOLIB/XREDEFD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                              FMTOPT(*NONE)                           /*S01147*/
                   MONMSG (CPF2817) CMPDTA(CPF2869)                   /*S01147*/
/**/
                   ALCOBJ     ((RESTAT *DTAARA *EXCLRD))
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                   CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('NEW')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                   DLCOBJ     ((RESTAT *DTAARA *EXCLRD))
                ENDDO
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
/**/
                IF COND(%SUBSTRING(&RESTAT 12 3) = 'NEW') THEN(DO)
                      ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/*********            CLRPFM FILE(REDEFD)                  **********  *S01098*/
/**/                                                                  /*S01098*/
/*   REMOVE LOGICAL FILE OVER PHYSICALS BEFORE COPYING      */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
                   RMVM       FILE(REDEF) MBR(REDEF)                  /*S01098*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
/*********   CPYF FROMFILE(XREDEFD) TOFILE(REDEFD) MBROPT(*ADD) + ***  *S01098*/
/*********                INCCHAR(RECI 1 *NE *) FMTOPT(*NOCHK)    ***  *S01098*/
                   CPYF   FROMFILE(XREDEFD) TOFILE(REDEFD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *NE *) +
                          FMTOPT(*NONE)                               /*S01098*/
                   MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM REDEFD)                         /*S01098*/
/**/                                                                  /*S01098*/
/*                 ADDLFM     FILE(REDEF) MBR(REDEF) */    /*S01098*/ /*BHF982*/
                   ADDLFM     FILE(REDEF) MBR(REDEF) SHARE(*YES)      /*BHF982*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                   CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('OLD')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                   DLCOBJ     ((RESTAT *DTAARA *EXCLRD))
/**/
                   CLRPFM FILE(XREDEFD)
                ENDDO
             ENDDO
/**/
             IF COND(&STAT = 'RECCY')  THEN(DO)
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                IF COND(%SUBSTRING(&RESTAT 12 3) = 'OLD') THEN(DO)
                   DLTF   FILE(XRECCYD)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
/*********         CLRPFM FILE(XRECCYD)                    **********  *S01098*/
/*********   CPYF FROMFILE(RECCYD) TOFILE(XRECCYD) MBROPT(*ADD) + ***  *S01098*/
/*********                 FMTOPT(*NOCHK)                         ***  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF   FROMFILE(RECCYD) TOFILE(XRECCYD) +    *****  *S01147*/
/*****                    MBROPT(*REPLACE) FMTOPT(*NONE)        *****  *S01147*/
/*****             MONMSG (CPF2817) CMPDTA(CPF2869) +           *****  *S01147*/
/*****                    EXEC(CLRPFM XRECCYD)                  *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(RECCYD) TOFILE(XRECCYD.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(RECCYD) TOFILE(&TOLIB/XRECCYD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                              FMTOPT(*NONE)                           /*S01147*/
                   MONMSG (CPF2817) CMPDTA(CPF2869)                   /*S01147*/
/**/
                   ALCOBJ     ((RESTAT *DTAARA *EXCLRD))
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                   CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('NEW')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                   DLCOBJ     ((RESTAT *DTAARA *EXCLRD))
                ENDDO
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
/**/
                IF COND(%SUBSTRING(&RESTAT 12 3) = 'NEW') THEN(DO)
                      ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/*********            CLRPFM FILE(RECCYD)                  **********  *S01098*/
/**/                                                                  /*S01098*/
/*   REMOVE LOGICAL FILE OVER PHYSICALS BEFORE COPYING      */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
                   RMVM       FILE(RECCY) MBR(RECCY)                  /*S01098*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/                                                                  /*S01098*/
/*********   CPYF FROMFILE(XRECCYD) TOFILE(RECCYD) MBROPT(*ADD) + ***  *S01098*/
/*********                INCCHAR(RECI 1 *NE *) FMTOPT(*NOCHK)    ***  *S01098*/
                   CPYF   FROMFILE(XRECCYD) TOFILE(RECCYD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *NE *) +
                          FMTOPT(*NONE)                               /*S01098*/
                   MONMSG (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM RECCYD)                         /*S01098*/
/**/                                                                  /*S01098*/
/*                 ADDLFM     FILE(RECCY) MBR(RECCY) */    /*S01098*/ /*BHF982*/
                   ADDLFM     FILE(RECCY) MBR(RECCY) SHARE(*YES)      /*BHF982*/
                   MONMSG     MSGID(CPF0000)                          /*S01098*/
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                   CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('OLD')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                   DLCOBJ     ((RESTAT *DTAARA *EXCLRD))
/**/
                   CLRPFM FILE(XRECCYD)
                ENDDO
             ENDDO
/**/
             IF COND(&STAT = 'REINT')  THEN(DO)
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                IF COND(%SUBSTRING(&RESTAT 12 3) = 'OLD') THEN(DO)
                   DLTF   FILE(XREINTD)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
/*********         CLRPFM FILE(XREINTD)                     *********  *S01098*/
/*********  CPYF FROMFILE(REINTD) TOFILE(XREINTD) MBROPT(*ADD) + ****  *S01098*/
/*********                 FMTOPT(*NOCHK)                        ****  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF   FROMFILE(REINTD) TOFILE(XREINTD) +    *****  *S01147*/
/*****                    MBROPT(*REPLACE) FMTOPT(*NONE)        *****  *S01147*/
/*****             MONMSG (CPF2817) CMPDTA(CPF2869) +           *****  *S01147*/
/*****                    EXEC(CLRPFM XREINTD)                  *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(REINTD) TOFILE(XREINTD.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(REINTD) TOFILE(&TOLIB/XREINTD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                              FMTOPT(*NONE)                           /*S01147*/
                   MONMSG (CPF2817) CMPDTA(CPF2869)                   /*S01147*/
/**/
                   ALCOBJ     ((RESTAT *DTAARA *EXCLRD))
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                   CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('NEW')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                   DLCOBJ     ((RESTAT *DTAARA *EXCLRD))
                ENDDO
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
/**/
                IF COND(%SUBSTRING(&RESTAT 12 3) = 'NEW') THEN(DO)
                      ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/*********            CLRPFM FILE(REINTD)                  **********  *S01098*/
/**/                                                                  /*S01098*/
                      RMVM       FILE(REINT) MBR(REINT)               /*S01098*/
                      MONMSG     MSGID(CPF0000)                       /*S01098*/
/**/                                                                  /*S01098*/
/*********   CPYF FROMFILE(XREINTD) TOFILE(REINTD) MBROPT(*ADD) + ***  *S01098*/
/*********                INCCHAR(RECI 1 *NE *) FMTOPT(*NOCHK)    ***  *S01098*/
/**/                                                                  /*S01098*/
                      CPYF   FROMFILE(XREINTD) TOFILE(REINTD) +
                             MBROPT(*REPLACE) INCCHAR(RECI 1 *NE *) +
                             FMTOPT(*NONE)                            /*S01098*/
                      MONMSG (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM REINTD)                      /*S01098*/
/**/                                                                  /*S01098*/
/*                    ADDLFM     FILE(REINT) MBR(REINT) */ /*S01098*/ /*BHF982*/
                      ADDLFM     FILE(REINT) MBR(REINT) SHARE(*YES)   /*BHF982*/
                      MONMSG     MSGID(CPF0000)                       /*S01098*/
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                   CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('OLD')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                   DLCOBJ     ((RESTAT *DTAARA *EXCLRD))
/**/
                   CLRPFM FILE(XREINTD)
                ENDDO
             ENDDO
/**/
             IF COND(&STAT = 'RECRG')  THEN(DO)
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                IF COND(%SUBSTRING(&RESTAT 12 3) = 'OLD') THEN(DO)
                   DLTF   FILE(XRECRGD)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
/*********         CLRPFM FILE(XRECRGD)                    **********  *S01098*/
/*********   CPYF FROMFILE(RECRGD) TOFILE(XRECRGD) MBROPT(*ADD) + ***  *S01098*/
/*********                 FMTOPT(*NOCHK)                         ***  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF   FROMFILE(RECRGD) TOFILE(XRECRGD) +    *****  *S01147*/
/*****                    MBROPT(*REPLACE) FMTOPT(*NONE)        *****  *S01147*/
/*****             MONMSG (CPF2817) CMPDTA(CPF2869) +           *****  *S01147*/
/*****                    EXEC(CLRPFM XRECRGD)                  *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(RECRGD) TOFILE(XRECRGD.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(RECRGD) TOFILE(&TOLIB/XRECRGD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                              FMTOPT(*NONE)                           /*S01147*/
                   MONMSG (CPF2817) CMPDTA(CPF2869)                   /*S01147*/
/**/
                   ALCOBJ     ((RESTAT *DTAARA *EXCLRD))
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                   CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('NEW')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                   DLCOBJ     ((RESTAT *DTAARA *EXCLRD))
                ENDDO
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
/**/
                IF COND(%SUBSTRING(&RESTAT 12 3) = 'NEW') THEN(DO)
                      ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/*********            CLRPFM FILE(RECRGD)                  **********  *S01098*/
/*********   CPYF FROMFILE(XRECRGD) TOFILE(RECRGD) MBROPT(*ADD) + ***  *S01098*/
/*********                INCCHAR(RECI 1 *NE *) FMTOPT(*NOCHK)    ***  *S01098*/
/**/                                                                  /*S01098*/
                      RMVM       FILE(RECRG) MBR(RECRG)               /*S01098*/
                      MONMSG     MSGID(CPF0000)                       /*S01098*/
/**/                                                                  /*S01098*/
/**/                                                                  /*S01098*/
                      CPYF   FROMFILE(XRECRGD) TOFILE(RECRGD) +
                             MBROPT(*REPLACE) INCCHAR(RECI 1 *NE *) +
                             FMTOPT(*NONE)                            /*S01098*/
                      MONMSG (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM RECRGD)                      /*S01098*/
/**/                                                                  /*S01098*/
/*                    ADDLFM     FILE(RECRG) MBR(RECRG) */ /*S01098*/ /*BHF982*/
                      ADDLFM     FILE(RECRG) MBR(RECRG) SHARE(*YES)   /*BHF982*/
                      MONMSG     MSGID(CPF0000)                       /*S01098*/
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                   CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('OLD')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                   DLCOBJ     ((RESTAT *DTAARA *EXCLRD))
/**/
                   CLRPFM FILE(XRECRGD)
                ENDDO
             ENDDO
/**/
             IF COND(&STAT = 'RETRG')  THEN(DO)
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                IF COND(%SUBSTRING(&RESTAT 12 3) = 'OLD') THEN(DO)
                   DLTF   FILE(XRETRGD)                               /*S01147*/
                   MONMSG MSGID(CPF0000)                              /*S01147*/
/*/COPY WNCPYSRC,REC90006                                            */
/*********         CLRPFM FILE(XRETRGD)                     *********  *S01098*/
/*********   CPYF FROMFILE(RETRGD) TOFILE(XRETRGD) MBROPT(*ADD) + ***  *S01098*/
/*********                 FMTOPT(*NOCHK)                         ***  *S01098*/
/**/                                                                  /*S01147*/
/*****             CPYF   FROMFILE(RETRGD) TOFILE(XRETRGD) +    *****  *S01147*/
/*****                    MBROPT(*REPLACE) FMTOPT(*NONE)        *****  *S01147*/
/*****             MONMSG (CPF2817) CMPDTA(CPF2869) +           *****  *S01147*/
/*****                    EXEC(CLRPFM XRETRGD)                  *****  *S01147*/
/**/                                                                  /*S01147*/
/*                 CPYF   FROMFILE(RETRGD) TOFILE(XRETRGD.&TOLIB) +     S01179*/
                   CPYF   FROMFILE(RETRGD) TOFILE(&TOLIB/XRETRGD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                              FMTOPT(*NONE)                           /*S01147*/
                   MONMSG (CPF2817) CMPDTA(CPF2869)                   /*S01147*/
/*/COPY WNCPYSRC,REC90007                                            */
/**/
                   ALCOBJ     ((RESTAT *DTAARA *EXCLRD))
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                   CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('NEW')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                   DLCOBJ     ((RESTAT *DTAARA *EXCLRD))
                ENDDO
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
/**/
                IF COND(%SUBSTRING(&RESTAT 12 3) = 'NEW') THEN(DO)
                      ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/*********            CLRPFM FILE(RETRGD)                  **********  *S01098*/
/*********   CPYF FROMFILE(XRETRGD) TOFILE(RETRGD) MBROPT(*ADD) + ***  *S01098*/
/*********                INCCHAR(RECI 1 *NE *) FMTOPT(*NOCHK)    ***  *S01098*/
/**/                                                                  /*S01098*/
                      RMVM       FILE(RETRG) MBR(RETRG)               /*S01098*/
                      MONMSG     MSGID(CPF0000)                       /*S01098*/
/**/                                                                  /*S01098*/
                      CPYF   FROMFILE(XRETRGD) TOFILE(RETRGD) +
                             MBROPT(*REPLACE) INCCHAR(RECI 1 *NE *) +
                             FMTOPT(*NONE)                            /*S01098*/
                      MONMSG (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM RETRGD)                      /*S01098*/
/*/COPY WNCPYSRC,REC90008                                            */
/**/                                                                  /*S01098*/
/*                    ADDLFM     FILE(RETRG) MBR(RETRG) */ /*S01098*/ /*BHF982*/
                      ADDLFM     FILE(RETRG) MBR(RETRG) SHARE(*YES)   /*BHF982*/
                      MONMSG     MSGID(CPF0000)                       /*S01098*/
/**/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
             RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)                /*S01179*/
                   CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('OLD')
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/
                   CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT) /*S01179*/
                   DLCOBJ     ((RESTAT *DTAARA *EXCLRD))
/**/
                   CLRPFM FILE(XRETRGD)
/*/COPY WNCPYSRC,REC90009                                            */
                ENDDO
             ENDDO
/**/
             IF COND(&STAT = 'REIAC')  THEN(DO)                       /*E10615*/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
/**********  RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)              */          /*S01179 AR1097467*/
/**********     IF COND(%SUBSTRING(&RESTAT 12 3) = 'OLD') THEN(DO)  */          /*E10615 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/**********        DLTF   FILE(XREICOD)                             */          /*E10615 AR1097467*/
/**********           MONMSG     MSGID(CPF0000)                     */          /*E10615 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/*                 CPYF       FROMFILE(REIACD) TOFILE(XREICOD.&TOLIB) + S01179*/
/**                CPYF       FROMFILE(REIACD) TOFILE(&TOLIB/XREOLIB)  *S01187*/
/**********        CPYF       FROMFILE(REIACD) TOFILE(&TOLIB/XREICOD) + */             /*AR1097467*/
/**********                   MBROPT(*REPLACE) CRTFILE(*YES) +      */                 /*AR1097467*/
/**********                   FMTOPT(*NONE)                         */          /*E10615 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/**********        ALCOBJ     ((RESTAT *DTAARA *EXCLRD))            */          /*E10615 AR1097467*/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
/**********  RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)              */          /*S01179 AR1097467*/
/**********        CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('NEW')*/          /*E10615 AR1097467*/
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/  /*E10615*/
/**********        CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT)          */   /*S01179 E10615 AR1097467*/
/**********        DLCOBJ     ((RESTAT *DTAARA *EXCLRD))            */          /*E10615 AR1097467*/
/**********     ENDDO                                               */          /*E10615 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
/**********  RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)              */          /*S01179 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/**********     IF COND(%SUBSTRING(&RESTAT 12 3) = 'NEW') THEN(DO)  */          /*E10615 AR1097467*/
/**********           ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))          */          /*E10615 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/**********           RMVM       FILE(REIAC) MBR(REIAC)             */          /*E10615 AR1097467*/
/**********           MONMSG     MSGID(CPF0000)                     */          /*E10615 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/**********           CPYF   FROMFILE(XREICOD) TOFILE(REIACD) +     */                 /*AR1097467*/
/**********                  MBROPT(*REPLACE) INCCHAR(RECI 1 *NE *) + */               /*AR1097467*/
/**********                  FMTOPT(*NONE)                          */          /*E10615 AR1097467*/
/**********           MONMSG (CPF2817) CMPDTA(CPF2869) +            */                 /*AR1097467*/
/**********                  EXEC(CLRPFM REIACD)                    */          /*E10615 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/*                    ADDLFM     FILE(REIAC) MBR(REIAC) */ /*E10615*/ /*BHF982*/
/**********           ADDLFM     FILE(REIAC) MBR(REIAC) SHARE(*YES) */          /*BHF982 AR1097467*/
/**********           MONMSG     MSGID(CPF0000)                     */          /*E10615 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/*           RCVDTAARA DTAARA(RESTAT)                   */            /*S01179*/
/**********  RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)              */          /*S01179 AR1097467*/
/**********        CHGVAR VAR(%SUBSTRING(&RESTAT 12 3)) VALUE('OLD') */         /*E10615 AR1097467*/
/*                 SNDDTAARA DTAARA(RESTAT)                *S01179*/  /*E10615*/
/**********        CHGDTAARA DTAARA(RESTAT) VALUE(&RESTAT)          */   /*S01179 E10615 AR1097467*/
/**********        DLCOBJ     ((RESTAT *DTAARA *EXCLRD))            */          /*E10615 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/**********         DLTF   FILE(XREICOD)                            */          /*E10615 AR1097467*/
/**********           MONMSG     MSGID(CPF0000)                     */          /*E10615 AR1097467*/
/********************************************************************/          /*E10615 AR1097467*/
/**********     ENDDO                                               */          /*E10615 AR1097467*/
             SCRUNSQL   SQL('Delete from REIACD where RECI = ''*''')                   /*AR1097467*/
             ENDDO                                                    /*E10615*/
/**/
/*           E R R O R     M E S S A G E S                           */
/**/
/*ROR:****** IF COND(%SWITCH(XXXXXXX1)) THEN(DO)                      /*S01117*/
ERROR:       IF COND(%SWITCH(XXXXXX01)) THEN(DO)                      /*S01117*/
/*********** CHGVAR VAR(&MSG) VALUE('FILE OUT OF BALANCE -' ||  &PGM) /*117321*/
             CHGVAR     VAR(&MSG) VALUE('FILE OUT OF BALANCE - ' +
                          *CAT &PGM)                                  /*117321*/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)                   /*S01117*/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
