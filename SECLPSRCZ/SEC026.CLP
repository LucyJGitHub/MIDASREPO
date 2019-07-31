/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Trade Settlement - Menu option control')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       CLP/SEC026 - Trade Settlement - Menu Option Control         */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG2502            Date 12May04              */
/*                      CAP182  *CREATE    Date 13Mar03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG2502 - TRSM should be dependent on feature CAP182 and    */
/*                 not CSE039.                                       */
/*       CAP182 - Automatic Settlement of Trades                     */
/*              - Conversion of SE Trade Settlement Input maintence  */
/*                function to modular structure to use as APIs.      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&Prog )
 
             DCL        VAR(&Prog)       TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&RtCd)       TYPE(*CHAR) LEN(7)
 
             DCL        VAR(&ReturnCode) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ActGrp)     TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&Msg)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&Message)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&NoReply)    TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CpyFld)     TYPE(*CHAR) LEN(64) VALUE('(c) +
                               Finastra International Limited +
                               2003')
 
/** Monitor for error messages not trapped in the rest of the **/
/** program.  If they occur, reclaim resources and exit.      **/
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(Error))
 
/** Reset job switches. **/
 
             CHGJOB     SWS(XXXXXX00)
 
/** End program if CAP182 isn't on **/
 
/**********  CALL       PGM(AOSARDR0) PARM(&RtCd '*VERIFY' 'CSE039')   ***/              /*BUG2502*/
             CALL       PGM(AOSARDR0) PARM(&RtCd '*VERIFY' 'CAP182')                     /*BUG2502*/
 
             IF         (&RtCd *NE ' ') +
                 GOTO       CMDLBL(EndPgm)
 
 
/** Call program. **/
 
                 CALL       PGM(&Prog)
 
 
/** Destroy the activation group used by the program, and ensure **/
/** that no files were left open in OPM programs called from it. **/
/** First, retrieve the name of the activation group that the    **/
/** program runs in.                                             **/
 
             CALL       PGM(ZAGETACTGP) PARM(&ReturnCode &ActGrp &Prog)
 
             IF         (&ReturnCode = ' ') +
               DO
                 RCLACTGRP  ACTGRP(&ActGrp)
                   MONMSG     MSGID(CPF0000)
               ENDDO
 
             RCLRSC
 
/** For Database Errors, recover Data from LDA. **/
 
             IF         (%Switch(XXXXXX11)) +
               DO
                 RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&Msg)
                 SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&Msg) +
                              TOMSGQ(MOPERQ)
 
/** Call SCC0010 to send abnormal termination screen. **/
 
                 RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&Message)
                   MONMSG     MSGID(CPF0000 MCH0000)
                 CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&Message)
                   MONMSG     MSGID(CPF0000 MCH0000)
                 RTVMSG     MSGID(SCM0088) MSGF(MIDASMSG) MSG(&Message)
                   MONMSG     MSGID(CPF0000 MCH0000)
                 CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&Message)
                   MONMSG     MSGID(CPF0000 MCH0000)
                 CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')
                   MONMSG     MSGID(CPF0000 MCH0000)
                 CALL       PGM(SCC0010) PARM('SEC026' 'ENTER' &NoReply)
                   MONMSG     MSGID(CPF0000 MCH0000)
 
                 ROLLBACK
               ENDDO
 
             GOTO       CMDLBL(EndPgm)
 
 Error:      RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
 EndPgm:
             CHGVAR     VAR(&CpyFld) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
