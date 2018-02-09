/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PB menu option control')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1490 - PB Menu Option Control                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC017 - Change to 250 library list.                        */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&Prog)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Prog)       TYPE(*CHAR) LEN(10)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&ReturnCode) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ActGrp)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&Message)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&NoReply)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(128)
/************DCL        VAR(&INLLIBL)  TYPE(*CHAR) LEN(275)                            */ /*CSC017*/
/************DCL        VAR(&CMD)      TYPE(*CHAR) LEN(289)                            */ /*CSC017*/
             DCL        VAR(&INLLIBL)  TYPE(*CHAR) LEN(2750)                              /*CSC017*/
             DCL        VAR(&CMD)      TYPE(*CHAR) LEN(2764)                              /*CSC017*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*  Monitor for error messages not trapped in the rest of the        */
/*  program. If they occur reclaim resources and exit.               */
/*-------------------------------------------------------------------*/
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Reset job switches U7 and U8.                                    */
/*-------------------------------------------------------------------*/
 
             CHGJOB     SWS(XXXXXX00)
 
             RTVJOBD    JOBD(TIJOBD) INLLIBL(&INLLIBL)
 
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                             &INLLIBL *CAT ')')
 
/************CALL       PGM(QCMDEXC) PARM(&CMD 289)                                    */ /*CSC017*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSC017*/
 
/*-------------------------------------------------------------------*/
/*  Call program.                                                    */
/*-------------------------------------------------------------------*/
 
             CALL    PGM(&Prog)
 
/*-------------------------------------------------------------------*/
/*  Destroy the activation group used by the program, and ensure     */
/*  that no files were left open in OPM programs called from it.     */
/*  First retrieve the name of the activation group that the program */
/*  runs in.                                                         */
/*-------------------------------------------------------------------*/
 
             CALL       PGM(ZAGETACTGP) PARM(&ReturnCode &ActGrp &Prog)
 
             IF         COND(&ReturnCode = ' ') THEN(DO)
                RCLACTGRP  ACTGRP(&ActGrp)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             RCLRSC
 
/*-------------------------------------------------------------------*/
/*  Database error processing                                        */
/*-------------------------------------------------------------------*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
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
                CALL       PGM(SCC0010) PARM('RPC1490' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) VALUE('RPC1490 - Private Banking +
                            Menu Option Control ended +
                          abnormally. See job log')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             RTVJOBD    JOBD(MIDASIC) INLLIBL(&INLLIBL)
 
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                             &INLLIBL *CAT ')')
 
/************CALL       PGM(QCMDEXC) PARM(&CMD 289)                                    */ /*CSC017*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSC017*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
