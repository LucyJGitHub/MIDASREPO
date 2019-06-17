/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS background process')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-GCMS Interface                                */
/*                                                                   */
/********GLCJ005****GCMS*BAckground*Process***************************/                   /*JMI113*/
/*       XXC113005  GCMS BAckground Process                          */                   /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/                   /*JMI113*/
/*       (c) Finastra International Limited 2018                     */                   /*JMI113*/
/*                                                                   */
/*       Last Amendment No. JMI113           Date 21May18            */
/*       Prev Amendment No. JMI019           Date 21Feb07            */
/*                          225651           Date 11Mar04            */
/*                          JMI019 *CREATE   Date 11Jun03            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Upgrade as is                                      */
/*       225651 - Job GLCJ005 creating many joblogs during COB       */
/*       JMI019 - Midas-GCMS Interface                               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM

/*           DCL        VAR(&CPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')       */                                                 /*JMI113*/
             DCL        VAR(&CPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/
/** Start of change JMI019 */
/*           DCL        VAR(&ANUM)   TYPE(*CHAR) LEN(18)            */
             DCL        VAR(&ANUM)   TYPE(*CHAR) LEN(24)
/** End of change JMI019 */
             DCL        VAR(&WAITTM) TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&DTQVAL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)


             DCL        VAR(&DAGCMS) TYPE(*CHAR) LEN(256) VALUE(' ')
/**/
/* Global Error Trap */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
/* Send message to MRUNQ */
/*           SNDPGMMSG  MSG('GLCJ005 - GCMS Background processing') +
                          TOMSGQ(MRUNQ)                 */                                /*JMI113*/
           SNDPGMMSG  MSG('XXC113005 - GCMS Background processing') +
                          TOMSGQ(MRUNQ)                                                   /*JMI113*/

/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)

/* Create DA/LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
/** Delete and re-create data queue GLGCMSA **/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *TCAT 'DPLIB')
             DLTDTAQ    DTAQ(GLGCMSA)
             MONMSG     MSGID(CPF0000)
             CRTDTAQ    DTAQ(&DPLIB/GLGCMSA) MAXLEN(1) +
                          TEXT('Midas-GCMS interface, MT940s and +
                          MT942s')
/**/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)


/* RETRIEVE JOB ATTRIBUTES */

             RTVJOBA    JOB(&JOBN) USER(&USRN) NBR(&JBNB)

/* AMEND GLGCMSDA WITH JOB DETAILS                                   */

/*           RTVDTAARA  DTAARA(GLGCMSDA) RTNVAR(&DAGCMS)             */                   /*JMI113*/
             RTVDTAARA  DTAARA(XXGCMGDA) RTNVAR(&DAGCMS)                                  /*JMI113*/
/*           CHGDTAARA  DTAARA(GLGCMSDA (1 26)) VALUE(&JOBN *CAT +
                          &USRN *CAT &JBNB)    */                                         /*JMI113*/
             CHGDTAARA  DTAARA(XXGCMGDA (1 26)) VALUE(&JOBN *CAT +
                          &USRN *CAT &JBNB)                                               /*JMI113*/
/**/
/* TIMEOUT:    RTVDTAARA  DTAARA(GLGCMSDA) RTNVAR(&DAGCMS)     */                         /*JMI113*/
 TIMEOUT:    RTVDTAARA  DTAARA(XXGCMGDA) RTNVAR(&DAGCMS)                                  /*JMI113*/
             IF         COND(%SST(&DAGCMS 27 1) *EQ 'Y') THEN(DO)
 /*            CALL       PGM(GLCJ008) PARM(&ANUM)             */                         /*JMI113*/
               CALL       PGM(XXC113008) PARM(&ANUM)                                      /*JMI113*/
/**/
/* If U7 or U8 are ON, perform standard database error processing */

               IF         COND(%SWITCH(XXXXXX1X) *OR +
                            %SWITCH(XXXXXXX1)) THEN(DO)
                 GOTO       CMDLBL(ABNOR)
               ENDDO
             ENDDO
/*           IF         COND(%SST(&DAGCMS 30 1) *EQ 'Y') THEN(CALL +
                          PGM(GLCJ006) PARM(&WAITTM))       */                            /*JMI113*/
             IF         COND(%SST(&DAGCMS 30 1) *EQ 'Y') THEN(CALL +
                          PGM(XXC113006) PARM(&WAITTM))                                   /*JMI113*/
/**/
/* If U7 or U8 are ON, perform standard database error processing */

               IF         COND(%SWITCH(XXXXXX1X) *OR +
                            %SWITCH(XXXXXXX1)) +
                 THEN(GOTO       CMDLBL(ABNOR))
               CALL       PGM(QRCVDTAQ) PARM(GLGCMSA *LIBL +
                            X'00001F' &DTQVAL &WAITTM)

/* If returned value is T, program is immediately terminated  */

               IF         COND((&DTQVAL *EQ ' ') *OR (&DTQVAL *EQ +
                            'C')) THEN(GOTO CMDLBL(TIMEOUT))

/*           CHGDTAARA  DTAARA(GLGCMSDA (1 26)) +
                          VALUE('                          ')              */             /*JMI113*/
             CHGDTAARA  DTAARA(XXGCMGDA (1 26)) +
                          VALUE('                          ')                             /*JMI113*/
/**/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
/**/
 ABNOR:        CHGJOB     SWS(XXXXXX11)
               ROLLBACK
               MONMSG     MSGID(CPF0000 MCH0000)
/*             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA+
                          ('Program GLCJ005 ended abnormally - +
                          see job log') TOMSGQ(MOPERQ MRUNQ)        */                    /*JMI113*/
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                            MSGDTA('Program XXC113005 ended +
                            abnormally - see job log') TOMSGQ(MOPERQ +
                            MRUNQ) /*JMI113*/
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
/**/
 ENDPGM:
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 MCH0000)                        /*225651*/
             ENDPGM
