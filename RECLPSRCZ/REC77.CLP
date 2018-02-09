/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Accounts to be made inactive')               */
/********************************************************************/
/*                                                                  */
/*        Midas - Retail Module                             */
/*                                                                  */
/*     REC77  -  ACCOUNTS TO BE TRANSFERRED TO INACTIVE STATUS      */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CGL127AP           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 11May95              */
/*                    S01337             Date 17Apr91                */
/*                    BHF982             DATE 19FEB91               */
/*                    LN0316             DATE 12JUN90               */
/*                    LN0134             DATE 09MAY90               */
/*                    S01117             DATE 16MAR90               */
/*                    S01194             DATE 12MAR90               */
/*                    S01189             DATE 12MAR90               */
/*                    E19060             DATE 09AUG89               */
/*                    S01179             DATE 10/09/88              */
/*                    S01147             DATE 27/11/87              */
/*                    E11700             DATE 04/11/87              */
/*                    S01098             DATE 08/07/86              *  *S01098*/
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     CGL127AP - COB Restructure - GL COB Optimisation Phase 1     */
/*     S01408  -  Addition of core hook REC77MP1                     */
/*     S01337  -  SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRARIES    */
/*                                                                  */
/*     BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                      */
/*                                                                  */
/*     LN0316  -  PROGRAM TRIES TO DELETE AN OVERRIDE THAT          */
/*                 HAS ALREADY BEEN DELETED                         */
/*                                                                  */
/*     LN0134  -  AMENDMENT TO ORDER OF PARAMETERS FOR RCF          */
/*                                                                  */
/*     S01117  -  MULTIBRANCHING                                    */
/*                                                                  */
/*     S01194  -  NEW STANDING DATA                                 */
/*                                                                  */
/*     S01189  -  COB recovery processing.                          */
/*                                                                  */
/*     E19060  -  REINSERTION OF 'ALCOBJ' AND 'DLCOBJ' COMMANDS     *  *E19060*/
/*                FOR ERROR NO. 11700                               *  *E19060*/
/*                                                                  */
/*     S01179  -  AS400 CONVERSION                                  */
/*                                                                  */
/*     S01147  -  RELEASE 22                                        */
/*                                                                  */
/*     E11700  -  ACCNT SHOULD BE ALLOCATED BEFORE USE.             *  *E11700*/
/*                                                                  */
/*     S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,          *  *S01098*/
/*                INSTEAD OF CLEARING AND ADDING                    *  *S01098*/
/*                FROM AND TO FILES ARE NOW 'BLOCKED'               *  *S01098*/
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/********    PGM        PARM(&STAT)                                   /*S01189*/
/************PGM        PARM(&STAT &CNAM &CSEQ)              *S01189*  *S01117*/
/************PGM     PARM(&RSEQ &RLEV &RENT &STAT &CNAM &CSEQ)  S01117  LN0134*/
             PGM        PARM(&STAT &CNAM &CSEQ &RSEQ &RLEV &RENT)     /*LN0134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL       VAR(&RSEQ) TYPE(*CHAR) LEN(5)                  /*S01117*/
             DCL       VAR(&RLEV) TYPE(*CHAR) LEN(1)                  /*S01117*/
             DCL       VAR(&RENT) TYPE(*CHAR) LEN(3)                  /*S01117*/
             DCL       VAR(&STAT) TYPE(*CHAR) LEN(1)
/************DCL       VAR(&MEM) TYPE(*CHAR) LEN(44)                 * *S01194*/
             DCL       VAR(&MEM) TYPE(*CHAR) LEN(50)                  /*S01194*/
             DCL       VAR(&TOLIB) TYPE(*CHAR) LEN(10)                /*S01147*/
             DCL       VAR(&PRE) TYPE(*CHAR) LEN(2)                   /*S01147*/
             DCL       VAR(&CNAM) TYPE(*CHAR) LEN(10)                 /*S01189*/
             DCL       VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                 /*S01189*/
             DCL       VAR(&STTS) TYPE(*CHAR) LEN(1) VALUE(' ')       /*S01189*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)                                  /*CGL127AP*/
/*           DCLDTAARA DTAARA(LDA)                         */         /*S01179*/
             DCL       VAR(&LDA) TYPE(*CHAR) LEN(256)       /*S01179*  *S01147*/
/*           DCLDTAARA DTAARA(RESTAT)                      */         /*S01179*/
/********    DCL       VAR(&RESTAT) TYPE(*CHAR) LEN(256)   /*S01147*/ /*S01189*/
/*           DCLDTAARA DTAARA(SDSTAT)                     *  *S01179*  *S01147*/
             DCL       VAR(&SDSTAT) TYPE(*CHAR) LEN(256)    /*S01179*  *S01147*/
