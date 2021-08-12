/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Stamp Duty Postings Component')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/********RECM005 - Retail Stamp Duty Postings Component              */
/*       XXC1405 - RE Stamp Duty Postings Component                  */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1998          */
/*                                                                   */
/*       This program runs in the Close of Business Phase            */
/*                                                                   */
/*       Last Amend No. LUC140             Date 24Feb21              */
/*       Prev Amend No. 145668             Date 28SEP98              */
/*                      MMI013             Date 14APR98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC140 - Upgrade MMI013 to FM2.1                            */
/*       145668 - Rewritten to remove restart processing             */
/*       MMI013 - Retail Stamp Duty and Account Charges              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)


             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Copyright Midas-Kapiti International Ltd. +
                          1998')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&LUC140) TYPE(*CHAR) LEN(1) VALUE('N')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)

             SNDPGMMSG  MSG('XXC1405 - Retail Stamp Duty postings Component') +
                          TOMSGQ(MRUNQ)
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB) /*LUC140*/

             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('LUC140')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '      ') THEN(DO)
                CHGVAR     (&LUC140)  VALUE('Y')
             ENDDO
             ELSE       CMD(GOTO CMDLBL(END))

/* Set the value of restart flag to 'Y' in case the component    */
/* fails to update the file using program CB0150.                */

             CHGVAR     VAR(&STAT) VALUE('Y')

             CLRPFM     FILE(GESDGLPP)
             CLRPFM     FILE(GESDREPP)
             CLRPFM     FILE(GESDGLZZ)
             CLRPFM     FILE(GESDREZZ)

             CALL       PGM(XX1405)
/* If the program fails                                            */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

/* If the components completes normally, reset the value of the    */
/* restart flag to 'N'  and update the file using program CB0150   */

             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

             COMMIT     /*LUC140*/
             GOTO       CMDLBL(END)

 ABNOR:

             CHGJOB     SWS(XXXXXX11)
             ROLLBACK   /*LUC140*/

/* Abnormal termination - batch job */

             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXC1405 +
                             ended abnormally - see job log') TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO


 END:        CHGVAR     VAR(&CPYFLD) VALUE('Copyright Midas-Kapiti +
                          International Ltd.')
             ENDCMTCTL  /*LUC140*/
             ENDPGM
