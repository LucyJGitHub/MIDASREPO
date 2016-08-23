/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas @24 KWG data extraction Report - Compnt')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERC000150 - Midas @24 KWG data extraction Report - Compnt   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/*       Last Amend No. CER059             Date 19Jul10              */
/*       Prev Amend No. CER047  *CREATE    Date 19May08              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       CER047 - German Features LF037-00 Reporting §24c KWG        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PSEQ &PLEV &PENT &PPARM)
 
             DCL        VAR(&PSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
 
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')
 
/** Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
 
/** Set-off Database Error Switches */
 
             CHGJOB     SWS(XXXXXX00)
 
/** Check if SAR CER047 is installed */
 
             CHGVAR     VAR(&PRTCD) VALUE('       ')
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&PSARD) VALUE('CER047')
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &PFMT)
 
/** If an error ocurred  */
 
             IF         COND((&PRTCD *NE '       ') *AND (&PRTCD *NE +
                          '*NRF    ')) THEN(DO)
               SNDPGMMSG  MSG('Switchable Feature CER047 is not *ON') +
                          TOMSGQ(MOPERQ)
               SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                TOMSGQ(MOPERQ)
               CHGJOB     SWS('XXXXXX11')
               GOTO       CMDLBL(ENDLBL)
             ENDDO
 
/** Create LDA if it does not already exist */
 
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
 
             CALL       PGM(ER000150) PARM(&PSEQ &PLEV &PENT &PPARM +
                          &PACT &PCMD)
 
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
 
             GOTO       CMDLBL(ENDLBL)
 
/** Database Error Messages will be sent by RCF */
 
 DBERR:      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
             MSGDTA(&MEM) TOMSGQ(MOPERQ) TOPGMQ(*EXT)
 
             GOTO       CMDLBL(ENDLBL)
 
 ABNOR:      SNDPGMMSG  MSG('@24 KWG Extraction Data Report ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 
 ENDLBL:     ENDPGM
