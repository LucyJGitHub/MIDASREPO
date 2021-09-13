/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Call COB Jobs')                              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4011 - Midas CB Call COB Jobs                            */
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
             PGM        PARM(&NAM &SEQ &T &R)

             DCL        VAR(&T) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&R) TYPE(*CHAR) LEN(1)

             OVRDBF     FILE(CBUDCFL1) SHARE(*NO)

             CALL       PGM(CB4001) PARM(&SEQ &R)

             ENDPGM
