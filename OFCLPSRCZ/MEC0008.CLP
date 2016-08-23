/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas OF Upload&Cvt MTCASH MT103s to SWIFT MT103s')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MEC0008 - Midas ME Upload and Convert Multicash MT100s to   */
/*                 Swift MT103s                                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2013           */
/*                                                                   */
/*       Last Amend No. AR1070196          Date 20Feb13              */
/*       Prev Amend No. CFT135  *CREATE    Date 20Feb13              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   AR1070196 - CFT135 - Submit job before outputting confirmation  */
/*               screen (Child: AR1070198)                           */
/*   CFT135 - MT100 MultiCash Interface                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Variable declaration                                              */
 
             DCL        VAR(&OK) TYPE(*CHAR) LEN(5)
             DCL        VAR(&NK) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLR) TYPE(*CHAR) LEN(7)
/*  AOSARDR0 variables.                                              */
             DCL        VAR(&CFT135)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&SFMT)    TYPE(*CHAR) LEN(200)
/*  Message  variables.                                              */
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(80)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR ))
             CHGJOB     SWS(00000000)
/* Is CFT135 switched ON ?                                           */
             CALL       PGM(AOSARDR0) PARM(&CFT135 '*VERIFY' 'CFT135' +
                            &SFMT)
             IF         COND(&CFT135 *NE ' ') THEN(DO)
             CHGVAR     VAR(&MESSAGE) VALUE('MT103 Interface with +
                          Multicash Feature             Not Available')
             CHGDTAARA  DTAARA(MIDASMSG (251 80)) VALUE(&MESSAGE)
             CALL  PGM(SCC0040) PARM('SCCD002' 'ENTER' &REPLY)
             GOTO ENDPGM
             ENDDO
 
/* Set message for task                                              */
             CHGVAR     VAR(&MESSAGE) VALUE('Copying input file +
                          from folder')
             CHGDTAARA  DTAARA(MIDASMSG (251 80)) VALUE(&MESSAGE)
             CALL  PGM(SCC0040) PARM('SCCD002' 'BLANK' &REPLY)
 
/* Get folder name for Multicash PC file                             */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&FLR) VALUE('MCASH' *TCAT &PRE)
 
/* Copy data into MIDAS file                                         */
 
             CPYFRMPCD  FROMFLR(&FLR) TOFILE(MCI100TD) +
                          FROMDOC(MCPYMT.DAT)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR ))
             DLTDLO     DLO(MCPYMT.DAT) FLR(&FLR)
 
/* Set message for task                                              */
             CHGVAR     VAR(&MESSAGE) VALUE('Formatting input file')
             CHGDTAARA  DTAARA(MIDASMSG (251 80)) VALUE(&MESSAGE)
             CALL  PGM(SCC0040) PARM('SCCD002' 'BLANK' &REPLY)
 
/* Call the transfer program                                         */
 
             CALL       PGM(ME0008) PARM(&OK &NK)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR ))
 
/* Error check                                                       */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))
 
/* Call incoming message index generation program                    */                /*AR1070196*/
                                                                                       /*AR1070196*/
             CALL       PGM(MSC4040)                                                   /*AR1070196*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR ))                       /*AR1070196*/
                                                                                       /*AR1070196*/
/* Report on number successes/fails                                  */
 
             CHGVAR     VAR(&MESSAGE) VALUE(&OK *TCAT '/' *TCAT &NK +
                          *BCAT 'payments transferred successfully')
             CHGDTAARA  DTAARA(MIDASMSG (251 80)) VALUE(&MESSAGE)
             CALL  PGM(SCC0040) PARM('SCCD002' 'ENTER' &REPLY)
 
/**Call*incoming message index generation program                 ****/                /*AR1070196*/
/**/                                                                                   /*AR1070196*/
/*****       CALL       PGM(MSC4040)                              ****/                /*AR1070196*/
/*****       MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR ))  ****/                /*AR1070196*/
/*****                                                            ****/                /*AR1070196*/
             GOTO ENDPGM
 
 ERROR:      CHGVAR     VAR(&MESSAGE) VALUE('Unexpected error - +
                          see job log to identify problem')
             CHGDTAARA  DTAARA(MIDASMSG (251 80)) VALUE(&MESSAGE)
             CALL  PGM(SCC0040) PARM('SCCD002' 'ENTER' &REPLY)
             MONMSG     MSGID(CPF0000)
 
 
 ENDPGM:     ENDPGM
