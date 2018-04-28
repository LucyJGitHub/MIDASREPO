/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Forward Recovery Reporting')                    */
/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                     */
/*                                                                  */
/*       SDC1790 FORWARD RECOVERY REPORTING                         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E22987          DATE 26JUL90                */
/*       PREV AMEND NO. S01194          DATE 21FEB90                */
/*                      E13205          DATE 10/03/89               */
/*                      S01179          DATE 13/09/88               */
/*                      S01127          DATE 02/06/88               */
/*                      E11956          DATE 23/05/88               */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       E22987 - REMOVE OLD HELP PROCESSING                        */
/*       S01194 - NEW STANDING DATA                                 * /*S01194*/
/*       E13205 - a)Allow copy from JRNEX1 to cope with an empty    * /*E13205*/
/*                  JRNEX2                                          * /*E13205*/
/*                b)Check parameter PARM is greater 0 for           * /*E13205*/
/*                  options 3 and 4                                 * /*E13205*/
/*                C)Select records outside 'ER' by calling SD1797   * /*E13205*/
/*       S01179 - AS400 CONVERSION                                  */
/*       S01127 - CHANGE JOURNAL CODE 'SR' TO 'IR'                  */
/*       E11956 - FILES JRNEX1 AND JRNEX2 HAVE DIFFERENT FORMATS    * /*E11956*/
/*                                                                  */
/********************************************************************/
             PGM
/**/
/*           DECLARE FILE, DATA AREA AND VARIABLES                   */
/**/
             DCLF       FILE(SD1790FM)
/**********  DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
             DCL        VAR(&BKPS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CURRCV) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ENTDTA) TYPE(*CHAR) LEN(135)
             DCL        VAR(&ENTRY) TYPE(*CHAR) LEN(125)
             DCL        VAR(&FROMTM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FROMDT) TYPE(*CHAR) LEN(6)
/************DCL********VAR(&HBPGM) TYPE(*CHAR) LEN(8) VALUE('RR1790')/*E22987*/
/************DCL********VAR(&HERCD) TYPE(*CHAR) LEN(80)               /*E22987*/
             DCL        VAR(&LRTP) TYPE(*CHAR) LEN(10)
/***         DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&OPTN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&PARM2) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&SQNRTP) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&SUCC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TOTM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TODT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           GLOBAL MONITOR MESSAGE                                  */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Forward Recovery Reporting') +
                          TOMSGQ(MRUNQ)
