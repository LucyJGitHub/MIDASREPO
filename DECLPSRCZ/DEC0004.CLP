/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Start projections on-line extract')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0004 - Start Projections On-line Extract for CCRM Limits */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CDE001  *CREATE    Date 12Nov99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CDE001 - Data Export - CCRM Limits                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DEC0004INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,DEC0004MPS                                          */
 
             ALCOBJ     OBJ((DEOLEJPD *FILE *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             DLCOBJ     OBJ((DEOLEJPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/************SBMJOB     JOB(PONLINE) JOBD(MBATCH) JOBQ(INTERFACE) +                       /*CPK014*/
/************             USER(*CURRENT) RTGDTA(*JOBD) RQSDTA('CALL +                     /*CPK014*/
/************             DEC0005') INLLIBL(*JOBD)                                        /*CPK014*/
/************SBMJOB     JOB(PONLINE) JOBD(MBATCH) JOBQ(INTERFACE) +                       /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             DEC0005') INLLIBL(*JOBD)                             /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(PONLINE) JOBD(MBATCH) JOBQ(INTERFACE) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          DEC0005') INLLIBL(*JOBD) OUTQ(*JOBD)                            /*CSC023*/
 
/* Call program to start Meridian Replication Feeder Job */
             CALL       PGM(KMDJBC)
 
/*/COPY WNCPYSRC,DEC0004MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0004ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DEC0004END                                          */
 
ENDPGM
