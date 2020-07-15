/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT menu option control')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas   - FT Module                                         */
/*                                                                   */
/*       FTC0041 - FT MENU OPTION CONTROL                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD055961           Date 08Jun20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CFT018             Date 29Nov02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      197420             Date 17Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CAP031  *CREATE    Date 01Jul99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD055961 - Outgoing Payments HATs option and messages to be */
/*                  processed thru FT end in error (ERZ248)          */
/*       MD046248 - Finastra Rebranding                              */
/*       CFT018 - Standard Settlement Instructions for               */
/*                Outgoing Payments                                  */
/*       CAP031 - Conversion of Midas inputs to modular API structure*/
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG &ACTION &PREF &RTNCD)

             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15)
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                         /*197420*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)                         /*197420*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)                        /*197420*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)                        /*197420*/

             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FTSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)

             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10) /* +
                          Return code for call to ZAGETACTGP */
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10) /* The +
                          activation group that the called program +
                          runs in */

/*/COPY WNCPYSRC,FTC0041001                                          */
             DCLF       FILE(SDMGMEPD)

/* Monitor for error messages not trapped in the rest of the */
/* program. If they occur reclaim resources and exit.        */
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERR))
             GOTO       CMDLBL(RUN)
ERR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
             RETURN

RUN:

/* RESET THE JOB SWITHCHES */
             CHGJOB     SWS(XXXXXX00)

/* CALL PROGRAM  */
                                                                      /*CFT018*/
             IF         COND(&PROG *EQ 'FTOPSISIN') THEN(DO)          /*CFT018*/
             OVRDBF     FILE(FTOPSAPD) SEQONLY(*NO)                   /*CFT018*/
             CALL       PGM(FTOPSISIN)                                /*CFT018*/
             ENDDO                                                    /*CFT018*/
             ELSE       CMD(DO)                                       /*CFT018*/
             OVRDBF     FILE(OTPAYQL0) OVRSCOPE(*JOB) SHARE(*NO)    /*MD055961*/
             CALL       PGM(&PROG) PARM(&ACTION &PREF &RTNCD)
             DLTOVR     FILE(OTPAYQL0) LVL(*JOB)                    /*MD055961*/

             ENDDO                                                    /*CFT018*/
/*/COPY WNCPYSRC,FTC0041002                                          */
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

             RCLRSC

 /* IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)

                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                             TOMSGQ(MOPERQ)

/*  CALL SCC0010 TO SEND ABNORMAL TERMINATION SCREEN */
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
                CALL       PGM(SCC0010) PARM('FTC0041' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)

                ROLLBACK
             ENDDO

             RCLRSC

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 /*END:********ENDPGM                                                        */ /*197420*/
  END:                                                                          /*197420*/
 /**/                                                                           /*197420*/
 /* CALL AOC8000 to release locks */                                            /*197420*/
 /**/                                                                           /*197420*/
              CHGVAR     VAR(&MODULE) VALUE('FT')                               /*197420*/
              CHGVAR     VAR(&TRNREF) VALUE('               ')                  /*197420*/
              CHGVAR     VAR(&RINFOR) VALUE('    ')                             /*197420*/
              CHGVAR     VAR(&RTNCDE) VALUE('       ')                          /*197420*/
              CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                           &RINFOR)                                             /*197420*/
              ENDPGM                                                            /*197420*/
