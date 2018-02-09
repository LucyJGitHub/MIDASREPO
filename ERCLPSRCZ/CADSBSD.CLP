/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas European Reporting XLIB Objects creation')      */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING UTILITY                       */
/*                                                                  */
/*     CADSBSD   - EUROPEAN REPORTING IMPLEMENTATION                */
/*                 CREATE ALL OBJECTS IN XLIB                       */
/*                                                                  */
/*                                                                  */
/*       (c) Finastra International Limited 2005                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      CADDB2             Date 26Aug98              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*     CADDB2 - EUROPEAN REPORTING - LUXEMBOURG UPGRADE IN DBA2     */
/*              PROGRAM REWRITTEN BECAUSE ER IS NOT USED ANYMORE    */
/*********************************************************************/
/**/
             PGM
             DCL        VAR(&DILIB)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREFIX)  TYPE(*CHAR) LEN(2)
 /********** DCL        VAR(&SBS)IBTYPE(*CHAR)RLEN(6)8)                   */              /*CER001*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(6)
 /********** DCL        VAR(&CADLIB) TYPE(*CHAR) LEN(8)                   */              /*CER001*/
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(8)
 /********** DCL        VAR(&LIBL) TYPE(*CHAR) LEN(275)                   */              /*CER001*/
 /********** DCL        VAR(&LIBLA) TYPE(*CHAR) LEN(253)                  */              /*CER001*/
 /********** DCL        VAR(&LIBLB) TYPE(*CHAR) LEN(22)                   */              /*CER001*/
 /********** DCL        VAR(&L1) TYPE(*CHAR) LEN(10)                      */              /*CER001*/
 /********** DCL        VAR(&L2) TYPE(*CHAR) LEN(10)                      */              /*CER001*/
 /********** DCL        VAR(&L3) TYPE(*CHAR) LEN(10)                      */              /*CER001*/
 /********** DCL        VAR(&L4) TYPE(*CHAR) LEN(10)                      */              /*CER001*/
 /********** DCL        VAR(&L5) TYPE(*CHAR) LEN(10)                      */              /*CER001*/
 /********** DCL        VAR(&L6) TYPE(*CHAR) LEN(10)                      */              /*CER001*/
 /********** DCL        VAR(&L7) TYPE(*CHAR) LEN(10)                      */              /*CER001*/
 /********** DCL        VAR(&L8) TYPE(*CHAR) LEN(10)                      */              /*CER001*/
 /********** DCL        VAR(&L9) TYPE(*CHAR) LEN(10)                      */              /*CER001*/
 /********** DCL        VAR(&L10) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L11) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L12) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L13) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L14) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L15) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L16) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L17) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L18) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L19) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L20) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L21) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L22) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L23) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L24) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
 /********** DCL        VAR(&L25) TYPE(*CHAR) LEN(10)                     */              /*CER001*/
             MONMSG     MSGID(CPF0000)
/* Get the library prefix & determine library names */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&PREFIX *CAT 'DILIB')
             CHGVAR     VAR(&XLIB) VALUE(&PREFIX *CAT 'XLIB')
/**********  CHGVAR     VAR(&CADLIB) VALUE(&PREFIX *CAT 'CADLIB')         */              /*CER001*/
             CHGVAR     VAR(&DTALIB) VALUE(&PREFIX *CAT 'DTALIB')
/**********  CHGVARQ    VAR(&SBS) VALUE('M' *CAT &PREFIX *CAT 'SBS')      */              /*CER001*/
/**/
/**********  ENDSBS     SBS(&SBS) OPTION(*IMMED)                          */              /*CER001*/
/**********  CRTOUTQ    OUTQ(&XLIB/CADOUTQ) TEXT('Midas CAD Output +
                          Queue')                                         */              /*CER001*/
