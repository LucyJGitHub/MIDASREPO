/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB View Associated Spool Files')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4007 - Midas CB View Associated Spool Files              */
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
             PGM        PARM(&NAM)

             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)

             WRKSPLF    SELECT(*CURRENT *ALL *ALL &NAM)
             MONMSG     MSGID(CPF0000)

             ENDPGM
