/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Send Error Messages')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4012 - Midas CB Send Error Messages                      */
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
             PGM        PARM(&NAM &SEQ)

             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)
             DCL        VAR(&M1) TYPE(*CHAR) LEN(17)
             DCL        VAR(&M2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&M3) TYPE(*CHAR) LEN(7)

             CHGVAR     VAR(&M1) VALUE('User Component ')
             CHGVAR     VAR(&M2) VALUE('Sequence ')
             CHGVAR     VAR(&M3) VALUE(' Failed')

             CHGVAR     VAR(&MSG) VALUE(&M1 *CAT &NAM *CAT &M2 *CAT +
                          &SEQ *CAT &M3)
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)

             ENDPGM
