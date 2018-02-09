/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Apply journal changes to database')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1722 - APPLY JOURNAL CHANGES TO THE DATABASE            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 23May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E24168             Date 3FEb92               */
/*                      E20839        DATE  28FEB90                 */
/*                      E16249        DATE  25NOV89                 */
/*                      E13205        DATE  14/02/89                */
/*                      E12300        DATE  24/03/88                */
/*                      S01133        DATE  31/03/87                */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                        */
/*       E24168 - WHEN CPF7067 OR CPF7049 OCCURS, THE PROGRAM       */
/*                SHOULD GO TO ABNOR, NOT CONTINUE PROCESSING.      */
/*       E20839 - EOD RUNS IN 38 MODE NOT NATIVE BECAUSE QCAEXEC    *  *E20839*/
/*                IS CALLED AND NOT QCMDEXC                         *  *E20839*/
/*       E16249 - ASTERISK OUT LINES WHICH ARE NEVER EXECUTED       */
/*       E13205 - Fix apply journal changes                         * /*E13205*/
/*                (i) Only use QCAEXEC once                         * /*E13205*/
/*               (ii) Call SD1722 to format files                   * /*E13205*/
/*              (iii) Monitor message CPF7048 and call SDC1763      * /*E13205*/
/*               (iv) if (iii) then loop on apply journal change    * /*E13205*/
/*                    after altering the from point via SD1723      * /*E13205*/
/*                (V) Add parameter to declare journal receiver     * /*E13205*/
/*                    this means this program replaces SDC1751      * /*E13205*/
/*       S01133 - DEALING ROOM SYSTEM                               */
/*                                                                  */
/********************************************************************/
/*       E12300 - APYJRNCHG parameters changed to MBR(*ALL) for     */
/*       file FXSTDDPP.Also,files MMSTDAPP,MMSTDBPP,MMSTDLPP and    */
/*       MMSTDSPP added.                                            */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM        PARM(&FRPNT &TOPNT)                        */ /*E13205*/
             PGM        PARM(&FRPNT &TOPNT &LST_RCV)                  /*E13205*/
/**/
/*   INITIAL PROCESSING                                             */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&FRPNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TOPNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FRPNA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOPNA) TYPE(*CHAR) LEN(10)
/*           DCL        VAR(&MSG) TYPE(*CHAR) LEN(560)             */ /*E13205*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(1110)               /*E13205*/
             DCL        VAR(&FILES) TYPE(*CHAR) LEN(450)              /*S01133*/
             DCL        VAR(&FILES_FMT) TYPE(*CHAR) LEN(900)          /*E13205*/
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(5)               /*E13205*/
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)                /*E13205*/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)                /*E13205*/
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)             /*E13205*/
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(54)              /*E13205*/
             DCL        VAR(&OLD_MSGDTA) TYPE(*CHAR) LEN(54)          /*E13205*/
             DCL        VAR(&DEC_10_0) TYPE(*DEC) LEN(10 0)           /*E13205*/
             DCL        VAR(&BIN_4) TYPE(*CHAR) LEN(4)                /*E13205*/
             DCL        VAR(&LST_RCV) TYPE(*CHAR) LEN(8)              /*E13205*/
                                                                      /*S01133*/
/**  Variables for QCLSCAN program.                                     S01133*/
                                                                      /*S01133*/
/*           DCL        VAR(&STRLEN)   TYPE(*DEC) LEN(3 0) VALUE(450) /*E16249*/
/*           DCL        VAR(&STRPOS)    TYPE(*DEC)  LEN(3 0) VALUE(1) /*E16249*/
/*           DCL        VAR(&PATTERN)   TYPE(*CHAR) LEN(11)           /*E16249*/
/*           DCL        VAR(&PATLEN)   TYPE(*DEC)  LEN(3 0) VALUE(11) /*E16249*/
/*           DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1) VALUE('0') /*E16249*/
/*           DCL        VAR(&TRIM) TYPE(*CHAR) LEN(1) VALUE('1')      /*E16249*/
/*           DCL        VAR(&WILD)      TYPE(*CHAR) LEN(1)            /*E16249*/
/*           DCL        VAR(&RESULT)    TYPE(*DEC)  LEN(3 0)          /*E16249*/
/**/
             DCLF       FILE(JRNFIL)
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Apply Journal Changes to the Database') +
                        TOMSGQ(MRUNQ)
