/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('MIDAS SE Yearly Profitability Report Prompt')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC8400B - SMI Yearly Profitability Report Prompt           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2017           */
/*                                                                   */
/*       Last Amend No. CSE108 *CREATE     Date 06Oct17              */
/*       Prev Amend No. nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE108 - Yearly Profitability Report and Enquiry            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2017')
 
             DCLF       FILE(SEC8400DF)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/* Set-off Database Error Switches */
             CHGJOB     SWS(XXXXXX00)
 
/* Get screen variables and display prompt screen */
             RTVJOBA    JOB(&WSID)
             CHGVAR   &UPBS  ' '
             CHGVAR   &RPBS  ' '
             CHGVAR   VAR(&REPORT) VALUE('N')
             CHGVAR   VAR(&OPTION) VALUE('V')
             CALL     SECTAB36 PARM(&UPBS &RPBS)
 
 PROMPT:     SNDRCVF    RCDFMT(SEC8400D1)
 
/* End program if Cmd3 pressed */
             IF         COND(&IN03 *EQ '1') THEN(DO)
                CHGVAR     VAR(&RCMD) VALUE('E')
                RETURN
 
             ENDDO
 
/* Clear error conditioning */
             CHGVAR     VAR(&IN97) VALUE('0')
 
/* If the option is not T,V or B, error it and re-display the screen */
             IF   ((&OPTION *NE 'T') *AND +
                   (&OPTION *NE 'V') *AND +
                   (&OPTION *NE 'B')) THEN(DO)
                CHGVAR &IN97 '1'
                GOTO   PROMPT
             ENDDO
 
/* Clear error conditioning */
             CHGVAR     VAR(&IN98) VALUE('0')
 
/* If the report is not Y or N, error it and re-display the screen */
             IF   ((&REPORT *NE 'Y') *AND +
                   (&REPORT *NE 'N')) THEN(DO)
                CHGVAR &IN98 '1'
                GOTO   PROMPT
             ENDDO
 
             IF         COND((&IN97 *EQ '0') *AND (&IN98 *EQ '0')) +
                          THEN(DO)
             CHGVAR     VAR(&RPARM) VALUE(&OPTION *CAT &REPORT)
             ENDDO
 
ENDPGM:      ENDPGM