/**********  CRTMSGQ    MSGQ(&XLIB/CADMSGQ) TEXT('Midas CAD Message +
                          Queue')                                         */              /*CER001*/
             CRTSAVF    FILE(&DILIB/ERSAVF1) TEXT('Midas CAD Save +
                          File 1')
             CRTSAVF    FILE(&DILIB/ERSAVF2) TEXT('Midas CAD Save +
                          File 2')
             CRTSAVF    FILE(&DILIB/ERSAVF3) TEXT('Midas CAD Save +
                          File 3')
             CRTSAVF    FILE(&DILIB/ERSAVF4) TEXT('Midas CAD Save +
                          File 4')
/**********  CRTJOBQ    JOBQ(&XLIB/CADJOBQ) TEXT('Midas CAD Job Queue')   */              /*CER001*/
/**********  RTVJOBA    USRLIBL(&LIBL)                                    */              /*CER001*/
/**********  CHGVAR     VAR(&LIBLA) VALUE(%SST(&LIBL 1 253))              */              /*CER001*/
/**********  CHGVAR     VAR(&LIBLB) VALUE(%SST(&LIBL 254 22))             */              /*CER001*/
 
/**********  CALL       PGM(CADLIBL) PARM(&PREFIX &LIBLA &LIBLB &L1 &L2 +
                          &L3 &L4 &L5 &L6 &L7 &L8 &L9 &L10 &L11 +
                          &L12 &L13 &L14 &L15 &L16 &L17 &L18 &L19 +
                          &L20 &L21 &L22 &L23 &L24 &L25)                  */              /*CER001*/
/**********  IF         COND(&L2 *EQ '          ') THEN(DO)               */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1) LOG(4 0 *SECLVL) LOGCLPGM(*YES)    */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L3 *EQ '          ') THEN(DO)               */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2) LOG(4 0 *SECLVL) +
                          LOGCLPGM(*YES)                                  */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L4 *EQ '          ') THEN(DO)               */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3) LOG(4 0 *SECLVL) +
                          LOGCLPGM(*YES)                                  */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L5 *EQ '          ') THEN(DO)               */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4) LOG(4 0 *SECLVL) +
                          LOGCLPGM(*YES)                                  */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L6 *EQ '          ') THEN(DO)               */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5) LOG(4 0 +
                          *SECLVL) LOGCLPGM(*YES)                         */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L7 *EQ '          ') THEN(DO)               */
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6) LOG(4 0 +
                          *SECLVL) LOGCLPGM(*YES)                         */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L8 *EQ '          ') THEN(DO)               */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7) +
                          LOG(4 0 *SECLVL) LOGCLPGM(*YES)                 */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L9 *EQ '          ') THEN(DO)               */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8) +
                          LOG(4 0 *SECLVL) LOGCLPGM(*YES)                 */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L10 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9) LOG(4 0 *SECLVL) LOGCLPGM(*YES)            */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L11 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10) LOG(4 0 *SECLVL) LOGCLPGM(*YES)       */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L12 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11) LOG(4 0 *SECLVL) +
                          LOGCLPGM(*YES)                                  */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L13 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12) LOG(4 0 *SECLVL) +
                          LOGCLPGM(*YES)                                  */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L14 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13) LOG(4 0 *SECLVL) +
                          LOGCLPGM(*YES)                                  */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L15 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14) LOG(4 0 +
                          *SECLVL) LOGCLPGM(*YES)                         */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L16 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14 &L15) LOG(4 +
                          0 *SECLVL) LOGCLPGM(*YES)                       */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L17 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14 &L15 &L16) +
                          LOG(4 0 *SECLVL) LOGCLPGM(*YES)                 */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L18 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14 &L15 &L16 +
                          &L17) LOG(4 0 *SECLVL) LOGCLPGM(*YES)           */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L19 *EQ '          ') THEN(DO)              */
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14 &L15 &L16 +
                          &L17 &L18) LOG(4 0 *SECLVL) LOGCLPGM(*YES)      */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L20 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14 &L15 &L16 +
                          &L17 &L18 &L19) LOG(4 0 *SECLVL) +
                          LOGCLPGM(*YES)                                  */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L21 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14 &L15 &L16 +
                          &L17 &L18 &L19 &L20) LOG(4 0 *SECLVL) +
                          LOGCLPGM(*YES)                                  */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L22 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14 &L15 &L16 +
                          &L17 &L18 &L19 &L20 &L21) LOG(4 0 +
                          *SECLVL) LOGCLPGM(*YES)                         */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L23 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14 &L15 &L16 +
                          &L17 &L18 &L19 &L20 &L21 &L22) LOG(4 0 +
/**********               *SECLVL) LOGCLPGM(*YES)                         */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L24 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14 &L15 &L16 +
                          &L17 &L18 &L19 &L20 &L21 &L22 &L23) LOG(4 +
                          0 *SECLVL) LOGCLPGM(*YES)                       */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  IF         COND(&L25 *EQ '          ') THEN(DO)              */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14 &L15 &L16 +
                          &L17 &L18 &L19 &L20 &L21 &L22 &L23 &L24) +
                          LOG(4 0 *SECLVL) LOGCLPGM(*YES)                 */              /*CER001*/
