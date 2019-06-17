/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS MT999 History processing')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-GCMS Interface                                */
/*                                                                   */
/********GLCJ048*-*GCMS*MT999*History*Processing**********************/                   /*JMI113*/
/*       XXC113048 - GCMS MT999 History Processing                   */                   /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/                   /*JMI113*/
/*       (c) Finastra International Limited 2018                     */                   /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 23May18              */
/*       Prev Amend No. JMI019  *CREATE    Date 21Feb07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Upgrade as is. &STAT checking of equal to 'N'      */
/*                changed to not equal to 'Y'.                       */
/*       JMI019 - Phase III MT999 Message Processing                 */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ)

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')                                       */                 /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/
             DCL        VAR(&CNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)   TYPE(*DEC)  LEN(5)
             DCL        VAR(&STAT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&F3MBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)

/*           DCLF       FILE(GLMREFL0)                                 */                 /*JMI113*/
             DCLF       FILE(XXMREFL0)                                                    /*JMI113*/

             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))

/* Send program message to MRUNQ */

/*           SNDPGMMSG  MSG('GLCJ048 - GCMS MT999 History +
                          Processing') TOMSGQ(MRUNQ)                   */                 /*JMI113*/
             SNDPGMMSG  MSG('XXC113048 - GCMS MT999 Histor+
                          y Processing') TOMSGQ(MRUNQ)                                    /*JMI113*/

/* Switch off all user switches */

             CHGJOB     SWS(00000000)

/* Call program CB0160, to update Status parameter */

             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)

/**If*status*parameter*is*'N',*clear*file*XGLMDTAPD,*and*copy*all***/
/**members*from*GLMDTAPD*into*it.**/                                                      /*JMI113*/
/* If status parameter is 'N', clear file XXXMDTAPD, and copy all  */
/* members from XXMDTAPD into it. */                                                      /*JMI113*/

             IF         COND(&STAT *NE 'Y') THEN(DO)
/*              RMVM       FILE(XGLMDTAPD) MBR(*ALL)               */                     /*JMI113*/
                RMVM       FILE(XXXMDTAPD) MBR(*ALL)                                      /*JMI113*/
                MONMSG     MSGID(CPF0000)
/*              CPYF       FROMFILE(GLMDTAPD) TOFILE(XGLMDTAPD) +
                           FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*ADD)    */               /*JMI113*/
                CPYF       FROMFILE(XXMDTAPD) TOFILE(XXXMDTAPD) +
                           FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*ADD)                     /*JMI113*/
                MONMSG     MSGID(CPF2817)
             ENDDO


/* Change status variable to 'Y' */

             CHGVAR     VAR(&STAT) VALUE('Y')

/* Call program CB0150, to update the restart indicator. */

             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/**Call*program*GLJ048,*to*drop*historic*records*from*GLMREFPD**/                         /*JMI113*/
/* Call program XX113048, to drop historic records from XXMREFPD */                       /*JMI113*/

/*           CALL       PGM(GLJ048)                              */                       /*JMI113*/
             CALL       PGM(XX113048)                                                     /*JMI113*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/**If*job*switches*7*&*8*are*off,*then*reorganise*GLMREFPD*to***/
/**compress*out*deleted*records,*and*copy*members*back*to*GLMDTAPD**/                     /*JMI113*/
/* If job switches 7 & 8 are off, then reorganise XXMREFPD to  */
/* compress out deleted records, and copy members back to XXMDTAPD */                     /*JMI113*/

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)

/**If*status*parameter*is*'Y',*clear*file*GLMDTAPD**/                                     /*JMI113*/
/* If status parameter is 'Y', clear file XXMDTAPD */                                     /*JMI113*/

               IF         COND(&STAT = 'Y') THEN(DO)
/*                 RMVM       FILE(GLMDTAPD) MBR(*ALL)             */                     /*JMI113*/
                   RMVM       FILE(XXMDTAPD) MBR(*ALL)                                    /*JMI113*/
                   MONMSG     MSGID(CPF0000)
               ENDDO

/*             RGZPFM     FILE(GLMREFPD)                           */                     /*JMI113*/
               RGZPFM     FILE(XXMREFPD)                                                  /*JMI113*/
               MONMSG     MSGID(CPF2995 CPF2981)
LOOP:          RCVF
               MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDLOOP))

/* Empty Member */


/* Ignore missing members */

/*                 CPYF       FROMFILE(XGLMDTAPD) TOFILE(GLMDTAPD) +
                          FROMMBR(&F3MBRN) TOMBR(*FROMMBR) MBROPT(*ADD)   */              /*JMI113*/
                   CPYF       FROMFILE(XXXMDTAPD) TOFILE(XXMDTAPD) +
                          FROMMBR(&F3MBRN) TOMBR(*FROMMBR) MBROPT(*ADD)                   /*JMI113*/
                   MONMSG     MSGID(CPF2817)

                   GOTO       CMDLBL(LOOP)

/* Change status parameter to 'N' */

 ENDLOOP:      CHGVAR     VAR(&STAT) VALUE('N')

/* Call CB0150 to Update restart indicator */

               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/**Remove*all*members*from*XGLMDTAPD**/                                                   /*JMI113*/
/* Remove all members from XXXMDTAPD */                                                   /*JMI113*/

/*             RMVM       FILE(XGLMDTAPD) MBR(*ALL)                        */             /*JMI113*/
               RMVM       FILE(XXXMDTAPD) MBR(*ALL)                                       /*JMI113*/
               MONMSG     MSGID(CPF0000)
             ENDDO

/* If either job user switches 7 or 8 are on, perform standard */
/* database error processing */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO

             GOTO       CMDLBL(END)

/* Abnormal Processing */

ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLJ048 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)                             */             /*JMI113*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          XX113048 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)

END:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')        */            /*JMI113*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/

             ENDPGM
