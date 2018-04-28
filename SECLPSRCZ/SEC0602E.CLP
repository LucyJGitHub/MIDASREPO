/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Generate a/c keys - depot movements')        */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0602E  GENERATE A/C KEYS - DEPOT MOVEMENTS              */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG8854            Date 10Oct05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CSE017             Date 20Oct99              */
/*                      171446             Date 11Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      102903         DATE 07MAY96                 */
/*                      S01408         DATE 10MAY95                 */
/*                      S01189         DATE 07JAN91                 */
/*                      S01117         DATE 10DEC90                 */
/*                      S01271         DATE 08JUN90                 */
/*                      E16870         DATE 08/03/89                */
/*                      S01176         DATE 20/10/88                */
/*                      S01179         DATE 16/09/88                */
/*                      S01129         DATE 31/03/88                */
/*                                                                  */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG8854- Remove Unneccesary delay wait.                     */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
/*       171446 - Amend fix 102903 to copy files initially           * *102903*/
/*       102903 - make security copies DPTMVD and DPTMVA which are   * *102903*/
/*                updated during processing of SE2200.               * *102903*/
/*                This corrects the restart processing.              * *102903*/
/*       S01408 - Addition of core hook SEC0602EMS                   */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2             */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01271 - PAY/RECEIVE IN INPUT CYCLE                         * *S01271*/
/*                DO NOT CLEAR OTHSTD FILE AS THIS MAY CONTAIN DATA  * *S01271*/
/*                FROM FAILED I/C PAY/RECEIVE RUN.  N.B. SE2200 NO   * *S01271*/
/*                LONGER EXTRACTS DATA TO OTHSTD - THIS IS DONE BY   * *S01271*/
/*                SE3310.                                            * *S01271*/
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                     * *E16870*/
/*       S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)                 * *S01176*/
/*       S01179 - ABS INCORPORATION                                  * *S01179*/
/*                                                                   */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/********    PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/********    DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
/*           DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)                 *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
 
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/*           DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
/*           DCLDTAARA  DTAARA(SDSTAT)                    *  *S01129*  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)     /*S01179E16870*/
/********    DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
                                                                      /*S01129*/
/*           RCVDTAARA DTAARA(SDSTAT)                     *  *S01129*  *S01179*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                 /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0602EMS                                          */
                                                                      /*S01408*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0602E - GENERATE A/C KEYS +
                          - DEPOT MOVEMENTS')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SET OFF SWITCHES                                              */
 
             CHGJOB     SWS(00000000)
 
/* CLEAR OUTPUT FILES                                            */
 
             CLRPFM     FILE(SEKEYD) MBR(DEPOTMVT)
             CLRPFM     FILE(SEKEYA) MBR(DEPOTMVT)
/************CLRPFM*****FILE(OTHSTD)***                   *S01176*     *S01271*/
/************CLRPFM*****FILE(OTHSTA)***                   *S01176*     *S01271*/
 
/* CHECK FOR COMPONENT RESTART                                   */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART, DISABLE ACCESS PATHS                              */
 
/********    IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
                RMVM       FILE(UDPAC)     MBR(UDPAC)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(CDPAC)     MBR(CDPAC)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(DEPAC)     MBR(DEPAC)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(DPMCP)     MBR(DPMCP)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(CSPAC)     MBR(CSPAC)
                MONMSG     MSGID(CPF0000)
 
/* IF RESTART, OVERRIDE TO SEQONLY(*YES 100)                     */
 
                OVRDBF     FILE(XUDPMVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XUDPMVA) SEQONLY(*YES 100)
                OVRDBF     FILE(XCDPMVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XCDPMVA) SEQONLY(*YES 100)
                OVRDBF     FILE(UDPMVD)  SEQONLY(*YES 100)
                OVRDBF     FILE(UDPMVA)  SEQONLY(*YES 100)
                OVRDBF     FILE(CDPMVD)  SEQONLY(*YES 100)
                OVRDBF     FILE(CDPMVA)  SEQONLY(*YES 100)
 
/* AND COPY FILES                                                */
 
                CPYF       FROMFILE(XDPTMVD) TOFILE(DPTMVD) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*102903*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DPTMVD)                        /*102903*/
                CPYF       FROMFILE(XDPTMVA) TOFILE(DPTMVA) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*102903*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DPTMVA)                        /*102903*/
 
                CPYF       FROMFILE(XUDPMVD) TOFILE(UDPMVD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM UDPMVD)
                CPYF       FROMFILE(XUDPMVA) TOFILE(UDPMVA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM UDPMVA)
                CPYF       FROMFILE(XCDPMVD) TOFILE(CDPMVD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CDPMVD)
                CPYF       FROMFILE(XCDPMVA) TOFILE(CDPMVA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CDPMVA)
 
