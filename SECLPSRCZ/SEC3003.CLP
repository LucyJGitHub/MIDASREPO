/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Bulk Update')                                */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*         SEC3003 - BULK UPDATE                                    */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 236125             Date 26Sep05              */
/*                      234440             Date 03Sep99              */
/*                        CSC023           Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                        CSE006           Date 03Sep99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                        CPK009           Date 09Aug99              */
/*                        S01408           DATE 21FEB96             */
/*                        084923           DATE 13APR95             */
/*                        S01448           DATE 22DEC93             */
/*                        S01401           DATE 19MAR93             */
/*                        S01117           DATE 10JAN91             */
/*                        E23408           DATE 06SEP90             */
/*                                                                  */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       236125 - Add override for TRADSD                           */
/*       234440 - add override ETCPOSL0 & L3                       */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSE006 - Repo Enhancement - New parameter (submitted from  */
/*                Buy-Sell Backs flag) for conditioning OVRDBF.     */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       S01408 - Addition of core hook SEC3003001                  */
/*                Addition of core hook SEC3003002                  */
/*       084923 - Send 'MIDAS' message to MSTATUS to balance with   */
/*                MIDASRMV CALL, which otherwise removes a message  */
/*                sent by another job.                              */
/*       S01448 - Bulk Input Enhancements                           */
/*                Add parameter to SE3003 for indicate cross agency */
/*                trade (between two portfolio clients).            */
/*       S01401 - SWIFT Messages MT5xxs : Call to SE1830 if         */
/*                MT5xx present. SE1830 attemps to keep BULKTD and  */
/*                BULKSDX1/X2 in line with each other.              */
/*              - Submit Confirmations Print program to generate    */
/*                paper Confirmations and MT5xx messages, if S01401 */
/*                (Switchable Feature) present.                     */
/*       S01117 - MULTIBRANCHING                                    */
/*       E23408 - SETON U1 IF RETAIL II OR INTEREST ON ACCOUNTS     */
/*                INSTALLED IN SYSTEM.                              */
/*                                                                  */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
/*********** PGM        PARM(&JOB &BLKREF)  ***/                      /*S01401*/
/*********** PGM        PARM(&JOB &BLKREF &TRDREF) ***/       /*S01401  S01448*/
/*********** PGM        PARM(&JOB &BLKREF &TRDREF &CAGT) ***/ /*S01448  CSE006*/
             PGM        PARM(&JOB &BLKREF &TRDREF &CAGT &BYSL)        /*CSE006*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BLKREF) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TRDREF) TYPE(*CHAR) LEN(6)               /*S01401*/
             DCL        VAR(&CAGT) TYPE(*CHAR) LEN(1)                 /*S01448*/
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&RE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IA) TYPE(*CHAR) LEN(1)                /*E23408*/
             DCL        VAR(&BYSL) TYPE(*CHAR) LEN(1)                 /*CSE006*/
             DCL        VAR(&ERRMSG) TYPE(*CHAR) LEN(100) VALUE('Bulk +
                          transaction xxxxxx defaults/updates +
                          produced an error report: Check invalid +
                          trades')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(S38ERROR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*USE)
 
 /***********STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))                /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                  /*CPK009*/
 
             RTVDTAARA  DTAARA(MMOD (16 1)) RTNVAR(&RE)
             RTVDTAARA  DTAARA(MMOD (23 1)) RTNVAR(&IA)            /*E23408*/
 
             IF (&TRDREF *NE 'S01401') THEN(DO)                       /*S01401*/
               CHGJOB SWS(XXXXXX00)                                   /*S01401*/
               CALL (SE1830) PARM(&BLKREF &TRDREF)                    /*S01401*/
                                                                      /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                   RTVDTAARA (LDA (134 50)) RTNVAR(&MEM)              /*S01401*/
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) +
                      MSGDTA(&MEM) TOMSGQ(MOPERQ &JOB)                /*S01401*/
                   GOTO (EXIT)                                        /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
             ENDDO                                                    /*S01401*/
                                                                      /*S01401*/
