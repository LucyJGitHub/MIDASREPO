/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Rollover Warning Period Rep (EOD)')          */
/*********************************************************************/
/*                                                                   */
/*       Midas   MONEY MARKET MODULE                                 */
/*                                                                   */
/*       MMC5330 - ROLLOVER WARNING PERIOD REPORT  (EOD)             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. 245795             Date 26Feb07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG8020            Date 08Aug05              */
/*                      CSD027             Date 07Jun06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      086493             Date 16Jun95              */
/*                      076467             Date 20Dec94              */
/*                      066155             Date 27Jan94              */
/*                      S01434             Date 26Jul93              */
/*                      049421             Date 18Jan93              */
/*                      ROLLO              Date 19Aug92              */
/*                      34682              Date 20Jan92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       245795 - Include branch in the key fields.                  */
/*       BUG8020 - Rollover Warning Report                           */
/*       CSD027  - Change Customer Number to alpha.                  */
/*       086493  - Deal Type IL & ID are not to be reported          */
/*       076467  - REPORT ONLY DEALS WITH AUTOMATIC ROLLOVER IND     */
/*                 EQUAL 'Y'                                         */
/*       066155  - Multibranching Changes                            */
/*       S01434  - Enhanced Rollovers                                */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       ROLLO  -  SWITCHABLE ROLLOVER CONFIRMATIONS                 */
/*       34682  -  REPORT MUST BE PRODUCED FOR TYPE 'TD' ONLY.       */
/*********************************************************************/
 
/************PGM                                                        S01434*/
             PGM        PARM(&RUN &RSEQ &RLEV &RENT)                  /*S01434*/
 
/* DECLARE VARIABLES */
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(1)                  /*S01434*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01434*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01434*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01434*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(256)             /*066155*/
             DCL        VAR(&QRYSL1) TYPE(*CHAR) LEN(50)              /*066155*/
             DCL        VAR(&QRYSL2) TYPE(*CHAR) LEN(200)             /*066155*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('Rollover Warning Period Report - +
                          MMC5330') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/*  Override open query file                                                  */
 
/*           OVRDBF     FILE(MMDELDPO) TOFILE(*LIBL/MMDELDPP) +
                          SHARE(*YES)                                 /*S01434*/
/*           MONMSG     MSGID(CPF0000)                                /*S01434*/
 
/**********  OVRDBF     FILE(MMDELDPO) TOFILE(*LIBL/MMDELDPP) +       /*076467*/
/**********               SHARE(*YES)                      /*S01434*/ /*076467*/
/**********  OVRDBF     FILE(MMDELDPO) TOFILE(*LIBL/MMDELDL1) +                       */ /*BUG8020*/
/**********               SHARE(*YES)                                      */ /*076467*/ /*BUG8020*/
             OVRDBF     FILE(MMDELDPO) TOFILE(*LIBL/MMDELDL8) +
                          SHARE(*YES)                                                    /*BUG8020*/
             MONMSG     MSGID(CPF0000)                                /*S01434*/
 
/* 34682 BEGIN  */
/*           OPNQRYF    FILE((*LIBL/MMDELDPP) (SDCUSTPD)) +
                          FORMAT(MMDELDPO) QRYSLT('(HKTYPE *NE +
                          "IP") *AND (HKTYPE *NE "IT")') +
                          KEYFLD((2/BBACOC) (1/HKMDYY) (1/HKMDMM) +
                          (1/HKMDDD) (1/HKCNUM) (1/HKCCY) +
                          (1/HKDN38)) JFLD((1/HKCNUM +
                          *MAPFLD/WWCUST)) MAPFLD((WWCUST BBCUST +
                          *ZONED 6 0))                     */
/*           OPNQRYF    FILE((*LIBL/MMDELDPP) (SDCUSTPD)) +
                          FORMAT(MMDELDPO) QRYSLT('(HKTYPE *EQ +
                          "TD")') KEYFLD((2/BBACOC) (1/HKMDYY) +
                          (1/HKMDMM) (1/HKMDDD) (1/HKCNUM) +
                          (1/HKCCY) (1/HKDN38)) JFLD((1/HKCNUM +
                          *MAPFLD/WWCUST)) MAPFLD((WWCUST BBCUST +
                          *ZONED 6 0))                                  S01434*/
                                                           /*S01434*/ /*066155*/
/*           OPNQRYF    FILE((MMDELDPP) (SDCUSTPD)) +
                          FORMAT(MMDELDPO) QRYSLT('(HKTYPE *NE +
                          "CD") *AND (HKTYPE *NE "CL") *AND (HKTYPE +
                          *NE "CI") *AND (HKDDLT *NE "D")') +
                          KEYFLD((2/BBACOC) (1/HKMDYY) +
                          (1/HKMDMM) (1/HKMDDD) (1/HKCNUM) +
                          (1/HKCCY) (1/HKDN38)) JFLD((1/HKCNUM +
                          *MAPFLD/WWCUST)) MAPFLD((WWCUST BBCUST +
                          *ZONED 6 0))                     /*S01434*/ /*066155*/
                                                                      /*066155*/
/*** If Branch level select records for specified branch only ***/
 
             IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')  ) +
                 THEN(DO)
                 CHGVAR     VAR(&QRYSL1) VALUE('*AND (HKBRCA="' *CAT +
                            &RENT *CAT '")')
             ENDDO
 
