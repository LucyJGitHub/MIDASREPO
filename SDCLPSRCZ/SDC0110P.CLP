/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Auth.Hold. Link Report for KWG @24 Prompt')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC0110P - Midas Customer/Authority Holder Link Report      */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD052296           Date 26Nov18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      CER059             Date 19Jul10              */
/*                      CER047  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD052296 - Problems caused by use of special characters     */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       CER047 - German Features LF037-00 Reporting §24c KWG        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PSEQ &PLEV &PENT &PPARM &PACT &PCMD)

             DCL        VAR(&DDCUAH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DDCNDT) TYPE(*CHAR) LEN(1)
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

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008')

             DCLF       FILE(SD000110DF) RCDFMT(SD000110F0)

             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DDRUNA)
             RTVJOBA    JOB(&DDWSID) USER(&DDUSER)

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
               GOTO       CMDLBL(ENDLBL)
             ENDDO

ERROR:
             SNDRCVF    RCDFMT(SD000110F0)
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')

/** If F3, return to RCF with action code = END */
             IF         COND(&IN01 *EQ '1') THEN(DO)
             CHGVAR     VAR(&PCMD) VALUE('E')
             GOTO       CMDLBL(ENDLBL)
             ENDDO

/** Source for report */
             IF         COND(&DDCUAH *NE 'C' *AND &DDCUAH *NE 'A') +
                          THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&DDMSG) VALUE('Entry not ''C'' or ''A''')
             GOTO       CMDLBL(ERROR)
             ENDDO

/** Print zero balances */
             IF         COND(&DDCNDT *NE 'C' *AND &DDCNDT *NE 'D') +
                          THEN(DO)
             CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&DDMSG) VALUE('Entry not ''C'' or ''D''')
             GOTO       CMDLBL(ERROR)
             ENDDO

/**********  CHGVAR     VAR(&PPARM) VALUE(&DDCUAH || &DDCNDT)        */                 /*MD052296*/
             CHGVAR     VAR(&PPARM) VALUE(&DDCUAH *CAT &DDCNDT)                         /*MD052296*/

             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
 ENDLBL:     ENDPGM
