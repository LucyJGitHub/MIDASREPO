/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Generation of standing order pyts')          */
/********************************************************************/
/*                                                                  */
/*        Midas - Retail Module                                     */
/*                                                                  */
/*     REC7A  -  GENERATION OF STANDING ORDERS PAYMENTS             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CAP187             Date 21Aug09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK024             Date 12Apr06              */
/*                      209995 (BUG9115)   Date 31Oct05              */
/*                    CRE013             Date 28Aug03               */
/*                    CPK016             Date 04Jun03                */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                    CPK009             Date 09Aug99               */
/*                    S01408             DATE 28JAN98               */
/*                    CCB002             DATE 30AUG96               */
/*                    S01408             DATE 30OCT95               */
/*                    BHF982             DATE 19FEB91               */
/*                    S01117             DATE 16MAR90               */
/*                    S01189             DATE 12MAR90               */
/*                    S01179             DATE 21/10/88              */
/*                    S01154             DATE 23/05/88              */
/*                    E10525             DATE 09/04/87              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CAP187  -  Document Linkage (Recompile)                     */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*     209995 - Clear files RENESOPD & DLNEEDPD before call to      */
/*              RE0730.                                             */
/*     CRE013 - Report of Failed Standing Orders                    */
/*     CPK016 - Externalise STRCMTCTL code for ease of later        */
/*              upgrade.                                            */
/*     CPK009 - Packaging for DBA3 release. STRCMTCTL values set    */
/*              to CMTSCOPE(*JOB).                                  */
/*     S01408  - Addition of Core Hook REC7A004                     */
/*     CCB002  -  COB Performance Enhancements                      */
/*                MEMOS used under commitment control               */
/*     S01408 - ADDITION OF CORE HOOK REC7A001                      */
/*     BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                      */
/*     S01117  -  MULTIBRANCHING                                    */
/*                                                                  */
/*     S01189  -  COB recovery processing.                          */
/*                                                                  */
/*     S01179  -  AS/400 CONVERSION                                 */
/*                                                                  */
/*     S01154  -  CHANGES FOR REAL-TIME STATEMENTS: NEW FILE        */
/*                RSACMTPD                                          */
/*                                                                  */
/*     E10525  -  COPYING MEMOS TO MEMOX CAUSES CRASH IN INPUT      *  *E10525*/
/*                INITIATION.                                       *  *E10525*/
/*                                                                  */
/*     S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,          *  *S01098*/
/*                INSTEAD OF CLEARING AND ADDING                    *  *S01098*/
/*                FROM AND TO FILES ARE NOW 'BLOCKED'               *  *S01098*/
/*                                                                  */
/********************************************************************/
/********     PGM PARM(&STAT)                                         /*S01189*/
              PGM PARM(&STAT &CNAM &CSEQ)                             /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 /**/
              DCL VAR(&STAT) TYPE(*CHAR) LEN(1)
              DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                       /*S01117*/
              DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                      /*S01117*/
              DCL VAR(&CNAM) TYPE(*CHAR) LEN(10)                     /*S01189*/
              DCL VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                      /*S01189*/
              DCL VAR(&STTS) TYPE(*CHAR) LEN(1) VALUE(' ')            /*S01189*/
              DCL VAR(&RESTAT) TYPE(*CHAR) LEN(256)
              DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                 /*CPK016*/
/***COPY*WNCPYS/C,REC7A002***                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,REC7A002                                            */                   /*CPK024*/
              RTVDTAARA DTAARA(RESTAT *ALL) RTNVAR(&RESTAT)
              CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STTS)          /*S01189*/
 /**/
              SNDPGMMSG MSG('REC7A - Generation of Standing Order Payments') +
                        TOMSGQ(MRUNQ)
              IF COND(&STAT *EQ 'N') THEN(CHGJOB SWS(10000000))
              ELSE CMD(CHGJOB SWS(00000000))
 /**/
/**/                                                                  /*S01098*/
/*                      'BLOCK FILES'                       */        /*S01098*/
/**/                                                                  /*S01098*/
              OVRDBF FILE(STANDSB) SEQONLY(*YES 100)                  /*S01098*/
              OVRDBF FILE(STNDOSB) SEQONLY(*YES 100)                  /*S01098*/
/*/COPY WNCPYSRC,REC7A010                                            */
/**/                                                                  /*S01098*/
/********     IF COND(%SUBSTRING(&RESTAT 15 1) = 'N') THEN(DO)        /*S01189*/
/********        ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))                 /*S01189*/
              IF         COND(&STTS *EQ 'N') THEN(DO)                 /*S01189*/
 /**/
                 IF COND(%SWITCH(1XXXXXXX)) THEN(DO)
/**/                                                                  /*S01098*/
/*********       CLRPFM FILE(MEMOX)                        **********  *S01098*/
/*********       CPYF FROMFILE(MEMOS) TOFILE(MEMOX) MBROPT(*ADD) +***  *S01098*/
/*********            FMTOPT(*NOCHK)                              ***  *S01098*/
                 CPYF   FROMFILE(MEMOS) TOFILE(MEMOX) +
                        MBROPT(*REPLACE) FMTOPT(*NOCHK)               /*E10525*/
