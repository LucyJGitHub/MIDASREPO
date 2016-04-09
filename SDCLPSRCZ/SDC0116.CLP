/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Link Types Maintenance')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC0116 - SD Midas Link Types Maintenance                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/*       Last Amend No. AR797240           Date 30Jun11              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG22521 *CREATE   Date 25Mar09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR797240 - New standing data tables available in the        */
/*                  maintenance menu are not available in the        */
/*                  enquiry menu                                     */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG22521 - Cannot navigate to Link Types Maintenance        */
/*                                                                   */
/*********************************************************************/
/**********  PGM */                                                                     /*AR797240*/
             PGM        PARM(&MODE)                                                     /*AR797240*/
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                                   /*AR797240*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                             Misys International Banking Systems +
                             Ltd. 2009')
 
/** Return code for call to ZAGETACTGP. */
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
 
/** The activation group that the called program runs in. */
 
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10)
 
/** Monitor for error messages not trapped in the rest of the */
/** program.  If they occur, reclaim resources and exit. */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERROR))
 
/** Reset job switches. */
 
             CHGJOB     SWS(XXXXXX00)
 
/** Setup calling program name. */
 
             CHGVAR     VAR(&PROG) VALUE('SD000116')
 
/** Call program. */
 
/**********  CALL       PGM(SD000116) */                                                /*AR797240*/
/** Mode of display 'M'=Mainteanance 'E'=Enquiry */                                     /*AR797240*/
             CALL       PGM(SD000116) PARM(&MODE)                                       /*AR797240*/
 
/** Destroy the activation group used by the program, and ensure */
/** that no files were left open in OPM programs called from it. */
/** First, retrieve the name of the activation group that the */
/** program runs in. */
 
             CALL       PGM(ZAGETACTGP) PARM(&RETURNCODE &ACTGRP &PROG)
 
             IF         COND(&RETURNCODE = ' ') THEN(DO)
                RCLACTGRP  ACTGRP(&ACTGRP)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             RCLRSC
 
/** For Database Errors, recover Data from LDA. */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                             TOMSGQ(MOPERQ)
 
/** Call SCC0010 to send abnormal termination screen. */
 
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
                CALL       PGM(SCC0010) PARM('SDC0100' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
 
             ENDDO
 
             GOTO       CMDLBL(ENDIS)
 
ERROR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
ENDIS:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