/**/                                                                  /*E13205*/
/* If &LST_RCV is blank place '*CURRENT as a default               */ /*E13205*/
/**/                                                                  /*E13205*/
             IF         COND(&LST_RCV *EQ ' ') THEN(CHGVAR +
                          VAR(&LST_RCV) VALUE('*CURRENT'))            /*E13205*/
/**/
/*   APPLY JOURNAL CHANGES PROCESSING                               */
/**/
/*                                                                  */
/*      EACH RECORD IN THE FILE JRNFIL CONTAINS A LIST OF PHYSICAL  */
/*      FILES TO WHICH JOURNAL CHANGES HAVE TO BE APPLIED. THE      */
/*      PROGRAM WILL PROCESS EACH RECORD IN TURN UNTIL THERE ARE NO */
/*      FURTHUR RECORDS.                                            */
/*       (CPF0864 INDICATES END OF FILE)                            */
/**/
READREC:     RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO END)
/**/
/* CONVERT THE NUMERIC VALUES OF FROM AND TO POINTS TO ALPHA VALUES  */
/**/
             CHGVAR     VAR(&FRPNA) VALUE(&FRPNT)
             CHGVAR     VAR(&TOPNA) VALUE(&TOPNT)
             CHGVAR     VAR(&FILES) VALUE(&FILEA *CAT &FILEB)         /*S01133*/
/**/                                                                  /*E13205*/
/* Format files and remove those that need not be recovered        */ /*E13205*/
/**/                                                                  /*E13205*/
             CALL       PGM(SD1722) PARM(&FILES &FILES_FMT &OPTION)   /*E13205*/
/**/                                                                  /*E13205*/
/* Set Message queue pointer to end of queue                       */ /*E13205*/
/**/                                                                  /*E13205*/
 READMSG:    RCVMSG     PGMQ(*SAME) MSGTYPE(*ANY) RMV(*NO) +
                          MSGID(&MSGID)                               /*E13205*/
             IF         COND(&MSGID *NE ' ') THEN(GOTO CMDLBL(READMSG))