/*           RCVDTAARA DTAARA(RESTAT)    */                           /*S01179*/
/********    RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)     /*S01179*/ /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STTS)           /*S01189*/
/*           RCVDTAARA DTAARA(SDSTAT)    */                 /*S01179*  *S01147*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT) /*S01147*/     /*S01179*/
/**/
             SNDPGMMSG  MSG('REC77 - Accounts to be Transferred to +
                          Inactive Status') TOMSGQ(MRUNQ)
/**/                                                                  /*S01147*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*S01147*/
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')   /*S01147 S01337*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01337*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC77MP1                                            */
                                                                      /*S01408*/
/**/
/**********  ALCOBJ     OBJ((ACCNT *FILE *EXCLRD)) WAIT(9999)      */            /*E19060 CGL127AP*/
             IF COND(&STAT *EQ 'I') THEN(DO)
/**/
/***********    CHGJOB SWS(00101000)                                  /*S01117*/
/**********     CHGJOB SWS(00001000)                               */            /*S01117 CGL127AP*/
/**/
                CLRPFM FILE(AXFIAX)
                CLRPFM FILE(RTZZ) MBR(AXFI)
/**/
/***************OVRDBF FILE(TABLE) TOFILE(TABRE2)                    * *S01194*/
                OVRDBF FILE(AXFIAZZ) TOFILE(RTZZ) MBR(AXFI)
/***********    CALL PGM(RE0570) PARM(I)                              /*S01117*/
/**********     CALL PGM(GL0570) PARM('3')                         */            /*S01117 CGL127AP*/
                CALL       PGM(RE377801) PARM(&ERROR)                                   /*CGL127AP*/
                IF         COND(&ERROR *NE 'Y') THEN(DO)                                /*CGL127AP*/
                   CALL       PGM(GL000569)                                             /*CGL127AP*/
                ENDDO                                                                   /*CGL127AP*/
                DLTOVR FILE(*ALL)
/**/
                IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
                   IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                /*S01117*/
                      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)             /*S01117*/
                      CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))   /*S01117*/
                      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                 MSGDTA(&MEM) TOMSGQ(MOPERQ)          /*S01117*/
                      GOTO END                                        /*S01117*/
                   ENDDO                                              /*S01117*/
/***********    SNDPGMMSG  MSG('FILE OUT OF BALANCE - RE0570') +      /*S01117*/
/**********     SNDPGMMSG  MSG('FILE OUT OF BALANCE - GL0570') +
                          TOMSGQ(MOPERQ)                           */            /*S01117 CGL127AP*/
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - GL000569') +
                             TOMSGQ(MOPERQ)                                             /*CGL127AP*/
                GOTO CMDLBL(END)
                ENDDO
/**/
                CHGJOB SWS(10000000)
/**/
             ENDDO
/**/
             ELSE CMD(CHGJOB SWS(00000000))
/**/
/*  BLOCK FILES   */                                                  /*S01098*/
/**/                                                                  /*S01098*/
             OVRDBF     FILE(ACORDAB) SEQONLY(*YES 100)               /*S01098*/
             OVRDBF     FILE(ACCNTAB) SEQONLY(*YES 100)               /*S01098*/
/**/                                                                  /*S01098*/
/********    IF COND(%SST(&RESTAT 15 1) = 'N') THEN(DO)               /*S01189*/
             IF         COND(&STTS *EQ 'N') THEN(DO)                  /*S01189*/
/********       ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))                  /*S01189*/
/**/                                                                  /*S01147*/
                DLTF   FILE(XACCNTAA)                                 /*S01147*/
                MONMSG MSGID(CPF0000)                                 /*S01147*/
                DLTF   FILE(XACCNTAB)                                 /*S01147*/
                MONMSG MSGID(CPF0000)                                 /*S01147*/
                DLTF   FILE(XACCNTAC)                                 /*S01147*/
                MONMSG MSGID(CPF0000)                                 /*S01147*/
