/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME GCMS convert Excel to SWIFT format')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas GCMS Interface                                */
/*                                                                   */
/********MECJ010*-*Midas*ME*GCMS*convert*Excel*to*SWIFT*format********/                   /*JMI113*/
/*       XXC113110 - Midas XX ME GCMS Convert Excel to SWIFT format  */                   /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/                   /*JMI113*/
/*       (c) Finastra International Limited 2018                     */                   /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 05Jun18              */
/*       Prev Amend No. JMI019  *CREATE    Date 21Feb07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Upgrade as is                                      */
/*       JMI019 - Midas GCMS Interface                               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')                                        */                /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/
/**/
/** Global Error Trap */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/** Send message to MRUNQ */
/*           SNDPGMMSG  MSG('MECJ001 - GCMS Convert Excel +
                          to SWIFT format') TOMSGQ(MRUNQ)              */                 /*JMI113*/
             SNDPGMMSG  MSG('XXC113101 - GCMS Convert Excel to SWIFT +
                          format') TOMSGQ(MRUNQ) /*JMI113*/

/** Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)

/** Clear GCMS MT101 Excel file */

/*           CLRPFM     FILE(MGGEXCPD)                                 */                 /*JMI113*/
             CLRPFM     FILE(XXGEXCPD)                                                    /*JMI113*/

/***Call*MEJ010**/                                                                        /*JMI113*/
/*           CALL       PGM(MEJ010)                                    */                 /*JMI113*/
/** Call XX113110 */                                                                      /*JMI113*/
             CALL       PGM(XX113110)                                                     /*JMI113*/
/**/
/** If U7 or U8 are ON, perform standard database error processing */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
/**/
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA+
                 ('Program MECJ010 ended abnormally - see job log') +
                 TOMSGQ(MOPERQ MRUNQ)                                  */                 /*JMI113*/
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA+
                 ('Program XXC113110 ended abnormally - see job log') +
                 TOMSGQ(MOPERQ MRUNQ)                                                     /*JMI113*/
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             ENDDO
/**/
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')         */           /*JMI113*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/
/**/
 ENDPGM:     ENDPGM
