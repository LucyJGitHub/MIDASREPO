/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Nostro transfers selection')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas   FUNDS TRANSFER MODULE                               */
/*                       PAYMENTS MODULE                             */
/*                                                                   */
/*       FTC0175    NOSTRO TRANSFER SELECTION                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT006             Date 06Sep99              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                       097871           DATE     19Feb98           */
/*                       084923           DATE     13APR95           */
/*                       068077           DATE     24JAN94           */
/*                       042167           DATE     21JUL92           */
/*                       S01117           DATE     01JUL90           */
/*                       S01194           DATE     28SEP90           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*   CFT006 - Addition of RFT and CCT id to SDFTFRPD (recompile)     */
/*   097871 - Change submit so that it is correct                    */
/*   084923 - If Auto Pay Receive generation is in effect, send      */
/*            'MIDAS' message to MSTATUS to balance with             */
/*            MIDASRMV CALL, which otherwise removes a message       */
/*            sent by another job.                                   */
/*   068077 - Change submit so that it is correct                    */
/*   042167 - Include CL Program for record locking                  */
/*   S01117 - MULTIBRANCHING CHANGES                                 */
/*   S01194 - NEW DATABASE ERROR HANDLING                            */
/*                                                                   */
/*********************************************************************/
             PGM
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&APYR) TYPE(*CHAR) LEN(1)                 /*S01194*/
             DCL        VAR(&AUTH) TYPE(*CHAR) LEN(1)
 
                                                                      /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
/*/COPY WNCPYSRC,FTC0175001                                          */
 
/************DCLF       FILE(TABTB11)                        */       /*S01194*/
             DCLF       FILE(SDFTFRPD)                                /*S01194*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*  CALL PROGRAM & MONITOR FOR ERRORS                               */
 
/*           CALL       PGM(FT0175)                                 */
             CALL       PGM(FT0175) PARM(&AUTH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                          Press Enter to Continue.') TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
/**/
/* AUTOMATIC CALL OF PAY/RECEIVE INDICATOR - IF AUTHORISE FUNCT. */
 
             IF         COND(&AUTH = 'Y') THEN(DO)
/************RCVF       RCDFMT(TABTB11F)                    */        /*S01194*/
             RCVF       RCDFMT(SDFTFRD0)                              /*S01194*/
/************IF         COND((&APYR = 'Y')) THEN(DO)        */        /*S01194*/
             IF         COND((&BTAFTM = 'Y')) THEN(DO)                /*S01194*/
/**/                                                                  /*084923*/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                  /*084923*/
/**/                                                                  /*084923*/
/*/COPY WNCPYSRC,FTC0175002                                          */
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +      *068077*/
/************       RQSDTA('CALL PGM(FTC0630 parm('''' '''' '''')') 11 *068077*/
/************SBMJOB     CMD(CALL PGM(FTC0630) PARM('''' '''' '''')) +
                          JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                     /*068077* *097871*/
/************SBMJOB     CMD(CALL PGM(FTC0630) PARM('' '' '')) +                           /*CPK014*/
/************             JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +                       /*CPK014*/
/************             INLLIBL(*JOBD)                              /*097871*/          /*CPK014*/
/*************************RQSDTA('CALL PGM(FTC0630)')                 /*S01117*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CPK014*/
/************             JOBD(MBATCH) RTGDTA(*JOBD) INLLIBL(*JOBD)   /*S01117*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(FTC0630) PARM('' '' '')) +                           /*CSC023*/
/************             JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD)                         /*CPK014*/ /*CSC023*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CSC023*/
/************             JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(FTC0630) PARM('' '' '')) +
                          JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)                        /*CSC023*/
             SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +
                          JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
/*/COPY WNCPYSRC,FTC0175003                                          */
             ENDDO
             ENDDO
/**/
 
/**   DATABASE ERROR HANDLING   **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)             /*S01194*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
/*END:*******ENDPGM                                                   /*S01194*/
END:                                                                  /*S01194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/                                                                  /*042167*/
/* CALL AOC8000 to release locks */                                   /*042167*/
/**/                                                                  /*042167*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*042167*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*042167*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*042167*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*042167*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*042167*/
/**/                                                                  /*042167*/
             ENDPGM
 
