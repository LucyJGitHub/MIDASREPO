/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS Message Generation')                    */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas-GCMS Interface                               */
/*                                                                  */
/********GLCJ009****GCMS Message Generation**************************/                    /*JMI113*/
/*       XXC113009  GCMS Message Generation                         */                    /*JMI113*/
/*                                                                  */
/********(c)*Misys*International Banking Systems Ltd. 2007***********/                    /*JMI113*/
/*       (c) Finastra International Limited 2018                    */                    /*JMI113*/
/*                                                                  */
/*       Last Amend No. JMI113             Date 22May18             */
/*       Prev Amend No. JMI019             Date 21Feb07             */
/*                      JMI019 (C01)       Date 21Jun05             */
/*                      JMI019B            Date 28Apr05             */
/*                      JMI019 *CREATE     Date 14Jun03             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1          */
/*       JMI019 - Upgrade as is                                     */
/*       JMI019 (C01) - Midas-GCMS Interface Change Control 01      */
/*                      Non-accumulation of MT942                   */
/*       JMI019B - GCMS. File Name and Confirmation File            */
/*       CGL004 - Midas-GCMS Interface                              */
/*                                                                  */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ)

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')                           */                             /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(10) +
                           VALUE('  DPLIB')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
             DCL        VAR(&SDSTT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MNM) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
/* Global Error Trap */
/*           MONMSG     MSGID(CPF0000 MCH0000)                               */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(DBERR))
/**/
/*           CHGVAR     VAR(&MSG) VALUE('GLCJ009 - GCMS Message +
                          Generation')  */                                                /*JMI113*/
             CHGVAR     VAR(&MSG) VALUE('XXC113009 - GCMS Message +
                          Generation') /*JMI113*/
/* Send message to MRUNQ */
             SNDPGMMSG  TOMSGQ(MRUNQ) MSG(&MSG)

/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)
/**/
/**          CLRPFM     FILE(GLRSSVPD)          **/                /*CGL006*/

 /*          CLRPFM     FILE(GLGCM2PP)           */                           /*JMI019*/  /*JMI113*/
             CLRPFM     FILE(XXGCM2PP)                                                    /*JMI113*/

             MONMSG     MSGID(CPF0000 MCH0000)
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTT)
             CHGVAR     VAR(%SST(&PREF 1 2)) VALUE(%SST(&SDSTT 6 2))
/*           RMVM       FILE(GLGDTAPD) MBR(GLGDTAPD)           */                         /*JMI113*/
             RMVM       FILE(XXGDTAPD) MBR(XXGDTAPD)                                      /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/* If Not Restart */
             IF         COND(&STAT *EQ 'N') THEN(DO)
/**********    CLRPFM     FILE(XGLGONAPD)                                                /*JMI019B*/
/*             CLRPFM     FILE(XGLGCACPD)         */                         /*JMI019B*/ /*JMI113*/
               CLRPFM     FILE(XXXGCACPD)                                                /*JMI113*/
               MONMSG     MSGID(CPF0000 MCH0000)
/**********    CPYF       FROMFILE(GLGONAPD) TOFILE(&PREF/XGLGONAPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)                  /*JMI019B*/
/*             CPYF       FROMFILE(GLGCACPD) TOFILE(&PREF/XGLGCACPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  */   /*JMI019B*/ /*JMI113*/
               CPYF       FROMFILE(XXGCACPD) TOFILE(&PREF/XXXGCACPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)                   /*JMI113*/
/* Monitor for from-file being empty */
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
/**/
             ELSE       CMD(DO)
/* If Restart */
/**********    CPYF       FROMFILE(XGLGONAPD) TOFILE(GLGONAPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)                               /*JMI019B*/
/**********    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(GLGONAPD))                                              /*JMI019B*/
/*             CPYF       FROMFILE(XGLGCACPD) TOFILE(GLGCACPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)  */               /*JMI019B*/ /*JMI113*/
               CPYF       FROMFILE(XXXGCACPD) TOFILE(XXGCACPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)                               /*JMI113*/
/*             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(GLGCACPD))               */                 /*JMI019B*/ /*JMI113*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(XXGCACPD))                                              /*JMI113*/
             ENDDO
/**/
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/*           CLRPFM     FILE(GLC940PD)                                  */   /*JMI019B*/ /*JMI113*/
/*           ADDPFM     FILE(GLGDTAPD) MBR(GLGDTAPD)                    */               /*JMI113*/
/*           OVRDBF     FILE(GLGDTAPD) MBR(GLGDTAPD)                    */               /*JMI113*/
/*           CALL       PGM(GLJ009) PARM(&MNM)                          */               /*JMI113*/
/*           DLTOVR     FILE(GLGDTAPD)                                  */               /*JMI113*/
             CLRPFM     FILE(XXC940PD)                                                   /*JMI113*/
             ADDPFM     FILE(XXGDTAPD) MBR(XXGDTAPD)                                     /*JMI113*/
             OVRDBF     FILE(XXGDTAPD) MBR(XXGDTAPD)                                     /*JMI113*/
             CALL       PGM(XX113009) PARM(&MNM)                                         /*JMI113*/
             DLTOVR     FILE(XXGDTAPD)                                                   /*JMI113*/

/* IF Both U7 & U8 are OFF */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 /*            RNMMBR     OLDFILE(GLGDTAPD) MBR(GLGDTAPD) NEWMBR(&MNM)    */             /*JMI113*/
               RNMMBR     OLDFILE(XXGDTAPD) MBR(XXGDTAPD) NEWMBR(&MNM)
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/**********    CLRPFM     FILE(XGLGONAPD)                                                /*JMI019B*/
/*             CLRPFM     FILE(XGLGCACPD)         */                         /*JMI019B*/
               CLRPFM     FILE(XXXGCACPD)                                                /*JMI113*/

/* Monitor for all messages */
               MONMSG     MSGID(CPF0000 MCH0000)
               GOTO       CMDLBL(ENDPGM)
             ENDDO

/* If U7 or U8 are ON, perform standard database error processing */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
               GOTO       CMDLBL(DBERR)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/*DBERR:        CPYF       FROMFILE(XGLGCACPD) TOFILE(GLGCACPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)     */                         /*JMI113*/
 DBERR:        CPYF       FROMFILE(XXXGCACPD) TOFILE(XXGCACPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)                                /*JMI113*/
/*BERR:        RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                            */
               RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
               MONMSG     MSGID(CPF0000 MCH0000)
               CHGVAR     VAR(&MSG) VALUE(%SST(&LDA 134 50))
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MSG) +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
/*           ENDDO                                                            */
/**/
 ENDPGM:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')           */         /*JMI113*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/

             ENDPGM
