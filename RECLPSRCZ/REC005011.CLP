/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Daily Withholding Tax Reporting')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC005011 - Mnthly Withholding Tax Reporting Control Program*/
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2015           */
/*                                                                   */
/*       Last Amend No. CGL165  *CREATE    Date 23Feb15              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL165 - Dual Withholding Tax                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(44)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(12)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&EOY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EOM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2015')
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
/**/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('REC005010 - Daily Withholding Tax +
                          Reporting') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB    SWS(00000000)
/**/
/* IF A RESTART COPY BACK SAVED MONTHLY/YEARLY DETAILS                    */
/*                                                                        */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
             IF         COND(&STAT = 'Y') THEN(DO)
             CPYF       FROMFILE(XREAWTXPD) TOFILE(&TOLIB/REAWTXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM REAWTXPD)
             ENDDO
 
/**/
/* MAKE A DUPLICATE COPY OF THE MONTHLY/YEARLY WITHOLDING TAX FILE        */
/*                                                                        */
             CPYF       FROMFILE(REAWTXPD) TOFILE(&TOLIB/XREAWTXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
             MONMSG     (CPF2817) CMPDTA(CPF2869)
/**/
/* CALL THE MONTHLY REPORT PROGRAM */
/**/
             CALL       PGM(RE005011P) PARM('     ')
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                          RTVDTAARA DTAARA(LDA) RTNVAR(&LDA)
                          CHGVAR VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 44))
                          SNDPGMMSG  MSG('Job Terminated Abnormally. See joblog +
                          for details.') TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/* CHECK IF EOM or EOY AND IF SO UPDATE MONTHLY/YEARLY DETAILS */
             CALL       PGM(SD2000) PARM(&EOM &EOY)
 
             IF         COND(&EOY = 'Y') THEN(DO)
                        CLRPFM FILE(REAWTXPD)
                        GOTO CMDLBL(ENDPGM)
             ENDDO
/**/
             IF         COND(&EOM = 'Y') THEN(DO)
             CALL       PGM(RE005011)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                          RTVDTAARA DTAARA(LDA) RTNVAR(&LDA)
                          CHGVAR VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 44))
                          SNDPGMMSG  MSG('Job Terminated Abnormally. See joblog +
                          for details.') TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             ENDDO
/**/
             DLTF       FILE(XREAWTXPD)
             MONMSG     MSGID(CPF0000)
/**/
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
