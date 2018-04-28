/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO On-Line Synch. of Global Layer SUBMIT')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0101 - On-Line Synchronisation of Global Layer SUBMIT    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. 261790             Date 07Sep09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BUG12185           Date 09Oct06              */
/*                      CRE026             Date 24May06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSD031             Date 10Apr06              */
/*                      BG1343             Date 23Feb04              */
/*                      CSC023             Date 29Jan04              */
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       261790 - Apply fix for 253213.                              */
/*       253213 - Reorganise GOOSCIPD file.                          */
/*       BUG12185 - Change file in INZPFM operation (Recompile)      */
/*       CRE026 - Consumer Banking                                   */
/*       CSD031 - Enhanced Centralise Static Data                    */
/*       BG1343 - Global job should only be submitted if input cycle */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Parameters For QCLRDTAQ */                                                             /*CRE026*/
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10) +
                             VALUE('SDCBTRDTQ')                                           /*CRE026*/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) VALUE('*LIBL')                      /*CRE026*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
             DCL        VAR(&PRTCD)  TYPE(*CHAR) LEN(7) VALUE('       ')                  /*CSD031*/
             DCL        VAR(&POPTN)  TYPE(*CHAR) LEN(7)                                   /*CSD031*/
             DCL        VAR(&PSAR)   TYPE(*CHAR) LEN(6)                                   /*CSD031*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSD031*/
             DCL        VAR(&CSD031) TYPE(*CHAR) LEN(1)                                   /*CSD031*/
             DCL        VAR(&CRE026) TYPE(*CHAR) LEN(1)                                   /*CRE026*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Check if Enhanced Centralised Static Data is installed */                              /*CSD031*/
                                                                                          /*CSD031*/
             CHGVAR     VAR(&PSAR) VALUE('CSD031')                                        /*CSD031*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CSD031*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSAR &SCSARD)                   /*CSD031*/
                                                                                          /*CSD031*/
             IF         COND(&PRTCD *EQ '       ') THEN(DO)                               /*CSD031*/
                 CHGVAR     VAR(&CSD031) VALUE('Y')                                       /*CSD031*/
             ENDDO                                                                        /*CSD031*/
                                                                                          /*CSD031*/
             IF         COND(&CSD031 *EQ 'Y') THEN(DO)                                    /*CSD031*/
             CALL       PGM(SDC000060S)
             ENDDO                                                                        /*CSD031*/
                                                                                          /*CSD031*/
 
/* Check if Consumer Banking is switched on */                                            /*CRE026*/
                                                                                          /*CRE026*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CRE026*/
             CHGVAR     VAR(&PSAR) VALUE('CRE026')                                        /*CRE026*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CRE026*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSAR &SCSARD)                   /*CRE026*/
                                                                                          /*CRE026*/
             IF         COND(&PRTCD *EQ '       ') THEN(DO)                               /*CRE026*/
                 CHGVAR     VAR(&CRE026) VALUE('Y')                                       /*CRE026*/
             ENDDO                                                                        /*CRE026*/
                                                                                          /*CRE026*/
             IF         COND(&CRE026 *EQ 'Y') THEN(DO)                                    /*CRE026*/
                                                                                          /*CRE026*/
                ALCOBJ     OBJ((GLNOSTPD *FILE *EXCL)) WAIT(0)                            /*CRE026*/
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)                        /*CRE026*/
                   GOTO       CMDLBL(NEXT1)                                               /*CRE026*/
                ENDDO                                                                     /*CRE026*/
 
                DLCOBJ     OBJ((GLNOSTPD *FILE *EXCL))                                    /*CRE026*/
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                 /*CRE026*/
 
                SBMJOB     JOB(CB_NOS_UPD) JOBD(MBATCH) JOBQ(INTERFACE) +
                             OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                             RQSDTA('CALL GLC000446') INLLIBL(*CURRENT)                   /*CRE026*/
 NEXT1:
 
                ALCOBJ     OBJ((GOEOSJSPD *FILE *EXCL)) WAIT(0)                           /*CRE026*/
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)                        /*CRE026*/
                   GOTO       CMDLBL(NEXT2)                                               /*CRE026*/
                ENDDO                                                                     /*CRE026*/
                                                                                          /*CRE026*/
                DLCOBJ     OBJ((GOEOSJSPD *FILE *EXCL))                                   /*CRE026*/
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                 /*CRE026*/
                                                                                          /*CRE026*/
                SBMJOB     JOB(EQ_ONL_SYN) JOBD(MBATCH) JOBQ(INTERFACE) +
                             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                             GOC0104') INLLIBL(*CURRENT) OUTQ(*JOBD)                      /*CRE026*/
                                                                                          /*CRE026*/
