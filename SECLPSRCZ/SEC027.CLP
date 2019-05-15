/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Statmts Prod.Req - Menu option control')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       CLP/SEC027 - Statement Production Requests                  */
/*                  - Menu Option Control                            */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE040  *CREATE    Date 14Mar03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE040 - Securities Statement Processing                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&Prog &CustNo &ProcMode &EndByF3 &EndByF12)
 
 
             DCL        VAR(&Prog)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&CustNo)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&ProcMode)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&EndByF3)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&EndByF12)   TYPE(*CHAR) LEN(1)
 
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
 
/** End program if CSE040 isn't on **/
 
             CALL       PGM(AOSARDR0) PARM(&RtCd '*VERIFY' 'CSE040')
 
             IF         (&RtCd *NE ' ') +
                 GOTO       CMDLBL(EndPgm)
 
/** File overrides **/
 
             OVRDBF     FILE(SESTPRL2) OVRSCOPE(*JOB) SHARE(*NO)
             OVRDBF     FILE(SECTYZ1) TOFILE(SECTY) OVRSCOPE(*JOB) +
                          SHARE(*NO)
             OVRDBF     FILE(SECTYZ2) TOFILE(SECTY) OVRSCOPE(*JOB) +
                          SHARE(*NO)
 
/** Call program. **/
 
             IF         (&Prog = 'SESTPRSIN') +
                 CALL       PGM(&Prog) PARM(&CustNo &ProcMode &EndByF3 +
                                            &EndByF12)
             ELSE +
                 CALL       PGM(&Prog)
 
/** Ensure that no files were left open in called OPM programs **/
 
             RCLRSC
 
/** Destroy the activation group used by the program             **/
/** First, retrieve the name of the activation group that the    **/
/** program runs in.                                             **/
 
             CALL       PGM(ZAGETACTGP) PARM(&ReturnCode &ActGrp &Prog)
 
             IF         (&ReturnCode = ' ') +
               DO
                 RCLACTGRP  ACTGRP(&ActGrp)
                   MONMSG     MSGID(CPF0000)
               ENDDO
 
/** Delete overrides **/
 
             DLTOVR     FILE(SESTPRL2) LVL(*JOB)
             DLTOVR     FILE(SECTYZ1)  LVL(*JOB)
             DLTOVR     FILE(SECTYZ2)  LVL(*JOB)
 
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
                 CALL       PGM(SCC0010) PARM('SEC027' 'ENTER' &NoReply)
                   MONMSG     MSGID(CPF0000 MCH0000)
 
                 ROLLBACK
               ENDDO
 
             GOTO       CMDLBL(EndPgm)
 
 Error:      RCLRSC
             RCLACTGRP  ACTGRP(*ELIGIBLE)
 
 EndPgm:
             CHGVAR     VAR(&CpyFld) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
