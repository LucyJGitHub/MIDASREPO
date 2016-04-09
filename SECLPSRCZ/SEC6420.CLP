/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Generate Settlements from Fees Accrued')        */
/********************************************************************/
/*                                                                  */
/*       Midas - Securities Trading Module                  */
/*                                                                  */
/*       CL/SEC6420 - Generate Safe Custody Settlements             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 11MAY95              */
/*       PREV Amend No. S01464             Date 04APR94             */
/*                      049421     BZ      DATE 19JAN93             */
/*                      SESCS              DATE 28AUG92             */
/*                      S01355             DATE 06MAY92             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       S01408 - Addition of core hook SEC6420MP1                   */
/*       S01464 - Safe Custody Fees                                 */
/*       049421  -  HEADER BOX STANDARDISATION                      */
/*       SESCS   -  SAFE CUSTODY FEES SWITCHABLE                    */
/*       S01355  -  RELEASE 3 INCORPORATION                         */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM  ************************************/               /*S01355*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01355*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)                /*S01464*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01464*/
/************DCL********VAR(&BUSY)**TYPE(*CHAR)*LEN(3)*************/ /*S01355*/
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)              /*S01355*/
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)              /*S01355*/
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')  /*S01355*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
/* >>> SESCS >>> */
/************DCL        VAR(&SCSW) TYPE(*CHAR) LEN(1)                 /*S01464*/
             DCL        VAR(&SCSE) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')                            /*S01464*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*FIRST ')                            /*S01464*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*S01464*/
 
/************RTVDTAARA  DTAARA(LZSTAT (28 1)) RTNVAR(&SCSW)           /*S01464*/
/************IF         COND(&SCSW *EQ 'Y') THEN(DO)                  /*S01464*/
/************                                                         /*S01464*/
/**CHECK*WHETHER*SAFE*CUSTODY*SETTLEMENTS*TO*BE*GENERATED*TODAY*****/ /*S01464*/
/************RTVDTAARA  DTAARA(SESTAT (75 1)) RTNVAR(&SCSE)           /*S01464*/
/* */                                                                 /*S01464*/
/* Check Safe Custody Fees flag on Securities Trading ICD          */ /*S01464*/
/* */                                                                 /*S01464*/
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)          /*S01464*/
/* */                                                                 /*S01464*/
             IF         COND((%SST(&FMT 189 1) *EQ 'Y') *AND (&RTCD +
                          *EQ '       ')) THEN(DO)                    /*S01464*/
/* */                                                                 /*S01464*/
/* Check whether safe custody settlements to be run today          */ /*S01464*/
/* */                                                                 /*S01464*/
             RTVDTAARA  DTAARA(SESTAT (79 1)) RTNVAR(&SCSE)
             IF         COND(&SCSE *NE 'Y') THEN(GOTO +
                          CMDLBL(END))
/* <<< SESCS <<< */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)        /*S01355*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')           /*S01464*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC6420MP1                                          */
                                                                      /*S01408*/
 
