/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Journal Entry Batch Monitor End Job')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC998002 - Journal Entry Batch Monitor End Job             */
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
             DCL        VAR(&MEM)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2022')

/** Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* End the job */

             CHGDTAARA  DTAARA(GLBATMONST (1 1)) VALUE('E')

             GOTO       CMDLBL(ENDP)

/* Abnormal ending: */
/*==================*/
 ABNOR:

/* Report an error */

             CHGVAR     VAR(&MEM) VALUE('GLC998002 - Journal Entry +
                          Batch Monitor End Job FAILED')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)

             SNDPGMMSG  MSGID(MEM5052) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)

 ENDP:       MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra +
                          International Limited')
             ENDPGM