/*********              MBROPT(*REPLACE) FMTOPT(*NONE)     **********  *E10525*/
                 MONMSG (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM MEMOX)                            /*S01098*/
/*                                                                      S01154*/
/* S01154: NEW FILE RSACMTPD                                            S01154*/
/*                                                                      S01154*/
             CPYF       FROMFILE(RSACMTPD) TOFILE(RSACMTPDX) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*S01154*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(RSACMTPDX))                            /*S01154*/
/*/COPY WNCPYSRC,REC7A007                                            */
/**/                                                                  /*S01098*/
                 ENDDO
 /**/
/*********       CLRPFM FILE(STNDOSA)                      **********  *S01098*/
/*********       CLRPFM FILE(STNDOSB)                      **********  *S01098*/
/*********       CLRPFM FILE(STNDOSC)                      **********  *S01098*/
/********* CPYF FROMFILE(STANDSA) TOFILE(STNDOSA) MBROPT(*ADD) +*****  *S01098*/
/*********            FMTOPT(*NOCHK)                            *****  *S01098*/
                 CPYF   FROMFILE(STANDSA) TOFILE(STNDOSA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*S01098*/
                 MONMSG (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM STNDOSA)                          /*S01098*/
/********* CPYF FROMFILE(STANDSC) TOFILE(STNDOSC) MBROPT(*ADD) +*****  *S01098*/
/*********            FMTOPT(*NOCHK)                            *****  *S01098*/
                 CPYF   FROMFILE(STANDSC) TOFILE(STNDOSC) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*S01098*/
                 MONMSG (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM STNDOSC)                          /*S01098*/
/********* CPYF FROMFILE(STANDSB) TOFILE(STNDOSB) MBROPT(*ADD) +*****  *S01098*/
/*********            FMTOPT(*NOCHK)                            *****  *S01098*/
                 CPYF   FROMFILE(STANDSB) TOFILE(STNDOSB) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*S01098*/
                 MONMSG (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM STNDOSB)                          /*S01098*/
/*/COPY WNCPYSRC,REC7A011                                            */
 /**/
/********        CHGVAR VAR(%SUBSTRING(&RESTAT 15 1)) VALUE('Y')      /*S01189*/
/*               SNDDTAARA DTAARA(RESTAT)                  *S01179*/
/********        CHGDTAARA DTAARA(RESTAT)   VALUE(&RESTAT) /*S01179*/ /*S01189*/
/********        DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))                 /*S01189*/
                 CHGVAR     VAR(&STTS) VALUE('Y')                     /*S01189*/
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STTS)       /*S01189*/
              ENDDO
              ELSE CMD(DO)
 /**/
/*********       CLRPFM FILE(STANDSA)                      **********  *S01098*/
/*********       CLRPFM FILE(STANDSB)                      **********  *S01098*/
/*********       CLRPFM FILE(STANDSC)                      **********  *S01098*/
                 IF COND(%SWITCH(1XXXXXXX)) THEN(DO)
/*********          CLRPFM FILE(MEMOS)                     **********  *S01098*/
/*********          CPYF FROMFILE(MEMOX) TOFILE(MEMOS) MBROPT(*ADD)**  *S01098*/
                    CPYF   FROMFILE(MEMOX) TOFILE(MEMOS) +
                           MBROPT(*REPLACE) FMTOPT(*NOCHK)            /*E10525*/
/*********                 MBROPT(*REPLACE) FMTOPT(*NONE)  **********  *E10525*/
                    MONMSG (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM MEMOS)                         /*S01098*/
/*                                                                      S01154*/
/* S01154: NEW FILE RSACMTPD                                            S01154*/
/*                                                                      S01154*/
/*/COPY WNCPYSRC,REC7A005                                            */
             CPYF       FROMFILE(RSACMTPDX) TOFILE(RSACMTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*S01154*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(RSACMTPD))                             /*S01154*/
/*/COPY WNCPYSRC,REC7A006                                            */
                 ENDDO
/**/                                                                  /*S01098*/
/*   REMOVE LOGICAL FILE OVER PHYSICALS BEFORE COPYING      */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
                 RMVM       FILE(STAND) MBR(STAND)                    /*S01098*/
                 MONMSG     MSGID(CPF0000)                            /*S01098*/
