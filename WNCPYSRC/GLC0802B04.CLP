000100000000/*********************************************************************/
000200000000/*                                                                   */
000300000000/*       Midas - Securities Trading Module                           */
000400000000/*                                                                   */
000500040726/*       GLC0802B  DAILY EVENTS BY CURRENCY                          */
000600000000/*                                                                   */
000700000000/*       (c) Misys International Banking Systems Ltd. 2004           */
000800000000/*                                                                   */
000801180208/*       Last Amend No. DUG503             Date 08Feb18              */
001100000000/*                                                                   */
001200000000/*********************************************************************/
001300000000/*                                                                   */
001301180208/*       DUG503 - Events by Value Date Report                        */
001302180208/*                DUG431 - Amendments to 'Events by Value Date'      */
001303180208/*                         Report                                    */
001304180208/*                DUG405 - Events by value date.                     */
001305040726/*                Upgrade of feature S20039 from ABS2.03 to DBA4.01. */
001600000000/*                                                                   */
001700000000/*********************************************************************/
001901180208             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
001902180208             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
001903180208             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
001904180208             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
001905180208             DCL        VAR(&DUG503) TYPE(*CHAR) LEN(1)
001906180208
