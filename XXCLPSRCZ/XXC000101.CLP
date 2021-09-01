/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Remap Interbranch Postings')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       CLP/XXC000101 - Remap Interbranch Postings                  */
/*                                                                   */
/*       (c) Copyright Finastra Ltd 2019                             */
/*                                                                   */
/*       Last Amend No. LUC118 *CREATE     Date 13Feb19              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC118 - Upgrade of S21045 to FB Midas 2.1                  */
/*                BV Auto transfer of interbranch account balances   */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RTNCD &PMODE)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra Ltd 2019')
/**/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
/**/
/** Global monitor message error trap */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 CPA0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
/**/
/* Mode 1 - First call */
/**/
             IF         COND(&PMODE *EQ '1') THEN(DO)
/**/
                RMVM       FILE(XXAPOSX1) MBR(*ALL)
                MONMSG     CPF0000
/**/
                CHGPF      FILE(XXAPOSX1) MAXMBRS(*NOMAX)
                ADDPFM     FILE(XXAPOSX1) MBR(MANPOPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GEFFPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GESTPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GEST1PD)
                ADDPFM     FILE(XXAPOSX1) MBR(GEDLPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GEDL2PD)
                ADDPFM     FILE(XXAPOSX1) MBR(GELEPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GELE2PD)
                ADDPFM     FILE(XXAPOSX1) MBR(GECEPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GESOPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GEICPD)
/**/
                GOTO       CMDLBL(END)
/**/
             ENDDO

/**/
/* Mode 2 - Second call */
/**/
             IF         COND(&PMODE *EQ '2') THEN(DO)
/**/
                RMVM       FILE(XXAPOSX1) MBR(*ALL)
                MONMSG     CPF0000
/**/
                CHGPF      FILE(XXAPOSX1) MAXMBRS(*NOMAX)
                ADDPFM     FILE(XXAPOSX1) MBR(MANPOPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GEFFPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GESTPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GEST1PD)
                ADDPFM     FILE(XXAPOSX1) MBR(GEDLPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GEDL2PD)
                ADDPFM     FILE(XXAPOSX1) MBR(GELEPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GELE2PD)
                ADDPFM     FILE(XXAPOSX1) MBR(GECEPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GESOPD)
                ADDPFM     FILE(XXAPOSX1) MBR(GEICPD)
/**/
                GOTO       CMDLBL(END)
             ENDDO

/**/
/* Mode 3 - Deletion */
/**/
             IF         COND(&PMODE *EQ '3') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/**  If database error, output message to user */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSG('XXC000101 - JOB TERMINATED, DATABASE IN ERROR') +
                             TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/* Abnormal Processing */
/**/
 ABNOR:      SNDPGMMSG  TOMSGQ(MOPERQ) MSG('Program XXC000101 abnormally')

             CHGVAR     VAR(&RTNCD) VALUE('*ERROR')

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra Ltd.')

             ENDPGM
