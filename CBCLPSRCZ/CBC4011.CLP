/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Call COB Jobs')                              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4011 - Midas CB Call COB Jobs                            */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. CCB019  *CREATE    Date 21Sep22              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB019 - Close of business Scheduler Enhancement            */
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
