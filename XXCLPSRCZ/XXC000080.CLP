/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Interest Statement of Deposit')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       XXC000080 - Interest Statement of Deposit                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2015           */
/*                                                                   */
/*       Last Amend No. LUC106  *CREATE    Date 21May15              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       GHT002 - Dealing interest statement                         */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(44)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2015')
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('XXC000080 - Interest Statement of Deposit') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB    SWS(00000000)
/**/
/* CALL THE PROGRAM */
/**/
             CALL          PGM(XX000080)
/**/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 44))
             SNDPGMMSG  MSG('Job Terminated Abnormally. See joblog +
                          for details.') TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('Copyright Midas-Kapiti +
                          International Ltd.')
             RCLRSC
             ENDPGM
