/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Initialisation Program for CGL176')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       GLC000030 - Initialisation program to setup feature         */
/*                   dependencies for CGL176                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2015           */
/*                                                                   */
/*       Last Amend No. CGL176  *CREATE    DATE 11Sep15              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL176 - Optimisation of Nostro Balances by Company         */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RTNCDE &IPMODE)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2015')
/**/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)
/**/
/** Global monitor message error trap */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 CPA0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
/**/
/**  Create LDA if not present */
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                            AUT(*EXCLUDE)
             ENDDO
/**/
             CHGJOB     SWS(00000000)
/**/
/**  Call program */
/**/
             CALL       PGM(GL000030) PARM(&RTCD &IPMODE)
/**/
/**  If database error, output message to user */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSG('GLC000030 - JOB TERMINATED, DATABASE IN +
                              ERROR') TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
ABNOR:       SNDPGMMSG  MSG('Program GLC000030 ended ABNORMALLY.') +
                          TOMSGQ(MOPERQ MRUNQ)
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
