/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTRTNDTAQD)                                             */
/*EXI    ALLOW(*IREXX *BREXX *BPGM *IPGM)                            */
/*EXI *  TEXT('Return DTAQ Description')                             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       RTNDTAQD  (Return DTAQ Description) command                 */
/*                                                                   */
/*       (C) COPYRIGHT MISYS-WBS Ltd. 2004                           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. 231490  *Create    Date 21Jan05              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       231490 - Applied fix 225515. Re-occurred MEC0710 is stuck.  */
/*                Do not wait for Meridian when all messages have    */
/*                been processed (= queue empty).                    */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Return *dtaq description')
             PARM       KWD(DTAQ) TYPE(QDTAQ) MIN(1) CHOICE(*NONE) +
                          PROMPT('Dtaq name')
 QDTAQ:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*CURLIB) (*LIBL)) PROMPT('Library')
             PARM       KWD(MAXLEN) TYPE(*DEC) LEN(5 0) RTNVAL(*YES) +
                          PROMPT('Maximum entry length')
             PARM       KWD(FORCE) TYPE(*CHAR) LEN(4) RTNVAL(*YES) +
                          PROMPT('Force indicator')
             PARM       KWD(SEQ) TYPE(*CHAR) LEN(6) RTNVAL(*YES) +
                          PROMPT('Sequence')
             PARM       KWD(KEYLEN) TYPE(*DEC) LEN(3 0) RTNVAL(*YES) +
                          PROMPT('Key length')
             PARM       KWD(SENDERID) TYPE(*CHAR) LEN(4) +
                          RTNVAL(*YES) PROMPT('Sender ID')
             PARM       KWD(TEXT) TYPE(*CHAR) LEN(50) RTNVAL(*YES) +
                          PROMPT('Text')
             PARM       KWD(NBRMSG) TYPE(*DEC) LEN(9 0) RTNVAL(*YES) +
                          PROMPT('Number of messages queued')
             PARM       KWD(MAXMSG) TYPE(*DEC) LEN(9 0) RTNVAL(*YES) +
                          PROMPT('Maximum messages on queue')
