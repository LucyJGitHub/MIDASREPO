/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Change OUTQ')                                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4002 - Midas CB Change OUTQ                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2012           */
/*                                                                   */
/*       Last Amend No. CCB019  *CREATE    Date 20Mar12              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB019 - Close of business Scheduler Enhancement            */
/*                Upgrade IPL089                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&QUEU &QULI &HOME)
             DCL        VAR(&QUEU) TYPE(*CHAR) LEN(10)
             DCL        VAR(&QULI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOME) TYPE(*CHAR) LEN(10)
             MONMSG     MSGID(CPF0000)
             CHGJOB     OUTQ(&QULI/&QUEU)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Override not done. If the Override +
                          failed, check job log.')
             ENDDO
             ENDPGM
