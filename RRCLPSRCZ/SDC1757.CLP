/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Rep Last Sucs. Trans on Primary Mach')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1757 - REPORT OF LAST SUCCESSFUL TRANSACTIONS ON        */
/*                 PRIMARY MACHINE                                  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E22892             Date 24Jul90              */
/*                      S01194             Date 21Feb90              */
/*                      E13205        DATE 15/03/89                 */
/*                      S01179        DATE 13/09/88                 */
/*                      S01127        DATE 02/06/88                 */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       E22892 - CPYF COMMAND DOES NOT MONITOR FOR AN EMPTY        */
/*                FROM FILE                                         */
/*       S01194 - NEW STANDING DATA                                 * /*S01194*/
/*       E13205 - Add the default reports by user and number        * /*E13205*/
/*       S01179 - AS400 CONVERSION                                  */
/*       S01127 - CHANGE JOURNAL CODE 'SR' TO 'IR'                  */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*  INITIAL PROCESSING                                               */
/**/
             DCL        VAR(&RCVNUM) TYPE(*DEC) LEN(3)
             DCL        VAR(&LSTNUM) TYPE(*DEC) LEN(3)
             DCL        VAR(&LSTRCV) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LRCV) TYPE(*CHAR) LEN(8) VALUE('ICRCV   ')
             DCL        VAR(&ENTDTA) TYPE(*CHAR) LEN(135)
/***         DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&OPTN) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&PARM2) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&SQNRTP) TYPE(*DEC) LEN(10 0)
/**********  DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
/**/
/*  GLOBAL MONITOR MESSAGE                                           */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Report of Last Successful Transactions on +
                          Primary Machine') TOMSGQ(MRUNQ)
/**/
/*  OBTAIN NO. OF LAST RECEIVER RESTORED FROM JNSTAT                */
/**/
             RTVDTAARA  DTAARA(JNSTAT (6 3)) RTNVAR(&LSTRCV)
             CHGVAR     VAR(&RCVNUM) VALUE(&LSTRCV)
             CHGVAR     VAR(&LSTNUM) VALUE(&RCVNUM - 1)
             CHGVAR     VAR(%SST(&LRCV 6 3)) VALUE(&LSTNUM)
/**/
/*  OBTAIN SEQUENCE NO. OF LAST RECEIVER SAVE ENTRY IN JOURNAL -     */
/*  TO BE USED AS 'REPORT TO' POINT                                  */
/**/
             RTVJRNE    JRN(ICJRN) RCVRNG(&LRCV ICRCV001) +
                          FROMENT(*LAST) TOENT(*FIRST) +
                          SEARCH(*DESCEND) JRNCDE(U) ENTTYP(JS) +
                          RTNSEQNBR(&SQNRTP)
/**/
/*  CLEAR FILES JRNEX1 & JRNEX2                                        */
/**/
             CLRPFM     FILE(JRNEX1)
             CLRPFM     FILE(JRNEX2)
/**/
/*  DISPLAY JOURNAL FOR RELEVANT ENTRIES & OUTPUT TO JRNEX1            */
/**/
                                                                      /*S01127*/
/************DSPJRN*****JRN(ICJRN)*RCVRNG(ICRCV001*&LRCV)*+*********/ /*S01127*/
/*************************TOENT(&SQNRTP)*ENTTYP(CM*ER*JS*SR*SV)*+***/ /*S01127*/
/*************************OUTPUT(*NONE)*OUTFILE(JRNEX1)*************/ /*S01127*/
             DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001 &LRCV) +
                          TOENT(&SQNRTP) ENTTYP(CM ER JS IR SV) +
                          OUTPUT(*OUTFILE) OUTFILE(JRNEX1)            /*S01127*/
                                                                      /*S01127*/
/**/                                                                  /*E13205*/
/*     Delete all records    outside recovery areas                */ /*E13205*/
/**/                                                                  /*E13205*/
                      CHGJOB     SWS(0XXXXXXX)                        /*E13205*/
                      CALL       PGM(SD1797)                          /*E13205*/
/* */                                                                 /*E13205*/
/*     Keep a copy of JRNEX1 for over reports                      */ /*E13205*/
/* */                                                                 /*E13205*/
             DLTF       FILE(QTEMP/JRNEX1)                            /*E13205*/
             MONMSG     MSGID(CPF2105)                                /*E13205*/
             CPYF       FROMFILE(JRNEX1) TOFILE(QTEMP/JRNEX1) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*E13205*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*E22892*/
