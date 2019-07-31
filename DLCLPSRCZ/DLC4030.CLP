/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FRA/IRS Rate Fix & Rerun Maintenance')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC4030 - FRAIRS Rate Fix & Rerun Maintenance               */
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
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CSW005  *CREATE    Date 01Aug96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSW005 - MG34n and MG36n Message Generation                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&PSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PPARM) TYPE(*CHAR) LEN(100)
             CHGVAR     VAR(&PPARM) VALUE(&MODE)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DLC4030 - FRAIRS Rate Fixing and Rate +
                          Fix Rerun Maintenance') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(DL4030) PARM(&MODE)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Submit job DLC1921 and MIDASMRV */
 
             ALCOBJ     OBJ((DLC1921 *PGM *EXCL)) WAIT(1)
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(GOTO CMDLBL(END))
 
             DLCOBJ     OBJ((DLC1921 *PGM *EXCL))
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/************SBMJOB     CMD(CALL PGM(DLC1921) PARM(&PSEQ &PLEV &PENT +                    /*CSC023*/
/************             &PPARM)) JOB(DLC1921) JOBD(MBATCH) +                            /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) +                      /*CSC023*/
/************             MSGQ(MOPERQ)                                                    /*CSC023*/
             SBMJOB     CMD(CALL PGM(DLC1921) PARM(&PSEQ &PLEV &PENT +
                          &PPARM)) JOB(DLC1921) JOBD(MBATCH) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) +
                          MSGQ(MOPERQ) OUTQ(*JOBD)                                        /*CSC023*/
 
/************SBMJOB     JOB(MIDASMRV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
             SBMJOB     JOB(MIDASMRV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DLC4030 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
