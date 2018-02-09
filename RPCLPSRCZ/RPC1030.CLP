/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Plato i/face - submit download of system')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC1030 - Midas-Plato Interface - Submit Download of System */
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
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      173248             Date 06Jan00              */
/*                      CPL003  *CREATE    Date 11Oct99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       173248 - Change REPMIDAS subsystem amended to include       */
/*                the Midas System Prefix.                           */
/*       CPL003 - Midas-Plato Interface.                             */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global Monitor Message:                                         */
/* If an unmonitorred message occurs perform error processing      */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
/* Submit job to download entire Midas system data.                */
 
/**********  SBMJOB     CMD(CALL PGM(RPC1020)) JOB(RPC1020) + */                          /*173248*/
/**********               JOBD(TIJOBD)                        */                          /*173248*/
/************SBMJOB     CMD(CALL PGM(RPC1020)) JOB(RPC1020) +                             /*CPK014*/
/************             JOBD(TIJOBD) INLLIBL(*JOBD)                           /*173248    CPK014*/
/************SBMJOB     CMD(CALL PGM(RPC1020)) JOB(RPC1020) +                             /*CSC023*/
/************             JOBD(TIJOBD) USER(*JOBD) INLLIBL(*JOBD)              /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(RPC1020)) JOB(RPC1020) +
                          JOBD(TIJOBD) USER(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)             /*CSC023*/
 
             GOTO       CMDLBL(TAG999)
 
/* Error Processing:                                               */
/* Dump the program if error occurred in this program              */
 
TAG998:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDMSG     MSG('Job terminated - RPC1030 Submit +
                          download of entire Midas system to Plato - +
                          Ended in Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
/* End of Program:                                                 */
TAG999:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
