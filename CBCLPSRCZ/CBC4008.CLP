/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Query Files')                                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4008 - Midas CB Query Files                              */
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
             PGM        PARM(&LIB &FIL)

             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL) TYPE(*CHAR) LEN(10)

             CHKOBJ     OBJ(&LIB/&FIL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
             RUNQRY     QRYFILE((&LIB/&FIL)) RCDSLT(*YES)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))

 END:        ENDPGM
