/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD ICD enquiry control program')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/********SDCJ001*-*Midas*SD*ICD*enquiry*control*program*-*new*menus***/                   /*JMI113*/
/*       XXC113001 - Midas XX SD ICD Enquiry control pgm - new menus */                   /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/                   /*JMI113*/
/*       (c) Finastra International Limited 2018                     */                   /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 16May18              */
/*       Prev Amend No. JMI019  *Create    Date 06Mar07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Midas GCMS Interface                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODULE)

             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WRTNCODE) TYPE(*CHAR) LEN(5)
 /*          DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')        */                                                /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018')                           /*JMI113*/

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             IF         COND((&MODULE *EQ 'GC') *OR (&MODULE *EQ +
                          '**')) THEN(DO)
    /*               CALL       PGM(SDJ002E) PARM(&RTNCODE 'GCMS' &WRTNCODE)       */     /*JMI113*/
                CALL       PGM(XX113001E) PARM(&RTNCODE 'GCMS' +
                             &WRTNCODE) /*JMI113*/
                     IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
             ENDDO

             GOTO       CMDLBL(END)

ABNOR:
  /*         SNDPGMMSG  MSG('Program SDCJ001 ended abnormally') +
                          TOMSGQ(MOPERQ)                    */                            /*JMI113*/
             SNDPGMMSG  MSG('Program XXC113001 ended abnormally') +
                          TOMSGQ(MOPERQ)                                                  /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')

             ENDPGM
