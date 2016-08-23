/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Monthly P/L Report (COB)')                   */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0685  -  MONTHLY P/L REPORT (COB)                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. 093912             DATE 04OCT95                  */
/*   PREV AMEND NO. S01456             DATE 06DEC93                  */
/*                  S01117             DATE 07MAY90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   093912  -  Branch positioning error if file empty - monitor     */
/*              for correct messages for DLTOVR and CLOF commands.   */
/*   S01456  -  Monthly profit and loss report.                      */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &RSEQ         TYPE(*CHAR)  LEN(5)             /*S01117*/
             DCL        &RLEV         TYPE(*CHAR)  LEN(1)             /*S01117*/
             DCL        &RENT         TYPE(*CHAR)  LEN(3)             /*S01117*/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)                  /*S01456*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)          /*S01456*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')     /*S01456*/
             DCL        VAR(&S01456) TYPE(*CHAR) LEN(1) VALUE(' ')    /*S01456*/
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)               /*S01456*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDMSG     MSG('FFC0685 - Monthly +
                          Profit and Loss Report') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
                                                                      /*S01456*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'S01456')          /*S01456*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&S01456) VALUE('Y'))        /*S01456*/
/**/                                                                  /*S01456*/
/*   IF THE FEATURE S01456 IS NOT ON:                              */ /*S01456*/
/**/                                                                  /*S01456*/
             IF COND(&S01456 *NE 'Y') THEN(DO)                        /*S01456*/
/**/                                                                  /*S01456*/
                                                                      /*S01456*/
/**/
/*   CLEAR P/L EXTRACT FILE AND CALL FF1240 TO EXTRACT P/L DETAILS */
/**/
             CLRPFM     BOKPL
/**/
/*   CALL FF1240 TO PRODUCE MONTHLY P/L REPORT EXTRACT            */
/**/
             CALL       PGM(FF1240)
/**/
/*   CALL FF1250 TO PRODUCE MONTHLY P/L REPORT                     */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01117*/
                        OVRDBF FILE(BOKPL) POSITION(*KEY 1 +
                        BOKPLF &RENT)                                 /*S01117*/
                        OPNDBF FILE(BOKPL) OPTION(*ALL)              /*S01117*/
                        MONMSG MSGID(CPF0000) EXEC(DO)                /*S01117*/
                        DLTOVR FILE(BOKPL)                           /*S01117*/
                        ENDDO                                         /*S01117*/
                        ENDDO                                         /*S01117*/
/*********** CALL       PGM(FF1250)                                */ /*S01117*/
             CALL       PGM(FF1250) PARM(&RSEQ &RENT)                 /*S01117*/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01117*/
                        DLTOVR FILE(BOKPL)                           /*S01117*/
                        MONMSG MSGID(CPF9841)                         /*S01117*/
                        ENDDO                                         /*S01117*/
             ENDDO
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
             ENDDO                                                    /*S01456*/
/**/
/*   IF THE FEATURE S01456 IS ON:                                  */ /*S01456*/
/**/                                                                  /*S01456*/
             IF COND(&S01456 *EQ 'Y') THEN(DO)                        /*S01456*/
/**/                                                                  /*S01456*/
/*   CLEAR P/L EXTRACT FILE AND CALL FF1241 TO EXTRACT P/L DETAILS */ /*S01456*/
/**/                                                                  /*S01456*/
             CLRPFM     BOKPL                                         /*S01456*/
/**/                                                                  /*S01456*/
/*   CALL FF1241 TO PRODUCE MONTHLY P/L REPORT EXTRACT            */  /*S01456*/
/**/                                                                  /*S01456*/
             OVRDBF     FILE(POSTNK) MBR(OTC)                         /*S01456*/
             CALL       PGM(FF1241) PARM(' ')                         /*S01456*/
