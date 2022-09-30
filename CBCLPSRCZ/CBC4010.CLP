/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Call COB Jobs')                              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4010 - Midas CB Call COB Jobs                            */
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
             PGM        PARM(&PHAS &FREQ)

             DCL        VAR(&PHAS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&FREQ)   TYPE(*CHAR) LEN(2)

             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES) SWS(XXXXXX00)

             CALL       PGM(CB4010) PARM(&PHAS &FREQ)
             MONMSG     MSGID(CPF0000) EXEC(CHGJOB SWS(XXXXXX11))

             ENDPGM
