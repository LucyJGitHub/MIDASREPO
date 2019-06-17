/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Initialisation program for GCMS i/face')     */
/********************************************************************/
/*                                                                  */
/*   Midas - Midas-GCMS Interface                                   */
/*                                                                  */
/****GLCJ011****Initialisation*program*for*GCMS*Interface************/                    /*JMI113*/
/*   XXC113011  Initialisation program for GCMS Interface           */                    /*JMI113*/
/*                                                                  */
/*****(c)*Misys*International*Banking*Systems*Ltd.*2007**************/                    /*JMI113*/
/*    (c) Finastra International Limited 2018                       */                    /*JMI113*/
/*                                                                  */
/*   Last Amendment No. JMI113           Date 22May18               */
/*   Prev Amendment No. JMI019 *CREATE   Date 21Feb07               */
/*                                                                  */
/*********************************************************************/
/*                                                                  */
/*   JMI113 - Midas-GCMS Interface. Upgrade to FBM 2.1              */
/*   JMI019 - Midas-GCMS Interface                                  */
/*                                                                  */
/*********************************************************************/
             PGM        PARM(&RTNCDE &IPMODE)

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')             */                                           /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)


             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* */
/** Mode 1 - Calling program for the first time                    */
/** Mode 2 - Re-calling program if already previously used         */
/* */

             IF         COND((&IPMODE = '1') *OR (&IPMODE = '2')) +
                          THEN(DO)
             CHGJOB     SWS(XXXXXX00)

/*           CHGDTAARA  DTAARA(GLGCMSDA (1 26)) VALUE(' ')   */                           /*JMI113*/
/*           CHGDTAARA  DTAARA(GLGCMSDA (27 1)) VALUE('Y')   */                           /*JMI113*/
/*           CHGDTAARA  DTAARA(GLGCMSDA (28 1)) VALUE('Y')   */                           /*JMI113*/
/*           CHGDTAARA  DTAARA(GLGCMSDA (29 1)) VALUE('L')   */                           /*JMI113*/
/*           CHGDTAARA  DTAARA(GLGCMSDA (30 1)) VALUE('Y')   */                           /*JMI113*/
             CHGDTAARA  DTAARA(XXGCMGDA (1 26)) VALUE(' ')                                /*JMI113*/
             CHGDTAARA  DTAARA(XXGCMGDA (27 1)) VALUE('Y')                                /*JMI113*/
             CHGDTAARA  DTAARA(XXGCMGDA (28 1)) VALUE('Y')                                /*JMI113*/
             CHGDTAARA  DTAARA(XXGCMGDA (29 1)) VALUE('L')                                /*JMI113*/
             CHGDTAARA  DTAARA(XXGCMGDA (30 1)) VALUE('Y')                                /*JMI113*/
/** Start of change JMI019                                           */
/**********  CHGDTAARA  DTAARA(GLGCMSDA (35 12)) VALUE('MIDAS123XXXX')                    /*JMI019*/
/*           CHGDTAARA  DTAARA(GLGCMSDA (35 12)) VALUE('MHCCIDJAAXXX')   */               /*JMI113*/
             CHGDTAARA  DTAARA(XXGCMGDA (35 12)) VALUE('MHCCIDJAAXXX')                    /*JMI113*/
/** End of Change JMI019                                             */
/*           CHGDTAARA  DTAARA(GLGCMSDA (47 3)) VALUE('FNS')         */                   /*JMI113*/
/*           CHGDTAARA  DTAARA(GLGCMSDA (50 8)) VALUE('00000000')    */                   /*JMI113*/
             CHGDTAARA  DTAARA(XXGCMGDA (47 3)) VALUE('FNS')                              /*JMI113*/
             CHGDTAARA  DTAARA(XXGCMGDA (50 8)) VALUE('00000000')                         /*JMI113*/
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&IPMODE = '3') THEN(DO)
             CHGJOB     SWS(XXXXXX00)
             GOTO       CMDLBL(END)
             ENDDO

ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLCJ011 ended abnormally ') TOMSGQ(MOPERQ +
                          MRUNQ)                         */                               /*JMI113*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          XXC113011 ended abnormally ') +
                          TOMSGQ(MOPERQ MRUNQ) /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)

 END:        ENDPGM

