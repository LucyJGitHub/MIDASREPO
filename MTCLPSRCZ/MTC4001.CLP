/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Start Midas-Orion link')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - SWIFT Direct Link                               */
/*                                                                   */
/*       MTC4001 - Start Midas-Orion Link                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             Date 07Nov96              */
/*                      067399             Date 01NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       067399 - Unable to stop/start Midas Telex link in I/C       */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(SDMGMEPD)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERR))
 
/* Check whether comms program already active by allocating MT4010  */
             ALCOBJ     OBJ((MT4010 *DTAARA *EXCL)) WAIT(1)
             MONMSG     MSGID(CPF0000) EXEC(DO)
 
/* If it is, send message and terminate                             */
               CHGVAR     VAR(&MESSAGE) VALUE('Midas Telex link +
                            already active')
               CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
               CALL       PGM(SCC0010) PARM('MTC4001' 'ENTER' ' ')
               GOTO       CMDLBL(END)
             ENDDO
 
/* Otherwise, deallocate data area                                  */
             DLCOBJ     OBJ((MT4010 *DTAARA *EXCL))
 
/* Start link by submitting MTC4010                                 */
/************SBMJOB     CMD(CALL PGM(MTC4010)) JOB(MTC4010) +         /*110242*/
/*************            JOBD(MBATCH) JOBQ(MTJOBQ) */                /*110242*/
/************SBMJOB     CMD(CALL PGM(MTC4010)) JOB(MTC4010) +                             /*CPK014*/
/************             JOBD(MBATCH) JOBQ(MTJOBQ) RTGDTA(*JOBD) +                       /*CPK014*/
/************             INLLIBL(*JOBD)                              /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MTC4010)) JOB(MTC4010) +                             /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MTJOBQ) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD)                         /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(MTC4010)) JOB(MTC4010) +
                          JOBD(MBATCH) JOBQ(MTJOBQ) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)                        /*CSC023*/
 
             GOTO       CMDLBL(END)
 
 ERR:        SNDPGMMSG  MSG('Midas Telex link startup ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
