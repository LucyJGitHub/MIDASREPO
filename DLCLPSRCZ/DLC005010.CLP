/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Daily Withholding Tax Reporting')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC005010 - Daily Withholding Tax Reporting                 */
/*                                                                   */
/*       (c) Finastra International Limited 2015                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CGL165  *CREATE    Date 23Feb15              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL165 - Dual Withholding Tax                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(44)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2015')
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
/**/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('DLC005010 - Daily Withholding Tax -
                          Reporting') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB    SWS(00000000)
/*                                                                        */
 
/* IF A RESTART COPY BACK SAVED MONTHLY/YEARLY DETAILS                    */
/*                                                                        */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
             IF         COND(&STAT = 'Y') THEN(DO)
             CPYF       FROMFILE(XDLAWTXPD) TOFILE(&TOLIB/DLAWTXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM DLAWTXPD)
             ENDDO
 
/**/
/* MAKE A DUPLICATE COPY OF THE MONTHLY/YEARLY WITHOLDING TAX FILE        */
/*                                                                        */
             CPYF       FROMFILE(DLAWTXPD) TOFILE(&TOLIB/XDLAWTXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
             MONMSG     (CPF2817) CMPDTA(CPF2869)
/**/
/* CALL THE PROGRAM */
/**/
             CALL       PGM(DL005010P)
/**/
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
             DLTF       FILE(XDLAWTXPD)
             MONMSG     MSGID(CPF0000)
/**/
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                ENDPGM
