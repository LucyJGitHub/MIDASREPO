/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('MIDAS SE Yearly Profitability Report')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC8400A - SMI Yearly Profitability Report I/C              */
/*                                                                   */
/*       (c) Finastra International Limited 2017                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSE108 *CREATE     Date 06Oct17              */
/*                      nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE108 - Yearly Profitability Report and Enquiry            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REPORT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BOTH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TORV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
 
/* Clear Switches */
             CHGJOB     SWS(00000000)
 
/* Run movement report and output SEBKPRPD if requested */
 
             CHGVAR     VAR(&REPORT) VALUE(%SST(&RPARM 2 1 ))
             IF COND(&REPORT *EQ 'Y') THEN(CHGJOB SWS(11000000))
 
/* Clear Files */
             CLRPFM     FILE(SEYPEDPD)
             CLRPFM     FILE(SEYPEAPD)
             CLRPFM     FILE(SEBKPRPD)
 
/* Call Yearly Profitability Extract Program */
 
             OVRPRTF    FILE(SE8400P1) TOFILE(QSYSPRT)
 
             CHGVAR     VAR(&BOTH) VALUE(' ')
             CHGVAR     VAR(&TORV) VALUE(%SST(&RPARM 1 1 ))
 
             IF COND(&TORV *EQ 'B') THEN(DO)
             CHGVAR     VAR(&TORV) VALUE('T')
             CHGVAR     VAR(&BOTH) VALUE('B')
             ENDDO
 
             CPYF       FROMFILE(BPACHD) TOFILE(BPACHD2) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2861)
 
/* Do trade date first */
             CALL       PGM(SE8400B) PARM(&TORV)
             CALL       PGM(SE8400) PARM(&RSEQ &TORV)
 
/* If no errors call Yearly Profitability report program */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CALL       PGM(SE8402) PARM(&RSEQ &TORV)
             ENDDO
 
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
 
/* For database errors recover data from LDA */
 
ERROR1:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ)
             ENDDO
 
             IF COND(&BOTH *NE 'B') THEN(DO)
                GOTO ENDPGM
             ENDDO
 
 
/* Clear Files */
             CLRPFM     FILE(SEYPEDPD)
             CLRPFM     FILE(SEYPEAPD)
             CLRPFM     FILE(SEBKPRPD)
 
/* Call Yearly Profitability Extract Program */
 
             OVRPRTF    FILE(SE8400P1) TOFILE(QSYSPRT)
 
             CHGVAR     VAR(&TORV) VALUE('V')
             CALL       PGM(SE8400B) PARM(&TORV)
             CALL       PGM(SE8400) PARM(&RSEQ &TORV)
 
/* If no errors call Yearly Profitability report program */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CALL       PGM(SE8402) PARM(&RSEQ &TORV)
             ENDDO
 
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
 
/* For database errors recover data from LDA */
 
ERROR2:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ)
             ENDDO
                GOTO ENDPGM
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
