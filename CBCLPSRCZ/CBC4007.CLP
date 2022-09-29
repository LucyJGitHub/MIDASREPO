/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB View Associated Spool Files')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4007 - Midas CB View Associated Spool Files              */
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
             PGM        PARM(&NAM)

             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)

             WRKSPLF    SELECT(*CURRENT *ALL *ALL &NAM)
             MONMSG     MSGID(CPF0000)

             ENDPGM
