/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME Download Midas MT940s to MultiCash')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       XXC0009 - Midas ME Download Midas MT940s to MultiCash       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2013           */
/*                                                                   */
/*       Last Amend No. ERZ212   *CREATE   Date 22Feb13              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       ERZ212 - Multicash MT940 Interface                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Variable declaration                                              */
 
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLR) TYPE(*CHAR) LEN(7)
/*  AOSARDR0 variables.                                              */
             DCL        VAR(&ERZ212)  TYPE(*CHAR) LEN(7)
/*  Message  variables.                                              */
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(80)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR ))
             CHGJOB     SWS(00000000)
/* Is ERZ212 switched ON ?                                           */
             CALL       PGM(AOSARDR0) PARM(&ERZ212 '*VERIFY' 'ERZ212')
             IF         COND(&ERZ212 *NE ' ') THEN(DO)
             CHGVAR     VAR(&MESSAGE) VALUE('ME MT940 interface with +
                          Multicash feature not available')
             CHGDTAARA  DTAARA(MIDASMSG (251 80)) VALUE(&MESSAGE)
             CALL  PGM(SCC0040) PARM('SCCD002' 'ENTER' &REPLY)
             GOTO ENDPGM
             ENDDO
 
/* Set message for task                                              */
             CHGVAR     VAR(&MESSAGE) VALUE('Formatting output file')
             CHGDTAARA  DTAARA(MIDASMSG (251 80)) VALUE(&MESSAGE)
             CALL  PGM(SCC0040) PARM('SCCD002' 'BLANK' &REPLY)
 
/* Clear ouput file                                                  */
             CLRPFM     FILE(XXO940TD)
             MONMSG     MSGID(CPF0000)
 
/* Call the transfer program                                         */
 
             OVRDBF     FILE(XXREFL0) TOFILE(XXOREFL0)
             CALL       PGM(XX0009) PARM(&ERR)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR ))
             IF         COND(&ERR *NE '       ') THEN(DO)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             DLTOVR     FILE(XXREFL0)
/* Set message for task                                              */
             CHGVAR     VAR(&MESSAGE) VALUE('Copying output file +
                          to folder')
             CHGDTAARA  DTAARA(MIDASMSG (251 80)) VALUE(&MESSAGE)
             CALL  PGM(SCC0040) PARM('SCCD002' 'BLANK' &REPLY)
 
/* Get folder name for Multicash PC file                             */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&FLR) VALUE('MCASH' *TCAT &PRE)
 
/* Copy data into MIDAS file                                         */
 
             CPYTOPCD   FROMFILE(XXO940TD) TOFLR(&FLR) +
                          TODOC(MCSTMT.DAT) REPLACE(*YES)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR ))
 
 
/* Report on success                                                 */
 
             CHGVAR     VAR(&MESSAGE) VALUE('Midas MT940s to +
                          MultiCash downloaded successfully')
             CHGDTAARA  DTAARA(MIDASMSG (251 80)) VALUE(&MESSAGE)
             CALL  PGM(SCC0040) PARM('SCCD002' 'ENTER' &REPLY)
             GOTO ENDPGM
 
 ERROR:      CHGVAR     VAR(&MESSAGE) VALUE('Unexpected error - +
                          check job log to identify problem')
             CHGDTAARA  DTAARA(MIDASMSG (251 80)) VALUE(&MESSAGE)
             CALL  PGM(SCC0040) PARM('SCCD002' 'ENTER' &REPLY)
             MONMSG     MSGID(CPF0000)
 
             DLTOVR     FILE(XXREFL0)
             MONMSG     MSGID(CPF0000)
 
 ENDPGM:     ENDPGM
