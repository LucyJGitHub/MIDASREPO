/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Manual Repayment - API Menu Control')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC002110 - Manual Repayment API - Menu Control             */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CRE020             Date 03Mar04              */
/*                      CAP077  *CREATE    Date 17Jul02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CAP077 - Lending API enhancements - Manual Repayments.      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)                                    /*CRE020*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CRE020*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CRE020*/
                                                                                          /*CRE020*/
/***  Return code for call to ZAGETACTGP.  ***/
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
 
/***  The activation group that the called program runs it.  ***/
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/***  Monitor for error messages not trapped in the rest of the  ***/
/***  program. If they occur reclaim resources and exit.         ***/
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERR))
                                                                                          /*CRE020*/
/** Check if CRE020 is on.*/                                                              /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CRE020*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CRE020*/
             CHGVAR     VAR(&PSARD) VALUE('CRE020')                                       /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&PRTCD *NE '       ' *AND &PRTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CRE020*/
               GOTO   CMDLBL(ERR)                                                         /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&PRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CRE020) VALUE('Y'))                                        /*CRE020*/
                                                                                          /*CRE020*/
             GOTO       CMDLBL(RUN)
 
ERR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
             RETURN
 
RUN:
 
/***  Reset job Switches.  ***/
             CHGJOB     SWS(XXXXXX00)
 
/***  Call Program.  ***/
             OVRDBF     FILE(FCLTY) SHARE(*NO)
             OVRDBF     FILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(LOAMD) TOFILE(LOAMS) SHARE(*NO)
             CALL       PGM(&PROG)
             DLTOVR     FILE(*ALL)
 
/** +
    Destroy the activation group used by the program, and ensure +
    that no files were left open in OPM programs called from it. +
    First retrieve the name of the activation group that the +
    program runs in. +
**/
             CALL       PGM(ZAGETACTGP) PARM(&RETURNCODE &ACTGRP &PROG)
 
             IF         COND(&RETURNCODE = ' ') THEN(DO)
                RCLACTGRP  ACTGRP(&ACTGRP)
                MONMSG     MSGID(CPF0000)
             ENDDO
                                                                                          /*CRE020*/
 /* If no previous error was encountered, CRE020 is switched on and*/                     /*CRE020*/
 /* print Input Cycle Debit/Credit Retail Advice Print.*/                                 /*CRE020*/
                                                                                          /*CRE020*/
          IF         COND((%SWITCH(XXXXX000)) +
                     *AND (&CRE020 = 'Y')) THEN(DO)                                       /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND((&PROG *EQ 'LEMAPYSIN') *OR (&PROG *EQ +
                          'LEMAPYRPR')) THEN(CHGVAR VAR(&PARM) +
                          VALUE('LEMAPYUPD'))                                             /*CRE020*/
                                                                                          /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   REC000881 +
                          (''' *CAT &PARM *CAT ''' ''LE'')') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) /*CRE020*/
                                                                                          /*CRE020*/
                   SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CRE020*/
                                                                                          /*CRE020*/
             ENDDO                                                                        /*CRE020*/
 
             RCLRSC
 
 /***  If U7 And U8 are on send DBerror Message to MOPERQ.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                             TOMSGQ(MOPERQ)
 
/***  Call SCC0010 To Send Abnormal Termination Screen.  **/
                RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                RTVMSG     MSGID(SCM0088) MSGF(MIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')
                MONMSG     MSGID(CPF0000 MCH0000)
                CALL       PGM(SCC0010) PARM('FXC0011' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
             ENDDO
 
             RCLRSC
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
             DLTOVR     FILE(*ALL)
             ENDPGM
