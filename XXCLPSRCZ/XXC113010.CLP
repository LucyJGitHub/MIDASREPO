/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS History processing')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-GCMS Interface                                */
/*                                                                   */
/********GLCJ010****GCMS*History*Processing***************************/                   /*JMI113*/
/*       XXC113010  GCMS History Processing                          */                   /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/                   /*JMI113*/
/*       (c) Finastra International Limited 2018                     */                   /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 22May18              */
/*       Prev Amend No. JMI019             Date 31May07              */
/*                      JMI019  *CREATE    Date 21Feb07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Keep FTP log for the day                           */
/*       JMI019 - Midas-GCMS Interface                               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ)

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')                        */                                /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018')                           /*JMI113*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&F3MBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)

/*           DCLF       FILE(GLGREFL0)                              */                    /*JMI113*/
             DCLF       FILE(XXGREFL0)                                                    /*JMI113*/

             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))

/* Send program message to MRUNQ */

/*           SNDPGMMSG  MSG('GLCJ010 - GCMS History Processing') +
                          TOMSGQ(MRUNQ)                   */                              /*JMI113*/
             SNDPGMMSG  MSG('XXC113010 GCMS History Processing') +
                          TOMSGQ(MRUNQ)                                                   /*JMI113*/

/* Switch off all user switches */

             CHGJOB     SWS(00000000)

/* Call program CB0160, to update Status parameter */

             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)

/**Clear*today's*log*file*GLGOOTBK*****************/                                      /*JMI113*/
/* Clear today's log file XXGOOTBK                */                                      /*JMI113*/

/*           CLRPFM     FILE(GLGOOTBK)            */                                      /*JMI113*/
             CLRPFM     FILE(XXGOOTBK)                                                    /*JMI113*/

/**If*status*parameter*is*'N',*clear*file*XGLFDTAPD,*and*copy*all  */
/* members*from*GLFDTAPD*into it. */                                                      /*JMI113*/
/* If status parameter is 'N', clear file XXXGDTAPD, and copy all  */
/* members from XXGDTAPD into it. */                                                      /*JMI113*/

             IF         COND(&STAT = 'N') THEN(DO)
/*              RMVM       FILE(XGLGDTAPD) MBR(*ALL)                */                    /*JMI113*/
                RMVM       FILE(XXXGDTAPD) MBR(*ALL)
                MONMSG     MSGID(CPF0000)
/*              CPYF       FROMFILE(GLGDTAPD) TOFILE(XGLGDTAPD) +
                           FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*ADD)     */              /*JMI113*/
                CPYF       FROMFILE(XXGDTAPD) TOFILE(XXXGDTAPD) +
                           FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*ADD)                     /*JMI113*/
                MONMSG     MSGID(CPF2817)
             ENDDO


/* Change status variable to 'Y' */

             CHGVAR     VAR(&STAT) VALUE('Y')

/* Call program CB0150, to update the restart indicator. */

             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/**Call*program*GLJ010,*to*drop*historic*records*from*GLGREFPD */                         /*JMI113*/
/* Call program XX113010, to drop historic records from XXGREFPD */                       /*JMI113*/

/*           CALL       PGM(GLJ010)                        */                             /*JMI113*/
             CALL       PGM(XX113010)                                                     /*JMI113*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/**If*job*switches*7*&*8*are*off,*then*reorganise*GLGREFPD*to* */                         /*JMI113*/
/**compress*out*deleted*records,*and*copy*members*back*to*GLGDATAPD */                    /*JMI113*/
/* If job switches 7 & 8 are off, then reorganise XXGREFPD to  */                         /*JMI113*/
/* compress out deleted records, and copy members back to XXGDTAPD */                     /*JMI113*/

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)

/**If*status*parameter*is*'Y',*clear*file*GLFDTAPD */                                     /*JMI113*/
/* If status parameter is 'Y', clear file XXGDTAPD */                                     /*JMI113*/

               IF         COND(&STAT = 'Y') THEN(DO)
/*                 RMVM       FILE(GLGDTAPD) MBR(*ALL)               */                   /*JMI113*/
                   RMVM       FILE(XXGDTAPD) MBR(*ALL)                                    /*JMI113*/
                   MONMSG     MSGID(CPF0000)
               ENDDO

/*             RGZPFM     FILE(GLGREFPD)                             */                   /*JMI113*/
               RGZPFM     FILE(XXGREFPD)                                                  /*JMI113*/
               MONMSG     MSGID(CPF2995 CPF2981)
LOOP:          RCVF
               MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDLOOP))

/* Empty Member */

               IF         COND(&F3MBRN = 'GCMS942') THEN(DO)
/*                 ADDPFM     FILE(GLGDTAPD) MBR(GCMS942)            */                   /*JMI113*/
                   ADDPFM     FILE(XXGDTAPD) MBR(GCMS942)                                 /*JMI113*/
                   MONMSG     MSGID(CPF0000)
                   ENDDO
             ELSE       CMD(DO)

/* Ignore missing members */

/*                 CPYF       FROMFILE(XGLGDTAPD) TOFILE(GLGDTAPD) +
                          FROMMBR(&F3MBRN) TOMBR(*FROMMBR) MBROPT(*ADD) */                /*JMI113*/
                   CPYF       FROMFILE(XXXGDTAPD) TOFILE(XXGDTAPD) +
                          FROMMBR(&F3MBRN) TOMBR(*FROMMBR) MBROPT(*ADD)                   /*JMI113*/
                   MONMSG     MSGID(CPF2817)
                   ENDDO

                   GOTO       CMDLBL(LOOP)

/* Change status parameter to 'N' */

 ENDLOOP:      CHGVAR     VAR(&STAT) VALUE('N')

/* Call CB0150 to Update restart indicator */

               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/**Remove*all*members*from XGLGDTAPD */                                                   /*JMI113*/
/* Remove all members from XXXGDTAPD */                                                   /*JMI113*/

/*             RMVM       FILE(XGLGDTAPD) MBR(*ALL)      */                               /*JMI113*/
               RMVM       FILE(XXXGDTAPD) MBR(*ALL)                                       /*JMI113*/
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
                          GLJ010 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)      */                                    /*JMI113*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          XX113010 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ) /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)

END:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')   */                 /*JMI113*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/

             ENDPGM