/* CHANGE DATA AREA TO 'OLD'                                    */
 
/********       CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
/**/
 
             ENDDO
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
 
                DLTF       FILE(XUDPMVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XUDPMVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCDPMVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCDPMVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XDPTMVD)                              /*102903*/
                   MONMSG MSGID(CPF0000)                              /*102903*/
                DLTF       FILE(XDPTMVA)                              /*102903*/
                   MONMSG MSGID(CPF0000)                              /*102903*/
 
/* COPY FILES                                                    */
 
/*              CPYF       FROMFILE(UDPMVD) TOFILE(XUDPMVD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XUDPMVD)                     *  *S01129*/
/*              CPYF       FROMFILE(UDPMVA) TOFILE(XUDPMVA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XUDPMVA)                     *  *S01129*/
/*              CPYF       FROMFILE(CDPMVD) TOFILE(XCDPMVD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XCDPMVD)                     *  *S01129*/
/*              CPYF       FROMFILE(CDPMVA) TOFILE(XCDPMVA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XCDPMVA)                     *  *S01129*/
             CPYF       FROMFILE(UDPMVD) TOFILE(&TOLIB/XUDPMVD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XUDPMVD)                       /*S01129*/
             CPYF       FROMFILE(UDPMVA) TOFILE(&TOLIB/XUDPMVA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XUDPMVA)                       /*S01129*/
             CPYF       FROMFILE(CDPMVD) TOFILE(&TOLIB/XCDPMVD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCDPMVD)                       /*S01129*/
             CPYF       FROMFILE(CDPMVA) TOFILE(&TOLIB/XCDPMVA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCDPMVA)                       /*S01129*/
             CPYF       FROMFILE(DPTMVD) TOFILE(&TOLIB/XDPTMVD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*171446*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XDPTMVD)                       /*171446*/
             CPYF       FROMFILE(DPTMVA) TOFILE(&TOLIB/XDPTMVA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*171446*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XDPTMVA)                       /*171446*/
 
/* CHANGE DATA AREA TO 'NEW'                                    */
 
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  DISABLE ACCESS PATHS FOR LFs NOT REQUIRED                   */
 
             RMVM       FILE(UDPAC)     MBR(UDPAC)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(CDPAC)     MBR(CDPAC)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(DEPAC)    MBR(DEPAC)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(DPMCP)    MBR(DPMCP)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(CSPAC)    MBR(CSPAC)
             MONMSG     MSGID(CPF0000)
 
/* OVERRIDE FILES                                                */
 
             OVRDBF     FILE(SEKEYD) MBR(DEPOTMVT)
             OVRDBF     FILE(SEKEYA) MBR(DEPOTMVT)
 
/* CALL THE PROGRAM                                              */
 
/* DLYJOB 120                                                    */                      /*BUG8854*/
             CALL       PGM(SE2200)
 
/* DELETE OVERRIDE                                               */
 
             DLTOVR     FILE(*ALL)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
/**/
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/*              CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 44))   S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0602E - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE IMBALANCE ERROR */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
            CHGVAR     VAR(&MEM) VALUE('SEC0602E - FILE CONTROLS OUT +
                          OF BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*  IF NO ERRORS CLEAR FILES                                     */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*           CLRPFM     FILE(XUDPMVD)                               *  *S01129*/
/*           CLRPFM     FILE(XUDPMVA)                               *  *S01129*/
/*           CLRPFM     FILE(XCDPMVD)                               *  *S01129*/
/*           CLRPFM     FILE(XCDPMVA)                               *  *S01129*/
                DLTF       FILE(XUDPMVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XUDPMVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCDPMVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XCDPMVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                                                      /*Begin 102903*/
     DLTF FILE(XDPTMVD)
     MONMSG MSGID(CPF0000)
     DLTF FILE(XDPTMVA)
     MONMSG MSGID(CPF0000)
                                                        /*End 102903*/
             ENDDO
 
/*  ENABLE FILE ACCESS PATHS                                     */
 
ENDPGM:      ADDLFM     FILE(UDPAC)    MBR(UDPAC)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(CDPAC)    MBR(CDPAC)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(DEPAC)   MBR(DEPAC)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(DPMCP)   MBR(DPMCP)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(CSPAC)   MBR(CSPAC)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
