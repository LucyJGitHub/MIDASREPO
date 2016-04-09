/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT PAYMENT CHARGES MAINTENANCE')                */
/********************************************************************/
/*                                                                  */
/*       Midas       FUNDS TRANSFER MODULE                      */
/*                                                                  */
/*       FTC0030  - CL COMPONENT TO CONTROL FT0030                  */
/*                  PAYMENT CHARGES MAINTENANCE.                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  S01194           DATE     29JUN90          */
/*       PREV AMEND NO.  XXXXXX           DATE     DDMMMYY          */
/*                                                                  */
/********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)                /*S01194*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*S01194*/
             CHGJOB     SWS(XXXXXX00)
/**/
/** Call program & monitor for untrapped errors **/
/**/
/************OVRDBF     FILE(TABLE) TOFILE(TABFP)                     /*S01194*/
             CALL       PGM(FT0030)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                        ROLLBACK
                        SNDPGMMSG  MSG('Transaction Failed. +
                                        Re-input necessary. +
                                        Press Enter to Continue.') +
                                   TOPGMQ(*EXT)
                        GOTO END
             ENDDO
/**/
/** Check for database errors trapped by program **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)         /*S01194*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01194*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
/**/
/*END:*******DLTOVR     FILE(TABLE)                                   /*S01194*/
/************MONMSG     MSGID(CPF9841)                                  S01194*/
END:                                                                  /*S01194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
