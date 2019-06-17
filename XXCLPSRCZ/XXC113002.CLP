/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD ICD maintenance control program')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/********SDCJ002*-*Midas*SD*ICD*maintenance*control*program***********/                   /*JMI113*/
/******************new*menus******************************************/                   /*JMI113*/
/*       XXC113002 - Midas XX SD ICD Maintenance Control Program     */                   /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/                   /*JMI113*/
/*       (c) Finastra International Limited 2018                     */                   /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 16May18              */
/*       Prev Amend No. JMI019  *Create    Date 06Mar07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1.          */
/*       JMI019 - Midas GCMS Interface                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODULE)

             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WRTNCODE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 /*          DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')                 */                                       /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018')                           /*JMI113*/

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             RTVJOBA    TYPE(&JOBTYPE) JOB(&JOB)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)

             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)

/* This program can only be called in input cycle           */

             IF         COND(&MPHAS *EQ 'D') THEN(DO)
               GOTO       CMDLBL(ERROR)
             ENDDO

             IF         COND(&MPHAS *NE 'A') THEN(DO)
 /*            SNDPGMMSG  MSG('SDCJ002 - Job cannot be run at this +
                            time. Phase of Day must be A.') +
                            TOMSGQ(MOPERQ)         */                                     /*JMI113*/
                SNDPGMMSG  MSG('XXC113002 - Job cannot be run at +
                             this time.  Phase of Day must be A.') +
                             TOMSGQ(MOPERQ)                                               /*JMI113*/
               GOTO       CMDLBL(ERROR)
             ENDDO

             IF         COND(&MPHAS *EQ 'A') THEN(DO)

/* Start commitment control for batch jobs with file updates */

             IF         COND(&JOBTYPE = '0') THEN(DO)
                     STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))
             ENDDO

             IF         COND((&MODULE *EQ 'GC') *OR (&MODULE *EQ +
                          '**')) THEN(DO)
  /*                 CALL       PGM(SDJ002R) PARM(&RTNCODE 'GCMS' +
                                &WRTNCODE ' ')                       */                   /*JMI113*/
                CALL       PGM(XX113001R) PARM(&RTNCODE 'GCMS' +
                             &WRTNCODE ' ') /*JMI113*/
                     IF         COND(&WRTNCODE *EQ '**CMD') THEN(GOTO +
                                CMDLBL(END))
             ENDDO

             ENDDO

ERROR:
             DLTOVR     FILE(*ALL)
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(&JOB)
                GOTO       CMDLBL(END)
             ENDDO

             GOTO       CMDLBL(END)

ABNOR:
             CHGJOB     SWS(XXXXXX11)
 /*          SNDPGMMSG  MSG('Program SDCJ002 ended abnormally') +
                          TOMSGQ(MOPERQ)      */                                          /*JMI113*/
             SNDPGMMSG  MSG('Program XXC113002 ended abnormally') +
                          TOMSGQ(MOPERQ)                                                  /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')

             ENDPGM
