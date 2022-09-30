/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Change OUTQ')                                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4006 - Midas CB Change OUTQ                              */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. CCB019  *CREATE    Date 21Sep22              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB019 - Close of Business User Defined Events              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&QUEU &QULI &HOME)
             DCL        VAR(&QUEU) TYPE(*CHAR) LEN(10)
             DCL        VAR(&QULI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOME) TYPE(*CHAR) LEN(10)
             MONMSG     MSGID(CPF0000)
             CHGJOB     OUTQ(*LIBL/MPRINT)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Removal of Override not done. If the +
                          Override failed, check job log.')
             ENDDO
             ENDPGM