NEXT2:                                                                                    /*CRE026*/
                                                                                          /*CRE026*/
                ALCOBJ     OBJ((GLCYPNPD *FILE *EXCL)) WAIT(0)                            /*CRE026*/
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)                        /*CRE026*/
                   GOTO       CMDLBL(NEXT3)                                               /*CRE026*/
                ENDDO                                                                     /*CRE026*/
                                                                                          /*CRE026*/
                DLCOBJ     OBJ((GLCYPNPD *FILE *EXCL))                                    /*CRE026*/
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                 /*CRE026*/
                                                                                          /*CRE026*/
                SBMJOB     JOB(CB_CCY_UPD) JOBD(MBATCH) JOBQ(INTERFACE) +
                             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                             GLC000447') INLLIBL(*CURRENT) OUTQ(*JOBD)                    /*CRE026*/
                                                                                          /*CRE026*/
NEXT3:                                                                                    /*CRE026*/
                                                                                          /*CRE026*/
/* Check lock on PF/SDCBTRPD */                                                           /*CRE026*/
                ALCOBJ     OBJ((SDCBTRPD *FILE *EXCL)) WAIT(0)                            /*CRE026*/
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)                        /*CRE026*/
                   GOTO       CMDLBL(NEXT4)                                               /*CRE026*/
                ENDDO                                                                     /*CRE026*/
                                                                                          /*CRE026*/
                DLCOBJ     OBJ((SDCBTRPD *FILE *EXCL))                                    /*CRE026*/
                                                                                          /*CRE026*/
/* Clear dataqueue before commencing job */                                               /*CRE026*/
                                                                                          /*CRE026*/
                CALL       PGM(QCLRDTAQ) PARM(&NAME &LIB)                                 /*CRE026*/
                                                                                          /*CRE026*/
                SBMJOB     JOB(CB_CBT_UPD) JOBD(MBATCH) JOBQ(INTERFACE) +
                             OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                             RQSDTA('CALL SDC000081') +
                             INLLIBL(*CURRENT)                                            /*CRE026*/
                                                                                          /*CRE026*/
NEXT4:                                                                                    /*CRE026*/
                                                                                          /*CRE026*/
             ENDDO                                                                        /*CRE026*/
                                                                                          /*CRE026*/
             ALCOBJ     OBJ((GOOSJSPD *FILE *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             DLCOBJ     OBJ((GOOSJSPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/************SBMJOB     JOB(OLSYNGLB) JOBD(MBATCH) JOBQ(INTERFACE) +                      /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             GOC0103') INLLIBL(*CURRENT)                                     /*CSC023*/
 
/**********  SBMJOB     JOB(OLSYNGLB) JOBD(MBATCH) JOBQ(INTERFACE) + ****/
/**********               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +   ****/
/**********               GOC0103') INLLIBL(*CURRENT) OUTQ(*JOBD)    ****/   /*CSC023*/   /*BG1343*/
                                                                                          /*BG1343*/
/* Reorganise GOOSCIPD file. */                                                           /*253213*/
                                                                                          /*253213*/
             CALL       PGM(SCC000060) PARM('GOOSCIPD' '*FIRST')                          /*253213*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*253213*/
                                                                                          /*253213*/
             SBMJOB     JOB(GO_ONL_SYN) JOBD(MBATCH) JOBQ(INTERFACE) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          GOC0103') INLLIBL(*CURRENT) OUTQ(*JOBD)                         /*BG1343*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
