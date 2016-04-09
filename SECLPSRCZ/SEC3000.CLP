/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Bulk Input')                                 */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*         SEC3000 - BULK INPUT                                     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 235546           Date 23Aug05                */
/*       Prev Amend No. 234691           Date 05Jul05                */
/*                      CRE020             Date 20Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      204747             Date 30Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CSE010           Date 21Jun99                */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CSE003           Date 11Oct96                */
/*                      S01401           Date 16Jun93                */
/*                        S01117           DATE 10JAN91             */
/*                        E23408           DATE 06SEP90             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       235546 - monitor for activation group mot exists           */
/*       234691 - Internal failure in compiler error ib SE001805    */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       204747 - Add OVRDBF on TRADSDZ3.                            */
/*       CSE010 - SE Transactions Enhancement                        */
/*       CSE003 - '?' processing for security shortname in se3000.  */
/*       S01401 - The generation of MT5xx SWIFT Messages if the     */
/*                option is available.                              */
/*       S01117 - MULTIBRANCHING                                    */
/*       E23408 - SETON U1 IF RETAIL II OR INTEREST ON ACCOUNTS     */
/*                INSTALLED IN SYSTEM.                              */
/*                                                                  */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&RE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IA) TYPE(*CHAR) LEN(1)                /*E23408*/
/*/COPY WNCPYSRC,SEC3000005                                          */
/**/                                                                  /*CSE010*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSE010*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSE010*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CSE010*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CSE010*/
             DCL        VAR(&CSE010) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE010*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*CRE020*/
 
/*/COPY WNCPYSRC,SEC3000001                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(S38ERROR))
 
/*/COPY WNCPYSRC,SEC3000002                                          */
/**/                                                                  /*CSE010*/
/**  Check if Transaction Enhancements is installed */                /*CSE010*/
/**/                                                                  /*CSE010*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE010*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE010*/
             CHGVAR     VAR(&SAR) VALUE('CSE010')                     /*CSE010*/
             CHGVAR     VAR(&CSE010) VALUE('N')                       /*CSE010*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE010*/
             IF COND(&RTCD *EQ '       ') THEN(DO)                    /*CSE010*/
                CHGVAR     VAR(&CSE010) VALUE('Y')                    /*CSE010*/
                OVRDBF FILE(SECTYX)   TOFILE(SECTY)    SHARE(*NO)     /*CSE010*/
                OVRDBF FILE(SEDEVX)   TOFILE(SEDEV)    SHARE(*NO)     /*CSE010*/
                OVRDBF FILE(SECTYZ1)  TOFILE(SECTY)    SHARE(*NO)     /*CSE010*/
                OVRDBF FILE(SECTYZ2)  TOFILE(SECTY)    SHARE(*NO)     /*CSE010*/
                OVRDBF FILE(SECTYZ3)  TOFILE(SECTY)    SHARE(*NO)     /*CSE010*/
             ENDDO                                                    /*CSE010*/
                                                                                          /*CRE020*/
/* Check if CRE020 is enabled. */                                                         /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CRE020*/
             CHGVAR     VAR(&SAR)  VALUE('CRE020')                                        /*CRE020*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('N')                                           /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTCD  *NE '       ' *AND &RTCD  *NE +
                          '*NRF   ') THEN(DO)                                             /*CRE020*/
               GOTO   CMDLBL(S38ERROR)                                                    /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF COND(&RTCD *EQ '       ') THEN(DO)                                        /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('Y')                                           /*CRE020*/
             ENDDO                                                                        /*CRE020*/
/* Data area sesds is used in se3000;                                 **CSE003*/
/* it holds parameters returned from se0240.                          **CSE003*/
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)                   /*CSE003*/
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37))    /*CSE003*/
             CHGDTAARA  DTAARA(SESDS) VALUE(' ')                      /*CSE003*/
             CHGDTAARA  DTAARA(SESDS (1 8)) VALUE('SE3000')           /*CSE003*/
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')          /*CSE003*/
 
             RTVDTAARA  DTAARA(MMOD (16 1)) RTNVAR(&RE)
             RTVDTAARA  DTAARA(MMOD (23 1)) RTNVAR(&IA)            /*E23408*/
 
/************IF*********COND(&RE *EQ 'Y') THEN(CHGJOB SWS(1XXXXX00))*E23408*/
             IF         COND((&RE *EQ 'Y') *OR (&IA *EQ 'Y')) +
                          THEN(CHGJOB SWS(1XXXXX00))               /*E23408*/
             ELSE       CMD(CHGJOB SWS(0XXXXX00))
/*/COPY WNCPYSRC,SEC3000006                                          */
 
             OVRDBF     FILE(TRADSDZ1) TOFILE(TRADSDY1) SHARE(*NO)    /*S01401*/
             OVRDBF     FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)    /*S01401*/
             OVRDBF     FILE(TRADSDY1) TOFILE(BULKSDY1) SHARE(*NO)    /*S01401*/
             OVRDBF     FILE(TRADSDY2) TOFILE(BULKSDY2) SHARE(*NO)    /*S01401*/
             OVRDBF     FILE(TRADSDZ3) TOFILE(TRADSDY2) SHARE(*NO)                        /*204747*/
/*/COPY WNCPYSRC,SEC3000003                                          */
             CALL       PGM(SE3000)
/*/COPY WNCPYSRC,SEC3000004                                          */
             DLTOVR     FILE(TRADSDZ1)                                /*S01401*/
             DLTOVR     FILE(TRADSDZ2)                                /*S01401*/
             DLTOVR     FILE(TRADSDY1)                                /*S01401*/
             DLTOVR     FILE(TRADSDY2)                                /*S01401*/
                                                                                          /*CRE020*/
/* Print Retail Advices if CRE020 is enabled. */                                          /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(%SWITCH(XXXXXX00) *AND +
                              &CRE020 *EQ 'Y') THEN(DO)                                   /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(REC000881) +
                          PARM(''SETRADUPD'' ''SE'')') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CRE020*/
             ENDDO                                                                        /*CRE020*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ENDDO
 
             GOTO       CMDLBL(EXIT)
 
 S38ERROR:   ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Error occurred while calling SE3000 - +
                          Bulk Input') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**EXIT:********ENDPGM                                                * *S01117*/
EXIT:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             RCLACTGRP  ACTGRP(SE001805)                              /*234691*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*235546*/
             ENDPGM                                                   /*S01117*/
