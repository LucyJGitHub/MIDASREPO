/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Reroute at i/c termination')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCRRTTERM - Program called after reroute of job             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG10848           Date 17Mar06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 07Aug95              */
/*                      S01463             Date 18APR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG10848 - Schedule not functioning for Global Processing   */
/*       S01408 - Hooks moved to WNCPYSRC from SCCPYSRC:             */
/*                - SCRRTTMINT                                       */
/*                - SCRRTTMMPS                                       */
/*                - SCRRTTMMPE                                       */
/*                - SCRRTTMERR                                       */
/*                - SCRRTTMEND                                       */
/*       S01463 - New program to allow rerouting of job to be        */
/*                updated without the need to change subsystem       */
/*                routing entries. The old SCRRTTERM processing      */
/*                has been moved to a new program SCC0105.           */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SCRRTTMINT                                          */
 
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    JOB(&JOB)
 
/*/COPY WNCPYSRC,SCRRTTMMPS                                        */
 
/* Call the reroute program via ML initiation */
 
             CALL       PGM(MLC0000) PARM('SCC0105' &PARM1 &PARM2 +
                          &PARM3 &PARM4 &PARM5)
 
/*/COPY WNCPYSRC,SCRRTTMMPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,SCRRTTMERR                                          */
 
/* Inform user that the program is in error */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCRRTTERM ended abnormally - see job +
                          log') TOMSGQ(MOPERQ &JOB)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)                                                   /*BUG10848*/
 
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SCRRTTMEND                                          */
 
             ENDPGM