/**/
/*   Check JNSTAT to make sure pgm being run on primary machine      */
/**/
             RTVDTAARA  DTAARA(JNSTAT (82 1)) RTNVAR(&BKPS)
             IF         COND(&BKPS *NE 'P') THEN(DO)
                SNDPGMMSG  MSG('This option can only be run on +
                                the primary machine') +
                                MSGTYPE(*INQ) TOPGMQ(*EXT)
                CHGJOB     SWS(XXXXXX1X)
                GOTO       END
             ENDDO
/**/
/*  CHECK JNSTAT TO SEE IF A SUCCESSFUL RECOVERY HAS BEEN RUN TODAY  */
/**/
             RTVDTAARA  DTAARA(JNSTAT (74 1)) RTNVAR(&SUCC)
/**/
             IF         COND(&SUCC *EQ 'Y') THEN(DO)
/**/
/*  OUTPUT PROMPT SCREEN & CALL HELP PROGRAM IF REQUESTED            */
/**/
SCRN:           SNDRCVF    RCDFMT(SD1790F1)
/***************IF         COND(&IN01 *EQ '1') THEN(DO)            */ /*E22987*/
/***************   CALL       PGM(MHELP) PARM(&HBPGM &HERCD)       */ /*E22987*/
/***************   GOTO       SCRN                                 */ /*E22987*/
/***************ENDDO                                              */ /*E22987*/
/**/
                IF         COND(&OPTN *EQ 23) THEN(GOTO END)
                IF         COND(&OPTN *EQ 24) THEN(SIGNOFF *LIST)
/*                                                                */ /*E13205*/
/*  Check that PARM is greater than 1 for option 3 and 4          */ /*E13205*/
/*                                                                */ /*E13205*/
             IF         COND((&OPTN *EQ 3) *OR (&OPTN *EQ 4)) THEN(DO)
             IF         COND(&PARM2 *LE 0) THEN(GOTO CMDLBL(SCRN))   /*E13205*/
             ENDDO                                                   /*E13205*/
/*                                                                */ /*E13205*/
/**/
/*  OBTAIN SEQUENCE NO. OF 'RECOVER TO' POINT FROM LAST 'ER' ENTRY   */
/*  IN THE JOURNAL                                                   */
/**/
/*           RTVJRNE    JRN(ICJRN) FROMENT(*LAST) TOENT(*FIRST) +  */ /*E13205*/
/*                        SEARCH(*DESCEND) JRNCDE(U) ENTTYP(ER) +  */ /*E13205*/
/*                        RTNSEQNBR(&SQNRTP) RTNJRNE(&ENTDTA)      */ /*E13205*/
             RTVDTAARA  DTAARA(JNSTAT (1 8)) RTNVAR(&CURRCV)          /*E13205*/
             RTVJRNE    JRN(ICJRN) RCVRNG(&CURRCV ICRCV001) +
                          FROMENT(*LAST) TOENT(*FIRST) +
                          SEARCH(*DESCEND) JRNCDE(U) ENTTYP(ER) +
                          RTNSEQNBR(&SQNRTP) RTNJRNE(&ENTDTA)         /*E13205*/
                CHGVAR     VAR(&LRTP) VALUE(%SST(&ENTDTA 126 10))
/**/
/*  IF REPORT REQUESTED IS 'LAST XX TRANSACTIONS' CALL SDC1795       */
/**/
                IF         COND(&OPTN *EQ 4) THEN(DO)
                   CALL       PGM(SDC1795) PARM(&PARM2 &LRTP)
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
                   GOTO END
                ENDDO
/**/
                ELSE DO
/**/
/* IF REPORT REQUESTED IS 'SUCCESSFUL TRANSACTIONS IN LAST XX MINUTES' */
/* OBTAIN DATE AND TIME OF 'RECOVER TO' JOURNAL ENTRY THEN CALL SD1790 */
/* TO CALCULATE DATE AND TIME OF 'RECOVER FROM' POINT                  */
/**/
                   IF         COND(&OPTN *EQ 3) THEN(DO)
                      RTVDTAARA  DTAARA(JNSTAT (1 8)) RTNVAR(&CURRCV)
                      RTVJRNE    JRN(ICJRN) RCVRNG(&CURRCV ICRCV001) +
                                   FROMENT(&LRTP) TOENT(&LRTP) +
                                   SEARCH(*DESCEND) RTNJRNE(&ENTRY)
                      CHGVAR     VAR(&TOTM) VALUE(%SST(&ENTRY 25 6))
                      CHGVAR     VAR(&TODT) VALUE(%SST(&ENTRY 19 6))
/**/
                      CALL       PGM(SD1790) PARM(&TOTM &PARM2 &FROMTM &TODT +
                                   &FROMDT)
/**/
/*  CLEAR FILES JRNEX1 & JRNEX2                                        */
/**/
                      CLRPFM     FILE(JRNEX1)
                      CLRPFM     FILE(JRNEX2)
/**/
/*  DISPLAY RELEVANT SECTIONS AND ENTRIES FROM JOURNAL INTO JRNEX1     */
/*  THEN CALL SD1791 TO SELECT 'CM' ENTRIES FROM OUTSIDE BOUNDARIES    */
/**/
                                                                      /*S01127*/
/*********************DSPJRN*****JRN(ICJRN)*RCVRNG(ICRCV001*&CURRCV)*+*********/
/**********************************FROMTIME(&FROMDT &FROMTM) TOTIME(&TODT*+****/
/**********************************&TOTM) ENTTYP(CM ER JS SR SV) OUTPUT(*NONE)*/
/**********************************OUTFILE(JRNEX1)*****************************/
                                                                      /*S01127*/
             DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001 &CURRCV) +
                          FROMTIME(&FROMDT &FROMTM) TOTIME(&TODT +
                          &TOTM) ENTTYP(CM ER JS IR SV) +
                          OUTPUT(*OUTFILE) OUTFILE(JRNEX1) /*S01127*/
                                                                      /*S01127*/
/**/                                                                  /*E13205*/
/*     Delete all records in outside recovery areas                */ /*E13205*/
/**/                                                                  /*E13205*/
                      CHGJOB     SWS(0XXXXXXX)                        /*E13205*/
                      CALL       PGM(SD1797)                          /*E13205*/
/**/
                      CALL       PGM(SD1791)
/**/
/*                    FOR DATABASE ERRORS RECOVER DATA FROM LDA               */
/**/
                      IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*  CLEAR JRNEX1, COPY JRNEX2 INTO JRNEX1 & CLEAR JRNEX2               */
/**/
                      CLRPFM     FILE(JRNEX1)
                      CPYF       FROMFILE(JRNEX2) TOFILE(JRNEX1) +
                                 MBROPT(*REPLACE) FMTOPT(*MAP *DROP)  /*E11956*/
/******                          MBROPT(*REPLACE)                   *  *E11956*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)       /*E13205*/
                      CLRPFM     FILE(JRNEX2)
/**/
                   ENDDO
                   ELSE DO
