/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       GLC0802B  DAILY EVENTS BY CURRENCY                          */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. DUG503 *CREATE     Date 08Feb18              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       DUG503 - Events by Value Date Report                        */
/*       DUG431 - Amendments to 'Events by Value Date'               */
/*                Report                                             */
/*       DUG405 - Events by value date.                              */
/*       Upgrade of feature S20039 from ABS2.03 to DBA4.01.          */
/*                                                                   */
/*********************************************************************/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*DUG502*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*DUG502*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*DUG502*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*DUG502*/
             DCL        VAR(&DUG503) TYPE(*CHAR) LEN(1)                                   /*DUG502*/

