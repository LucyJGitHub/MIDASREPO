/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Month End Update Controlling Program')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bank of England Module                              */
/*                                                                   */
/*       BYC4040 - Month End Update Controlling Program              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 1998           */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*    CoB program, run at month end only. Calls BY4040 - Month End   */
/*    Update.                                                        */
/*-------------------------------------------------------------------*/
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Last Amend No. 121832             Date 14AUG97              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       121832 - Message being sent TOMSGQ(MRUNQ/MOPERQ) in error.  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Misys International Banking Systems Ltd. 1997')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)
 
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*  Check if switchable feature LLN007 - Bank of England is on  */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN007' +
                          ' ')
             IF         COND(&LRTCD *EQ '*NRF') THEN(DO)
/**************SNDPGMMSG  MSG('The Bank of England module is not avai+                    /*121832*/
/**************           lable') TOMSGQ(MRUNQ/MOPERQ)                                    /*121832*/
               SNDPGMMSG  MSG('The Bank of England module is not avai+
                          lable') TOMSGQ(MRUNQ MOPERQ)                                    /*121832*/
               RETURN
             ENDDO
 
 
/* Call RPG Month End Update prog */
             CALL       PGM(BY4040) PARM(&LRTCD)
 
/* Program completed normally */
          IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
              RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
              SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
          ENDDO
 
          RETURN
 
 
/* Abnormal termination  */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                        BYC4040 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
