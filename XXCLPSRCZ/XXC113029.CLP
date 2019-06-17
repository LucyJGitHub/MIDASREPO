/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Drop historic GCMS')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas GCMS Interface                                */
/*                                                                   */
/********GLCJ029*-*Drop*historic*GCMS*********************************/                   /*JMI113*/
/*       XXC113029 - Drop historic GCMS                              */                   /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2003************/                   /*JMI113*/
/*       (c) Finastra International Limited 2018                     */                   /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 22May18              */
/*       Prev Amend No. JMI019             Date 23Feb07              */
/*                      JMI020             Date 11Feb04              */
/*                      JMI019  *CREATE    Date 23Jul03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Upgrade as is remover JMI020                       */
/*       JMI020 - Midas GCMS Interface for manual CSV file upload    */
/*                (network SPEM).                                    */
/*       JMI019 - Midas GCMS Interface                               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')                                */                        /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)

/** Global monitor message                        */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)

/** Send message to MRUNQ                         */
             SNDPGMMSG  MSG('Message Management - Drop historic +
                          GCMS') TOMSGQ(MRUNQ)

/** Set-off Data Base Error Switches.             */
             CHGJOB     SWS(XXXXXX00)

/** Clear GCMS backup files                       */
/*           CLRPFM     FILE(MGGCMXBK)                        */                          /*JMI113*/
/*           CLRPFM     FILE(MGGCMMBK)                        */                          /*JMI113*/
/*           CLRPFM     FILE(MGG101BK)                        */                          /*JMI113*/
             CLRPFM     FILE(XXGCMXBK)                                                    /*JMI113*/
             CLRPFM     FILE(XXGCMMBK)                                                    /*JMI113*/
             CLRPFM     FILE(XXG101BK)                                                    /*JMI113*/

/**/
/** Copy all the non-historic messages to backup files */
/*           CALL       PGM(GLJ029) PARM(' ')       */                                    /*JMI113*/
             CALL       PGM(XX113029) PARM(' ')                                           /*JMI113*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 GOTO       CMDLBL(ERR)
             ENDDO

/***Copy*from*back*up*file*to*MGGCMXPD            */                                      /*JMI113*/
/*           CPYF     FROMFILE(MGGCMXBK) TOFILE(*LIBL/MGGCMXPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)    */                             /*JMI113*/
/** Copy from back up file to XXGCMXPD            */                                      /*JMI113*/
             CPYF     FROMFILE(XXGCMXBK) TOFILE(*LIBL/XXGCMXPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)                                   /*JMI113*/
/***If*MGGCMXBK*is*empty*we*clear*the*file        */                                      /*JMI113*/
      /*     MONMSG   MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM  FILE(MGGCMXPD))    */                              /*JMI113*/
/** If XXGCMXBK is empty we clear the file        */                                      /*JMI113*/
             MONMSG   MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM  FILE(XXGCMXPD))                                    /*JMI113*/

/***Copy*from*back*up*file*to*MGGCMMPD*************/                                      /*JMI113*/
/*           CPYF     FROMFILE(MGGCMMBK) TOFILE(*LIBL/MGGCMMPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)   */                              /*JMI113*/
/** Copy from back up file to XXGCMMPD            */                                      /*JMI113*/
             CPYF     FROMFILE(XXGCMMBK) TOFILE(*LIBL/XXGCMMPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)                                   /*JMI113*/
/***If*MGGCMMBK*is*empty*we*clear*the*file*********/                                      /*JMI113*/
/*           MONMSG   MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM  FILE(MGGCMMPD))      */                            /*JMI113*/
/** If XXGCMMBK is empty we clear the file        */                                      /*JMI113*/
             MONMSG   MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM  FILE(XXGCMMPD))                                    /*JMI113*/

/***Copy*from*back*up*file*to*MGG101PD*************/                                      /*JMI113*/
/*           CPYF     FROMFILE(MGG101BK) TOFILE(*LIBL/MGG101PD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)  */                               /*JMI113*/
/** Copy from back up file to XXG101PD            */                                      /*JMI113*/
             CPYF     FROMFILE(XXG101BK) TOFILE(*LIBL/XXG101PD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)                                   /*JMI113*/
/***If*MGG101BK*is*empty*we*clear*the*file*********/                                      /*JMI113*/
/*           MONMSG   MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM  FILE(MGG101PD)) */                                 /*JMI113*/
/** If XXG101BK is empty we clear the file        */                                      /*JMI113*/
             MONMSG   MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM  FILE(XXG101PD))                                    /*JMI113*/

             GOTO END

 ERR:        SNDPGMMSG  MSG('Message Management - Drop Historic +
                          GCMS ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG MSGID(CPF0000 MCH0000)

 END:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')  */                  /*JMI113*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/
             ENDPGM