/************IF*********COND(&RE *EQ 'Y') THEN(CHGJOB SWS(1XXXXX00))*E23408*/
             IF         COND((&RE *EQ 'Y') *OR (&IA *EQ 'Y')) +
                          THEN(CHGJOB SWS(1XXXXX00))               /*E23408*/
             ELSE       CMD(CHGJOB SWS(00000000))
 
             CHGVAR     VAR(%SST(&ERRMSG 18 6)) VALUE(&BLKREF)
 
             IF         COND(&BYSL *EQ 'Y ') THEN(DO)                 /*CSE006*/
                OVRDBF     FILE(BULKTD) TOFILE(SEBYSLL0) SHARE(*NO)   /*CSE006*/
             ENDDO                                                    /*CSE006*/
             OVRDBF FILE(ETCPOSL0) SHARE(*NO)                                             /*234440*/
             OVRDBF FILE(ETCPOSL3) SHARE(*NO)                                             /*234440*/
             OVRDBF FILE(TRADS) SHARE(*NO)                                                /*236125*/
                                                                      /*CSE006*/
/************CALL*******PGM(SE3003) PARM(&JOB &BLKREF)*****/          /*S01448*/
/************CALL*******PGM(SE3003) PARM(&JOB &BLKREF &CAGT)  /*S01448  CSE006*/
             CALL       PGM(SE3003) PARM(&JOB &BLKREF &CAGT &BYSL)    /*CSE006*/
 
             IF         COND(&BYSL *EQ 'Y ') THEN(DO)                 /*CSE006*/
                DLTOVR     FILE(BULKTD)                               /*CSE006*/
             ENDDO                                                    /*CSE006*/
                DLTOVR     FILE(ETCPOSL0)                                                 /*234440*/
                                                                      /*CSE006*/
             IF         COND(&BLKREF *EQ 'ERROR ') THEN(SNDPGMMSG +
                          MSG(&ERRMSG) TOMSGQ(&JOB MOPERQ))
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ &JOB)
                ENDDO
                                                                      /*S01401*/
/***  If no errors, then before exiting program, submit the  ***/     /*S01401*/
/***  Confirmation Print program. (This will also generate   ***/     /*S01401*/
/***  MT5xx Messages if S01401 Feature is present).          ***/     /*S01401*/
                                                                      /*S01401*/
             IF ((&BLKREF *NE 'ERROR ') *AND +
                 (%SWITCH(XXXXXX00))) THEN(DO)                        /*S01401*/
/**/                                                                  /*084923*/
/*/COPY WNCPYSRC,SEC3003001                                          */
/**/                                                                  /*084923*/
/**/                                                                  /*084923*/
                 SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)              /*084923*/
/**/                                                                  /*084923*/
/************  SBMJOB (SEC0304) JOBD(MBATCH) USER(*JOBD) +                                /*CSC023*/
/************     RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +                                  /*CSC023*/
/************     INLLIBL(*JOBD) MSGQ(MOPERQ)                         /*S01401*/          /*CSC023*/
/************  SBMJOB (MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                               /*CSC023*/
/************     RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                                 /*CSC023*/
/************     INLLIBL(*JOBD) MSGQ(MOPERQ)                         /*S01401*/          /*CSC023*/
               SBMJOB (SEC0304) JOBD(MBATCH) USER(*JOBD) +
                  RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +
                  INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                                 /*CSC023*/
               SBMJOB (MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                  RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                  INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                                 /*CSC023*/
/**/                                                                  /*084923*/
/*/COPY WNCPYSRC,SEC3003002                                          */
/**/                                                                  /*084923*/
             ENDDO                                                    /*S01401*/
 
             GOTO       CMDLBL(EXIT)
 
 S38ERROR:   ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Error occurred while calling SE3003 - +
                          Bulk Update') TOMSGQ(MOPERQ &JOB)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 EXIT:       CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             RCVMSG     MSGQ(MSTATUS) RMV(*YES)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
