/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Extension files housekeeping program')      */
/*********************************************************************/
/*                                                                   */
/*   MIDAS - Bank of England                                         */
/*                                                                   */
/*   BYC9010 - Extension Files Housekeeping Program                  */
/*                                                                   */
/*   (c) Misys International Banking Systems Ltd. 1997               */
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*   Last Amend No. 121611       Date: 14AUG97                       */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   121611 - Parameters passed incorrectly to AOSARDR0 and component*/
/*            not showing as failed.                                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)  /* Return code 1     */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Misys International Banking Systems Ltd. 2006')
 
/* Global Monitor Message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/* Reset job switches */
             CHGJOB     SWS(00000000)
 
/* Check if switchable feature LLN007 - Bank of England is on   */
/************CALL       PGM(AOSARDR0) PARM(&LRTCD 'LLN007' '*VERIFY' +                    /*121611*/
/************             ' ')                                                            /*121611*/
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN007' +
                          ' ')                                                            /*121611*/
 
/* LLN007 not present  */
             IF         COND(&LRTCD *EQ '*NRF') THEN(DO)
               SNDPGMMSG  MSG('Bank of England module is not +
                          available') TOMSGQ(MRUNQ MOPERQ)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* Check for error on call to AOSARDR0  */
             IF         COND(&LRTCD *NE ' ' *AND &LRTCD *NE '*NRF') +
                          THEN(DO)
               SNDPGMMSG  MSG('Error occurred on call to program +
                          AOSARDR0') TOMSGQ(MRUNQ MOPERQ)
/**************GOTO       CMDLBL(ENDPGM)                                                  /*121611*/
               GOTO       CMDLBL(ABNORM)                                                  /*121611*/
             ENDDO
 
/* Call Extension Files Housekeeping Program */
             CALL       PGM(BY9010) PARM(&LRTCD)
             IF         COND(&LRTCD *NE ' ') THEN(DO)
               SNDPGMMSG  MSG('Error occurred on call to program +
                          BY9010') TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNORM)
             ENDDO
 
/* End program normally */
             RETURN
 
/* Error processing */
 ABNORM:     SNDPGMMSG  MSG('Program BYC9010, Extension Files +
                        Housekeeping Program, has terminated +
                        abnormally.') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
 ENDPGM:     ENDPGM
