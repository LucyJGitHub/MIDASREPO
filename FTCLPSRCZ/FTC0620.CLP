/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT CHEQUE CLEARING MAINTENANCE')                */
/*********************************************************************/
/*                                                                   */
/*       Midas       FUNDS TRANSFER MODULE                       */
/*                                                                   */
/*       FTC0620 - CHEQUE  CLEARING MAINTENANCE                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01194             Date 7JUn90               */
/*                                                                   */
/*********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       S01194 - STANDING DATA CHANGES                              */
/*       S01117 - RELEASE 10 MULTIBRANCHING CHANGES                  */
/*********************************************************************/
 
START:  PGM        /* CL Program for running Cheque Clearing +
                      Maintenance Program. */
/**/
/**     DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)                    /*S01194*/
        DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
        CHGJOB     SWS(XXXXXX00)
/**/
/***************************************************/
/**  Call Program & Monitor for Untrapped Errors  **/
/***************************************************/
/**/
        CALL       PGM(FT0620)
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                   ROLLBACK
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)
                   GOTO END
        ENDDO
/**/
/****************************************************/
/**  Check for Database Errors Trapped by Program  **/
/****************************************************/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(DO)
           ROLLBACK
/**        RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)             /*S01194*/
           RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)             /*S01194*/
           SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                      TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                                                                     /*S01117*/
             ENDPGM                                                  /*S01117*/
/** END:    ENDPGM                                                   /*S01117*/
