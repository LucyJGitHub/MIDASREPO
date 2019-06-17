/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS Intra-day Proj. Mvmts. Generation')     */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas-GCMS Interface                               */
/*                                                                  */
/********GLCJ008****GCMS*Message*Generation**************************/                    /*JMI113*/
/*       XXC113008  GCMS Message Generation                         */                    /*JMI113*/
/*                                                                  */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007***********/                    /*JMI113*/
/*       (c) Finastra International Limited 2018                    */                    /*JMI113*/
/*                                                                  */
/*       Last Amend No. JMI113             Date 22May18             */
/*       Prev Amend No. JMI019             Date 21Feb07             */
/*                      JMI019 (C01)       Date 21Jun05             */
/*                      JMI019B            Date 28Apr05             */
/*                      JMI019  *CREATE    Date 12Jun03             */
/*                                                                  */
/*********************************************************************/
/*                                                                  */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1          */
/*       JMI019 - Upgrade as is                                     */
/*                increase the size of &ANUM variable from 18 to 24 */
/*       JMI019 (C01) - Midas-GCMS Interface Change Control 01      */
/*                      Non-accumulation of MT942                   */
/*       JMI019B - GCMS. File Name and Confirmation File            */
/*       JMI019 - Midas-GCMS Interface                              */
/*                                                                  */
/*********************************************************************/
/**/
             PGM        PARM(&ANUM)

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')         */                                               /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018')                           /*JMI113*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
             DCL        VAR(&MNM) TYPE(*CHAR) LEN(10) +
                           VALUE('GCMS942 ')
/* Start of change JMI019                                           */
/**********  DCL        VAR(&ANUM) TYPE(*CHAR) LEN(18)              */
             DCL        VAR(&ANUM) TYPE(*CHAR) LEN(24)
/* Start of change JMI019                                           */
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
/* Global Error Trap */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(DBERR))
/**/
/*           CHGVAR     VAR(&MSG) VALUE('GLCJ008 - GCMS Message +
                          Generation')     */
             CHGVAR     VAR(&MSG) VALUE('XXC113008 - GCMS Message +
                          Generation')
/* Send message to MRUNQ */
             SNDPGMMSG  TOMSGQ(MRUNQ) MSG(&MSG)

/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)

/*           CLRPFM     FILE(GLC942PD)                      */               /*JMI019B*/  /*JMI113*/
/*           CLRPFM     FILE(GLGDTAPD) MBR(GCMS942)         */                            /*JMI113*/
/*           OVRDBF     FILE(GLGDTAPD) MBR(GCMS942)         */                            /*JMI113*/
/*           CLRPFM     FILE(GLGCAMPP)                      */               /*JMI019*/   /*JMI113*/
/*           CLRPFM     FILE(GLGCM1PP)                      */               /*JMI019*/   /*JMI113*/
/*           CALL       PGM(GLJ008A)                        */               /*JMI019*/   /*JMI113*/
/*           CALL       PGM(GLJ008B)                        */               /*JMI019*/   /*JMI113*/
/*           CALL       PGM(GLJ008) PARM(&MNM &ANUM)        */                            /*JMI113*/
/*           DLTOVR     FILE(GLGDTAPD)                      */                            /*JMI113*/
             CLRPFM     FILE(XXC942PD)                                                    /*JMI113*/
             CLRPFM     FILE(XXGDTAPD) MBR(GCMS942)                                       /*JMI113*/
             OVRDBF     FILE(XXGDTAPD) MBR(GCMS942)                                       /*JMI113*/
             CLRPFM     FILE(XXGCAMPP)                                                    /*JMI113*/
             CLRPFM     FILE(XXGCM1PP)                                                    /*JMI113*/
             CALL       PGM(XX113008A)                                                    /*JMI113*/
             CALL       PGM(XX113008B)                                                    /*JMI113*/
             CALL       PGM(XX113008) PARM(&MNM &ANUM)                                    /*JMI113*/
             DLTOVR     FILE(XXGDTAPD)                                                    /*JMI113*/

/* If either job user switches 7 or 8 are on, perform standard */
/* database error processing */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
               GOTO       CMDLBL(DBERR)
             ENDDO

             GOTO       CMDLBL(ENDPGM)
/**/
 DBERR:      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(&MSG) VALUE(%SST(&LDA 134 50))
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
 ENDPGM:     ENDPGM
