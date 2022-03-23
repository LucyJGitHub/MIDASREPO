/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Journal Entry Batch Monitor Submit Job')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC998001 - Journal Entry Batch Monitor Submit Job          */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. MD059435 *CREATE   Date 16Feb22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD059435 - STP Batch entered Midas as held with an error    */
/*                  in the header record                             */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(70)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2022')

/** Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('GLC998001 - Journal Entry Batch Monitor +
                          Submit Job') TOMSGQ(MRUNQ)

             ALCOBJ     OBJ((GLBATMONLK *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ENDP))

/* Allow job to run */

             CHGDTAARA  DTAARA(GLBATMONST (1 1)) VALUE('R')

/* Set wait time in DTAARA/GLBATMONST */

             CHGDTAARA  DTAARA(GLBATMONST (2 3)) VALUE('060')

             DLCOBJ     OBJ((GLBATMONLK *DTAARA *EXCL))

/* Submit Journal Entry Batch Monitor */

             SBMJOB     JOB(GLBATCHMON) JOBD(MBATCH) JOBQ(INTERFACE) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL GLC998003') +
                          INLLIBL(*CURRENT) MSGQ(MOPERQ)

             GOTO       CMDLBL(ENDP)

/* Abnormal ending: */
/*==================*/

 ABNOR:      CHGJOB     SWS(XXXXXX11)

/* Report an error */

             CHGVAR     VAR(&MEM) VALUE('GLC998001 - Journal Entry +
                          Batch Monitor Submit Job FAILED')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)

             SNDPGMMSG  MSGID(MEM5052) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)

 ENDP:       CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra +
                          International Limited')
             ENDPGM