/*  SETUP AND SEND PGM MESSAGE                                      */
             SNDPGMMSG  MSG('SEC6420 - Generate safe custody fee +
                          settlements') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/*  SET OFF ALL SWITCHES                                            */
 
             CHGJOB SWS(00000000)
 
/*  CHECK FOR COMPONENT RESTART                                     */
 
/**********  RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)*********/ /*S01355*/
 
/*  IF RESTART, OVERRIDE TO SEQONLY(*YES 100)                       */
 
/************IF*********COND(&BUSY = 'NEW') THEN(DO)***************/ /*S01355*/
             IF         COND(&STATUS = 'Y') THEN(DO)                 /*S01355*/
 
/************   OVRDBF     FILE(XSCSCFAPD) SEQONLY(*YES 100)          /*S01464*/
/************   OVRDBF     FILE(SCSCFAPD) SEQONLY(*YES 100)           /*S01464*/
/************   OVRDBF     FILE(XSCICDPPD) SEQONLY(*YES 100)          /*S01464*/
/************   OVRDBF     FILE(SCICDPPD) SEQONLY(*YES 100)           /*S01464*/
                OVRDBF     FILE(XSESCFAPD) SEQONLY(*YES 100)          /*S01464*/
                OVRDBF     FILE(SESCFAPD) SEQONLY(*YES 100)           /*S01464*/
                OVRDBF     FILE(XSDSCFEPD) SEQONLY(*YES 100)          /*S01464*/
                OVRDBF     FILE(SDSCFEPD) SEQONLY(*YES 100)           /*S01464*/
                OVRDBF     FILE(XGESCPD) SEQONLY(*YES 100)
                OVRDBF     FILE(GESCPD) SEQONLY(*YES 100)
                OVRDBF     FILE(XGESCZZ) SEQONLY(*YES 100)
                OVRDBF     FILE(GESCZZ) SEQONLY(*YES 100)
/************   OVRDBF     FILE(XSCOCFSPD) SEQONLY(*YES 100)          /*S01464*/
/************   OVRDBF     FILE(SCOCFSPD) SEQONLY(*YES 100)           /*S01464*/
                OVRDBF     FILE(XSEOCFSPD) SEQONLY(*YES 100)          /*S01464*/
                OVRDBF     FILE(SEOCFSPD) SEQONLY(*YES 100)           /*S01464*/
 
/*  AND COPY FILES                                                  */
 
/************   CPYF       FROMFILE(XSCSCFAPD) TOFILE(SCSCFAPD) +     /*S01464*/
/************               MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01464*/
/************   MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*S01464*/
/************               EXEC(CLRPFM SCSCFAPD)                     /*S01464*/
/************   CPYF       FROMFILE(XSCICDPPD) TOFILE(SCICDPPD) +     /*S01464*/
/************               MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01464*/
/************   MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*S01464*/
/************               EXEC(CLRPFM SCICDPPD)                     /*S01464*/
                CPYF       FROMFILE(XSESCFAPD) TOFILE(SESCFAPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01464*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SESCFAPD)                     /*S01464*/
                CPYF       FROMFILE(XSDSCFEPD) TOFILE(SDSCFEPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01464*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SDSCFEPD)                     /*S01464*/
                CPYF       FROMFILE(XGESCPD) TOFILE(GESCPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM GESCPD)
                CPYF       FROMFILE(XGESCZZ) TOFILE(GESCZZ) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM GESCZZ)
/************   CPYF       FROMFILE(XSCOCFSPD) TOFILE(SCOCFSPD) +     /*S01464*/
/************               MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01464*/
/************   MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*S01464*/
/************               EXEC(CLRPFM SCOCFSPD)                     /*S01464*/
                CPYF       FROMFILE(XSEOCFSPD) TOFILE(SEOCFSPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01464*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SEOCFSPD)                     /*S01464*/
/*/COPY WNCPYSRC,SEC6420001                                          */
 
/*  CHANGE DATA AREA TO 'OLD'                                      */
 
                CHGVAR     VAR(&STATUS) VALUE('N')                   /*S01355*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)     /*S01355*/
/************** CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')***********S01355*/
 
             ENDDO
 
/*  ELSE BACKUP FILES                                               */
 
             ELSE       CMD(DO)
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
/************   OVRDBF     FILE(SCSCFAPD)  SEQONLY(*YES 100)          /*S01464*/
/************   OVRDBF     FILE(XSCSCFAPD) SEQONLY(*YES 100)          /*S01464*/
/************   OVRDBF     FILE(SCICDPPD)  SEQONLY(*YES 100)          /*S01464*/
/************   OVRDBF     FILE(XSCICDPPD) SEQONLY(*YES 100)          /*S01464*/
                OVRDBF     FILE(SESCFAPD)  SEQONLY(*YES 100)          /*S01464*/
                OVRDBF     FILE(XSESCFAPD) SEQONLY(*YES 100)          /*S01464*/
                OVRDBF     FILE(SDSCFEPD)  SEQONLY(*YES 100)          /*S01464*/
                OVRDBF     FILE(XSDSCFEPD) SEQONLY(*YES 100)          /*S01464*/
                OVRDBF     FILE(GESCPD)  SEQONLY(*YES 100)
                OVRDBF     FILE(XGESCPD) SEQONLY(*YES 100)
                OVRDBF     FILE(GESCZZ)  SEQONLY(*YES 100)
                OVRDBF     FILE(XGESCZZ) SEQONLY(*YES 100)
/************   OVRDBF     FILE(SCOCFSPD)  SEQONLY(*YES 100)          /*S01464*/
/************   OVRDBF     FILE(XSCOCFSPD) SEQONLY(*YES 100)          /*S01464*/
                OVRDBF     FILE(SEOCFSPD)  SEQONLY(*YES 100)          /*S01464*/
                OVRDBF     FILE(XSEOCFSPD) SEQONLY(*YES 100)          /*S01464*/
 