/**********  GOTO       CMDLBL(ENDJOBD)                                   */              /*CER001*/
/**********  ENDDO                                                        */              /*CER001*/
/**********  CRTJOBD    JOBD(&XLIB/CADJOBD) JOBQ(&XLIB/CADJOBQ) +
                          OUTQ(&XLIB/CADOUTQ) TEXT('Midas European +
                          Reporting Jobd') RTGDTA(CADREPORT) +
                          INLLIBL(&L1 &L2 &L3 &L4 &L5 &L6 &L7 &L8 +
                          &L9 &L10 &L11 &L12 &L13 &L14 &L15 &L16 +
                          &L17 &L18 &L19 &L20 &L21 &L22 &L23 &L24 +
                          &L25) LOG(4 0 *SECLVL) LOGCLPGM(*YES)           */              /*CER001*/
ENDJOBD:
 /********** CRTCLS     CLS(&XLIB/CADCLS) RUNPTY(50) TIMESLICE(2000) +
                          TEXT('Midas CAD Interface Job Class')           */              /*CER001*/
 /********** CHGSBSD    SBSD(&XLIB/&SBS) POOLS((5 *INTERACT))             */              /*CER001*/
 /********** MONMSG     MSGID(CPF1697) CMPDTA(CPD1415) EXEC(DO)           */              /*CER001*/
 /********** DLYJOB     DLY(30)                                           */              /*CER001*/
 /********** CHGSBSD    SBSD(&XLIB/&SBS) POOLS((5 *INTERACT))             */              /*CER001*/
 /**********              ENDDO                                           */              /*CER001*/
 /********** ADDJOBQE   SBSD(&XLIB/&SBS) JOBQ(&XLIB/CADJOBQ) +
                          MAXACT(1) SEQNBR(800)                           */              /*CER001*/
 /********** MONMSG     MSGID(CPF1697) CMPDTA(CPD1415) EXEC(DO)           */              /*CER001*/
 /********** DLYJOB     DLY(30)                                           */              /*CER001*/
 /********** ADDJOBQE   SBSD(&XLIB/&SBS) JOBQ(&XLIB/CADJOBQ) +
                          MAXACT(1) SEQNBR(800)                           */              /*CER001*/
 /**********              ENDDO                                           */              /*CER001*/
 /********** ADDRTGE    SBSD(&XLIB/&SBS) SEQNBR(900) +
                          CMPVAL(CADREPORT) PGM(*LIBL/CBC0102) +
                          CLS(&XLIB/CADCLS) POOLID(5)                     */              /*CER001*/
 /********** MONMSG     MSGID(CPF1697) CMPDTA(CPD1415) EXEC(DO)           */              /*CER001*/
 /********** DLYJOB     DLY(30)                                           */              /*CER001*/
 /********** ADDRTGE    SBSD(&XLIB/&SBS) SEQNBR(900) +
                          CMPVAL(CADREPORT) PGM(*LIBL/CBC0102) +
                          CLS(&XLIB/CADCLS) POOLID(5)                     */              /*CER001*/
 /**********              ENDDO                                           */              /*CER001*/
             CHGDTAARA  DTAARA(ERCTLD (1 256)) VALUE(' ')
             CHGDTAARA  DTAARA(ERCTLD (8 12)) VALUE('*SAVFERSAVF3')
             CHGDTAARA  DTAARA(ERCTLD (23 13)) VALUE('N*SAVFERSAVF4')
             CHGDTAARA  DTAARA(ERCTLD (39 22)) +
                          VALUE('NNNNNNNNNNNNNNNNNNNNNN')
             ENDPGM
