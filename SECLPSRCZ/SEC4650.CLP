/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Submit Statement Production')                */
/*********************************************************************/
/*                                                                   */
/*       Midas    - Securities Trading Module                        */
/*                                                                   */
/*       SEC4650  - MIDAS SE Submit Statement Production             */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 02Feb04              */
/*                      CSE040  *CREATE    Date 25Mar03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSE040 - Securities Statement Processing                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SEC4650INT                                          */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SEC4650MPS                                          */
 
/************SBMJOB     JOB(SEC4651) JOBD(MBATCH) JOBQ(MT53XJOBQ) +                       /*CSC023*/
/************             USER(*JOBD) RTGDTA(MULTILANGUAGE) +                             /*CSC023*/
/************             RQSDTA('CALL   SEC4651') INLLIBL(*JOBD) +                       /*CSC023*/
/************             MSGQ(MOPERQ)                                                    /*CSC023*/
 
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(MT53XJOBQ) +                      /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)                          /*CSC023*/
 
             SBMJOB     JOB(SEC4651) JOBD(MBATCH) JOBQ(MT53XJOBQ) +
                          USER(*JOBD) RTGDTA(MULTILANGUAGE) +
                          RQSDTA('CALL   SEC4651') INLLIBL(*JOBD) +
                          MSGQ(MOPERQ) OUTQ(*JOBD)                                        /*CSC023*/
 
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(MT53XJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)              /*CSC023*/
 
             GOTO       CMDLBL(END)
 
ABNOR:
 
/*/COPY WNCPYSRC,SEC4650ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SEC4650 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SEC4650END                                          */
 
             ENDPGM