/**/
/*  CALL SD1792 TO SELECT THE LAST 'CM' ENTRY FOR EACH WORKSTN         */
/**/
             CALL       PGM(SD1792)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*  CLEAR JRNEX1, COPY JRNEX2 INTO JRNEX1 & CLEAR JRNEX2               */
/**/
             CLRPFM     FILE(JRNEX1)
             CPYF       FROMFILE(JRNEX2) TOFILE(JRNEX1) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*E22892*/
             CLRPFM     FILE(JRNEX2)
/**/
/*  CALL SD1794 TO OUTPUT REPORT OF LAST SUCCESSFUL TRANSACTIONS BY WRKSTN */
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABICD)
             CALL       PGM(SD1794) PARM(&OPTN &PARM2)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/* */                                                                 /*E13205*/
/*     Restore file JRNEX1 from JRNEX1.QTEMP                       */ /*E13205*/
/* */                                                                 /*E13205*/
             CLRPFM     FILE(JRNEX1)                                  /*E13205*/
             CPYF       FROMFILE(QTEMP/JRNEX1) TOFILE(JRNEX1) +
                          MBROPT(*REPLACE)                            /*E13205*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*E22892*/
/**/                                                                  /*E13205*/
/*  Call SD1793 to select the last 'CM' entry for each user        */ /*E13205*/
/**/                                                                  /*E13205*/
             CALL       PGM(SD1793)                                   /*E13205*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)      /*E13205*/
/**/                                                                  /*E13205*/
/*  Clear JRNEX1, copy JRNEX2 into JRNEX1 & clear JRNEX2           */ /*E13205*/
/**/                                                                  /*E13205*/
             CLRPFM     FILE(JRNEX1)                                  /*E13205*/
             CPYF       FROMFILE(JRNEX2) TOFILE(JRNEX1) +
                          MBROPT(*REPLACE)                            /*E13205*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*E22892*/
             CLRPFM     FILE(JRNEX2)                                  /*E13205*/
/**/                                                                  /*E13205*/
/*  Call SD1794 to output report of last successful transaction by */ /*E13205*/
/*  user                                                           */ /*E13205*/
/**/                                                                  /*E13205*/
             CHGVAR     VAR(&OPTN) VALUE(2)                           /*E13205*/
             CALL       PGM(SD1794) PARM(&OPTN &PARM2)                /*E13205*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)      /*E13205*/
/**/
/* */                                                                 /*E13205*/
/*     Restore file JRNEX1 from JRNEX1.QTEMP                       */ /*E13205*/
/* */                                                                 /*E13205*/
             CLRPFM     FILE(JRNEX1)                                  /*E13205*/
             CPYF       FROMFILE(QTEMP/JRNEX1) TOFILE(JRNEX1) +
                          MBROPT(*REPLACE)                            /*E13205*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*E22892*/
/**/                                                                  /*E13205*/
/*  Call SD1791 to select all 'CM' entries then select the fisrt 99*/ /*E13205*/
/**/                                                                  /*E13205*/
             CALL       PGM(SD1791)                                   /*E13205*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)      /*E13205*/
/**/                                                                  /*E13205*/
/*  Clear JRNEX1, copy JRNEX2 into JRNEX1 & clear JRNEX2           */ /*E13205*/
/**/                                                                  /*E13205*/
             CLRPFM     FILE(JRNEX1)                                  /*E13205*/
             CPYF       FROMFILE(JRNEX2) TOFILE(JRNEX1) +
                          MBROPT(*REPLACE) NBRRCDS(99)                /*E13205*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*E22892*/
             CLRPFM     FILE(JRNEX2)                                  /*E13205*/
/**/                                                                  /*E13205*/
/*  Call SD1794 to output report of last successful transaction by */ /*E13205*/
/*  user                                                           */ /*E13205*/
/**/                                                                  /*E13205*/
             CHGVAR     VAR(&OPTN) VALUE(4)                           /*E13205*/
             CHGVAR     VAR(&PARM2) VALUE(99)                         /*E13205*/
             CALL       PGM(SD1794) PARM(&OPTN &PARM2)                /*E13205*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)      /*E13205*/
/**/
             GOTO       END
/**/
/*  DATABASE ERROR PROCESSING                                                 */
/**/
/* DBERR: ** RCVDTAARA  DTAARA(LDA) *********************************  *S01179*/
DBERR:       RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/***         CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))         */ /*S01194*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO END
/**/
/*  GLOBAL MONITOR MESSAGE ERROR PROCESSING                                   */
/**/
ABNOR:       SNDPGMMSG  TOMSGQ(MOPERQ MRUNQ) TOPGMQ(*EXT) +
                          MSG('Report of Last Successful Transactions on +
                          Primary Machine - ENDED ABNORMALLY')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
