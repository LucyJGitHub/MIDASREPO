/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT PAYMENT CHARGES AUDIT AND LIST')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - PAYMENTS MODULE                             */
/*                                                                   */
/*       FTC0500    REPORT OF PAYMENT CHARGES                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1060743          Date 26Nov12              */
/*                      CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117               Date 28Sep90            */
/*                      S01194               Date 28SEP90            */
/*                          000000             DATE 00/00/00         */
/*                                                                   */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       AR1060743 - All HATS input initial screen appears a         */
/*                   confirmation of NWDC processing                 */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       S01117 - RELEASE 10 MULTIBRANCHING CHANGES                 */
/*       S01194 - STANDING DATA CHANGES                             */
/*********************************************************************/
/************PGM        PARM(&TYPE)                                  /*S01117*/
             PGM        PARM(&TYPE &RSEQ &RLEV &RENT)                /*S01117*/
/**/
/*******DCL***VAR(&MEM)   TYPE(*CHAR)   LEN(44)                      /*S01194*/
        DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                    /*S01194*/
        DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                     /*S01117*/
        DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                     /*S01117*/
        DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                     /*S01117*/
        DCL   VAR(&TYPE)  TYPE(*CHAR)   LEN(1)
/*******DCL   VAR(&MPHAS) TYPE(*CHAR)   LEN(1)                                         */ /*CCB020*/
        DCL   VAR(&MPHAS) TYPE(*CHAR)   LEN(4)                                            /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                     /*S01117*/
                                                                     /*S01117*/
/**/                                                                 /*S01194*/
/** CHECK IF LDA DATA AREA EXISTS AND CREATE IT IF NOT **/           /*S01194*/
/**/                                                                 /*S01194*/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)                         /*S01194*/
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))                 /*S01194*/
/**/
        CHGJOB     SWS(XXXXXX00)
/**/
/** retreive data area MPHAS  **/
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
/**********  CALL       PGM(CBC000001) PARM(&MPHAS)                             /*CCB020 AR1060743*/
             CALL       PGM(CBC001001) PARM(&MPHAS)                                    /*AR1060743*/
/**/
/**/
/*******IF* COND(%SST(&MPHAS 1 1) = 'C') THEN( +                                       */ /*CCB020*/
/********** SNDPGMMSG  MSG('FT0500 -  Payment charges reporting') +                    */ /*CCB020*/
/**********        TOMSGQ(MRUNQ))                                                      */ /*CCB020*/
        IF         COND(&MPHAS *EQ '*YES') THEN( +
            SNDPGMMSG  MSG('FT0500 -  Payment charges reporting') +
                   TOMSGQ(MRUNQ))                                                         /*CCB020*/
/**/                                                                 /*S01117*/
/** OVERRIDE PRINTER FILES TO  AU IF TYPE IS AUDIT                   /*S01117*/
/**/                                                                 /*S01117*/
             IF         COND(&TYPE *EQ 'A') THEN(OVRPRTF +
                          FILE(FT0500P1) OUTQ(MPRINTAU))             /*S01117*/
/**/
/*******CALL*PGM(FT0500) PARM(&TYPE)                                 /*S01117*/
        CALL PGM(FT0500) PARM(&RSEQ &RLEV &RENT &TYPE)               /*S01117*/
/**/
/**   DATABASE ERROR HANDLING   **/
/**/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/************RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&MEM)         /*S01194*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)         /*S01194*/
/**********  IF  COND(%SST(&MPHAS 1 1) = 'C') THEN( +                                  */ /*CCB020*/
/**********      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +                  */ /*CCB020*/
/**********        TOMSGQ(MRUNQ MOPERQ))                                               */ /*CCB020*/
             IF         COND(&MPHAS *EQ '*YES') THEN( +
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOMSGQ(MRUNQ MOPERQ))                                                  /*CCB020*/
             ELSE  CMD( +
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ))
        ENDDO
/**/
             DLTOVR     FILE(FT0500P1)                                /*S01117*/
             MONMSG     MSGID(CPF9841)                                /*S01117*/
/**/                                                                 /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
        ENDPGM
