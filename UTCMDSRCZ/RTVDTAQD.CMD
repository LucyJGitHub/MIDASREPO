/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(QSYS/QMHQRDQD)                                          */
/*EXI    ALLOW(*IREXX *BREXX *BPGM *IPGM)                            */
/*EXI *  TEXT('Retrieve DTAQ Description')                           */
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
             CMD        PROMPT('Retrieve *dtaq description')
             PARM       KWD(DTAQD) TYPE(*CHAR) LEN(80) RTNVAL(*YES) +
                          MIN(1) PROMPT('Dtaq description returned' 2)
             PARM       KWD(DTAQDLEN) TYPE(*INT4) CONSTANT(80) MIN(1)
             PARM       KWD(FORMAT) TYPE(*NAME) LEN(8) +
                          CONSTANT(RDQD0100) MIN(1)
             PARM       KWD(DTAQ) TYPE(Q014D) MIN(1) CHOICE(*NONE) +
                          PROMPT('Dtaq name' 1)
 Q014D:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*CURLIB) (*LIBL)) PROMPT('Library')
