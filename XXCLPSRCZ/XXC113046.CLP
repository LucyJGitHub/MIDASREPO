/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS MT999 Message Generation')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-GCMS Interface                                */
/*                                                                   */
/********GLCJ046*-*MT999*GCMS*Message*Generation**********************/                   /*JMI113*/
/*       XXC113046 - MT999 GCMS Message Generation                   */                   /*JMI113*/
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
/*       JMI019 - Upgrade as is                                      */
/*       JMI019 - Phase III MT999 Message Processing                 */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ)

             DCL        VAR(&CNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)   TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&STAT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF)   TYPE(*CHAR) LEN(10) +
                           VALUE('  DPLIB')
             DCL        VAR(&MSG)    TYPE(*CHAR) LEN(52)
             DCL        VAR(&SDSTT)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&MNM)    TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')                                        */                /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/
/**/
/* Global Error Trap */
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
/*           CHGVAR     VAR(&MSG) VALUE('GLCJ046 - GCMS MT999 Message +
                          Generation')                                  */                /*JMI113*/
             CHGVAR     VAR(&MSG) VALUE('XXC113046 - GCMS MT999 +
                          Message Generation') /*JMI113*/
/* Send message to MRUNQ */
             SNDPGMMSG  TOMSGQ(MRUNQ) MSG(&MSG)

/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTT)
             CHGVAR     VAR(%SST(&PREF 1 2)) VALUE(%SST(&SDSTT 6 2))
/*           RMVM       FILE(GLMDTAPD) MBR(GLMDTAPD)                */                    /*JMI113*/
             RMVM       FILE(XXMDTAPD) MBR(XXMDTAPD)                                      /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)
/* If Not Restart */
/**/
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/*           CLRPFM     FILE(GLC999PD)                              */                    /*JMI113*/
/*           ADDPFM     FILE(GLMDTAPD) MBR(GLMDTAPD)                */                    /*JMI113*/
/*           OVRDBF     FILE(GLMDTAPD) MBR(GLMDTAPD)                */                    /*JMI113*/
/*           CALL       PGM(GLJ046) PARM(&MNM)                      */                    /*JMI113*/
/*           DLTOVR     FILE(GLMDTAPD)                              */                    /*JMI113*/
             CLRPFM     FILE(XXC999PD)                                                    /*JMI113*/
             ADDPFM     FILE(XXMDTAPD) MBR(XXMDTAPD)                                      /*JMI113*/
             OVRDBF     FILE(XXMDTAPD) MBR(XXMDTAPD)                                      /*JMI113*/
             CALL       PGM(XX113046) PARM(&MNM)                                          /*JMI113*/
             DLTOVR     FILE(XXMDTAPD)                                                    /*JMI113*/

/* IF Both U7 & U8 are OFF */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*             RNMMBR     OLDFILE(GLMDTAPD) MBR(GLMDTAPD) NEWMBR(&MNM)       */           /*JMI113*/
               RNMMBR     OLDFILE(XXMDTAPD) MBR(XXMDTAPD) NEWMBR(&MNM)                    /*JMI113*/
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/* Monitor for all messages */
               MONMSG     MSGID(CPF0000 MCH0000)
               GOTO       CMDLBL(ENDPGM)
             ENDDO

/* If U7 or U8 are ON, perform standard database error processing */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
/**/
 DBERR:        RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
               MONMSG     MSGID(CPF0000 MCH0000)
               CHGVAR     VAR(&MSG) VALUE(%SST(&LDA 134 50))
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MSG) +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
/**/
 ENDPGM:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')     */               /*JMI113*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/

             ENDPGM
