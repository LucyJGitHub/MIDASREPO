/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE End Loan Manager drip feed job')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2013 - END LOAN MANAGER INTERFACE DRIP FEED JOB          */
/*                                                                   */
/*       Function: To End the Loan Manager Interface dripfeed        */
/*                 process LEC2016.                                  */
/*                                                                   */
/*       Calls:    None.                                             */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619            Date 01Feb06              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      203561 *CREATE     Date 14Jun02              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       203561 - Created as part of 203561.                         */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('LEC2013 - End Loan Manager Drip Feed +
                          Job') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(00000000)
 
/* Try and allocate LEDRIP data area. If fails then LEC2016 drip */
/* feed job is still running. Attempt to shut it down and check  */
/* again. If still fails after 30 secs, fail the component       */
 
             ALCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
 /**********    SNDJRNE    JRN(ICJRN) TYPE('YE') ENTDTA('STOP LE + */                    /*BUG9619*/
 /**********              UPDATE') FILE(SDCLNDPD) */                                     /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE('YE') ENTDTA('STOP LE +
                          UPDATE') FILE(SDCLNDPD) FORCE(*YES)                            /*BUG9619*/
                ALCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD)) WAIT(30)
                MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ABNOR))
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 ABNOR:
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSG('LEC2013 - End Loan Manager drip +
                             feed job has ENDED ABNORMALLY') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSG('LEC2013 - End Loan Manager drip +
                             feed job has ENDED ABNORMALLY') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
/* Call SCC0010 to inform the user that an error has occurred */
 
                RTVMSG     MSGID(SCM0087) MSGF(GBMIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                CALL       PGM(SCC0010) PARM('LEC2013' 'ENTER' ' ')
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Normal termination */
 END:
             DLCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
