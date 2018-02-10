/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Start ref. gen. for incoming msgs')          */
/*********************************************************************/
/*                                                                   */
/*     Midas - SWIFT DIRECT LINK                                     */
/*                                                                   */
/*     MSC4040 - START INCOMING MESSAGE INDEX GENERATION             */
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
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      099902             Date 24Feb97              */
/*                      085386             Date 20Oct95              */
/*                NO 068100            DATE 16JAN94                  */
/*                NO S01436            DATE 15JUL93                  */
/*                NO E20723            DATE 08JAN90                  */
/*                NO S01310            DATE 06DEC90                  */
/*                NO S01259            DATE 20AUG90                  */
/*                NO S01179            DATE 12/09/88                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*     085386 - MSC5030 submitted to MSJOBQ and never run as         */
/*              MSJOBQ can only contain 2 job active at the same     */
/*              time.(MSC4010,MSC0200)                               */
/*     099902 - Reverse 085386. Should solve by changing job queue   */
/*              entry to allow 3 jobs active at same time.           */
/*     085386 - MSC5030 submitted to MSJOBQ and never run as         */
/*              MSJOBQ can only contain 2 job active at the same     */
/*              time.(MSC4010,MSC0200)                               */
/*              Submit MSC5030 to MJOBQ.                             */
/*     068100 - Allow for multi-language overrides                   */
/*     S01436 - Addition of Switchable Feature for Comms Program     */
/*              for the ST400.                                       */
/*     E20723  -  S/38 TO AS400 CONVERSION TO 'SBMJOB'; ALL          */
/*                OCCURANCES SHOULD BE RTGDTA(*JOBD) INLLIBL(*JOBD).*/
/*     S01310 - SWIFT RATIONALISATION                                */
/*     S01259 - If SWIFT II on submit MSC5030 else submit MSC1240    */
/*     S01179  -  CHANGE RCVDTAARA TO RTVDTAARA FOR AS400            */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                   */
/* Declare Variable and Data Area                                    */
/*                                                                   */
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(256)
/************DCL********VAR(&SWII) TYPE(*CHAR) LEN(1)           /*S01259S01310*/
/*           DCLDTAARA  DTAARA(MSSTAT)                              *  *S01179*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01436*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01436*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*01436*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01436') /*S01436*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*S01436*/
/*                                                                   */
/* Global monitor message                                            */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                   */
/* Audit Msg to MRUNQ                                                */
/*                                                                   */
             SNDPGMMSG  MSG('Incoming SWIFT messages reference +
                         generation') TOMSGQ(MRUNQ)
/*                                                                   */
/* Amend MSSTAT position 57 to 'Y' (Incoming msg. ref. generation)   */
/*                                                                   */
/*           RCVDTAARA  DTAARA(MSSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(MSSTAT)  RTNVAR(&MSSTAT)               /*S01179*/
             CHGVAR     VAR(%SST(&MSSTAT 57 1)) VALUE(Y)
/**          SNDDTAARA  DTAARA(MSSTAT)                             **  *S01179*/
             CHGDTAARA  DTAARA(MSSTAT) VALUE(&MSSTAT)                 /*S01179*/
/**/                                                                  /*S01436*/
/* Access the Switchable Features File to see if the bank have an    +
   ST400 or an ST200. If the bank have an ST200 a record will NOT be +
   found on the file.                                                 /*S01436*/
/**/                                                                  /*S01436*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD     +
                          &DSFDY)                                     /*S01436*/
/**/                                                                  /*S01436*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*S01436*/
/**/                                                                  /*S01436*/
/***********************************************************************068100*/
/***************SBMJOB*JOB(MSC5030)*JOBD(MBATCH)*JOBQ(MSJOBQ)*+*********068100*/
/***************USER(*JOBD)*RTGDTA(*JOBD)*+*****************************068100*/
/***************RQSDTA('CALL*MSC5030')*INLLIBL(*JOBD)*MSGQ(MOPERQ)S01436068100*/
/************SBMJOB*****JOB(MSC5030)*JOBD(MBATCH)*JOBQ(MSJOBQ)*+********085386*/
/*************************USER(*JOBD) RTGDTA(MSEXTRACT)*+***************085386*/
/*************************RQSDTA('CALL*MSC5030')*INLLIBL(*JOBD)*+*******085386*/
/*************************MSGQ(MOPERQ)**************************068100**085386*/
/************SBMJOB     JOB(MSC5030) JOBD(MBATCH) JOBQ(MJOBQ) +               */
/************             USER(*JOBD) RTGDTA(MSEXTRACT) +                     */
/************             RQSDTA('CALL MSC5030') INLLIBL(*JOBD) +             */
/************             MSGQ(MOPERQ)                          /*085386099902*/
/************SBMJOB     JOB(MSC5030) JOBD(MBATCH) JOBQ(MSJOBQ) +                          /*CSC023*/
/************             USER(*JOBD) RTGDTA(MSEXTRACT) +                                 /*CSC023*/
/************             RQSDTA('CALL MSC5030') INLLIBL(*JOBD) +                         /*CSC023*/
/************             MSGQ(MOPERQ)                                /*099902*/          /*CSC023*/
             SBMJOB     JOB(MSC5030) JOBD(MBATCH) JOBQ(MSJOBQ) +
                          USER(*JOBD) RTGDTA(MSEXTRACT) +
                          RQSDTA('CALL MSC5030') INLLIBL(*JOBD) +
                          MSGQ(MOPERQ) OUTQ(*JOBD)                                        /*CSC023*/
/**/                                                                  /*S01436*/
                ENDDO
/**/                                                                  /*S01436*/
                ELSE DO                                               /*S01436*/
/*                                                                   */
/* Submit job to generate references for incoming SWIFT messages.    */
/*                                                                   */
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/************RTVDTAARA**DTAARA(MMOD (95 1)) RTNVAR(&SWII)       /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/***If*SWIFT*II*on*submit*MSC5030                               /*S01259S01310*/
/************IF*COND(&SWII**EQ 'Y') THEN(DO)                    /*S01259S01310*/
/************** SBMJOB JOB(MSC5030) JOBD(MBATCH) USER(*JOBD) +
                RQSDTA('CALL MSC5030') MSGQ(MOPERQ)             E20723/*S01259*/
/***********************************************************************068100*/
/************SBMJOB*****JOB(MSC5030)*JOBD(MBATCH)*USER(*JOBD)*+*********068100*/
/*************************RQSDTA('CALL*MSC5030')*MSGQ(MOPERQ)*+*********068100*/
/*************************RTGDTA(*JOBD)*INLLIBL(*JOBD)***********E20723 068100*/
/************SBMJOB*****JOB(MSC5030)*JOBD(MBATCH)*JOBQ(MSJOBQ)*+********085386*/
/*************************USER(*JOBD) RTGDTA(MSEXTRACT)*+***************085386*/
/*************************RQSDTA('CALL*MSC5030')*INLLIBL(*JOBD)*+*******085386*/
/*************************MSGQ(MOPERQ)**************************068100**085386*/
/************SBMJOB     JOB(MSC5030) JOBD(MBATCH) JOBQ(MJOBQ) +               */
/************             USER(*JOBD) RTGDTA(MSEXTRACT) +                     */
/************             RQSDTA('CALL MSC5030') INLLIBL(*JOBD) +             */
/************             MSGQ(MOPERQ)                          /*085386099902*/
/************SBMJOB     JOB(MSC5030) JOBD(MBATCH) JOBQ(MSJOBQ) +                          /*CSC023*/
/************             USER(*JOBD) RTGDTA(MSEXTRACT) +                                 /*CSC023*/
/************             RQSDTA('CALL MSC5030') INLLIBL(*JOBD) +                         /*CSC023*/
/************             MSGQ(MOPERQ)                                /*099902*/          /*CSC023*/
             SBMJOB     JOB(MSC5030) JOBD(MBATCH) JOBQ(MSJOBQ) +
                          USER(*JOBD) RTGDTA(MSEXTRACT) +
                          RQSDTA('CALL MSC5030') INLLIBL(*JOBD) +
                          MSGQ(MOPERQ) OUTQ(*JOBD)                                        /*CSC023*/
/**/                                                                  /*S01436*/
             ENDDO                                                    /*S01436*/
/**/                                                                  /*S01436*/
/************ENDDO*********                                     /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/***If*SWIFT*II*off*submit*MSC1240                              /*S01259S01310*/
/************IF*COND(&SWII**NE 'Y') THEN(DO)                    /*S01259S01310*/
/************SBMJOB*****JOB(MSC1240) JOBD(MBATCH) USER(*JOBD) +       /*S01310*/
/*************************RQSDTA('CALL MSC1240') MSGQ(MOPERQ)         /*S01310*/
/************ENDDO*********                                     /*S01259S01310*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ)          E20723*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ) +                          /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD)                /*E20723*/          /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)                        /*CSC023*/
/*                                                                   */
             GOTO       END
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('Incoming SWIFT messages reference +
                          generation ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