/**/                                                                  /*S01456*/
/*   CALL FF1250 TO PRODUCE MONTHLY P/L REPORT                     */ /*S01456*/
/**/                                                                  /*S01456*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*S01456*/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01456*/
                        OVRDBF FILE(BOKPL) POSITION(*KEY 1 +
                        BOKPLF &RENT)                                 /*S01456*/
                        OPNDBF FILE(BOKPL) OPTION(*ALL)               /*S01456*/
                        MONMSG MSGID(CPF0000) EXEC(DO)                /*S01456*/
                        DLTOVR FILE(BOKPL)                            /*S01456*/
                        ENDDO                                         /*S01456*/
                        ENDDO                                         /*S01456*/
             CALL       PGM(FF1250) PARM(&RSEQ &RENT)                 /*S01456*/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01456*/
                        DLTOVR FILE(BOKPL)                            /*S01456*/
                        MONMSG MSGID(CPF9841)                         /*S01456*/
                        CLOF (BOKPL)                                  /*S01456*/
                        MONMSG MSGID(CPF4520)                         /*093912*/
          /*************MONMSG MSGID(CPF9841)                  /*S01456 093912*/
                        ENDDO                                         /*S01456*/
             ENDDO                                                    /*S01456*/
/**/                                                                  /*S01456*/
             DLTOVR FILE(POSTNK)                                      /*S01456*/
/**/                                                                  /*S01456*/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      * /*S01456*/
/* MESSAGE TO MOPERQ AND MRUNQ.                                     * /*S01456*/
/**/                                                                  /*S01456*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01456*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01456*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01456*/
             ENDDO                                                    /*S01456*/
/**/                                                                  /*S01456*/
/* IF THE SAR IS SWITCHED ON THEN:                                  *  *S01456*/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC     *  *S01456*/
/**/                                                                  /*S01456*/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)                  /*S01456*/
/**/                                                                  /*S01456*/
 LOOP:       CHGJOB     SWS(XXXXXX00)                                 /*S01456*/
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(END))                 /*S01456*/
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))            /*S01456*/
/**/                                                                  /*S01456*/
/*  OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR MARKET         * *S01456*/
/**/                                                                  /*S01456*/
             OVRDBF     FILE(POSTNK) MBR(&MKT)                        /*S01456*/
             CLRPFM     BOKPL                                         /*S01456*/
/**/                                                                  /*S01456*/
/*   CALL FF1241 TO PRODUCE MONTHLY P/L REPORT EXTRACT            */  /*S01456*/
/**/                                                                  /*S01456*/
             CALL       PGM(FF1241) PARM(&MKT)                        /*S01456*/
/**/                                                                  /*S01456*/
/*   CALL FF1250 TO PRODUCE MONTHLY P/L REPORT                     */ /*S01456*/
/**/                                                                  /*S01456*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*S01456*/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01456*/
                        OVRDBF FILE(BOKPL) POSITION(*KEY 1 +
                        BOKPLF &RENT)                                 /*S01456*/
                        OPNDBF FILE(BOKPL) OPTION(*ALL)               /*S01456*/
                        MONMSG MSGID(CPF0000) EXEC(DO)                /*S01456*/
                        DLTOVR FILE(BOKPL)                            /*S01456*/
                        ENDDO                                         /*S01456*/
                        ENDDO                                         /*FF014 */
             CALL       PGM(FF1250) PARM(&RSEQ &RENT)                 /*S01456*/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01456*/
                        DLTOVR FILE(BOKPL)                            /*S01456*/
                        MONMSG MSGID(CPF9841)                         /*093912*/
                        CLOF (BOKPL)                                  /*S01456*/
                        MONMSG MSGID(CPF4520)                         /*093912*/
           /************MONMSG MSGID(CPF9841)                  /*S01456 093912*/
                        ENDDO                                         /*S01456*/
             ENDDO                                                    /*S01456*/
             DLTOVR     FILE(POSTNK)                                  /*S01456*/
/**/                                                                  /*S01456*/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      * /*S01456*/
/* MESSAGE TO MOPERQ AND MRUNQ.                                     * /*S01456*/
/**/                                                                  /*S01456*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01456*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01456*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01456*/
             ENDDO                                                    /*S01456*/
/**/                                                                  /*S01456*/
             CHGVAR     VAR(&A) VALUE(&A + 2)                         /*S01456*/
             GOTO       CMDLBL(LOOP)                                  /*S01456*/
             ENDDO                                                    /*S01456*/
             RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
END:                                                                  /*S01456*/
             ENDPGM
