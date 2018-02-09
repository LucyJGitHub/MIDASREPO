/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Nostro transfers authorisation')             */
/*********************************************************************/
/*                                                                   */
/*       Midas   FUNDS TRANSFER MODULE                               */
/*                                                                   */
/*       FTC0130    NOSTRO TRANSFERS AUTHORISATION                   */
/*                            SELECTION                              */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/*                      CFT006             Date 06Sep99              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                          110242             DATE 07NOV96          */
/*                          084923             DATE  13APR95         */
/*                          042167             DATE  21JUL92         */
/*                          S01117             DATE  24SEP90         */
/*                          S01194             DATE  24SEP90         */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CFT006 - Addition of RFT and CCT id to SDFTFRPD (recompile) */
/*       110242  -  Change defaults for SBMJOB cmd to take *JOBD     */
/*       084923  -  If Auto Pay Receive generation is in effect, send*/
/*                  'MIDAS' message to MSTATUS to balance with       */
/*                  MIDASRMV CALL, which otherwise removes a message */
/*                  sent by another job.                             */
/*       042167  -  Include CL Program for record locking            */
/*       S01194  -  NEW DATABASE HANDLING                            */
/*       S01117  -  RELEASE 10 MULTIBRANCHING CHANGES                */
/*********************************************************************/
/**          PGM                                                      /*S01117*/
             PGM        PARM(&BRCH &BORO &PCMD)                       /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**          DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01194*/
/**          DCL        VAR(&APYR)  TYPE(*CHAR) LEN(1)                /*S01194*/
/**          DCLF       FILE(TABTB11)                                 /*S01194*/
             DCLF       FILE(SDFTFRPD)                                /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&BRCH) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&BORO) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(1)                 /*S01117*/
 
                                                                      /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
/*/COPY WNCPYSRC,FTC0130001                                          */
 
 
             CHGJOB     SWS(XXXXXX00)
 
/*  CALL PROGRAM & MONITOR FOR ERRORS                               */
 
/**          CALL       PGM(FT0130)                                   /*S01117*/
             CALL       PGM(FT0130) PARM(&BRCH &BORO &PCMD)           /*S01117*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                          Press Enter to Continue.') TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
/**/
/* AUTOMATIC CALL OF PAY/RECEIVE INDICATOR */
 
/**          RCVF       RCDFMT(TABTB11F)                              /*S01194*/
/**          IF         COND((&APYR = 'Y')) THEN(DO)                  /*S01194*/
             RCVF       RCDFMT(SDFTFRD0)                              /*S01194*/
             IF         COND((&BTAFTM = 'Y')) THEN(DO)                /*S01194*/
/**/                                                                  /*084923*/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                  /*084923*/
/**/                                                                  /*084923*/
/*/COPY WNCPYSRC,FTC0130002                                          */
/**          SBMJOB     JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +     /*S01117*/
/**                       RQSDTA('CALL PGM(FTC0630)')                 /*S01117*/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +     /*110242*/
/*************      RQSDTA('CALL PGM(FTC0630) PARM('''' '''' '''')')  /*110242*/
/*************                                                 /*S01117 110242*/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +                         /*CPK014*/
/************             RQSDTA('CALL PGM(FTC0630) PARM('''' '''' +                      /*CPK014*/
/************             '''')') INLLIBL(*JOBD)                      /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CPK014*/
/************             JOBD(MBATCH) RTGDTA(*JOBD) INLLIBL(*JOBD)   /*S01117*/          /*CPK014*/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +                           /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL PGM(FTC0630) +                       /*CSC023*/
/************             PARM('''' '''' '''')') INLLIBL(*JOBD)                /*CPK014*/ /*CSC023*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CSC023*/
/************             JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(FTC0630) +
                          PARM('''' '''' '''')') INLLIBL(*JOBD) OUTQ(*JOBD)               /*CSC023*/
             SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +
                          JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
/*/COPY WNCPYSRC,FTC0130003                                          */
             ENDDO
/**/
 
/**   DATABASE ERROR HANDLING   **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**          RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)             /*S01194*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
/**END:********ENDPGM                                                 /*S01117*/
 END:                                                                 /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/                                                                  /*042167*/
/* CALL AOC8000 to release locks */                                   /*042167*/
/* */                                                                 /*042167*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*042167*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*042167*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*042167*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*042167*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*042167*/
/**/                                                                  /*S01117*/
            ENDPGM                                                    /*S01117*/
 
