/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT End Midas-Orion link')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - SWIFT Direct Link                               */
/*                                                                   */
/*       MTC4002 - End Midas-Orion link                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 067399             Date 01Nov94              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       067399 - Unable to stop/start Midas Telex link in I/C       */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/* Check whether the communications program is all ready active     */
/* by trying to allocate its data area                              */
             ALCOBJ     OBJ((MT4010 *DTAARA *EXCL)) WAIT(1)
             MONMSG     MSGID(CPF1002) EXEC(DO)
 
/* If the data area could not be allocated                          */
/* then the link is active                                          */
 
/* Get job name for communications job termination messages         */
               RTVJOBA    JOB(&JOB)
 
/* End outgoing transmission processing                             */
               CALL       PGM(QSNDDTAQ) PARM(MTDTQA *LIBL X'00001F' T)
 
/* Wait for the transmission program to complete termination        */
               ALCOBJ     OBJ((MT4010 *DTAARA *EXCL)) WAIT(300)
               MONMSG     MSGID(CPF1002) EXEC(DO)
 
/* If the data area cannot be allocated                              */
/* then the program has not terminated successfully                  */
/* (and hence relinquished control of the data area)                 */
                 CHGVAR     VAR(&MESSAGE) VALUE('Midas Telex link +
                          termination unsuccessful')
                 CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
                 CALL       PGM(SCC0010) PARM('MTC4002' 'ENTER' ' ')
                 GOTO       CMDLBL(END)
               ENDDO
 
/* If all went well                                                 */
/* then terminate                                                   */
 
               GOTO       CMDLBL(END)
 
             ENDDO
 
/* If the link is not active                                         */
/* -that is, the data area could be allocated-                       */
/* send a message and terminate                                      */
             CHGVAR     VAR(&MESSAGE) VALUE('Midas Telex link is not +
                          active')
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('MTC4002' 'ENTER' ' ')
             GOTO       CMDLBL(END)
 
 ERROR:      SNDPGMMSG  MSG('Midas Telex link termination ended +
                          abnormally') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
 END:        DLCOBJ     OBJ((MT4010 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
