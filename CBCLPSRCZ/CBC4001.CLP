/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Call Program Controller')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4001 - Midas CB Call Program Controller                  */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. CCB019  *CREATE    Date 21Sep22              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB019 - Close of business Scheduler Enhancement            */
/*                Upgrade IPL089                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SEQ &R)

             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&R) TYPE(*CHAR) LEN(1)

             OVRDBF     FILE(CBUDCFL0) SHARE(*NO)

             CALL       PGM(CB4001) PARM(&SEQ &R)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&R) VALUE('Y'))


             ENDPGM
