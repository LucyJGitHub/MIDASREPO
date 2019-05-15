/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Market Prices Maintenance')                  */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0220  -  MARKET CENTRE PRICES MAINTENANCE                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      122228             Date 18Feb98              */
/*                      S01117             Date 05Jul90              */
/*                      E20718             Date 16Jan90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*   122228  -  FIELD &SBJOB INCORRECTLY SETTED UP.                  */
/*   S01117  -  MULTIBRANCHING                                       */
/*   E20718  -  ADD PARMS, RTGDTA(*JOBD) INLLIBL(*JOBD), TO SBMJOB   */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&PMRKT)   TYPE(*CHAR)  LEN(2)
             DCL        VAR(&PHEAD)   TYPE(*CHAR)  LEN(30)
             DCL        VAR(&SBJOB)   TYPE(*CHAR)  LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*   CALL PROMPT PROGRAM                                            */
/**/
 MARKETSLT:  CHGJOB     SWS(XXXX0XXX)
/**/
             CHGVAR     VAR(&PHEAD) VALUE('MARKET PRICES INPUT')
             CALL       PGM(FF1265) PARM(&PMRKT &PHEAD)
/*                                                                  */
/* FOR DATABASE ERRORS, GO TO END                                   */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO EXIT)
/**/
/***CMD/1*TAKEN,*MARKET*CENTRE*PARAMETER*WILL*BE*'**'***************/ /*S01117*/
/*  CMD/3 TAKEN, MARKET CENTRE PARAMETER WILL BE '03'              */ /*S01117*/
/*  CMD/12 TAKEN, MARKET CENTRE PARAMETER WILL BE '12'             */ /*S01117*/
/**/
/*********** IF         COND(&PMRKT *EQ '**') THEN(GOTO EXIT)      */ /*S01117*/
             IF         COND(&PMRKT *EQ '03') THEN(GOTO EXIT)         /*S01117*/
             IF         COND(&PMRKT *EQ '12') THEN(GOTO EXIT)         /*S01117*/
/*                                                                  */
/* CALL MARKET PRICES MAINTENANCE FOR REQUIRED MARKET               */
/**/
                  IF         COND(&PMRKT *NE '  ') THEN(DO)
                  OVRDBF PRICS MBR(&PMRKT)
                  OVRDBF PRICSA MBR(&PMRKT)
                  OVRDBF     FILE(PRICSX) TOFILE(PRICS) MBR(&PMRKT) SHARE(*NO)
/**/
                  ENDDO
                  ELSE DO
                  OVRDBF PRICS MBR(OTC)
                  OVRDBF PRICSA MBR(OTC)
                  OVRDBF     FILE(PRICSX) TOFILE(PRICS) MBR(OTC) SHARE(*NO)
                  ENDDO
/**/
             CALL       PGM(FF0220) PARM(&PMRKT)
/**/
             IF         COND(%SWITCH(1XXXXX00)) THEN(DO)
/*           CHGVAR     VAR(&SBJOB) VALUE('CALL FFC0221 PARM(' *CAT +
                          &PMRKT *CAT ')')                             122228 */
             IF         COND(&PMRKT *EQ '  ') THEN(DO)              /* 122228 */
             CHGVAR     VAR(&SBJOB) VALUE('CALL FFC0221 +
                          PARM(''OTC'')')                           /* 122228 */
                          ENDDO                                     /* 122228 */
                          ELSE CMD(DO)                              /* 122228 */
             CHGVAR     VAR(&SBJOB) VALUE('CALL FFC0221 PARM(''' +
                          *CAT &PMRKT *CAT ''')')                   /* 122228 */
                          ENDDO                                     /* 122228 */
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/************SBMJOB     JOB('RVAL' *CAT &PMRKT) JOBD(MBATCH) +        /*E20718*/
/************             USER(*JOBD) JOBQ(FFJQRV) RQSDTA(&SBJOB) +   /*E20718*/
/************             MSGQ(MOPERQ)                                /*E20718*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +      /*E20718*/
/************             JOBQ(FFJQRV) RQSDTA('CALL MIDASRMV') +      /*E20718*/
/************             MSGQ(MOPERQ)                                /*E20718*/
/************SBMJOB     JOB('RVAL' *CAT &PMRKT) JOBD(MBATCH) +                            /*CSC023*/
/************             JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ)                      /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)                          /*CSC023*/
             SBMJOB     JOB('RVAL' *CAT &PMRKT) JOBD(MBATCH) +
                          JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)          /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)              /*CSC023*/
/************                                                         /*E20718*/
             ENDDO
/**/
/* DELETE OVERRIDES                                                 */
/**/
             DLTOVR FILE(*ALL)
/**/
             IF         COND(&PMRKT *NE '  ') THEN(DO)
                  DLCOBJ     OBJ((&PMRKT *DTAARA *SHRRD))
             ENDDO
/**/
/* IF COMMAND/5 WAS TAKEN TO END PROGRAM, RETURN TO MARKET SELECTION*/
/**/
             IF         COND(%SWITCH(XXXX1X00)) THEN(GOTO +
                          CMDLBL(MARKETSLT))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
EXIT:        ENDPGM