/**/                                                                  /*E13205*/
/* Format apply journal changes command                            */ /*E13205*/
/**/                                                                  /*E13205*/
/*APYJRNE: CHGVAR     VAR(&MSG) VALUE(' APYJRNCHG JRN(ICJRN) FILE(' + /*E13205*/  /*BG18886*/
/**********               *CAT &FILES_FMT *TCAT ') +                  /*E13205*/  /*BG18886*/
/**********               RCVRNG(*LIBL/ICRCV001 ' *BCAT &LST_RCV +    /*E13205*/  /*BG18886*/
/**********               *TCAT ') FROMENT(' ** &FRPNA *< ') TOENT(' +/*E13205*/  /*BG18886*/
/**********               ** &TOPNA *< ') CMTBDY(*YES)')              /*E13205*/  /*BG18886*/
 APYJRNE:    CHGVAR     VAR(&MSG) VALUE(' APYJRNCHG JRN(ICJRN) +
                          FILE(' *CAT &FILES_FMT *TCAT ') +
                          RCVRNG(*LIBL/ICRCV001 ' *BCAT &LST_RCV +
                          *TCAT ') FROMENT(' *CAT &FRPNA *TCAT ') +
                          TOENT(' *CAT &TOPNA *TCAT ') +
                          CMTBDY(*YES)')                              /*E13205*/  /*BG18886*/
/**/                                                                  /*E13205*/
/* Execute command                                                 */ /*E13205*/
/**/                                                                  /*E13205*/
/************CALL*******PGM(QCAEXEC) PARM(&MSG 1110)*/     /*E13205*/ /*E20839*/
             CALL       PGM(QCMDEXC) PARM(&MSG 1110)                  /*E20839*/
/**/                                                                  /*E13205*/
/* If the FROM or TO POINT is not on a commitment boundary, continue  /*E13205*/
/* processing                                                      */ /*E13205*/
/**/                                                                  /*E13205*/
/************MONMSG     MSGID(CPF7039 CPF7067 CPF7049) EXEC(GOTO +
/************             CMDLBL(READREC))                 /*E13205*/ /*E24168*/
             MONMSG     MSGID(CPF7039) EXEC(GOTO CMDLBL(READREC))     /*E24168*/
/**/                                                                  /*E13205*/
/* Monitor for message CPF7048, unique access path error, call     */ /*E13205*/
/* SDC1763 to rebuild access paths and then return to APYJRNE      */ /*E13205*/
/**/                                                                  /*E13205*/
             MONMSG     MSGID(CPF7048) EXEC(DO)                       /*E13205*/
 READMSG2:   RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) MSGFLIB(&MSGFLIB) /*E13205*/
             IF         COND(&MSGID *EQ ' ') THEN(GOTO CMDLBL(ABNOR)) /*E13205*/
             IF         COND(&MSGID *NE 'CPF7048') THEN(GOTO +
                          CMDLBL(READMSG2))                           /*E13205*/
             IF         COND(&MSGDTA *EQ &OLD_MSGDTA) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*E13205*/
             CALL       PGM(SDC1763) PARM(&MSGDTA)                    /*E13205*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*E13205*/
             CHGVAR     VAR(&OLD_MSGDTA) VALUE(&MSGDTA)               /*E13205*/
/**/                                                                  /*E13205*/
/*           Call conversion program Binary to decimal             */ /*E13205*/
/**/                                                                  /*E13205*/
             CHGVAR     VAR(&BIN_4) VALUE(%SST(&MSGDTA 51 4))         /*E13205*/
             CALL       PGM(SD1723) PARM(&BIN_4 &DEC_10_0)            /*E13205*/
             CHGVAR     VAR(&FRPNA) VALUE(&DEC_10_0)                  /*E13205*/
/**/                                                                  /*E13205*/
             GOTO       CMDLBL(APYJRNE)                               /*E13205*/
/**/                                                                  /*E13205*/
             ENDDO                                                    /*E13205*/
/**/                                                                  /*E13205*/
             GOTO       CMDLBL(READREC)                               /*E13205*/
/**/                                                                  /*E13205*/
/* All code below this point to ABNOR tag should never be executed */ /*E13205*/
/*                                                                 */ /*E13205*/
/*            NEXT EXECUTEABLE STATEMENT IS AT ABNOR TAG           */ /*E13205*/
/*                                                                 */ /*E13205*/
/*******************************************************************/ /*E13205*/
/*                                                         /*S01133*/ /*E16249*/
/**  blank out FXDWNBPP because this is in DLIB so is not restored */ /*E16249*/
/*   so no need to aply jrn changes to it                  /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(&PATTERN) VALUE(FXDWNBPP)      /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CALL       PGM(QCLSCAN) PARM(&FILES &STRLEN &STRPOS +    /*E16249*/
/*                        &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +   /*E16249*/
/*                        &RESULT)                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*  If +ve value returned in &RESULT then scan chars have been found  /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           IF         COND(&RESULT *GT 0) THEN(DO)       /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(%SST(&FILES &RESULT 8)) VALUE('        ') /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           ENDDO                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/**  blank out FXSTDDPP because this is used only during the update   /*E16249*/
/*   of MIDAS and DRS file and then the record is deleted  /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/**  Scan for FXSTDDPP                                     /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(&PATTERN) VALUE(FXSTDDPP)      /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CALL       PGM(QCLSCAN) PARM(&FILES &STRLEN &STRPOS +    /*E16249*/
/*                        &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +   /*E16249*/
/*                        &RESULT)                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*  If +ve value returned in &RESULT then scan chars have been found  /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           IF         COND(&RESULT *GT 0) THEN(DO)       /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(%SST(&FILES &RESULT 8)) VALUE('        ') /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           ENDDO                                         /*S01133*/ /*E16249*/
/**/                                                                  /*E16249*/
/* SETUP THE APPLY JOURNAL CHANGES COMMAND IN A VARIABLE TO EXECUTE*/ /*E16249*/
/* UNDER QCAEXEC AND CALL QCAEXEC                                  */ /*E16249*/
/**/                                                                  /*E16249*/
/*           CHGVAR     VAR(&MSG) VALUE('APYJRNCHG JRN(ICJRN) +       /*E16249*/
/*                      FILE(' *CAT &FILEA *CAT &FILEB *CAT ') +      /*E16249*/
/*                      RCVRNG(ICRCV001.*LIBL *CURRENT) +             /*E16249*/
/*                      FROMENT('**&FRPNA**') TOENT('**&TOPNA**') +   /*E16249*/
/*                          CMTBDY(*YES)')                 /*E12300*/ /*E16249*/
/*                                                                    /*E16249*/
/*           CHGVAR     VAR(&MSG) VALUE('APYJRNCHG JRN(ICJRN) FILE(' +/*E16249*/
/*                        *CAT &FILEA *CAT &FILEB *CAT ') MBR(*ALL)+  /*E16249*/
/*                        RCVRNG(ICRCV001.*LIBL *CURRENT) FROMENT(' + /*E16249*/
/*                        ** &FRPNA *< ') TOENT(' ** &TOPNA *< ') +   /*E16249*/
/*                        CMTBDY(*YES)')                   /*E12300*/ /*E16249*/
/**/                                                                  /*E16249*/
/*           CALL       PGM(QCAEXEC) PARM(&MSG 560)                   /*E16249*/
/**/                                                                  /*E16249*/
/**  blank out MMSTDAPP because this is used only during the update   /*E16249*/
/*   of MIDAS and DRS file and then the record is deleted  /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/**  Scan for MMSTDAPP                                     /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(&PATTERN) VALUE(FXSTDDPP)      /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CALL       PGM(QCLSCAN) PARM(&FILES &STRLEN &STRPOS +    /*E16249*/
/*                        &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +   /*E16249*/
/*                        &RESULT)                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*  If +ve value returned in &RESULT then scan chars have been found  /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           IF         COND(&RESULT *GT 0) THEN(DO)       /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(%SST(&FILES &RESULT 8)) VALUE('        ') /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           ENDDO                                         /*S01133*/ /*E16249*/
/**/                                                                  /*E16249*/
/* SETUP THE APPLY JOURNAL CHANGES COMMAND IN A VARIABLE TO EXECUTE   /*E16249*/
/* UNDER QCAEXEC AND CALL QCAEXEC                          /*E12300*/ /*E16249*/
/**/                                                                  /*E16249*/
/*           CHGVAR     VAR(&MSG) VALUE('APYJRNCHG JRN(ICJRN) FILE(' +/*E16249*/
/*                        *CAT &FILEA *CAT &FILEB *CAT ') MBR(*ALL)+  /*E16249*/
/*                        RCVRNG(ICRCV001.*LIBL *CURRENT) FROMENT(' + /*E16249*/
/*                        ** &FRPNA *< ') TOENT(' ** &TOPNA *< ') +   /*E16249*/
/*                        CMTBDY(*YES)')                   /*E12300*/ /*E16249*/
/*           CALL       PGM(QCAEXEC) PARM(&MSG 560)        /*E12300*/ /*E16249*/
/**/                                                                  /*E16249*/
/**  blank out MMSTDBPP because this is used only during the update   /*E16249*/
/*   of MIDAS and DRS file and then the record is deleted  /*S01133*/ /*E16249*/
/**  Scan for MMSTDBPP                                     /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(&PATTERN) VALUE(MMSTDBPP)      /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CALL       PGM(QCLSCAN) PARM(&FILES &STRLEN &STRPOS +    /*E16249*/
/*                        &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +   /*E16249*/
/*                        &RESULT)                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*  If +ve value returned in &RESULT then scan chars have been found  /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           IF         COND(&RESULT *GT 0) THEN(DO)       /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(%SST(&FILES &RESULT 8)) VALUE('        ') /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           ENDDO                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(&MSG) VALUE('APYJRNCHG JRN(ICJRN) FILE(' +/*E16249*/
/*                        *CAT &FILEA *CAT &FILEB *CAT ') MBR(*ALL)+  /*E16249*/
/*                        RCVRNG(ICRCV001.*LIBL *CURRENT) FROMENT(' + /*E16249*/
/*                        ** &FRPNA *< ') TOENT(' ** &TOPNA *< ') +   /*E16249*/
/*                        CMTBDY(*YES)')                   /*E12300*/ /*E16249*/
/*           CALL       PGM(QCAEXEC) PARM(&MSG 560)        /*E12300*/ /*E16249*/
/**/                                                                  /*E16249*/
/**  blank out MMSTDLPP because this is used only during the update   /*E16249*/
/*   of MIDAS and DRS file and then the record is deleted  /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/**  Scan for MMSTDLPP                                     /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(&PATTERN) VALUE(MMSTDLPP)      /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CALL       PGM(QCLSCAN) PARM(&FILES &STRLEN &STRPOS +    /*E16249*/
/*                        &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +   /*E16249*/
/*                        &RESULT)                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*  If +ve value returned in &RESULT then scan chars have been found  /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           IF         COND(&RESULT *GT 0) THEN(DO)       /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(%SST(&FILES &RESULT 8)) VALUE('        ') /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           ENDDO                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(&MSG) VALUE('APYJRNCHG JRN(ICJRN) FILE(' +/*E16249*/
/*                        *CAT &FILEA *CAT &FILEB *CAT ') MBR(*ALL)+  /*E16249*/
/*                        RCVRNG(ICRCV001.*LIBL *CURRENT) FROMENT(' + /*E16249*/
/*                        ** &FRPNA *< ') TOENT(' ** &TOPNA *< ') +   /*E16249*/
/*                        CMTBDY(*YES)')                   /*E12300*/ /*E16249*/
/*           CALL       PGM(QCAEXEC) PARM(&MSG 560)        /*E12300*/ /*E16249*/
/**/                                                                  /*E16249*/
/**  blank out MMSTDSPP because this is used only during the update   /*E16249*/
/*   of MIDAS and DRS file and then the record is deleted  /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/**  Scan for MMSTDSPP                                     /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(&PATTERN) VALUE(MMSTDSPP)      /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CALL       PGM(QCLSCAN) PARM(&FILES &STRLEN &STRPOS +    /*E16249*/
/*                        &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +   /*E16249*/
/*                        &RESULT)                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*  If +ve value returned in &RESULT then scan chars have been found  /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           IF         COND(&RESULT *GT 0) THEN(DO)       /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(%SST(&FILES &RESULT 8)) VALUE('        ') /*E16249*/
/*                                                         /*S01133*/ /*E16249*/
/*           ENDDO                                         /*S01133*/ /*E16249*/
/*           CHGVAR     VAR(&MSG) VALUE('APYJRNCHG JRN(ICJRN) FILE(' +/*E16249*/
/*                        *CAT &FILEA *CAT &FILEB *CAT ') MBR(*ALL)+  /*E16249*/
/*                        RCVRNG(ICRCV001.*LIBL *CURRENT) FROMENT(' + /*E16249*/
/*                        ** &FRPNA *< ') TOENT(' ** &TOPNA *< ') +   /*E16249*/
/*                        CMTBDY(*YES)')                   /*E12300*/ /*E16249*/
/*           CALL       PGM(QCAEXEC) PARM(&MSG 560)        /*E12300*/ /*E16249*/
/**/                                                                  /*E16249*/
/* IF THE FROM OR TO POINT IS NOT ON A COMMITMENT BOUNDARY,CONTINUE*/ /*E16249*/
/* PROCESSING                                                      */ /*E16249*/
/*           MONMSG     MSGID(CPF7039 CPF7067) EXEC(GOTO READREC)     /*E16249*/
/*           MONMSG     MSGID(CPF7039 CPF7067 CPF7049)     /*S01133*/ /*E16249*/
/**/                                                                  /*E16249*/
/*           GOTO READREC                                             /*E16249*/
/**/
ABNOR:       SNDPGMMSG  MSG('PROGRAM - Apply Journal Changes to the Database +
                        - ENDED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
END:         ENDPGM
/**/