/**/                                                                  /*S01098*/
/********* CPYF FROMFILE(STNDOSA) TOFILE(STANDSA) MBROPT(*ADD) +  ***  *S01098*/
/*********            FMTOPT(*NOCHK)                              ***  *S01098*/
                 CPYF   FROMFILE(STNDOSA) TOFILE(STANDSA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*S01098*/
                 MONMSG (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM STANDSA)                          /*S01098*/
/********* CPYF FROMFILE(STNDOSC) TOFILE(STANDSC) MBROPT(*ADD) +  ***  *S01098*/
/*********            FMTOPT(*NOCHK)                              ***  *S01098*/
                 CPYF   FROMFILE(STNDOSC) TOFILE(STANDSC) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*S01098*/
                 MONMSG (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM STANDSC)                          /*S01098*/
/********* CPYF FROMFILE(STNDOSB) TOFILE(STANDSB) MBROPT(*ADD) +  ***  *S01098*/
/*********            FMTOPT(*NOCHK)                              ***  *S01098*/
                 CPYF   FROMFILE(STNDOSB) TOFILE(STANDSB) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*S01098*/
                 MONMSG (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM STANDSB)                          /*S01098*/
/*/COPY WNCPYSRC,REC7A012                                            */
/**/                                                                  /*S01098*/
/*               ADDLFM     FILE(STAND) MBR(STAND) */      /*S01098*/ /*BHF982*/
                 ADDLFM     FILE(STAND) MBR(STAND) SHARE(*YES)        /*BHF982*/
                 MONMSG     MSGID(CPF0000)                            /*S01098*/
/**/                                                                  /*S01098*/
              ENDDO
/**/                                                                  /*S01098*/
              DLTOVR FILE(STANDSB)                                    /*S01098*/
              DLTOVR FILE(STNDOSB)                                    /*S01098*/
/**/                                                                  /*S01098*/
/*/COPY WNCPYSRC,REC7A013                                            */
 /**/
              CLRPFM FILE(SOEXSO)
              CLRPFM FILE(RTZZ) MBR(SOEX)
              CLRPFM FILE(GESOHH)
              CLRPFM FILE(GESOPD)
              CLRPFM FILE(GESOZZ)
              CLRPFM FILE(RENESOPD)                                   /*209995*/
              CLRPFM FILE(DLNEEDPD)                                   /*209995*/
              OVRDBF FILE(TABLE) TOFILE(TABRE2)
              OVRDBF FILE(SOEXZZ) TOFILE(RTZZ) MBR(SOEX)
              OVRDBF FILE(MEMO) TOFILE(MEMOS)
              OVRDBF FILE(GESOPD) SEQONLY(*YES 250)                   /*S01098*/
              CLRPFM FILE(RESTORPD)                                   /*CRE013*/
              MONMSG MSGID(CPF3142)                                   /*CRE013*/
 /**/
/*/COPY WNCPYSRC,REC7A003                                            */
 /**/                                                                 /*CCB002*/
/* Start commitment control */                                                            /*CPK016*/
/**********  STRCMTCTL  LCKLVL(*CHG)                           /*CCB002 CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB) */                         /*CPK009*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
 /**/                                                                 /*CCB002*/
              CALL PGM(RE0730)
             COMMIT                                                   /*CCB002*/
             CLOF       OPNID(MEMOSL1)                                /*CCB002*/
             MONMSG     MSGID(CPF0000)                                /*CCB002*/
             CLOF       OPNID(MEMOSL2)                                /*CCB002*/
             MONMSG     MSGID(CPF0000)                                /*CCB002*/
/*/COPY WNCPYSRC,REC7A008                                            */
             RCLRSC                                                   /*CCB002*/
 /**/                                                                 /*CCB002*/
             ENDCMTCTL                                                /*CCB002*/
 /**/                                                                 /*CCB002*/
/*/COPY WNCPYSRC,REC7A004                                          */ /*S01408*/
 /**/
              DLTOVR FILE(*ALL)
 /**/
 /*********** IF COND(%SWITCH(XXXXXXX0)) THEN(DO)                     /*S01117*/
              IF COND(%SWITCH(XXXXXX00)) THEN(DO)                     /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC7A001                                          */ /*S01408*/
                                                                      /*S01408*/
                 ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
/********        CHGVAR VAR(%SUBSTRING(&RESTAT 15 1)) VALUE('N')      /*S01189*/
                 CHGVAR     VAR(&STTS) VALUE('N')                     /*S01189*/
 /**/
                 IF COND(%SWITCH(1XXXXXXX)) THEN(CHGVAR VAR(%SUBSTRING(&RESTAT +
                                                 16 1)) VALUE('Y'))
 /**/
/*               SNDDTAARA DTAARA(RESTAT)                  *S01179*/
                 CHGDTAARA DTAARA(RESTAT)   VALUE(&RESTAT) /*S01179*/
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STTS)       /*S01189*/
                 DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))
 /**/
                 CLRPFM FILE(STNDOSA)
                 CLRPFM FILE(STNDOSB)
                 CLRPFM FILE(STNDOSC)
                 CLRPFM FILE(MEMOX)
                 CLRPFM FILE(RSACMTPDX)                               /*S01154*/
/*/COPY WNCPYSRC,REC7A009                                            */
              ENDDO
              ELSE CMD(DO)
               IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                    /*S01117*/
                 RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)              /*S01117*/
                 CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01117*/
                 SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)                       /*S01117*/
               ENDDO                                                  /*S01117*/
 /***********  ELSE                                                   /*S01117*/
               ELSE CMD(DO)                                           /*S01117*/
                 SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0730') TOMSGQ(MRUNQ +
                                MOPERQ)
 /**/
               ENDDO                                                  /*S01117*/
              ENDDO
              RCLRSC                                                  /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
              ENDPGM
