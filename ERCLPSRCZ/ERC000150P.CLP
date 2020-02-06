/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas @24 KWG data extraction Report - Prompt')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERC000150P - Midas @24 KWG data extraction Report - Prompt  */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD052296           Date 26Nov18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      CER059             Date 19Jul10              */
/*                      CER047  *CREATE    Date 19May08              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD052296 - Problems caused by use of special characters     */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       CER047 - German Features LF037-00 Reporting §24c KWG        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PSEQ &PLEV &PENT &PPARM &PACT &PCMD)
 
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
             DCL        VAR(&PZAPGMQ) TYPE(*CHAR) LEN(10) VALUE('+
                          ERC000150P')
             DCL        VAR(&PZAPGRL) TYPE(*CHAR) LEN(5) VALUE('*SAME')
             DCL        VAR(&PZAMSID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PZAMSGF) TYPE(*CHAR) LEN(10) VALUE('+
                          SDUSRMSG')
             DCL        VAR(&PZAMSDA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&PZAMSTP) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WFRFNR) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WTOFNR) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WFRDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WTODAT) TYPE(*CHAR) LEN(8)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008')
 
             DCLF       FILE(ER000150DF)
 
/** Retrieve header data */
 
             CHGVAR     VAR(&DDPGM) VALUE(&PZAPGMQ)
 
             RTVJOBA    JOB(&DDJOB)
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DDMRDT)
 
/** Check if SAR CER047 is installed */
 
             CHGVAR     VAR(&PRTCD) VALUE('       ')
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&PSARD) VALUE('CER047')
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &PFMT)
 
/** If an error ocurred */
 
             IF         COND((&PRTCD *NE '       ') *AND (&PRTCD *NE +
                          '*NRF    ')) THEN(DO)
               SNDPGMMSG  MSG('Switchable Feature CER047 is not *ON') +
                          TOMSGQ(MOPERQ)
               SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDLBL)
             ENDDO
 
ERROR:       SNDF       RCDFMT(ER000150C0)
             SNDRCVF    RCDFMT(ER000150F0)
 
             CALL       PGM(Y2CLMSC) PARM(&PZAPGMQ &PZAPGRL)
             CHGVAR     VAR(&IN71) VALUE('0')
             CHGVAR     VAR(&IN72) VALUE('0')
             CHGVAR     VAR(&IN73) VALUE('0')
             CHGVAR     VAR(&IN74) VALUE('0')
 
/** IF F3, Return to RCF with action code = END */
 
             IF         COND(&IN03 *EQ '1') THEN(DO)
             CHGVAR     VAR(&PCMD) VALUE('E')
             GOTO       CMDLBL(ENDLBL)
             ENDDO
 
/** Check for errors */
/** File Number */
 
             IF         COND(&DDFRFNR *NE 0 *AND &DDTOFNR *EQ 0) +
                          THEN(CHGVAR VAR(&DDTOFNR) VALUE(&DDFRFNR))
             IF         COND(&DDFRFNR *GT &DDTOFNR) THEN(DO)
             CHGVAR     VAR(&PZAMSID) VALUE('USR9019')
             CHGVAR     VAR(&PZAMSDA) VALUE(' ')
             CALL       PGM(Y2SNMGC) PARM(&PZAPGMQ &PZAPGRL &PZAMSID +
                          &PZAMSGF &PZAMSDA &PZAMSTP)
             CHGVAR     VAR(&IN72) VALUE('1')
             GOTO       CMDLBL(ERROR)
             ENDDO
             CHGVAR     VAR(&WFRFNR) VALUE(&DDFRFNR)
             CHGVAR     VAR(&WTOFNR) VALUE(&DDTOFNR)
 
/** Date */
 
             IF         COND(&DDFRDAT *NE ' ') THEN(DO)
             CVTDAT     DATE(&DDFRDAT) TOVAR(&WFRDAT) FROMFMT(*DMY) +
                          TOFMT(*YYMD) TOSEP(*NONE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&IN73) VALUE('1')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
             ELSE       CMD(CHGVAR VAR(&WFRDAT) VALUE(' '))
 
             IF         COND(&DDTODAT *NE ' ') THEN(DO)
             CVTDAT     DATE(&DDTODAT) TOVAR(&WTODAT) FROMFMT(*DMY) +
                          TOFMT(*YYMD) TOSEP(*NONE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&IN74) VALUE('1')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
             ELSE       CMD(CHGVAR VAR(&WTODAT) VALUE(' '))
 
             IF         COND(&WFRDAT *NE ' ' *AND &WTODAT *EQ ' ') +
                          THEN(CHGVAR VAR(&WTODAT) VALUE(&WFRDAT))
             IF         COND(&WFRDAT *GT &WTODAT) THEN(DO)
             CHGVAR     VAR(&PZAMSID) VALUE('USR9020')
             CHGVAR     VAR(&PZAMSDA) VALUE(' ')
 
             CALL       PGM(Y2SNMGC) PARM(&PZAPGMQ &PZAPGRL &PZAMSID +
                          &PZAMSGF &PZAMSDA &PZAMSTP)
             CHGVAR     VAR(&IN74) VALUE('1')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/**********  CHGVAR     VAR(&PPARM) VALUE(&WFRFNR || &WTOFNR || +    */                 /*MD052296*/
/**********               &WFRDAT || &WTODAT)                        */                 /*MD052296*/
             CHGVAR     VAR(&PPARM) VALUE(&WFRFNR *CAT &WTOFNR *CAT +
                          &WFRDAT *CAT &WTODAT)                                         /*MD052296*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
 ENDLBL:     ENDPGM
