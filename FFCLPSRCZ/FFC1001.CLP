/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Start EOC processing control')               */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1001  -  START END OF CENTRE PROCESSING CONTROL              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG9619            Date 01Feb06              */
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      199720             Date 19Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CED005             Date 11Aug97              */
/*                      S01117             Date 21Jun90              */
/*                  E20718             DATE 16JAN90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       199720 - Clear MKCMPD before adding new components for End  */
/*                Of Centre run, use *REPLACE instead of *ADD.       */
/*   CED005  -  Trade MIS and Cashflow                               */
/*   S01117  -  MULTIBRANCHING                                       */
/*   E20718  -  ADD PARMS, RTGDTA(*JOBD) INLLIBL(*JOBD), TO SBMJOB   */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        &MARKT        TYPE(*CHAR)  LEN(2)
             DCL        &ACT          TYPE(*CHAR)  LEN(1)
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &MSG          TYPE(*CHAR)  LEN(70)
             DCL        &ESD          TYPE(*CHAR)  LEN(12)
             DCL        VAR(&ED_RTCD) TYPE(*CHAR) LEN(7)              /*CED005*/
             DCL        VAR(&ED_FMT)  TYPE(*CHAR) LEN(200)            /*CED005*/
             DCL        &ESD          TYPE(*CHAR)  LEN(12)            /*CED005*/
             DCL        VAR(&SBJOB)   TYPE(*CHAR)  LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             ALCOBJ     OBJ((FFECA *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO MONACT)
/**/
             SNDPGMMSG  MSG('End of Centre Monitor must be active +
                        before program can be run') TOPGMQ(*EXT)
             DLCOBJ     OBJ((FFECA *DTAARA *EXCL))
             GOTO CMDLBL(END)
/**/
/*    Monitor Active Processing.                                     */
/**/
 MONACT:     IF         COND(&MARKT *NE '  ') THEN(DO)
             DLCOBJ     OBJ((&MARKT *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
             CHGVAR     VAR(&ACT) VALUE(' ')
             CHGVAR     VAR(&MARKT) VALUE('  ')
             CHGJOB     SWS(XXXXXX00)
/**/
             OVRDBF MKCTLX MKCTL
/**/
             CALL       PGM(FF0470) PARM(&ACT &MARKT)
/**/
/*    DATABASE ERROR                                                 */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********  RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         */ /*S01117*/
              RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)            /*S01117*/
              SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                         MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
              GOTO CMDLBL(END)
             ENDDO
/**/
/*    If the Market and Action are Blank, the User has finished.     */
/**/
             IF         COND((&ACT *EQ ' ') *AND (&MARKT *EQ '  ')) +
                          THEN(GOTO CMDLBL(END))
/**/
/*    Call FF0475 and do relevant DB Error processing after sending  */
/*    Journal Entries (denoting start of EOC and component on journal*/
/*                                                                   */
/*    If the Action is 'I' an End of Centre is being Initiated       */
/**/
             IF         COND(&ACT *EQ 'I') THEN(DO)
                   CHGVAR     VAR(&ESD) VALUE('          ' *CAT &MARKT)
/**********        SNDJRNE    JRN(ICJRN) TYPE('FC') ENTDTA(&ESD) */                      /*BUG9619*/
                   SNDJRNE    JRN(ICJRN) TYPE('FC') ENTDTA(&ESD) +
                          FORCE(*YES)                                                    /*BUG9619*/
/**********        SNDJRNE    JRN(ICJRN) TYPE('NC') ENTDTA(&ESD) */                      /*BUG9619*/
                   SNDJRNE    JRN(ICJRN) TYPE('NC') ENTDTA(&ESD) +
                          FORCE(*YES)                                                    /*BUG9619*/
 
/* If ED module FF account key extract required save existing data */ /*CED005*/
/* for recovery */                                                    /*CED005*/
             CALL       PGM(AOBUTFR0) PARM('EDFKEYPD' '          ' +
                          &ED_RTCD &ED_FMT)                           /*CED005*/
             IF         COND(&ED_RTCD *NE '*FAILED') THEN(DO)         /*CED005*/
                                                                      /*CED005*/
/* Add member for market in case it doesn't exist */                  /*CED005*/
             ADDPFM     FILE(EDSFKYPD) MBR(&MARKT)                    /*CED005*/
             MONMSG     MSGID(CPF7306)                                /*CED005*/
                                                                      /*CED005*/
/* Save existing data (if any) for recovery */                        /*CED005*/
             CPYF       FROMFILE(EDSFKYPD) TOFILE(XEDSFKYPD) +
                          FROMMBR(&MARKT) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)                            /*CED005*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XEDSFKYPD) MBR(&MARKT))                /*CED005*/
                                                                      /*CED005*/
                          ENDDO                                       /*CED005*/
/**/
/*              Call FF0475 to prompt for End of Centre Indicators   */
/**/
                   CALL       PGM(FF0475) PARM(&MARKT)
/**/
                   IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                    CALL       PGM(FF0472) PARM('F' &MARKT)
                    CHGVAR     VAR(&MSG) VALUE('End of Centre +
                    Reporting Parameter Prompt ended abnormally')
                    CALL       PGM(FF0473) PARM(&MARKT 'I' &MSG)
/***********        RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)   */ /*S01117*/
                    RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)      /*S01117*/
                    SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                               MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                    GOTO CMDLBL(MONACT)
                   ENDDO
/**/
                   CHGVAR     VAR(&MSG) VALUE('End of Centre +
                                initiated')
                   CALL       PGM(FF0473) PARM(&MARKT 'I' &MSG)
/**/
/*    Prices Input Processing                                        */
/**/
             CHGVAR     VAR(&MSG) VALUE('End of Centre Prices Input +
                          in progress ')
             CALL       PGM(FF0473) PARM(&MARKT ' ' &MSG)
/**/
             CHGJOB     SWS(00000000)
             OVRDBF     FILE(PRICSA) MBR(&MARKT)
             OVRDBF     FILE(PRISPA) MBR(&MARKT)
             OVRDBF     FILE(POSTN4) MBR(&MARKT)
             OVRDBF     FILE(PRICS) MBR(&MARKT)
             OVRDBF     FILE(PRISP) MBR(&MARKT)
/**/
             CALL       PGM(FF0310) PARM(&MARKT ' ' ' ')
/**/
             DLTOVR *ALL
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 CALL       PGM(FF0472) PARM('F' &MARKT)
                 CHGVAR     VAR(&MSG) VALUE('End of Centre Prices +
                              Input ended abnormally')
                 CALL       PGM(FF0473) PARM(&MARKT 'I' &MSG)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                 GOTO CMDLBL(MONACT)
             ENDDO
/**/
             IF         COND(%SWITCH(1XXXXX00)) THEN(DO)
                 CALL       PGM(FF0472) PARM(' ' &MARKT)
                 CHGVAR     VAR(&MSG) VALUE('End of Centre +
                              terminated')
                 CALL       PGM(FF0473) PARM(&MARKT 'I' &MSG)
                 GOTO CMDLBL(MONACT)
             ENDDO
 
/**/
/*  Set up Components to be run                                      */
/**/
/**********  CPYF       FROMFILE(CMPRND) TOFILE(MKCMPD) TOMBR(&MARKT) +
                          MBROPT(*ADD) */                                                 /*199720*/
             CPYF       FROMFILE(CMPRND) TOFILE(MKCMPD) TOMBR(&MARKT) +
                          MBROPT(*REPLACE)                                                /*199720*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ERR1))
             GOTO CMDLBL(NEXT2)
/**/
ERR1:        CALL       PGM(FF0472) PARM('F' &MARKT)
             SNDPGMMSG  MSG('Set up list of End of Centre components +
               ended abnormally for ' *CAT &MARKT) TOPGMQ(*EXT) +
               TOMSGQ(MOPERQ)
             CHGVAR     VAR(&MSG) VALUE('Components list creation +
                        terminated Abnormally')
             CALL       PGM(FF0473) PARM(&MARKT 'I' &MSG)
             CHGVAR     VAR(&MSG) VALUE('End of Centre terminated')
             CALL       PGM(FF0473) PARM(&MARKT 'I' &MSG)
             GOTO CMDLBL(MONACT)
NEXT2:       CHGVAR     VAR(&SBJOB) VALUE('CALL FFC1077 PARM(' *CAT +
                          &MARKT *CAT ')')
/************SBMJOB     JOB(&MARKT *CAT 'EOC') JOBD(MBATCH) +         /*E20718*/
/************             USER(*JOBD) JOBQ(FFJQEC) RQSDTA(&SBJOB) +   /*E20718*/
/************             MSGQ(MOPERQ)                                /*E20718*/
/************SBMJOB     JOB(&MARKT *CAT 'EOC') JOBD(MBATCH) +                             /*CSC023*/
/************             JOBQ(FFJQEC) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ)  /*E20718*/          /*CSC023*/
             SBMJOB     JOB(&MARKT *CAT 'EOC') JOBD(MBATCH) +
                          JOBQ(FFJQEC) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)          /*CSC023*/
/************                                                         /*E20718*/
             CALL       PGM(FF0472) PARM('Q' &MARKT)
             CHGVAR     VAR(&MSG) VALUE('End of Centre submitted to +
                        job queue')
             CALL       PGM(FF0473) PARM(&MARKT ' ' &MSG)
             GOTO CMDLBL(MONACT)
             ENDDO
/**/
/*    If the Action is 'H' an End of Centre submitted is to be held  */
/**/
             IF         COND(&ACT *EQ 'H')  THEN(DO)
             CHGDTAARA  DTAARA(&MARKT (1 1)) VALUE('H')
             CHGVAR     VAR(&MSG) VALUE('Hold requested for End of +
                        Centre')
             CALL       PGM(FF0473) PARM(&MARKT ' ' &MSG)
             GOTO CMDLBL(MONACT)
             ENDDO
/**/
/*    If the Action is 'R' an End of Centre is to be re-started    */
/**/
             IF         COND(&ACT *EQ 'R')  THEN(DO)
              CHGVAR     VAR(&SBJOB) VALUE('CALL FFC1077 PARM(' *CAT +
                           &MARKT *CAT ')')
/************ SBMJOB     JOB(&MARKT *CAT 'EOC') JOBD(MBATCH) +        /*E20718*/
/************             USER(*JOBD) JOBQ(FFJQEC) RQSDTA(&SBJOB) +   /*E20718*/
/************             MSGQ(MOPERQ)                                /*E20718*/
/************SBMJOB     JOB(&MARKT *CAT 'EOC') JOBD(MBATCH) +                             /*CSC023*/
/************             JOBQ(FFJQEC) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ)  /*E20718*/          /*CSC023*/
             SBMJOB     JOB(&MARKT *CAT 'EOC') JOBD(MBATCH) +
                          JOBQ(FFJQEC) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)          /*CSC023*/
/************                                                         /*E20718*/
              CALL       PGM(FF0472) PARM('Q' &MARKT)
              CHGVAR     VAR(&MSG) VALUE('End of Centre restarted')
              CALL       PGM(FF0473) PARM(&MARKT 'I' &MSG)
              CHGVAR     VAR(&MSG) VALUE('End of Centre submitted +
                         to job queue')
              CALL       PGM(FF0473) PARM(&MARKT ' ' &MSG)
              GOTO CMDLBL(MONACT)
             ENDDO
/**/
/*    If the Action is 'C' a Component is to be re-started.          */
/**/
             IF         COND(&ACT *EQ 'C')  THEN(DO)
/**/
             CALL       PGM(FF0472) PARM('C' &MARKT)
             CHGVAR     VAR(&MSG) VALUE('Component has been restarted +
                        for failed End of Centre')
             CALL       PGM(FF0473) PARM(&MARKT ' ' &MSG)
/**/
             CALL       PGM(FFC1090) PARM(&MARKT 'N')
/**/
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)
               CHGVAR     VAR(&SBJOB) VALUE('CALL FFC1077 PARM(' *CAT +
                          &MARKT *CAT ')')
/************  SBMJOB     JOB(&MARKT *CAT 'EOC') JOBD(MBATCH) +       /*E20718*/
/************              USER(*JOBD) JOBQ(FFJQEC) RQSDTA(&SBJOB) +  /*E20718*/
/************              MSGQ(MOPERQ)                               /*E20718*/
/************SBMJOB     JOB(&MARKT *CAT 'EOC') JOBD(MBATCH) +                             /*CSC023*/
/************             JOBQ(FFJQEC) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ)  /*E20718*/          /*CSC023*/
             SBMJOB     JOB(&MARKT *CAT 'EOC') JOBD(MBATCH) +
                          JOBQ(FFJQEC) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)          /*CSC023*/
/************                                                         /*E20718*/
               CALL       PGM(FF0472) PARM('Q' &MARKT)
               CHGVAR     VAR(&MSG) VALUE('End of Centre submitted to +
                          job queue')
               CALL       PGM(FF0473) PARM(&MARKT ' ' &MSG)
             ENDDO
/**/
             GOTO CMDLBL(MONACT)
             ENDDO
/**/
/*    If the Action is 'O' a Market is to be Re-opened for Input     */
/**/
             IF         COND(&ACT *EQ 'O')  THEN(DO)
/**/
             CALL       PGM(FF0472) PARM('O' &MARKT)
             CHGVAR     VAR(&MSG) VALUE('Market being reopened for +
                        input')
             CALL       PGM(FF0473) PARM(&MARKT ' ' &MSG)
/**/
             CALL       PGM(FFC1090) PARM(&MARKT 'F')
/**/
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)
                CALL       PGM(FF0472) PARM(' ' &MARKT)
             ENDDO
/**/
             GOTO CMDLBL(MONACT)
             ENDDO
 
/**/
             GOTO       CMDLBL(END)   /* Normal termination*/
/**/
/* Abnormal termination                                              */
/**/
 ABNOR:      IF         COND(&MARKT *NE '  ')  THEN(DO)
             CALL       PGM(FF0472) PARM('F' &MARKT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&MSG) VALUE('End of Centre Processing +
                        Control ended abnormally')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CALL       PGM(FF0473) PARM(&MARKT 'I' &MSG)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&MARKT *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
             SNDPGMMSG  MSG('End of Centre Processing Control ended +
                             abnormally') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 END:        DLTOVR *ALL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                  */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
