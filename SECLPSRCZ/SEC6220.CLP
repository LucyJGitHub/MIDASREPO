/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Customer/instrument fee codes audit')           */
/*********************************************************************/
/*                                                                   */
/*          Midas     SECURITIES TRADING MODULE                      */
/*                                                                   */
/*          SEC6220    CUSTOMER / INSTRUMENT CUSTODY FEE CODES REPORT*/
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
/*       PREV AMEND NO. S01464             DATE 04APR94              */
/*                      049421     BZ      DATE 19JAN93              */
/*                      SESCS              DATE 28AUG92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       S01464  -  Safe Custody Fees.                               */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       SESCS   -  SAFE CUSTODY FEES SWITCHABLE                     */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &RSEQ &RLEV &RENT)                 /*S01464*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                      /*S01464*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01464*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01464*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01464*/
                                                                      /*S01464*/
             DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ') /*S01464*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ') /*S01464*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)                 /*S01464*/
                                                                      /*S01464*/
             DCL        VAR(&MRDT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)                /*S01464*/
/************DCL        VAR(&SCSW) TYPE(*CHAR) LEN(1)        /*SESCS  /*S01464*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01464*/
 
/************RTVDTAARA  DTAARA(LZSTAT (28 1)) RTNVAR(&SCSW)  /*SESCS  /*S01464*/
/************IF         COND(&SCSW *EQ 'Y') THEN(DO)         /*SESCS  /*S01464*/
/* */                                                                 /*S01464*/
/* Check Safe Custody Fees flag on Securities Trading ICD             /*S01464*/
/* */                                                                 /*S01464*/
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)          /*S01464*/
/* */                                                                 /*S01464*/
             IF         COND((%SST(&FMT 189 1) *EQ 'Y') *AND (&RTCD +
                          *EQ '       ')) THEN(DO)                    /*S01464*/
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* IF REPORT RUNNING IN INPUT CYCLE CALL SE6220 WITH PARAMETER '2'   */
             IF         COND(&MODE *EQ '2') THEN(DO)                  /*S01464*/
 
/************OVRDBF     FILE(SCCICFPD) SHARE(*YES)                    /*S01464*/
             OVRDBF     FILE(SECICFPD) SHARE(*YES)                    /*S01464*/
 
/************OPNQRYF    FILE((SCCICFPD)) QRYSLT('SCRECI *EQ ''D''') + /*S01464*/
/************             KEYFLD(*FILE) +                             /*S01464*/
             OPNQRYF    FILE((SECICFPD)) QRYSLT('SCRECI *EQ ''D''') +
                          KEYFLD(*FILE)                               /*S01464*/
 
/************CALL       PGM(SE6220) PARM('2')                         /*S01464*/
             CALL       PGM(SE6220) PARM('2' &RSEQ)                   /*S01464*/
 
/************CLOF       OPNID(SCCICFPD)                               /*S01464*/
/************DLTOVR     FILE(SCCICFPD)                                /*S01464*/
             CLOF       OPNID(SECICFPD)                               /*S01464*/
             DLTOVR     FILE(SECICFPD)                                /*S01464*/
             ENDDO
 
/* IF REPORT RUNNING IN COB SELECT RECORDS CHANGED TODAY BEFORE      */
/* CALLING SE6220 WITH PARAMETER OF '1'                              */
             ELSE       CMD(DO)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('SEC6220 - Customer / Instrument Custody +
                          Fee Codes Audit Report') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
             RTVDTAARA  DTAARA(SDSTAT (117 5)) RTNVAR(&MRDT)
 
/* SELECT RECORDS CHANGED TODAY */
 
/************OVRDBF     FILE(SCCICFPD) SHARE(*YES)                    /*S01464*/
 
/************OPNQRYF    FILE((SCCICFPD)) QRYSLT('"' *CAT &MRDT *CAT + /*S01464*/
/************             '" *EQ RDATE') KEYFLD(*FILE) +              /*S01464*/
/************             MAPFLD((WDATE SCLCD *ZONED 5) (RDATE +      /*S01464*/
/************             WDATE *CHAR 5))                             /*S01464*/
             OVRDBF     FILE(SECICFPD) SHARE(*YES)                    /*S01464*/
                                                                      /*S01464*/
             OPNQRYF    FILE((SECICFPD)) QRYSLT('"' *CAT &MRDT *CAT +
                          '" *EQ RDATE') KEYFLD(*FILE) +
                          MAPFLD((WDATE SCLCD *ZONED 5) (RDATE +
                          WDATE *CHAR 5))                             /*S01464*/
 
/************CALL       PGM(SE6220) PARM('1')                         /*S01464*/
             CALL       PGM(SE6220) PARM('1' &RSEQ)                   /*S01464*/
 
/************CLOF       OPNID(SCCICFPD)                               /*S01464*/
/************DLTOVR     FILE(SCCICFPD)                                /*S01464*/
             CLOF       OPNID(SECICFPD)                               /*S01464*/
             DLTOVR     FILE(SECICFPD)                                /*S01464*/
 
             ENDDO
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01464*/
/***************                                           /*R00300*/ /*S01464*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG)MSGDTA(&DATA)+/*S01464*/
/***************             TOMSGQ(MOPERQ MRUNQ)                     /*S01464*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01464*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)        /*S01464*/
/*                                                                    /*R00300*/
             ENDDO
 
             ENDDO                                                 /* SESCS */
                                                                      /*S01464*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM:   ENDPGM