/*** Set up &QRYSLT parameter to select records ***/
/*********** CHGVAR     VAR(&QRYSL2) VALUE('(HKTYPE *NE "CD") *AND +   *086493*/
/***********              (HKTYPE *NE "CL") *AND (HKTYPE *NE "CI") +   *086493*/
/***********              *AND (HKDDLT *NE "D")')                      *086493*/
             CHGVAR     VAR(&QRYSL2) VALUE('(HKTYPE *NE "CD") *AND +
                          (HKTYPE *NE "CL") *AND (HKTYPE *NE "CI") +
                          *AND (HKTYPE *NE "IL") *AND (HKTYPE *NE +
                          "ID") *AND (HKDDLT *NE "D")')               /*086493*/
             CHGVAR     &QRYSLT (&QRYSL2 *BCAT &QRYSL1)
 
/*********** OPNQRYF  FILE((MMDELDPP) (SDCUSTPD)) +
/***********              FORMAT(MMDELDPO) QRYSLT(&QRYSLT) +
/***********              KEYFLD((1/HKBRCA) (2/BBACOC) (1/HKMDYY) +
/***********              (1/HKMDMM) (1/HKMDDD) (1/HKCNUM) +
/***********              (1/HKCCY) (1/HKDN38)) JFLD((1/HKCNUM +
/***********              *MAPFLD/WWCUST)) MAPFLD((WWCUST BBCUST +
/***********              *ZONED 6 0)) **/                            /*076467*/
/**********  OPNQRYF  FILE((MMDELDL1) (SDCUSTPD)) +
/**********               FORMAT(MMDELDPO) QRYSLT(&QRYSLT) +
/**********               KEYFLD((1/HKBRCA) (2/BBACOC) (1/HKMDYY) +
/**********               (1/HKMDMM) (1/HKMDDD) (1/HKCNUM) +
/**********               (1/HKCCY) (1/HKDN38)) JFLD((1/HKCNUM +
/**********               *MAPFLD/WWCUST)) MAPFLD((WWCUST BBCUST +
/**********               *ZONED 6 0))                                        /*076467*/  /*CSD027*/
/**********  OPNQRYF    FILE((MMDELDL1) (SDCUSTPD)) FORMAT(MMDELDPO) +                */ /*BUG8020*/
/**********               QRYSLT(&QRYSLT) KEYFLD((1/HKBRCA) +                         */ /*BUG8020*/
/**********               (2/BBACOC) (1/HKMDYY) (1/HKMDMM) +                          */ /*BUG8020*/
/**********               (1/HKMDDD) (1/HKCNUM) (1/HKCCY) +                           */ /*BUG8020*/
/**********               (1/HKDN38)) JFLD((1/HKCNUM +                                */ /*BUG8020*/
/**********               *MAPFLD/WWCUST)) MAPFLD((WWCUST BBCUST +                    */ /*BUG8020*/
/**********               *CHAR 6))                                        */ /*CSD027*/ /*BUG8020*/
/**********  OPNQRYF    FILE((MMDELDL8) (SDCUSTPD)) FORMAT(MMDELDPO) +                 */ /*245795*/
/**********               QRYSLT(&QRYSLT) KEYFLD((1/HKBRCA) +                          */ /*245795*/
/**********               (2/BBACOC) (1/HKMDYY) (1/HKMDMM) +                           */ /*245795*/
/**********               (1/HKMDDD) (1/HKCNUM) (1/HKCCY) +                            */ /*245795*/
/**********               (1/HKDN38)) JFLD((1/HKCNUM +                                 */ /*245795*/
/**********               *MAPFLD/WWCUST)) MAPFLD((WWCUST BBCUST +                     */ /*245795*/
/**********               *CHAR 6))                                        */ /*BUG8020*/ /*245795*/
             OPNQRYF    FILE((MMDELDL8) (SDCUSTPD)) FORMAT(MMDELDPO) +
                          QRYSLT(&QRYSLT) KEYFLD((1/HKBRCA) +
                          (1/HKAURO) (2/BBACOC) (1/HKMDYY) +
                          (1/HKMDMM) (1/HKMDDD) (1/HKCNUM) +
                          (1/HKCCY) (1/HKDN38)) JFLD((1/HKCNUM +
                          *MAPFLD/WWCUST)) MAPFLD((WWCUST BBCUST +
                          *CHAR 6))                                                       /*245795*/
                                                                      /*066155*/
/* 34682 END    */
/* CALL PROGRAM */
/*********   CALL       PGM(MM5330) PARM(&RUN &RSEQ)       /*S01434*/ /*066155*/
             CALL       PGM(MM5330) PARM(&RUN &RSEQ &RENT)            /*S01434*/
 
/**********  CLOF       OPNID(MMDELDPP) **/                           /*076467*/
/**********  CLOF       OPNID(MMDELDL1)                                    */ /*076467*/ /*BUG8020*/
             CLOF       OPNID(MMDELDL8)                                                  /*BUG8020*/
             DLTOVR     FILE(MMDELDPO)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*           RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)              S01434*/
/*           SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRSMG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                          S01434*/
             RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)            /*S01434*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(GBDRSMM) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01434*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/*           RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)              S01434*/
/*           SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                          S01434*/
             RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)            /*S01434*/
             SNDPGMMSG  MSGID(MMM1066) MSGF(GBDRSMM) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01434*/
             ENDDO
 
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
