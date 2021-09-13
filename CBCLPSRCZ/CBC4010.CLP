/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Call COB Jobs')                              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4010 - Midas CB Call COB Jobs                            */
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
             PGM        PARM(&PHAS &FREQ)

             DCL        VAR(&PHAS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&FREQ)   TYPE(*CHAR) LEN(2)

             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES) SWS(XXXXXX00)

             CALL       PGM(CB4010) PARM(&PHAS &FREQ)
             MONMSG     MSGID(CPF0000) EXEC(CHGJOB SWS(XXXXXX11))

             ENDPGM
