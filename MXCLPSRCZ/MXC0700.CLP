/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Submit i/c bulk extract and transmission')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0700 - Submit Input Cycle Bulk Extract and Transmission  */
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
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX010             Date 18Jan01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CMX010 - Flat file export from Midas Export module.         */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMI &EXTT &FMT)
 
/*/COPY WNCPYSRC,MXC0700INT                                          */
 
             DCL        VAR(&COMI)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&EXTT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&FMT )   TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&EXTNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CALLEXT) TYPE(*CHAR) LEN(90)
             DCL        VAR(&TRMNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CALLTRM) TYPE(*CHAR) LEN(90)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CMX010*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CMX010*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CMX010*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CMX010*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Set up job names */
 
             IF         COND(&COMI *EQ '*NONE   ') THEN(DO)
             CHGVAR     VAR(&EXTNAM) VALUE('X_FORMAT')
             CHGVAR     VAR(&TRMNAM) VALUE('T_FORMAT')
             ENDDO
 
             IF         COND(&COMI *NE '*NONE   ') THEN(DO)
             CHGVAR     VAR(&EXTNAM) VALUE('X_' *CAT &COMI)
             CHGVAR     VAR(&TRMNAM) VALUE('T_' *CAT &COMI)
             ENDDO
 
/* Set up job execution details */
 
 
             CHGVAR     VAR(&CALLEXT) VALUE('CALL MXC0710 PARM(' +
                          *CAT &COMI *CAT ' ' *CAT &EXTT *CAT ' ' +
                          *CAT &FMT *CAT ')')
 
/* Check if switchable feature CMX010 (Flat file export) is    */     /*CMX010*/
/* installed.                                                  */     /*CMX010*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CMX010*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CMX010*/
             CHGVAR     VAR(&SAR) VALUE('CMX010')                     /*CMX010*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CMX010*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CMX010*/
 
/* Change variable to use 'Flat file' version of export program       /*CMX010*/
 
             CHGVAR     VAR(&CALLTRM) VALUE('CALL MXC0721 PARM(' +
                          *CAT &COMI *CAT ' ' *CAT &EXTT *CAT ' ' +
                          *CAT &FMT *CAT ')')                         /*CMX010*/
             ENDDO                                                    /*CMX010*/
 
             ELSE       CMD(DO)                                       /*CMX010*/
 
             CHGVAR     VAR(&CALLTRM) VALUE('CALL MXC0720 PARM(' +
                          *CAT &COMI *CAT ' ' *CAT &EXTT *CAT ' ' +
                          *CAT &FMT *CAT ')')
 
             ENDDO                                                    /*CMX010*/
 
/*/COPY WNCPYSRC,MXC0700MPS                                          */
 
/************SBMJOB     JOB(&EXTNAM) JOBD(MBATCH) USER(*JOBD) +                           /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA(&CALLEXT) +                                /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
 
             SBMJOB     JOB(&EXTNAM) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA(&CALLEXT) +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
 
/************SBMJOB     JOB(&TRMNAM) JOBD(MBATCH) USER(*CURRENT) +                        /*CPK014*/
/************             RTGDTA(*JOBD) RQSDTA(&CALLTRM) +                                /*CPK014*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CPK014*/
/************SBMJOB     JOB(&TRMNAM) JOBD(MBATCH) USER(*JOBD) +                           /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA(&CALLTRM) +                                /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                          /*CPK014*/ /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
             SBMJOB     JOB(&TRMNAM) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA(&CALLTRM) +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
 
/*/COPY WNCPYSRC,MXC0700MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0700ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,MXC0700END                                          */
 
ENDPGM
