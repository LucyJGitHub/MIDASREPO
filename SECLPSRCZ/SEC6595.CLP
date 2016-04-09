/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Customer charge groups audit report')        */
/*********************************************************************/
/*                                                                   */
/*  Midas - Securities Trading Module                            */
/*                                                                   */
/*  SEC6595 - Customer Groups Audit/List Report                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. S01496                  DATE 27OCT94              */
/*  PREV AMEND NO. S10984                  DATE 10MAY93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  S01496 - Incorporation of JYSKE Enhancements (S10984)            */
/*  S10984 - JYSZRH: Customer Groups for SE Charges                  */
/*           (copy of CLP/SEC6210)                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&MODE)                                */ /*S01496*/
             PGM        PARM(&MODE &RSEQ &RLEV &RENT)                 /*S01496*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01496*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01496*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01496*/
             DCL        VAR(&MRDT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) +
                           VALUE('       ')                           /*S01496*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                           VALUE('*FIRST ')                           /*S01496*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*S01496*/
 
/*********** DCLF       FILE(SDSTRDPD)                             */ /*S01496*/
/**/                                                                  /*S01496*/
/*  Check Autocharge Option flag on Securities Trading ICD.           /*S01496*/
/**/                                                                  /*S01496*/
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)          /*S01496*/
/**/                                                                  /*S01496*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*S01496*/
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* IF REPORT RUNNING IN INPUT CYCLE CALL SE6595 WITH PARAMETER '2'   */
             IF         COND(&MODE *EQ '2') THEN(DO)
 
/*********** RCVF                                                  */ /*S01496*/
 
/*********** IF         COND(&BVCUGR *NE 'Y') THEN(DO)             */ /*S01496*/
             IF         COND(%SST(&FMT 175 1) *NE 'Y') THEN(DO)       /*S01496*/
                    SNDPGMMSG  MSG('Option not allowed, Charge by Customer +
                          Groups not installed') TOPGMQ(*EXT)
                    GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             OVRDBF     FILE(SECUGRPD) SHARE(*YES)
             OPNQRYF    FILE((SECUGRPD)) QRYSLT('CGRECI *NE ''*''') +
                          KEYFLD(*FILE)
/*********** CALL       PGM(SE6595) PARM('2')                      */ /*S01496*/
             CALL       PGM(SE6595) PARM('2' &RSEQ)                   /*S01496*/
             CLOF       OPNID(SECUGRPD)
             DLTOVR     FILE(SECUGRPD)
             ENDDO
 
/* IF REPORT RUNNING IN COB SELECT RECORDS CHANGED TODAY BEFORE      */
/* CALLING SE6595 WITH PARAMETER OF '1'                              */
             ELSE       CMD(DO)
 
/*********** IF         COND(&BVCUGR *NE 'Y') THEN(GOTO CMDLBL(END */ /*S01496*/
             IF         COND(%SST(&FMT 175 1) *NE 'Y') THEN(DO)       /*S01496*/
                GOTO       CMDLBL(ENDPGM)                             /*S01496*/
             ENDDO                                                    /*S01496*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('SEC6595 - SE Customer Groups audit +
                          report') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             RTVDTAARA  DTAARA(SDSTAT (117 5)) RTNVAR(&MRDT)
 
/* SELECT RECORDS CHANGED TODAY */
 
             OVRDBF     FILE(SECUGRPD) SHARE(*YES)
             OPNQRYF    FILE((SECUGRPD)) +
                          QRYSLT('RDATE *EQ "' *CAT &MRDT *CAT '"') +
                          KEYFLD(*FILE) MAPFLD((WDATE CGLCD *ZONED +
                          5) (RDATE WDATE *CHAR 5))
 
/*********** CALL       PGM(SE6595) PARM('1')                      */ /*S01496*/
             CALL       PGM(SE6595) PARM('1' &RSEQ)                   /*S01496*/
             CLOF       OPNID(SECUGRPD)
             DLTOVR     FILE(SECUGRPD)
             ENDDO
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*S01496*/
                CHGVAR VAR(&MEM) VALUE('SEC6595 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
             ENDDO                                                    /*S01496*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
