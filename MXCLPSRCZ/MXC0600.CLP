/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Start i/c drip-feed extrct and transmissn')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0600 - Start I/C Drip-Feed Extract and Transmission      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX001  *CREATE    Date 01Jan00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0600INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,MXC0600MPS                                          */
 
             ALCOBJ     OBJ((MXOLEJPD *FILE *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                GOTO       CMDLBL(NEXT)
             ENDDO
 
             DLCOBJ     OBJ((MXOLEJPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/************SBMJOB     JOB(MXOLEXT) JOBD(MBATCH) JOBQ(INTERFACE) +                       /*CPK014*/
/************             USER(*CURRENT) RTGDTA(*JOBD) RQSDTA('CALL +                     /*CPK014*/
/************             MXC0610') INLLIBL(*JOBD)                                        /*CPK014*/
/************SBMJOB     JOB(MXOLEXT) JOBD(MBATCH) JOBQ(INTERFACE) +                       /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MXC0610') INLLIBL(*JOBD)                             /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(MXOLEXT) JOBD(MBATCH) JOBQ(INTERFACE) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MXC0610') INLLIBL(*JOBD) OUTQ(*JOBD)                            /*CSC023*/
 
  NEXT:
 
             ALCOBJ     OBJ((MXOLTJPD *FILE *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             DLCOBJ     OBJ((MXOLTJPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/************SBMJOB     JOB(MXOLTRM) JOBD(MBATCH) JOBQ(INTERFACE) +                       /*CPK014*/
/************             USER(*CURRENT) RTGDTA(*JOBD) RQSDTA('CALL +                     /*CPK014*/
/************             MXC0620') INLLIBL(*JOBD)                                        /*CPK014*/
/************SBMJOB     JOB(MXOLTRM) JOBD(MBATCH) JOBQ(INTERFACE) +                       /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MXC0620') INLLIBL(*JOBD)                             /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(MXOLTRM) JOBD(MBATCH) JOBQ(INTERFACE) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MXC0620') INLLIBL(*JOBD) OUTQ(*JOBD)                            /*CSC023*/
 
/*/COPY WNCPYSRC,MXC0600MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0600ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,MXC0600END                                          */
 
ENDPGM