/* DELETE COPY FILES                               */
 
/************   DLTF       FILE(XSCSCFAPD)                            /*S01464*/
                DLTF       FILE(XSESCFAPD)                            /*S01464*/
                   MONMSG MSGID(CPF0000)
/************   DLTF       FILE(XSCICDPPD)                            /*S01464*/
                DLTF       FILE(XSDSCFEPD)                            /*S01464*/
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XGESCPD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XGESCZZ)
                   MONMSG MSGID(CPF0000)
/************   DLTF       FILE(XSCOCFSPD)                            /*S01464*/
                DLTF       FILE(XSEOCFSPD)                            /*S01464*/
                   MONMSG MSGID(CPF0000)
 
/*  AND COPY FILES                                                 */
 
/************   CPYF      FROMFILE(SCSCFAPD) TOFILE(&TOLIB/XSCSCFAPD)+/*S01464*/
/************           MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  /*S01464*/
/************   MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*S01464*/
/************              EXEC(CLRPFM XSCSCFAPD)                     /*S01464*/
/************   CPYF     FROMFILE(SCICDPPD) TOFILE(&TOLIB/XSCICDPPD) +/*S01464*/
/************           MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  /*S01464*/
/************   MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*S01464*/
/************              EXEC(CLRPFM XSCICDPPD)                     /*S01464*/
                CPYF      FROMFILE(SESCFAPD) TOFILE(&TOLIB/XSESCFAPD) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  /*S01464*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSESCFAPD)                     /*S01464*/
                CPYF      FROMFILE(SDSCFEPD) TOFILE(&TOLIB/XSDSCFEPD) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  /*S01464*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSDSCFEPD)                     /*S01464*/
                CPYF      FROMFILE(GESCPD) TOFILE(&TOLIB/XGESCPD) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XGESCPD)
                CPYF      FROMFILE(GESCZZ) TOFILE(&TOLIB/XGESCZZ) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XGESCZZ)
/************   CPYF      FROMFILE(SCOCFSPD) TOFILE(&TOLIB/XSCOCFSPD)+/*S01464*/
/************           MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  /*S01464*/
/************   MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*S01464*/
/************              EXEC(CLRPFM XSCOCFSPD)                     /*S01464*/
                CPYF      FROMFILE(SEOCFSPD) TOFILE(&TOLIB/XSEOCFSPD) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  /*S01464*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSEOCFSPD)                     /*S01464*/
/*/COPY WNCPYSRC,SEC6420002                                          */
 
             ENDDO
 
/*  CHANGE DATA AREA TO 'NEW'                                       */
 
 /********** CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')**********/ /*S01355*/
             CHGVAR     VAR(&STATUS) VALUE('Y')                      /*S01355*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)        /*S01355*/
/**/
             CALL       PGM(SE6420)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01464*/
/************    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*S01464*/
/*                                                                    /*R00300*/
/************    SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)+/*S01464*/
/************             TOMSGQ(MOPERQ MRUNQ)                        /*S01464*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01464*/
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)           /*S01464*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                             MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ) /*S01464*/
             ENDDO
 
/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD"                       */
/*                    AND TRANSFERS DONE TODAY INDICATOR TO "NO"   */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
                CHGVAR     VAR(&STATUS) VALUE('N')                   /*S01355*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)     /*S01355*/
/***************CHGDTAARA**DTAARA(SESTAT (1 3)) VALUE('OLD')***********S01355*/
/************   DLTF       FILE(XSCSCFAPD)                            /*S01464*/
                DLTF       FILE(XSESCFAPD)                            /*S01464*/
                   MONMSG MSGID(CPF0000)
/***************DLTF       FILE(XSCICDPPD)                            /*S01464*/
                DLTF       FILE(XSDSCFEPD)                            /*S01464*/
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XGESCPD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XGESCZZ)
                   MONMSG MSGID(CPF0000)
/************   DLTF       FILE(XSCOCFSPD)                            /*S01464*/
                DLTF       FILE(XSEOCFSPD)                            /*S01464*/
                   MONMSG MSGID(CPF0000)
             ENDDO
 
/* >>> SESCS >>> */
             ENDDO
 
/*********** ENDPGM                                                   ********/
/***END:*********ENDPGM                                               /*S01464*/
/* <<< SESCS <<< */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
          ENDPGM                                                      /*S01464*/