/**/                                                                  /*S01147*/
/*********      CLRPFM FILE(XACCNTAA)                      **********  *S01098*/
/*********      CLRPFM FILE(XACCNTAB)                      **********  *S01098*/
/*********      CLRPFM FILE(XACCNTAC)                      **********  *S01098*/
/**/                                                                  /*S01098*/
/*********CPYF FROMFILE(ACCNTAA) TOFILE(XACCNTAA) MBROPT(*ADD) + ****  *S01098*/
/*********           FMTOPT(*NOCHK)                              ****  *S01098*/
/**/                                                                  /*S01147*/
/*****          CPYF       FROMFILE(ACCNTAA) TOFILE(XACCNTAA) + *****  *S01147*/
/*****                     MBROPT(*REPLACE) FMTOPT(*NONE)       *****  *S01147*/
/*****          MONMSG     (CPF2817) CMPDTA(CPF2869) +          *****  *S01147*/
/*****                     EXEC(CLRPFM XACCNTAA)                *****  *S01147*/
/**/                                                                  /*S01147*/
/*              CPYF      FROMFILE(ACCNTAA) TOFILE(XACCNTAA.&TOLIB) +   S01179*/
                CPYF      FROMFILE(ACCNTAA) TOFILE(&TOLIB/XACCNTAA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/**/                                                                  /*S01147*/
/*********CPYF FROMFILE(ACCNTAC) TOFILE(XACCNTAC) MBROPT(*ADD) + ****  *S01098*/
/*********           FMTOPT(*NOCHK)                              ****  *S01098*/
/**/                                                                  /*S01147*/
/*****          CPYF       FROMFILE(ACCNTAC) TOFILE(XACCNTAC) + *****  *S01147*/
/*****                     MBROPT(*REPLACE) FMTOPT(*NONE)       *****  *S01147*/
/*****          MONMSG     (CPF2817) CMPDTA(CPF2869) +          *****  *S01147*/
/*****                     EXEC(CLRPFM XACCNTAC)                *****  *S01147*/
/**/                                                                  /*S01147*/
/*              CPYF      FROMFILE(ACCNTAC) TOFILE(XACCNTAC.&TOLIB) +   S01179*/
                CPYF      FROMFILE(ACCNTAC) TOFILE(&TOLIB/XACCNTAC) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/**/                                                                  /*S01147*/
/*********CPYF FROMFILE(ACCNTAB) TOFILE(XACCNTAB) MBROPT(*ADD) + ****  *S01098*/
/*********           FMTOPT(*NOCHK)                              ****  *S01098*/
/**/                                                                  /*S01147*/
/*****          CPYF       FROMFILE(ACCNTAB) TOFILE(XACCNTAB) + *****  *S01147*/
/*****                     MBROPT(*REPLACE) FMTOPT(*NONE)       *****  *S01147*/
/*****          MONMSG     (CPF2817) CMPDTA(CPF2869) +          *****  *S01147*/
/*****                     EXEC(CLRPFM XACCNTAB)                *****  *S01147*/
/**/                                                                  /*S01147*/
/*              CPYF      FROMFILE(ACCNTAB) TOFILE(XACCNTAB.&TOLIB) +   S01179*/
                CPYF      FROMFILE(ACCNTAB) TOFILE(&TOLIB/XACCNTAB) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01147*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/**/
/********       CHGVAR VAR(%SST(&RESTAT 15 1)) VALUE('Y')             /*S01189*/
/*              SNDDTAARA DTAARA(RESTAT)                   *S01179*/
/********       CHGDTAARA DTAARA(RESTAT)    VALUE(&RESTAT) /*S01179*/ /*S01189*/
                CHGVAR     VAR(&STTS) VALUE('Y')                      /*S01189*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STTS)        /*S01189*/
/**/
/********       DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))                  /*S01189*/
/**/
             ENDDO
             ELSE CMD(DO)
/*********      CLRPFM FILE(ACCNTAA)                       **********  *S01098*/
/*********      CLRPFM FILE(ACCNTAB)                       **********  *S01098*/
/*********      CLRPFM FILE(ACCNTAC)                       **********  *S01098*/
/**/                                                                  /*S01098*/
/*   REMOVE LOGICAL FILES OVER PHYSICALS BEFORE COPYING     */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
                RMVM       FILE(ACCNT) MBR(ACCNT)                     /*S01098*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
                RMVM       FILE(ACNUM) MBR(ACNUM)                     /*S01098*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
                RMVM       FILE(SADETC) MBR(SADETC)                   /*S01098*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
/**/                                                                  /*S01098*/
/*********CPYF FROMFILE(XACCNTAA) TOFILE(ACCNTAA) MBROPT(*ADD) + ****  *S01098*/
/*********           FMTOPT(*NOCHK)                              ****  *S01098*/
                CPYF       FROMFILE(XACCNTAA) TOFILE(ACCNTAA) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01098*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM ACCNTAA)                       /*S01098*/
/*********CPYF FROMFILE(XACCNTAC) TOFILE(ACCNTAC) MBROPT(*ADD) + ****  *S01098*/
/*********           FMTOPT(*NOCHK)                              ****  *S01098*/
                CPYF       FROMFILE(XACCNTAC) TOFILE(ACCNTAC) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01098*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM ACCNTAC)                       /*S01098*/