/**/
/*  CLEAR FILES JRNEX1 & JRNEX2                                        */
/**/
                      CLRPFM     FILE(JRNEX1)
                      CLRPFM     FILE(JRNEX2)
/**/
/*  DISPLAY JOURNAL FOR RELEVANT ENTRIES UP TO 'RECOVER TO' POINT  &   */
/*  OUTPUT TO JRNEX1                                                   */
/**/
                                                                      /*S01127*/
/*********************DSPJRN*****JRN(ICJRN)*RCVRNG(ICRCV001)*TOENT(&LRTP)*+****/
/**********************************ENTTYP(CM*ER*JS*SR*SV)*OUTPUT(*NONE)*+******/
/**********************************OUTFILE(JRNEX1)*****************************/
                                                                      /*S01127*/
             DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001) TOENT(&LRTP) +
                          ENTTYP(CM ER JS IR SV) OUTPUT(*OUTFILE) +
                          OUTFILE(JRNEX1) /*S01127*/
                                                                      /*S01127*/
/**/                                                                  /*E13205*/
/*     Delete all records in outside recovery areas                */ /*E13205*/
/**/                                                                  /*E13205*/
                      CHGJOB     SWS(0XXXXXXX)                        /*E13205*/
                      CALL       PGM(SD1797)                          /*E13205*/
/**/
/* IF REPORT REQUESTED IS 'LAST SUCCESSFUL TRANSACTION BY WORKSTN'     */
/* CALL SD1792 TO SELECT THE LAST 'CM' ENTRY FOR EACH WORKSTN          */
/**/
                      IF         COND(&OPTN *EQ 1) THEN(DO)
/**/
                         CALL       PGM(SD1792)
/**/
/*                       FOR DATABASE ERRORS RECOVER DATA FROM LDA            */
/**/
                         IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*  CLEAR JRNEX1, COPY JRNEX2 INTO JRNEX1 & CLEAR JRNEX2               */
/**/
                         CLRPFM     FILE(JRNEX1)
                         CPYF       FROMFILE(JRNEX2) TOFILE(JRNEX1) +
                                  MBROPT(*REPLACE) FMTOPT(*MAP *DROP) /*E11956*/
/******                                MBROPT(*REPLACE)             *  *E11956*/
                         MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    /*E13205*/
                         CLRPFM     FILE(JRNEX2)
/**/
                      ENDDO
                      ELSE DO
/**/
/* IF REPORT REQUESTED IS 'LAST SUCCESSFUL TRANSACTION BY USER'        */
/* CALL SD1793 TO SELECT THE LAST 'CM' ENTRY FOR EACH USER             */
/**/
                         CALL       PGM(SD1793)
/**/
/*                       FOR DATABASE ERRORS RECOVER DATA FROM LDA            */
/**/
                         IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*  CLEAR JRNEX1, COPY JRNEX2 INTO JRNEX1 & CLEAR JRNEX2               */
/**/
                         CLRPFM     FILE(JRNEX1)
                         CPYF       FROMFILE(JRNEX2) TOFILE(JRNEX1) +
                                  MBROPT(*REPLACE) FMTOPT(*MAP *DROP) /*E11956*/
/******                                MBROPT(*REPLACE)             *  *E11956*/
                         MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    /*E13205*/
                         CLRPFM     FILE(JRNEX2)
                      ENDDO
/**/
                   ENDDO
/**/
                ENDDO
/**/
/*  CALL SD1794 TO OUTPUT FORWARD RECOVERY REPORT                      */
/**/
                OVRDBF     FILE(TABLE) TOFILE(TABICD)
                CALL       PGM(SD1794) PARM(&OPTN &PARM2)
/**/
/*              FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
/**/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
                CLRPFM     FILE(JRNEX1)
/**/
             ENDDO
             ELSE DO
/**/
                CHGVAR     VAR(&MSG) VALUE('Forward Recovery Reporting +
                           is not valid')
                SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MRUNQ) +
                           MSGTYPE(*INFO)
             ENDDO
/**/
             GOTO END
/**/
/*           DATABASE ERROR PROCESSING                                        */
/**/
/** DBERR: ************  RCVDTAARA  DTAARA(LDA)                     *  *S01179*/
DBERR:                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)          /*S01179*/
/***                  CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))*/ /*S01194*/
                      CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))   /*S01194*/
                         SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                    MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ) +
                                    TOPGMQ(*EXT)
                         GOTO END
/**/
/*           GLOBAL MONITOR MESSAGE ERROR PROCESSING                          */
/**/
ABNOR:       SNDPGMMSG  TOMSGQ(MOPERQ MRUNQ) TOPGMQ(*EXT) +
                          MSG('Forward Recovery Reporting ENDED +
                          ABNORMALLY')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
