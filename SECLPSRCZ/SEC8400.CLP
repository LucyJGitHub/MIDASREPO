       /*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('MIDAS SE SMI Yearly Prof. Repts and Update COB')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC8400 - SMI Yearly Profitability Reports and Updates      */
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
             PGM
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PARV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2017')

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             CHGVAR     VAR(&MEM) VALUE('SEC8400 - Update SMI Yearly +
                          Profitability')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)

/* SWITCHES */
             CHGJOB     SWS(00000100)

/* CLEAR FILES */
             CLRPFM     FILE(SEYPEDPD)
             CLRPFM     FILE(SEYPEAPD)
             CLRPFM     FILE(SEYPDWPD)
             CLRPFM     FILE(SEYPDZPD)

             CPYF       FROMFILE(BPACHD) TOFILE(BPACHD2) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2861)

/* CALL YEARLY PROFITABILITY EXTRACT PROGRAM */

             CHGVAR     VAR(%SST(&PARV 1 1)) VALUE('T')
             CALL       PGM(SE8400B) PARM(&PARV)
             CALL       PGM(SE8400) PARM(&RSEQ &PARV)

/* IF NO ERRORS CALL YEARLY PROFITABILITY REPORT PROGRAM */

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CALL       PGM(SE8402) PARM(&RSEQ &PARV)
             ENDDO

/* IF NO ERRORS CALL YEARLY PROFITABILITY FILES UPDATE PROGRAM */

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CALL       PGM(SE8406)
             ENDDO

/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */

 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)                 +
                             TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC8400 - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO       END
             ENDDO

/* FILE CONTROLS OUT OF BALANCE */

             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                CHGVAR     VAR(&MEM) VALUE('SEC8400 - File Controls Out of +
                             Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO       END
             ENDDO

/* CLEAR FILES */
             CLRPFM     FILE(SEYPEDPD)
             CLRPFM     FILE(SEYPEAPD)
             CLRPFM     FILE(SEYPDWPD)
             CLRPFM     FILE(SEYPDZPD)

/* RE-ORGANIZE SMI FILES */
             RGZPFM     FILE(SEYPDBPD)
             RGZPFM     FILE(SEYPDSPD)
 END:        ENDPGM
