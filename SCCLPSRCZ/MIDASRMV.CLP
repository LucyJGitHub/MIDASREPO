/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Remove a "MIDAS" from MSTATUS')              */
/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                     */
/*                                                                  */
/*       MIDASRMV - REMOVE A MIDAS FROM MSTATUS                     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 103717             Date 24Sep97              */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       103717 - Include a wait in the program if MSTATUS is not    */
/*                available at the time requested. This can occur    */
/*                when a user is signing on at the same time that    */
/*                this job is running.                               */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        /* Program to remove MIDAS from Mstatus +
                          message queue when issued by a program +
                          which subsequently submits a batch job */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/*********** CHGMSGQ ** MSGQ(MSTATUS) RESET(*YES) ******** 103717 **/
                                                         /* 103717 */
             MONMSG     MSGID(CPF2451) EXEC(GOTO +
                          CMDLBL(PAUSE))                 /* 103717 */
 RETRY:      CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
                                                         /* 103717 */
             MONMSG     MSGID(CPF2451) EXEC(GOTO +
                          CMDLBL(PAUSE))                 /* 103717 */
             RCVMSG     MSGQ(MSTATUS) RMV(*YES) /* The option +
                          RMV(*yes) removes the first of a group of +
                          messages which have not previously been +
                          recieved */
             GOTO EOPGM
                                                         /* 103717 */
 PAUSE:      DLYJOB     DLY(10)                          /* 103717 */
             GOTO RETRY                                  /* 103717 */
                                                         /* 103717 */
 ABNORMAL:   SNDPGMMSG  MSG('ERROR OCCURRED IN MIDASRMV') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
EOPGM:       ENDPGM
