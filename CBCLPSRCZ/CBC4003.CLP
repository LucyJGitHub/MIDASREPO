/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Call Individual Programs')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4003 - Midas CB Call Individual Programs                 */
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
             PGM        PARM(&P &L &P0 &P1 &P2 &P3 &P4 &P5 &P6 &P7 +
                          &P8 &P9 &R)

             DCL        VAR(&P) TYPE(*CHAR) LEN(10)
             DCL        VAR(&L) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P5) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P7) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P8) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P9) TYPE(*CHAR) LEN(10)
             DCL        VAR(&R) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&R) VALUE(' ')
             CALL       PGM(&L/&P) PARM(&P0 &P1 &P2 &P3 &P4 &P5 &P6 +
                          &P7 &P8 &P9 &R)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO

             ENDPGM
