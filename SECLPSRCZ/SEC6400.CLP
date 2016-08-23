/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Check safe custody fee dates')                  */
/********************************************************************/
/*                                                                  */
/*          MIDAS SECURITIES TRADING MODULE                         */
/*                                                                  */
/*          SEC6400    CHECK SAFE CUSTODY CONTROL DATES             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 11MAY95              */
/*       PREV AMEND NO. S01464             DATE 04APR94             */
/*     +                049421     BZ      DATE 19JAN93             */
/*                      SESCS              DATE 28AUG92             */
/*                      S01355             DATE 06MAY92             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       S01408 - Addition of core hook SEC6400MP1                   */
/*       S01464  -  Safe Custody Fees.                              */
/*       049421  -  HEADER BOX STANDARDISATION                      */
/*       SESCS   -  SAFE CUSTODY FEES SWITCHABLE                    */
/*       S01355  -  RELEASE 3 INCORPORATION                         */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM  ************************************/               /*S01355*/
/************PGM        PARM(&CNAM &CSEQ)*************/      /*S01355* *S01464*/
             PGM        PARM(&CNAM &CSEQ &MODE)                       /*S01464*/
/* DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)                /*S01464*/
/************DCL********VAR(&BUSY)**TYPE(*CHAR)*LEN(3)*************/ /*S01355*/
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)              /*S01355*/
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)              /*S01355*/
             DCL        VAR(&MODE)  TYPE(*CHAR) LEN(1)               /*S01464*/
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')  /*S01355*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
/************DCL        VAR(&SCSW) TYPE(*CHAR) LEN(1)        /*SESCS* /*S01464*/
 
             DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ') /*S01464*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ') /*S01464*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)                 /*S01464*/
             DCL       VAR(&MEM) TYPE(*CHAR) LEN(50)                  /*S01464*/
 
/************RTVDTAARA  DTAARA(LZSTAT (28 1)) RTNVAR(&SCSW)  /*SESCS  /*S01464*/
/************IF         COND(&SCSW *EQ 'Y') THEN(DO)         /*SESCS  /*S01464*/
/* */                                                                 /*S01464*/
/* Check Safe Custody Fees flag on Securities Trading ICD             /*S01464*/
/* */                                                                 /*S01464*/
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)          /*S01464*/
/* */                                                                 /*S01464*/
             IF         COND((%SST(&FMT 189 1) *EQ 'Y') *AND (&RTCD +
                          *EQ '       ')) THEN(DO)                   /*S01464*/
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)        /*S01355*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
 /**         CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')           /*S01464*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01464*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC6400MP1                                          */
                                                                      /*S01408*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('SEC6400 - Check safe custody control +
                          dates') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CLEAR OUT POSTINGS FILES */
             IF         COND(&MODE = ' ') THEN(DO)                    /*S01464*/
             CLRPFM     FILE(GESCPD)
             CLRPFM     FILE(GESCZZ)
             ENDDO                                                    /*S01464*/
             ELSE       CMD(DO)                                       /*S01464*/
             CLRPFM     FILE(GESC1PD)                                 /*S01464*/
             CLRPFM     FILE(GESC1ZZ)                                 /*S01464*/
             ENDDO                                                    /*S01464*/
 
/*  CHECK FOR COMPONENT RESTART                                     */
 
/**********  RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)*********/ /*S01355*/
 
/*  IF RESTART, OVERRIDE TO SEQONLY(*YES 100)                       */
 
/************IF*********COND(&BUSY = 'NEW') THEN(DO)***************/ /*S01355*/
             IF         COND(&STATUS = 'Y') THEN(DO)                 /*S01355*/
 
/*  COPY FILES                                                      */
 
/***************CPYF       FROMFILE(XSCICDPPD) TOFILE(SCICDPPD) +     /*S01464*/
/***************            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01464*/
/***************MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*S01464*/
/***************            EXEC(CLRPFM SCICDPPD)                     /*S01464*/
                CPYF       FROMFILE(XSDSCFEPD) TOFILE(SDSCFEPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01464*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SDSCFEPD)                     /*S01464*/
 
/*  CHANGE DATA AREA TO 'OLD'                                      */
 
                CHGVAR     VAR(&STATUS) VALUE('N')                   /*S01355*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)     /*S01355*/
/************** CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')***********S01355*/
 
             ENDDO
 
/*  ELSE BACKUP FILES                                               */
 
             ELSE       CMD(DO)
 
/* DELETE COPY FILES                               */
 
/***************DLTF       FILE(XSCICDPPD)                            /*S01464*/
                DLTF       FILE(XSDSCFEPD)                            /*S01464*/
                   MONMSG MSGID(CPF0000)
 
/*  AND COPY FILES                                                 */
 
/***************CPYF      FROMFILE(SCICDPPD) TOFILE(&TOLIB/XSCICDPPD)+/*S01464*/
/***************        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  /*S01464*/
/***************MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*S01464*/
/***************           EXEC(CLRPFM XSCICDPPD)                     /*S01464*/
                CPYF      FROMFILE(SDSCFEPD) TOFILE(&TOLIB/XSDSCFEPD) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  /*S01464*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSDSCFEPD)                     /*S01464*/
 
             ENDDO
 
 /************* CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')*******/ /*S01355*/
                CHGVAR     VAR(&STATUS) VALUE('Y')                   /*S01355*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)     /*S01355*/
 
/* CALL RPG PROGRAM */
             CALL       PGM(SE6400)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01464*/
/***************                                           /*R00300*/ /*S01464*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01464*/
/***************             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01464*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01464*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)        /*S01464*/
/*                                                                    /*R00300*/
             ENDDO
 
/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD"                       */
/*                    AND TRANSFERS DONE TODAY INDICATOR TO "NO"   */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
                CHGVAR     VAR(&STATUS) VALUE('N')                   /*S01355*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)     /*S01355*/
/***************CHGDTAARA**DTAARA(SESTAT (1 3)) VALUE('OLD')***********S01355*/
/***************DLTF       FILE(XSCICDPPD)                            /*S01464*/
                DLTF       FILE(XSDSCFEPD)                            /*S01464*/
                   MONMSG MSGID(CPF0000)
             ENDDO
 
             ENDDO                                                 /* SESCS */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