/*********CPYF FROMFILE(XACCNTAB) TOFILE(ACCNTAB) MBROPT(*ADD) + ****  *S01098*/
/*********           FMTOPT(*NOCHK)                              ****  *S01098*/
                CPYF       FROMFILE(XACCNTAB) TOFILE(ACCNTAB) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01098*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM ACCNTAB)                       /*S01098*/
/**/                                                                  /*S01098*/
/*              ADDLFM     FILE(ACCNT) MBR(ACCNT) */       /*S01098*/ /*BHF982*/
                ADDLFM     FILE(ACCNT) MBR(ACCNT) SHARE(*YES)         /*BHF982*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
/*              ADDLFM     FILE(ACNUM) MBR(ACNUM) */       /*S01098*/ /*BHF982*/
                ADDLFM     FILE(ACNUM) MBR(ACNUM) SHARE(*YES)         /*BHF982*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
/*              ADDLFM     FILE(SADETC) MBR(SADETC) */     /*S01098*/ /*BHF982*/
                ADDLFM     FILE(SADETC) MBR(SADETC) SHARE(*YES)       /*BHF982*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
/**/                                                                  /*S01098*/
             ENDDO
/**/
             DLTOVR     FILE(ACORDAB)                                 /*S01098*/
             DLTOVR     FILE(ACCNTAB)                                 /*S01098*/
/**/                                                                  /*S01098*/
             OVRDBF FILE(TABLE) TOFILE(TABSDU)
/*           IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +                  */
/*              THEN(OVRDBF FILE(SAXFI) POSITION(*KEY 1 +                     */
/*              AXFIAXF &RENT)                                        /*S01117*/
             IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                THEN(DO)                                              /*S01117*/
                OVRDBF FILE(SAXFI) POSITION(*KEY 1 +
                AXFIAXF &RENT)                                        /*S01117*/
                OPNDBF FILE(SAXFI) OPTION(*ALL)                       /*S01117*/
                MONMSG MSGID(CPF0000) EXEC(DO)                        /*S01117*/
                DLTOVR FILE(SAXFI)                                    /*S01117*/
                ENDDO                                                 /*S01117*/
                ENDDO                                                 /*S01117*/
/*********** CALL PGM(RE0778)                                         /*S01117*/
                CALL PGM(RE0778)  PARM(&RSEQ &RENT)                   /*S01117*/
                IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                   THEN(DO)                                           /*LN0316*/
/*                 THEN(DLTOVR FILE(SAXFI))           */   /*S01117*/ /*LN0316*/
                          DLTOVR FILE(SAXFI)                          /*LN0316*/
                          MONMSG MSGID(CPF9841)                       /*LN0316*/
                   ENDDO                                              /*LN0316*/
             DLTOVR FILE(TABLE)
/**/
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/********       ALCOBJ OBJ((RESTAT *DTAARA *EXCLRD))                  /*S01189*/
/********       CHGVAR VAR(%SST(&RESTAT 15 1)) VALUE('N')             /*S01189*/
/*              SNDDTAARA DTAARA(RESTAT)                   *S01179*/
/********       CHGDTAARA DTAARA(RESTAT)    VALUE(&RESTAT) /*S01179*/ /*S01189*/
/********       DLCOBJ OBJ((RESTAT *DTAARA *EXCLRD))                  /*S01189*/
                CHGVAR     VAR(&STTS) VALUE('N')                      /*S01189*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STTS)        /*S01189*/
/**/
/*****          CLRPFM FILE(XACCNTAA)                           *****  *S01147*/
/*****          CLRPFM FILE(XACCNTAB)                           *****  *S01147*/
/*****          CLRPFM FILE(XACCNTAC)                           *****  *S01147*/
                DLTF   FILE(XACCNTAA)                                 /*S01147*/
                MONMSG MSGID(CPF0000)                                 /*S01147*/
                DLTF   FILE(XACCNTAB)                                 /*S01147*/
                MONMSG MSGID(CPF0000)                                 /*S01147*/
                DLTF   FILE(XACCNTAC)                                 /*S01147*/
                MONMSG MSGID(CPF0000)                                 /*S01147*/
             ENDDO
             DLCOBJ    OBJ((ACCNT *FILE *EXCLRD))                     /*E19060*/
/**/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 /*             RCVDTAARA  DTAARA(LDA)       */                      /*S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                     /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))        * *S01194*/
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))         /*S01194*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO END                                              /*S01117*/
             ENDDO
/**/
             IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - RE0778') +
                          TOMSGQ(MOPERQ)
             ENDDO
/**/
END:         RCLRSC                                                   /*S01117*/
/*D:         ENDPGM                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
